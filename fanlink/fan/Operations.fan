/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

using mongo

class Operations {

  static Void insert(DB db, MongoDoc obj, Bool safe := false) {
    type := Type.of(obj)
    doc := Serializer.serialize(obj)
    collectionName := Utils.mongoDocName(type)

    db.collection(collectionName).insert(doc, safe)
  }

  static Void update(DB db, FindFilter filter, MongoDoc obj,
                Bool upsert := false, Bool multi := false, Bool safe := false) {
    mongoFilter := getMongoFindObj(filter)
    doc := Serializer.serialize(obj)
    collectionName := Utils.mongoDocName(mongoFilter.type)

    db.collection(collectionName).update(mongoFilter.filterMap, doc, upsert, multi, safe)
  }

  static MongoDoc[] findAll(DB db, Type type) {
    collectionName := Utils.mongoDocName(type)
    collections := db.collection(collectionName).find
    result := MongoDoc[,]
    collections.each |element| {
      result.add(Deserializer.deserialize(element, type))
    }

    return result.toImmutable
  }

  static MongoDoc findOne(DB db, Type type) {
    collectionName := Utils.mongoDocName(type)
    collection := db.collection(collectionName).findOne
    return Deserializer.deserialize(collection, type)
  }

  static MongoDoc[] find(DB db, FindFilter filter, FindOpts opts := FindOpts {}) {
    mongoFilter := getMongoFindObj(filter, opts)
    collectionName := Utils.mongoDocName(mongoFilter.type)
    collections := db.collection(collectionName).find(mongoFilter.filterMap, mongoFilter.options)
    result := MongoDoc[,]
    collections.each |element| {
      result.add(Deserializer.deserialize(element, mongoFilter.type))
    }

    return result.toImmutable
  }

  internal static MongoFindObj getMongoFindObj(FindFilter filter, FindOpts opts := FindOpts {}) {
    MongoFindObj {
      type = filter.filter.typeof
      options = FindOpts.convertToMap(opts)
      filterMap = Serializer.serialize(filter.filter).exclude |value, key| {
        !filter.fieldNames.contains(key)
      }
    }
  }

}

internal const class MongoFindObj {
  const Type type
  const Str:Obj? filterMap
  const Str:Obj options

  new make(|This f| f) {
    f(this)
  }
}