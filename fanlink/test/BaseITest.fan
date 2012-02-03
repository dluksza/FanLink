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
    map := findPersistedObj(TestObj#)
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
    map := findPersistedObj(TestObjWithTransient#)
    verify(map["persistent"] == "persistent")
    verify(!map.containsKey("transient"))
  }

  Void testThrownExceptionWhenNonSerializableObjIsMeet() {
    // given
    obj := TestNonSerializableObject { 
      nonSerializable = ``
    }

    // when
    try {
      Operations.persistObj(db, obj)
    } catch (FanLinkSerializationErr e) {
      return
    }
    fail("FanLinkSeerializationErr should be thrown")
  }
  
  Void testPersistingNestedListsAndMaps() {
    // given
    obj := TestObjWithListAndMap {
      strings = ["one", "two"]
      mapping = ["one": "jeden", "two": "dwa"]
    }
    
    // when
    Operations.persistObj(db, obj)
    
    // then
    map := findPersistedObj(TestObjWithListAndMap#)
    verify(map["strings"] is List)
    list := (List) map["strings"]
    verify(list.size == 2)
    verify(list.get(0) == "one")
    verify(list.get(1) == "two")
    verify(map["mapping"] is Map)
    mapping := (Map) map["mapping"]
    verify(mapping.size == 2)
    verify(mapping["one"] == "jeden")
    verify(mapping["two"] == "dwa")
  }

  Void testPersistingNestedObjects() {
    // given
    obj := TestObjWithNested {
      nested = Nested {
        str = "test"
      }
    }

    // when
    Operations.persistObj(db, obj)

    // then
    map := findPersistedObj(TestObjWithNested#)
    verify(map["nested"] is Map)
    nested := (Map) map["nested"]
    verify(nested["str"] == "test")
  }

  private Str:Obj? findPersistedObj(Type type) {
    result := db.collection(Utils.mongoDocName(type)).find
    verify(result.count == 1)
    return result.next
  }
  
}
