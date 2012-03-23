/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

using mongo

const class SecondLevelNestedObj : MongoDoc {
  
  const Str[] nestedList
  
  override const ObjectID? _id
  
  new make(|This f| f) {
    f(this)
  }
  
}

const class FirstLevelNestedObj : MongoDoc {
  
  const SecondLevelNestedObj secondLevel
  
  const Str:Decimal nestedMap
  
  override const ObjectID? _id
  
  new make(|This f| f){
    f(this)
  }
  
}

const class TestObjWithDoubleNesting : MongoDoc {
  
  const FirstLevelNestedObj[] nestedList
  
  override const ObjectID? _id
  
  new make(|This f| f) {
    f(this)
  }
  
}
