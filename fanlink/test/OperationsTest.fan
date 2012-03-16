class OperationsTest : Test {

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
    map := Str:Obj?["nested": Str:Str["str": "test"]]

    // when
    result := Operations.deserialize(map, TestObjWithNested#)
    
    // then
    verifyType(result, TestObjWithNested#)
    obj := (TestObjWithNested) result
    verifyEq(obj.nested.str, "test")
  }

  Void testDeserializeComplexNestedObj() {
    // given
    map := Str:Obj?["nestedList": [Str:Obj?[
        "nestedMap": Str:Decimal["one": 1d],
        "secondLevel": Str:Obj?["nestedList": Str["b", "c"]]
     ]]]

    // when
    result := Operations.deserialize(map, TestObjWithDoubleNesting#)

    // then
    verifyType(result, TestObjWithDoubleNesting#)
    obj := (TestObjWithDoubleNesting) result
    verifyEq(obj.nestedList.size, 1)
    nested := obj.nestedList[0]
    verifyType(nested.nestedMap, Str:Decimal#)
    verifyType(nested.secondLevel.nestedList, Str[]#)
    verifyEq(nested.nestedMap, ["one": 1d])
    verifyEq(nested.secondLevel.nestedList, ["b", "c"])
  }

}
