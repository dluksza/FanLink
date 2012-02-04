
class OperationsTest : Test {

  Void testIsTransient() {
    // given
    transient := TestObjWithTransient#.field("transient")
    persistent := TestObjWithTransient#.field("persistent")

    // when
    shouldBeTransient := Operations.isTransient(transient)
    shouldNotBeTransient := Operations.isTransient(persistent)

    // then
    verify(shouldBeTransient)
    verify(!shouldNotBeTransient)
  }

  Void testSerializeSimpleObj() {
    // given
    obj := TestObj {
      string = "str"
      decimal = 8d
    }

    // when
    result := Operations.serialize(obj)

    // then
    map := Str:Obj?["string": "str", "decimal": 8d]
    verify(result == map, "${result} != ${map}")
  }

  Void testSerializeTransienFields() {
    // given
    obj := TestObjWithTransient {
      transient = "transient"
      persistent = "persistent"
    }

    // when
    result := Operations.serialize(obj)

    // then
    map := Str:Obj?["persistent": "persistent"]
    verify(result == map, "${result} != ${map}")
  }

  Void testThrowExceptionWhenNonSerializableObjIsMeet() {
    // given
    obj := TestNonSerializableObject {
      nonSerializable = ``
    }

    // when
    verifyErr(FanLinkSerializationErr#, |->| {
      Operations.serialize(obj)
    })
  }

  Void testSerializeNestedListAndMaps() {
    // given
    obj := TestObjWithListAndMap {
      strings = ["one", "two"]
      mapping = ["one": "jeden", "two": "dwa"]
    }

    // when
    result := Operations.serialize(obj)

    // then
    map := Str:Obj?[
      "strings": Str["one", "two"],
      "mapping": Str:Str["one": "jeden", "two": "dwa"]
    ]
    verify(result == map, "${result} != ${map}")
  }

  Void testSerializeNesteObjects() {
    // given
    obj := TestObjWithNested {
      nested = Nested {
        str = "test"
      }
    }

    // when
    result := Operations.serialize(obj)
    
    // then
    map := Str:Obj?["nested": Str:Obj?["str": "test"]]
    verify(result == map, "${result} != ${map}")
  }

  Void testSerizlizeComplexNestedObj() {
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
    result := Operations.serialize(obj)

    // then
    map := Str:Obj?["nestedList": [Str:Obj?[
        "nestedMap": Str:Decimal["one": 1d],
        "secondLevel": Str:Obj?["nestedList": Str["b", "c"]]
     ]]]
    verify(result == map, "${result} != ${map}")
  }

}
