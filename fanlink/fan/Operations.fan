using mongo

class Operations {

  static Void persistObj(DB db, MongoDoc obj) {
    type := Type.of(obj)
    doc := Serializer.serialize(obj)
    collectionName := Utils.mongoDocName(type)

    db.collection(collectionName).insert(doc)
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
  
  static MongoDoc[] find(DB db, FindFilter filter, FindOpts opts:= FindOpts {}) {
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
