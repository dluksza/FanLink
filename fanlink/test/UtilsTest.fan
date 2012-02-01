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
    verify(Utils.isSimpleType(Str#))
    verify(Utils.isSimpleType(Int#))
    verify(Utils.isSimpleType(Float#))
    verify(Utils.isSimpleType(Decimal#))
    verify(Utils.isSimpleType(Date#))
    verify(Utils.isSimpleType(Buf#))
    verify(Utils.isSimpleType(List#))
    verify(Utils.isSimpleType(Bool#))
    verify(Utils.isSimpleType(Map#))
    verify(Utils.isSimpleType(Code#))
    verify(Utils.isSimpleType(ObjectID#))
    verify(!Utils.isSimpleType(Obj#))
    verify(!Utils.isSimpleType(MongoDoc#))
  }
  
  Void testIsComplexType() {
    verify(!Utils.isComplexType(Str#))
    verify(!Utils.isComplexType(Int#))
    verify(!Utils.isComplexType(Float#))
    verify(!Utils.isComplexType(Decimal#))
    verify(!Utils.isComplexType(Date#))
    verify(!Utils.isComplexType(Buf#))
    verify(!Utils.isComplexType(List#))
    verify(!Utils.isComplexType(Bool#))
    verify(!Utils.isComplexType(Map#))
    verify(!Utils.isComplexType(Code#)) 
    verify(!Utils.isComplexType(ObjectID#))
    verify(!Utils.isComplexType(Obj#))
    verify(Utils.isComplexType(MongoDoc#))
  }

}

class ValidMongoDocId {
  ObjectID id := ObjectID()
}

class InvalidMongoDocId {
  Str id := "should be ObjectID"
  
  ObjectID nestedId := ObjectID()
}
