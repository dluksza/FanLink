
class SerializeStackTest : Test {

  Void test() {
    stack := SerializeStack()
    verify(stack.isEmpty)

    element1 := SerializeStackElement {
      name = "first element"
      parentFields = [,]
      parentMap = [:]
      parentObj = it
    }

    stack.put(element1)
    verifyFalse(stack.isEmpty)
    verifyEq(stack.pop, element1)
    verify(stack.isEmpty)

    element2 := SerializeStackElement {
      name = "second element"
      parentFields = [,]
      parentMap = [:]
      parentObj = it
    }
    element3 := SerializeStackElement {
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
