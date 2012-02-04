
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
    try {
      resutl := Operations.serialize(obj)
    } catch (FanLinkSerializationErr e) {
      return
    }
    fail("Should thrown ${FanLinkSerializationErr#}")
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
  
}
