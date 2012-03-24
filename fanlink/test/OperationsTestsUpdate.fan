/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

class OperationsTestsUpdate : BaseITest {

  Void testUpdateOneObject() {
    // given
    found := createTestObj("string", 1d)
    modified := TestObj {
      string = "changed"
      decimal = found.decimal
    }
    findFilter := FindFilter {
      filter = TestObj {
        string = "uninteresting"
        decimal = -1d
        _id = found._id
      }
      interestingFields = [TestObj#_id]
    }

    // when
    Operations.update(db, findFilter, modified)

    // then
    result := Operations.findAll(db, TestObj#)
    verifyEq(result.size, 1)
    result = Operations.find(db, FindFilter {
      filter = TestObj {
        string = "changed"
        decimal = -1d
      }
      interestingFields = [TestObj#string]
    })
    verifyEq(result.size, 1)
    assertTestObj("changed", 1d, result[0])
    r := result[0] as TestObj
    verifyEq(r._id, found._id)
  }

  Void testUpdateTwoOfThreeObjects() {
    // given
    createTestObj("string", 1d)
    createTestObj("string", 2d)
    createTestObj("test", 1d)
    modified := TestObj {
      string = "test"
      decimal = 1d
    }
    findFilter := FindFilter {
      filter = TestObj {
        string = "string"
        decimal = -1d
      }
      interestingFields = [TestObj#string]
    }

    // when
    Operations.update(db, findFilter, modified)

    // then
    result := Operations.findAll(db, TestObj#)
    verifyEq(result.size, 3)
    result = Operations.find(db, FindFilter {
      filter = TestObj {
        string = "test"
        decimal = 1d
      }
      interestingFields = [TestObj#string]
    })
    verifyEq(result.size, 2)
    assertTestObj("test", 1d, result[0])
    assertTestObj("test", 1d, result[1])
  }

  private TestObj createTestObj(Str s, Decimal d) {
    obj := TestObj {
      string = s
      decimal = d
    }
    Operations.insert(db, obj)
    result := Operations.find(db, FindFilter {
      filter = obj
      interestingFields = [TestObj#string, TestObj#decimal]
    })

    verifyEq(result.size, 1)
    verifyNotNull(result[0]._id)
    verifyType(result[0], TestObj#)
    r := result[0] as TestObj

    return r
  }

  private Void assertTestObj(Str expectedStr, Decimal expectedDecimal,
                TestObj actual) {
    verifyType(actual, TestObj#)
    a := actual as TestObj
    verifyEq(a.string, expectedStr)
    verifyEq(a.decimal, expectedDecimal)
  }

}
