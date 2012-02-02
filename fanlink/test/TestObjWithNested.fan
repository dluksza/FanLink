using mongo

const class Nested : MongoDoc {

  const Str str

  override const ObjectID? id

  new make(|This f| f) {
    f(this)
  }

}

const class TestObjWithNested : MongoDoc {

  const Nested nested

  override const ObjectID? id

  new make(|This f| f) {
    f(this)
  }

}