
const class MongoDocStackElement {

  const Str name

  const Field[] parentFields

  const Str:Obj? parentMap

  new make(|This f| f) {
    f(this)
  }

}

class MongoDocStack {
  
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
