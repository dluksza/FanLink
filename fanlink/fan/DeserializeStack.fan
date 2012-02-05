
internal const class DeserializeStackElement {

  const Type type

  const Field field

  const Str:Obj? map

  const Field:Obj? fieldsMap
  
  new make(|This f| f) {
    f(this)
  }
  
}

internal class DeserializeStack {
  
  private DeserializeStackElement[] stack := [,]
  
  DeserializeStackElement? pop() {
    stack.pop
  }
  
  Void put(DeserializeStackElement element) {
    stack.add(element)
  }
  
  Bool isEmpty() {
    stack.isEmpty
  }
  
}
