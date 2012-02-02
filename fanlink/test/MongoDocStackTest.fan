
class MongoDocStackTest : Test {

  Void test() {
    stack := MongoDocStack()
    verify(stack.isEmpty)

    element1 := MongoDocStackElement {
      name = "first element"
      parentFields = [,]
      parentMap = [:]
    }

    stack.put(element1)
    verify(!stack.isEmpty)
    verify(stack.pop == element1)
    verify(stack.isEmpty)

    element2 := MongoDocStackElement {
      name = "second element"
      parentFields = [,]
      parentMap = [:]
    }
    element3 := MongoDocStackElement {
      name = "third element"
      parentFields = [,]
      parentMap = [:]
    }

    stack.put(element2)
    stack.put(element3)
    verify(!stack.isEmpty)
    verify(stack.pop == element3)
    verify(!stack.isEmpty)
    verify(stack.pop == element2)
    verify(stack.isEmpty)
  }

}
