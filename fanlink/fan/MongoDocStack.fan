
internal const class MongoDocStackElement {

  const Str name

  const Field[] parentFields

  const Str:Obj? parentMap
  
  const Obj parentObj

  new make(|This f| f) {
    f(this)
  }

}

internal class MongoDocStack {
  
  private MongoDocStackElement[] stack := [,]
  
  MongoDocStackElement? pop() {
    stack.pop
  }
  
  Void put(MongoDocStackElement element) {
    stack.add(element)
  }
  
  Bool isEmpty() {
    stack.isEmpty
  }
  
}
