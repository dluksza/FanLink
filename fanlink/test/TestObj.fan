using mongo

const class TestObj : MongoDoc {

  const Str string

  const Decimal decimal
  
  override const ObjectID? id
  
  new make(|This f| f) {
    f(this)
  }
  
}