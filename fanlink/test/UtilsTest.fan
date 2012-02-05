using mongo

class UtilsTest : Test {
  
  Void testMongoDocName() {
    // given
    type := UtilsTest#
    
    // when
    name := Utils.mongoDocName(type)
    
    // then
    verifyEq(name, "fanlink_UtilsTest")
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
    verifyFalse(r2, "should be invalid mongo doc id field, type shouldn't match")
    verifyFalse(r3, "should be invalid mongo doc id field, name shouldn't match")
  }

  Void testIsSimpleType() {
    verify(Utils.isSimpleType(Str#))
    verify(Utils.isSimpleType(Str?#))
    verify(Utils.isSimpleType(Int#))
    verify(Utils.isSimpleType(Int?#))
    verify(Utils.isSimpleType(Float#))
    verify(Utils.isSimpleType(Float?#))
    verify(Utils.isSimpleType(Decimal#))
    verify(Utils.isSimpleType(Decimal?#))
    verify(Utils.isSimpleType(Date#))
    verify(Utils.isSimpleType(Date?#))
    verify(Utils.isSimpleType(Buf#))
    verify(Utils.isSimpleType(Buf?#))
    verify(Utils.isSimpleType(List#))
    verify(Utils.isSimpleType(List?#))
    verify(Utils.isSimpleType(Bool#))
    verify(Utils.isSimpleType(Bool?#))
    verify(Utils.isSimpleType(Map#))
    verify(Utils.isSimpleType(Map?#))
    verify(Utils.isSimpleType(Code#))
    verify(Utils.isSimpleType(Code?#))
    verify(Utils.isSimpleType(ObjectID#))
    verify(Utils.isSimpleType(ObjectID?#))
    verifyFalse(Utils.isSimpleType(Obj#))
    verifyFalse(Utils.isSimpleType(Obj?#))
    verifyFalse(Utils.isSimpleType(MongoDoc#))
    verifyFalse(Utils.isSimpleType(MongoDoc?#))
    verifyFalse(Utils.isSimpleType(TestObj#))
    verifyFalse(Utils.isSimpleType(TestObj?#))
  }
  
  Void testIsComplexType() {
    verifyFalse(Utils.isComplexType(Str#))
    verifyFalse(Utils.isComplexType(Str?#))
    verifyFalse(Utils.isComplexType(Int#))
    verifyFalse(Utils.isComplexType(Int?#))
    verifyFalse(Utils.isComplexType(Float#))
    verifyFalse(Utils.isComplexType(Float?#))
    verifyFalse(Utils.isComplexType(Decimal#))
    verifyFalse(Utils.isComplexType(Decimal?#))
    verifyFalse(Utils.isComplexType(Date#))
    verifyFalse(Utils.isComplexType(Date?#))
    verifyFalse(Utils.isComplexType(Buf#))
    verifyFalse(Utils.isComplexType(Buf?#))
    verifyFalse(Utils.isComplexType(List#))
    verifyFalse(Utils.isComplexType(List?#))
    verifyFalse(Utils.isComplexType(Bool#))
    verifyFalse(Utils.isComplexType(Bool?#))
    verifyFalse(Utils.isComplexType(Code#)) 
    verifyFalse(Utils.isComplexType(Code?#)) 
    verifyFalse(Utils.isComplexType(ObjectID#))
    verifyFalse(Utils.isComplexType(ObjectID?#))
    verifyFalse(Utils.isComplexType(Map?#))
    verifyFalse(Utils.isComplexType(Map#))
    verifyFalse(Utils.isComplexType(Obj#))
    verifyFalse(Utils.isComplexType(Obj?#))
    verify(Utils.isComplexType(TestObj#))
    verify(Utils.isComplexType(TestObj?#))
  }
  
  Void testIsParametrizedWithMongoDoc() {
    verifyFalse(Utils.isParametrizedWithMongoDoc(Str#))
    verifyFalse(Utils.isParametrizedWithMongoDoc(Type.of(["string", "list"])))
    verifyFalse(Utils.isParametrizedWithMongoDoc(Type.of([1d, 2d])))
    verifyFalse(Utils.isParametrizedWithMongoDoc(Type.of(["map": "of strings"])))
    verifyFalse(Utils.isParametrizedWithMongoDoc(Type.of([1f: 1d])))
    verify(Utils.isParametrizedWithMongoDoc(Type.of(["a": TestObj {
      string= "a"
      decimal = 1d
    }])))
    verify(Utils.isParametrizedWithMongoDoc(Type.of([TestObj {
      string = "b"
      decimal = 2d
    }])))
  }

}

class ValidMongoDocId {
  ObjectID id := ObjectID()
}

class InvalidMongoDocId {
  Str id := "should be ObjectID"
  
  ObjectID nestedId := ObjectID()
}
