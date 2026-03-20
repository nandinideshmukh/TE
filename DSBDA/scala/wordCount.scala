val text = "This is a simple Scala program. This program counts the words."

val wordCounts = text
  .toLowerCase
  .split("[^\\w']+")
  .filter(_.nonEmpty)
  .groupMapReduce(identity)(_ => 1)(_ + _)

object MAin{
    def main(args: Array[String]): Unit = {
        println(wordCounts)
    }
}