/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

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
