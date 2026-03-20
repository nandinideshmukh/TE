class Person(make: String, model: Int) {

  def displayInfo(): Unit = {
    println(s"Person Information:\nName - $make, Age - $model")
  }

  def get_age():Unit = {
    println(s"Age of person is: $model")
  }
}

object PersonDemo {
  def main(args: Array[String]): Unit = {
    val p = new Person("Chiku", 14)

    p.displayInfo()
    p.get_age()
  }
}
