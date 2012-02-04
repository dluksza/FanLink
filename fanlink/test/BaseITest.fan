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
    verifyEq(map["decimal"], 8.0f)
    verifyEq(map["string"], "asd")
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
    verifyEq(map["persistent"], "persistent")
    verify(!map.containsKey("transient"))
  }

  Void testThrownExceptionWhenNonSerializableObjIsMeet() {
    // given
    obj := TestNonSerializableObject { 
      nonSerializable = ``
    }

    // when
    verifyErr(FanLinkSerializationErr#, |->| {
      Operations.persistObj(db, obj)
    })
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
    verifyEq(list.size, 2)
    verifyEq(list.get(0), "one")
    verifyEq(list.get(1), "two")
    verifyType(map["mapping"], [Str:Obj?]#)
    mapping := (Map) map["mapping"]
    verifyEq(mapping.size, 2)
    verifyEq(mapping["one"], "jeden")
    verifyEq(mapping["two"], "dwa")
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
    verifyType(map["nested"], [Str:Obj?]#)
    nested := (Map) map["nested"]
    verifyEq(nested["str"], "test")
  }

  Void testPersistingComplexNestedObjects() {
    // given
    obj := TestObjWithDoubleNesting {
      nestedList = [FirstLevelNestedObj {
        nestedMap = ["one": 1d]
        secondLevel = SecondLevelNestedObj {
          nestedList = ["b", "c"]
        }
      }]
    }

    // when
    Operations.persistObj(db, obj)

    // then
    map := findPersistedObj(TestObjWithDoubleNesting#)
    verifyType(map["nestedList"], Obj?[]#)
    nestedList := (Obj?[]) map["nestedList"]
    verifyEq(nestedList.size, 1)
    verifyType(nestedList[0], [Str:Obj?]#)
    listElement := (Str:Obj?) nestedList[0]
    verifyEq(listElement.size, 2)
    verifyType(listElement["nestedMap"], [Str:Obj?]#)
    verifyType(listElement["secondLevel"], [Str:Obj?]#)
    nestedMap := (Str:Obj?) listElement["nestedMap"]
    secondLevel := (Str:Obj?) listElement["secondLevel"]
    verifyEq(nestedMap.size, 1)
    verifyEq(secondLevel.size, 1)
    verifyEq(nestedMap["one"], 1f)
    verifyType(secondLevel["nestedList"], Obj?[]#)
    innerList := (Obj?[]) secondLevel["nestedList"]
    verifyEq(innerList.size, 2)
    verifyEq(innerList[0], "b")
    verifyEq(innerList[1], "c")
  }

  private Str:Obj? findPersistedObj(Type type) {
    result := db.collection(Utils.mongoDocName(type)).find
    verifyEq(result.count, 1)

    return result.next
  }

}
