/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

class OperationsTestsFindAll : BaseITest {

  Void testShouldStoreAndRestoreDocument() {
    // given
    obj := TestObj {
      string = "test string"
      decimal = 11d
    }
    
    // when
    Operations.insert(db, obj)
    result := Operations.findAll(db, TestObj#)
    
    // then
    findPersistedObj(TestObj#)
    verifyNull(obj._id)
    verifyEq(result.size, 1)
    verifyNotNull(result[0]._id)
    verifyType(result[0], TestObj#)
    resultObj := (TestObj) result[0]
    verifyEq(resultObj.string, "test string")
    verifyEq(resultObj.decimal, 11d)
  }
  
  Void testShouldStoreAndRestoreMultipleDocuments() {
    // given
    count := 27
    obj := TestObj[,]
    for (i := 0; i < count; i++)
      obj.add(TestObj {
        string = "test ${i}"
        decimal = i.toDecimal
      })
    
    // when
    obj.each |o| {
      Operations.insert(db, o)
    }
    result := Operations.findAll(db, TestObj#)
    
    // then
    verifyEq(result.size, 27)
    for (i := 0; i < count; i++) {
      r := result[i]
      verifyType(r, TestObj#)
      t := (TestObj) r
      verifyEq(t.string, "test ${i}")
      verifyEq(t.decimal, i.toDecimal)
    }
  }
  
  Void testShouldStoreAndRestoreComplexNestedObjects() {
    // given
    obj := TestObjWithDoubleNesting {
      nestedList = [FirstLevelNestedObj {
        nestedMap = ["one": 1d]
        secondLevel = SecondLevelNestedObj {
          nestedList = ["b", "c"]
        }
      }]
    }

    // when
    Operations.insert(db, obj)
    result := Operations.findAll(db, TestObjWithDoubleNesting#)

    // then
    findPersistedObj(TestObjWithDoubleNesting#)
    verifyEq(result.size, 1)
    verifyNotNull(result[0]._id)
    verifyType(result[0], TestObjWithDoubleNesting#)
    r := (TestObjWithDoubleNesting) result[0]
    verifyEq(r.nestedList.size, 1)
    verifyType(r.nestedList[0], FirstLevelNestedObj#)
    verifyEq(r.nestedList[0].nestedMap.size, 1)
    verifyEq(r.nestedList[0].nestedMap["one"], 1d)
    verifyType(r.nestedList[0].secondLevel, SecondLevelNestedObj#)
    verifyEq(r.nestedList[0].secondLevel.nestedList.size, 2)
    verifyEq(r.nestedList[0].secondLevel.nestedList[0], "b")
    verifyEq(r.nestedList[0].secondLevel.nestedList[1], "c")
  }

}
