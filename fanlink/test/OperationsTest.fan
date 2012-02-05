
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

  Void testSerializeComplexNestedObj() {
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

  Void testDeserializeSimpleObj() {
    // given
    map := Str:Obj?["string": "str", "decimal": 8d]

    // when
    result := Operations.deserialize(map, TestObj#)

    // then
    verifyType(result, TestObj#)
    obj := (TestObj) result
    verifyEq(obj.decimal, 8d)
    verifyEq(obj.string, "str")
  }

  Void testdeserializeTransienFields() {
    // given
    map := Str:Obj?["persistent": "persistent"]

    // when
    result := Operations.deserialize(map, TestObjWithTransient#)

    // then
    verifyType(result, TestObjWithTransient#)
    obj := (TestObjWithTransient) result
    verifyEq(obj.persistent, "persistent")
  }

  Void testDeserializeNestedListAndMaps() {
    // given
    map := Str:Obj?[
      "strings": Str["one", "two"],
      "mapping": Str:Str["one": "jeden", "two": "dwa"]
    ]

    // when
    result := Operations.deserialize(map, TestObjWithListAndMap#)

    // then
    verifyType(result, TestObjWithListAndMap#)
    obj := (TestObjWithListAndMap) result
    verifyEq(obj.strings, ["one", "two"])
    verifyEq(obj.mapping, ["one": "jeden", "two": "dwa"])
  }

  Void testDeserializeNesteObjects() {
    // given
    map := Str:Obj?["nested": Str:Obj?["str": "test"]]

    // when
    result := Operations.deserialize(map, TestObjWithNested#)
    
    // then
    verifyType(result, TestObjWithNested#)
    obj := (TestObjWithNested) result
    verifyEq(obj.nested.str, "test")
  }

}
