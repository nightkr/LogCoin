package logcoin
import cats.effect.IOApp
import cats.effect.{ExitCode, IO}
import cats.implicits._
import org.http4s.server.blaze.BlazeServerBuilder
import org.http4s._
import org.http4s.implicits._
import org.http4s.dsl.io._
import java.{util => ju}
import doobie._
import doobie.implicits._
import doobie.postgres.implicits._
import java.time.Instant
import cats.Monad
import io.circe.generic.auto._
import org.http4s.circe.CirceEntityEncoder._
import io.circe.Encoder
import io.circe.Decoder

case class Id[A](raw: ju.UUID)

object Id {
  implicit def decoder[A]: Decoder[Id[A]] =
    Decoder.decodeUUID.map(Id[A](_))
  implicit def encoder[A]: Encoder[Id[A]] =
    Encoder.encodeUUID.contramap[Id[A]](_.raw)
}

case class Account(id: Id[Account])

case class Transaction(id: Id[Transaction], time: Instant)

object Transaction {
  def forAccount(accountId: Id[Account]): ConnectionIO[List[Transaction]] =
    sql"SELECT id, time FROM transaction WHERE id IN (SELECT transaction_id FROM transactionlog where account_id=$accountId) ORDER BY time ASC"
      .query[Transaction]
      .to[List]
}

case class TransactionRow(
    id: Id[TransactionRow],
    transaction: Id[Transaction],
    account: Id[Account],
    direction: TransactionRowDirection,
    amount: BigDecimal,
    currency: String
)

object TransactionRow {
  def forTransaction(
      transactionId: Id[Transaction]
  ): ConnectionIO[List[TransactionRow]] =
    sql"SELECT id, transaction_id, account_id, type, amount, amount_type FROM transactionlog WHERE transaction_id=$transactionId"
      .query[TransactionRow]
      .to[List]
}

sealed trait TransactionRowDirection {
  def name = toString().toLowerCase()
}
object TransactionRowDirection {
  case object Credit extends TransactionRowDirection
  case object Debit  extends TransactionRowDirection

  val all = List[TransactionRowDirection](Credit, Debit)
    .map(dir => (dir.name, dir))
    .toMap
  implicit def meta: Meta[TransactionRowDirection] =
    Meta.StringMeta.imap(all(_))(_.name)
}

case class TransactionTreeTransfer(account: Id[Account], amount: BigDecimal)
case class TransactionTreeItem(
    transaction: Id[Transaction],
    from: List[TransactionTreeTransfer],
    to: TransactionTreeTransfer
)
case class TransactionTree(items: List[TransactionTreeItem])
object TransactionTree {
  def aroundAccount(accountId: Id[Account]) =
    Transaction
      .forAccount(accountId)
      .flatMap(
        _.map(transaction => itemsForTransaction(transaction.id)).sequence
          .map(_.flatten)
      )
      .map(TransactionTree(_))

  def itemsForTransaction(
      transactionId: Id[Transaction]
  ): ConnectionIO[List[TransactionTreeItem]] =
    TransactionRow.forTransaction(transactionId).map { rows =>
      val credits =
        rows.filter(_.direction == TransactionRowDirection.Credit)
      val debits            = rows.filter(_.direction == TransactionRowDirection.Debit)
      val totalCreditAmount = credits.map(_.amount).sum
      credits.map(
        credit =>
          TransactionTreeItem(
            credit.transaction,
            from = debits.map(
              debit =>
                TransactionTreeTransfer(
                  debit.account,
                  amount = debit.amount / totalCreditAmount * credit.amount
                )
            ),
            to = TransactionTreeTransfer(credit.account, amount = credit.amount)
          )
      )
    }
}

object LogcoinApi extends IOApp {
  def app(transactor: Transactor[IO]) =
    HttpRoutes
      .of[IO] {
        case GET -> Root / "account" / UUIDVar(accountId) / "transaction-tree" =>
          TransactionTree
            .aroundAccount(Id[Account](accountId))
            .transact(transactor)
            .flatMap(Ok(_))
      }
      .orNotFound

  override def run(args: List[String]): IO[ExitCode] =
    BlazeServerBuilder[IO]
      .bindHttp(8080, "localhost")
      .withHttpApp(
        app(
          Transactor.fromDriverManager[IO](
            "org.postgresql.Driver",  // driver classname
            "jdbc:postgresql:logcoin" // connect URL (driver-specific)
          )
        )
      )
      .serve
      .compile
      .drain
      .as(ExitCode.Success)
}
