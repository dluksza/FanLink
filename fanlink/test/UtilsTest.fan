using mongo

class UtilsTest : Test {
  
  Void testMongoDocName() {
    // given
    type := UtilsTest#
    
    // when
    name := Utils.mongoDocName(type)
    
    // then
    verify(name == "fanlink_UtilsTest", "${name} != fanlink_UtilsTest")
  }
  
  Void testIsMongoDocId() {
    // given
    validField := ValidMongoDocId#.fields[0]
    invalidField1 := InvalidMongoDocId#.fields[0]
    invalidField2 := InvalidMongoDocId#.fields[1]
    
    // when
    r1 := Utils.isMongoDocId(validField)
    r2 := Utils.isMongoDocId(invalidField1)
    r3 := Utils.isMongoDocId(invalidField2)
    
    // then
    verify(r1, "should be valid mongo doc id field")
    verify(!r2, "should be invalid mongo doc id field, type shouldn't match")
    verify(!r3, "should be invalid mongo doc id field, name shouldn't match")
  }

  Void testIsSimpleType() {
    verify(Utils.isSimpleType("string"), "Str should be simple type")
    verify(Utils.isSimpleType(1), "Int should be simple type")
    verify(Utils.isSimpleType(1.0f), "Float should be simple type")
    verify(Utils.isSimpleType(0.1d), "Decimal should be simple type")
    verify(Utils.isSimpleType(Date.today), "Date should be simple type")
    verify(Utils.isSimpleType(Buf()), "Buf should be simple type")
    verify(Utils.isSimpleType([,]), "List should be simple type")
    verify(Utils.isSimpleType(false), "Bool should be simple type")
    verify(Utils.isSimpleType([:]), "Map should be simple type")
    verify(Utils.isSimpleType(Code("")), "Code should be simple type")
    verify(Utils.isSimpleType(ObjectID()), "ObjectID should be simple type")
    verify(!Utils.isSimpleType(TestObj {
      string = ""
      decimal = 2d
    }))
  }
  
  Void testIsComplexType() {
    verify(!Utils.isComplexType(Str#))
    verify(!Utils.isComplexType(Str?#))
    verify(!Utils.isComplexType(Int#))
    verify(!Utils.isComplexType(Int?#))
    verify(!Utils.isComplexType(Float#))
    verify(!Utils.isComplexType(Float?#))
    verify(!Utils.isComplexType(Decimal#))
    verify(!Utils.isComplexType(Decimal?#))
    verify(!Utils.isComplexType(Date#))
    verify(!Utils.isComplexType(Date?#))
    verify(!Utils.isComplexType(Buf#))
    verify(!Utils.isComplexType(Buf?#))
    verify(!Utils.isComplexType(List#))
    verify(!Utils.isComplexType(List?#))
    verify(!Utils.isComplexType(Bool#))
    verify(!Utils.isComplexType(Bool?#))
    verify(!Utils.isComplexType(Code#)) 
    verify(!Utils.isComplexType(Code?#)) 
    verify(!Utils.isComplexType(ObjectID#))
    verify(!Utils.isComplexType(ObjectID?#))
    verify(!Utils.isComplexType(Map?#))
    verify(!Utils.isComplexType(Map#))
    verify(!Utils.isComplexType(Obj#))
    verify(!Utils.isComplexType(Obj?#))
    verify(Utils.isComplexType(TestObj#))
    verify(Utils.isComplexType(TestObj?#))
  }

}

class ValidMongoDocId {
  ObjectID id := ObjectID()
}

class InvalidMongoDocId {
  Str id := "should be ObjectID"
  
  ObjectID nestedId := ObjectID()
}
