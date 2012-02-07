using mongo

const class TestObjWithListAndMap : MongoDoc {
  
  const Str[] strings
  
  const Str:Str mapping
  
  override const ObjectID? _id
  
  new make(|This f| f){
    f(this)
  }
  
}
