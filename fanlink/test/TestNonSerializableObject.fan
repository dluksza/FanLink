using mongo

const class TestNonSerializableObject : MongoDoc {
  
  const Obj nonSerializable
  
  override const ObjectID? id
  
  new make(|This f| f) {
    f(this)
  }
  
}
