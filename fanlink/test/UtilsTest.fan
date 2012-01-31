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
  
}

class ValidMongoDocId {
  ObjectID id := ObjectID()
}

class InvalidMongoDocId {
  Str id := "should be ObjectID"
  
  ObjectID nestedId := ObjectID()
}
