class FindFilterTest : Test {

  Void testEmptyFieldNameList() {
  	// when
    filter := FindFilter {
      filter = TestObj {
        string = "none"
      }
      interestingFields = [,]
    }

  	// then
    verifyNotNull(filter.fieldNames)
  	verifyEq(filter.fieldNames.size, 0)
  }
  
  Void testAddAllInterestingFieldNames() {
  	// when
    filter := FindFilter {
      filter = TestObj {
        string = "interesting"
        decimal = 1d
      }
      interestingFields = [TestObj#string]
    }
  
  	// then
  	verifyNotNull(filter.fieldNames)
    verifyEq(filter.fieldNames.size, 1)
    verifyEq(filter.fieldNames[0], TestObj#string.name)
  }
  
  Void testAddAllInterestingFieldsNames1() {
  	// when
    filter := FindFilter {
      filter = TestObj {
        string = "interesting"
        decimal = 2d
      }
      interestingFields = [TestObj#string, TestObj#decimal]
    }

  	// then
  	verifyNotNull(filter.fieldNames)
    verifyEq(filter.fieldNames.size, 2)
    verify(filter.fieldNames.contains(TestObj#string.name))
    verify(filter.fieldNames.contains(TestObj#decimal.name))
  }

}
