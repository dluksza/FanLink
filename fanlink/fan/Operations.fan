using mongo

class Operations {

  static Void persistObj(DB db, MongoDoc obj) {
    type := Type.of(obj)
    collectionName := Utils.mongoDocName(type)
    Str:Obj? doc := [:] 
    type.fields.each |field| {
      if (!Utils.isMongoDocId(field) && !isTransient(field))
        doc.add(field.name, field.get(obj))
    }

    db.collection(collectionName).insert(doc)
  }
  
  private static Bool isTransient(Field field) {
    return field.hasFacet(Transient#)
  }

}
