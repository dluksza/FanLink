using mongo

const class TestObjWithTransient : MongoDoc {
  
  @Transient
  const Str? transient
  
  const Str persistent
  
  override const ObjectID? id
  
  new make(|This f| f) {
    f(this)
  }
  
}
