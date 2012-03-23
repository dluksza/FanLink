/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

using mongo

class BaseITest : Test {

  static const Mongo m := Mongo("127.0.0.1", 27017)

  protected DB? db;

  override Void setup() {
    m.db("test-db").drop
    db = m.db("test-db")
  }

  override Void teardown() {
    m.db("test-db").drop
  }

  protected Str:Obj? findPersistedObj(Type type) {
    result := db.collection(Utils.mongoDocName(type)).find
    verifyEq(result.count, 1)

    return result.next
  }

}
