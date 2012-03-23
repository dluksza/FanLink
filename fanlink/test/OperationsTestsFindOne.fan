/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

class OperationsTestsFindOne : BaseITest {
  
  Void testFindOneSimpleObject() {
  	// given
    obj1 := TestObj {
      string = "first object string"
      decimal = 1d
    }
    obj2 := TestObj {
      string = "second object string"
      decimal = 2d
    }

  	// when
    persistTwoObjects(obj1, obj2)
    result := Operations.findOne(db, TestObj#)

  	// then
  	verifyNotNull(result)
    verifyType(result, TestObj#)
    resultObj := result as TestObj
    verifyNotNull(result._id)
    verifyEq(resultObj.string, "first object string")
    verifyEq(resultObj.decimal, 1d)
  }
  
  Void testFindOneComplexObject() {
  	// given
    obj1 := TestObjWithDoubleNesting {
      nestedList = [FirstLevelNestedObj {
        nestedMap = ["one": 1d]
        secondLevel = SecondLevelNestedObj {
          nestedList = ["a", "b"]
        }
      }]
    }
    obj2 := TestObjWithDoubleNesting {
      nestedList = [FirstLevelNestedObj {
        nestedMap = ["two": 2d]
        secondLevel = SecondLevelNestedObj {
          nestedList = ["c", "d"]
        }
      }]
    }
  	
  	// when
    persistTwoObjects(obj1, obj2)
    result := Operations.findOne(db, TestObjWithDoubleNesting#)
  
  	// then
    verifyNotNull(result)
    verifyType(result, TestObjWithDoubleNesting#)
    resultObj := result as TestObjWithDoubleNesting
    verifyNotNull(result._id)
  	r := (TestObjWithDoubleNesting) result
    verifyEq(r.nestedList.size, 1)
    verifyType(r.nestedList[0], FirstLevelNestedObj#)
    verifyEq(r.nestedList[0].nestedMap.size, 1)
    verifyEq(r.nestedList[0].nestedMap["one"], 1d)
    verifyType(r.nestedList[0].secondLevel, SecondLevelNestedObj#)
    verifyEq(r.nestedList[0].secondLevel.nestedList.size, 2)
    verifyEq(r.nestedList[0].secondLevel.nestedList[0], "a")
    verifyEq(r.nestedList[0].secondLevel.nestedList[1], "b")
  }
  
  private Void persistTwoObjects(MongoDoc obj1, MongoDoc obj2) {
    Operations.insert(db, obj1)
    Operations.insert(db, obj2)
  }
  
}
