/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

class DeserializeStackTest : Test {

  Void test() {
    stack := DeserializeStack()
    verify(stack.isEmpty)

    element1 := DeserializeStackElement {
      type = TestObj#
      field = TestObj#string
      map = [:]
      fieldsMap = [:]
    }

    stack.put(element1)
    verifyFalse(stack.isEmpty)
    verifyEq(stack.pop, element1)
    verify(stack.isEmpty)

    element2 := DeserializeStackElement {
      type = TestObj#
      field = TestObj#string
      map = [:]
      fieldsMap = [:]
    }
    element3 := DeserializeStackElement {
      type = TestObj#
      field = TestObj#string
      map = [:]
      fieldsMap = [:]
    }

    stack.put(element2)
    stack.put(element3)
    verifyFalse(stack.isEmpty)
    verifyEq(stack.pop, element3)
    verifyFalse(stack.isEmpty)
    verifyEq(stack.pop, element2)
    verify(stack.isEmpty)
  }

}
