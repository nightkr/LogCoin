package logcoin
import cats.effect.IOApp
import cats.effect.{ExitCode, IO}
import cats.implicits._
import org.http4s.server.blaze.BlazeServerBuilder
import org.http4s._
import org.http4s.implicits._
import org.http4s.dsl.io._

object LogcoinApi extends IOApp {
  def app =
    HttpRoutes
      .of[IO] {
        case _ => Ok("hi")
      }
      .orNotFound

  override def run(args: List[String]): IO[ExitCode] =
    BlazeServerBuilder[IO]
      .bindHttp(8080, "localhost")
      .withHttpApp(app)
      .serve
      .compile
      .drain
      .as(ExitCode.Success)
}
