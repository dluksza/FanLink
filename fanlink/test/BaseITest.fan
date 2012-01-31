using mongo

class BaseITest : Test {
  
  static const Mongo m := Mongo("127.0.0.1", 27017)
  
  private DB? db;
  
  override Void setup() {
    m.db("test-db").drop
    db = m.db("test-db")
  }
  
  override Void teardown() {
    m.db("test-db").drop
  }
  
  Void testPersistingSimpleObjects() {
    // given
    obj := TestObj {
      string = "asd"
      decimal = 8d
    }
    
    // when
    Operations.persistObj(db, obj)
    
    // then
    result := db.collection(Utils.mongoDocName(TestObj#)).find
    verify(result.count == 1)
    map := result.next
    verify(map["decimal"] == 8.0f)
    verify(map["string"] == "asd")
  }

  Void testNotPersistingTransientFields() {
    // given
    obj := TestObjWithTransient {
      transient = "transient"
      persistent = "persistent"
    }

    //when
    Operations.persistObj(db, obj)

    // then
    result := db.collection(Utils.mongoDocName(TestObjWithTransient#)).find
    verify(result.count == 1)
    map := result.next
    verify(map["persistent"] == "persistent")
    verify(!map.containsKey("transient"))
  }

}
