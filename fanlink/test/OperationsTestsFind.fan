class OperationsTestsFind : BaseITest {
  
  Void testReturnFilteredResults() {
  	// given
    initData
    filter1 := FindFilter {
      filter = TestObj {
        string = "one"
      }
      interestingFields = [TestObj#string]
    }
    filter2 := FindFilter {
      filter = TestObj {
        decimal = 2d
      }
      interestingFields = [TestObj#decimal]
    }

  	// when
    result1 := Operations.find(db, filter1)
    result2 := Operations.find(db, filter2)

  	// then
    verifyEq(result1.size, 1)
  	verifyType(result1[0], TestObj#)
    r1 := result1[0] as TestObj
    verifyEq(r1.string, "one")
    verifyEq(r1.decimal, 1d)
    verifyEq(result2.size, 1)
  	verifyType(result2[0], TestObj#)
    r2 := result2[0] as TestObj
    verifyEq(r2.string, "two")
    verifyEq(r2.decimal, 2d)
  }

  Void testReturnFilteredResults2() {
    // given
    initData
    obj := TestObj {
      string = "one"
      decimal = 1.5d
    }
    filter1 := FindFilter {
      filter = TestObj {
        string = "one"
      }
      interestingFields = [TestObj#string]
    }

    // when
    Operations.persistObj(db, obj)
    result1 := Operations.find(db, filter1)

    // then
    verifyEq(result1.size, 2)
    verifyType(result1[0], TestObj#)
    r1 := result1[0] as TestObj
    verifyEq(r1.string, "one")
    verifyEq(r1.decimal, 1d)
    verifyType(result1[1], TestObj#)
    r2 := result1[1] as TestObj
    verifyEq(r2.string, "one")
    verifyEq(r2.decimal, 1.5d)
  }
  
  Void testFindEntryWithNullValues() {
  	// given
    initData
    obj := TestObj {
      string = "none"
      decimal = null
    }
    filter := FindFilter {
      filter = TestObj {
        string = "not interesting field, but required by language syntax"
        decimal = null
      }
      interestingFields = [TestObj#decimal]
    }

  	// when
    Operations.persistObj(db, obj)
    result := Operations.find(db, filter)
  
  	// then
  	verifyNotNull(result)
    verifyEq(result.size, 1)
    verifyType(result[0], TestObj#)
    r := result[0] as TestObj
    verifyEq(r.string, "none")
    verifyNull(r.decimal)
  }
  
  Void testFindFirstTwoEntrys() {
  	// given
    initData
    obj := TestObj {
      string = "three"
      decimal = 3d
    }
    filter := FindFilter {
      filter = TestObj {
        string = "required by language syntax"
      }
      interestingFields = [,]
    }

  	// when
    Operations.persistObj(db, obj)
    result := Operations.find(db, filter, FindOpts { limit = 2 })

  	// then
  	verifyNotNull(result)
    verifyEq(result.size, 2)
    verifyType(result[0], TestObj#)
    r1 := result[0] as TestObj
    verifyEq(r1.string, "one")
    verifyEq(r1.decimal, 1d)
    verifyType(result[1], TestObj#)
    r2 := result[1] as TestObj
    verifyEq(r2.string, "two")
    verifyEq(r2.decimal, 2d)
  }

  Void testSkipOneEntry() {
    // given
    initData
    obj := TestObj {
      string = "three"
      decimal = 3d
    }
    filter := FindFilter {
      filter = TestObj {
        string = "required by language syntax"
      }
      interestingFields = [,]
    }

    // when
    Operations.persistObj(db, obj)
    result := Operations.find(db, filter, FindOpts { skip = 1 })

    // then
    verifyNotNull(result)
    verifyEq(result.size, 2)
    verifyType(result[0], TestObj#)
    r1 := result[0] as TestObj
    verifyEq(r1.string, "two")
    verifyEq(r1.decimal, 2d)
    verifyType(result[1], TestObj#)
    r2 := result[1] as TestObj
    verifyEq(r2.string, "three")
    verifyEq(r2.decimal, 3d)
  }

  Void testLimitFieldsInResult() {
    // given
    initData
    obj := TestObj {
      string = "three"
      decimal = 3d
    }
    filter := FindFilter {
      filter = TestObj {
        string = "one"
      }
      interestingFields = [TestObj#string]
    }

    // when
    Operations.persistObj(db, obj)
    result := Operations.find(db, filter, FindOpts { fields = ["string"] })

    // then
    verifyNotNull(result)
    verifyEq(result.size, 1)
    verifyType(result[0], TestObj#)
    r1 := result[0] as TestObj
    verifyEq(r1.string, "one")
    verifyEq(r1.decimal, null)
  }

  private Void initData() {
    obj1 := TestObj {
      string = "one"
      decimal = 1d
    }
    obj2 := TestObj {
      string = "two"
      decimal = 2d
    }
    Operations.persistObj(db, obj1)
    Operations.persistObj(db, obj2)
  }

}
