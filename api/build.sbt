ThisBuild / scalaVersion := "2.12.9"
ThisBuild / scalafmtOnCompile := true

scalacOptions ++= Seq("-Ypartial-unification", "-deprecation", "-feature")

val http4sVersion = "0.20.10"

libraryDependencies ++= Seq(
  "org.http4s"     %% "http4s-dsl"          % http4sVersion,
  "org.http4s"     %% "http4s-blaze-server" % http4sVersion,
  "org.http4s"     %% "http4s-blaze-client" % http4sVersion,
  "ch.qos.logback" % "logback-classic"      % "1.2.3"
)
