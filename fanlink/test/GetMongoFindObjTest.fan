/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

class GetMongoFindObjTest : Test {

  Void testOneInterestingField() {
    // given
    filter := FindFilter {
      filter = TestObj {
        string = "interesting"
        decimal = -1d
      }
      interestingFields = [TestObj#string]
    }

    // when
    result := Operations.getMongoFindObj(filter)

    // then
    verifyNotNull(result)
    verifyEq(result.type, TestObj#)
    verifyEq(result.options.size, 0)
    verifyEq(result.filterMap, Str:Obj?["string": "interesting"])
  }

  Void testMultipleInterestingField() {
    // given
    filter := FindFilter {
      filter = TestObj {
        string = "interesting"
        decimal = 1d
      }
      interestingFields = [TestObj#string, TestObj#decimal]
    }

    // when
    result := Operations.getMongoFindObj(filter)

    // then
    verifyNotNull(result)
    verifyEq(result.type, TestObj#)
    verifyEq(result.options.size, 0)
    verifyEq(result.filterMap, Str:Obj?["string": "interesting", "decimal": 1d])
  }

  Void testOptsConversion() {
    // given
    filter := FindFilter {
      filter = TestObj {
        string = "uninteresting"
        decimal = -1d
      }
      interestingFields = [,]
    }

    // when
    result := Operations.getMongoFindObj(filter, FindOpts {
      skip = 2
      limit = 3
    })

    // then
    verifyNotNull(result)
    verifyEq(result.type, TestObj#)
    verifyEq(result.options, Str:Obj["skip": 2, "limit": 3])
    verifyEq(result.filterMap, Str:Obj?[:])
  }

}
