
internal const class SerializeStackElement {

  const Str name

  const Field[] parentFields

  const Str:Obj? parentMap
  
  const Obj parentObj

  new make(|This f| f) {
    f(this)
  }

}

internal class SerializeStack {
  
  private SerializeStackElement[] stack := [,]
  
  SerializeStackElement? pop() {
    stack.pop
  }
  
  Void put(SerializeStackElement element) {
    stack.add(element)
  }
  
  Bool isEmpty() {
    stack.isEmpty
  }
  
}
