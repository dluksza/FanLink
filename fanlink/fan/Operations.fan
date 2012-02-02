using mongo

class Operations {

  static Void persistObj(DB db, MongoDoc obj) {
    stack := MongoDocStack()
    Str:Obj? doc := [:] 
    type := Type.of(obj)
    fields := type.fields.dup
    collectionName := Utils.mongoDocName(type)
    
    while (true) {
      field := fields.pop
      if (field == null) {
        if (!stack.isEmpty){
          // restore from stack
          element := stack.pop
          fields = element.parentFields.dup
          doc = element.parentMap.dup.add(element.name, doc)
          obj = element.parentObj
          continue
        } else
          break
      }
      // don't persist transient and id fields
      if (isTransient(field) || Utils.isMongoDocId(field))
        continue;
      
      fType := field.type
      if (Utils.isSimpleType(fType))
        // persist simple field
        doc.add(field.name, field.get(obj))
      else if (Utils.isComplexType(fType) && field.get(obj) != null) {
        // put current data on stack
        stack.put(MongoDocStackElement {
          name = field.name
          parentFields = fields
          parentMap = doc
          parentObj = obj
        })
        // reset data
        doc = [:]
        fields = field.type.fields.dup
        obj = field.get(obj)
      } else
        throw FanLinkSerializationErr("Cannot serialize object type ${fType} in obj ${type}")
    }
    db.collection(collectionName).insert(doc)
  }
  
  internal static Bool isTransient(Field field) {
    return field.hasFacet(Transient#)
  }

}
