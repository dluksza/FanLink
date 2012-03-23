/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

class DeserializerTest : Test {

  Void testDeserializeSimpleObj() {
    // given
    map := Str:Obj?["string": "str", "decimal": 8d]

    // when
    result := Deserializer.deserialize(map, TestObj#)

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
    result := Deserializer.deserialize(map, TestObjWithTransient#)

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
    result := Deserializer.deserialize(map, TestObjWithListAndMap#)

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
    result := Deserializer.deserialize(map, TestObjWithNested#)

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
    result := Deserializer.deserialize(map, TestObjWithDoubleNesting#)

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
