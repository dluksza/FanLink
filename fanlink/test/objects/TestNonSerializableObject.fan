using mongo

const class TestNonSerializableObject : MongoDoc {
  
  const Obj nonSerializable
  
  override const ObjectID? _id
  
  new make(|This f| f) {
    f(this)
  }
  
}
