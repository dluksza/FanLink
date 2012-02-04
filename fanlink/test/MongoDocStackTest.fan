
class MongoDocStackTest : Test {

  Void test() {
    stack := MongoDocStack()
    verify(stack.isEmpty)

    element1 := MongoDocStackElement {
      name = "first element"
      parentFields = [,]
      parentMap = [:]
      parentObj = it
    }

    stack.put(element1)
    verifyFalse(stack.isEmpty)
    verifyEq(stack.pop, element1)
    verify(stack.isEmpty)

    element2 := MongoDocStackElement {
      name = "second element"
      parentFields = [,]
      parentMap = [:]
      parentObj = it
    }
    element3 := MongoDocStackElement {
      name = "third element"
      parentFields = [,]
      parentMap = [:]
      parentObj = it
    }

    stack.put(element2)
    stack.put(element3)
    verifyFalse(stack.isEmpty)
    verifyEq(stack.pop, element3)
    verifyFalse(stack.isEmpty)
    verifyEq(stack.pop, element2)
    verify(stack.isEmpty)
  }

}
