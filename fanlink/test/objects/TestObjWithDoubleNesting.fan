using mongo

const class SecondLevelNestedObj : MongoDoc {
  
  const Str[] nestedList
  
  override const ObjectID? _id
  
  new make(|This f| f) {
    f(this)
  }
  
}

const class FirstLevelNestedObj : MongoDoc {
  
  const SecondLevelNestedObj secondLevel
  
  const Str:Decimal nestedMap
  
  override const ObjectID? _id
  
  new make(|This f| f){
    f(this)
  }
  
}

const class TestObjWithDoubleNesting : MongoDoc {
  
  const FirstLevelNestedObj[] nestedList
  
  override const ObjectID? _id
  
  new make(|This f| f) {
    f(this)
  }
  
}
