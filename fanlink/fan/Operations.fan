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
    type := filter.filter.typeof
    filterMap := Serializer.serialize(filter.filter)
    options := FindOpts.convertToMap(opts)
    collectionName := Utils.mongoDocName(type)
    filterMap = filterMap.exclude |value, key| {
      !filter.fieldNames.contains(key)
    }
    collections := db.collection(collectionName).find(filterMap, options)
    result := MongoDoc[,]
    collections.each |element| {
      result.add(Deserializer.deserialize(element, type))
    }

    return result.toImmutable
  }

}
