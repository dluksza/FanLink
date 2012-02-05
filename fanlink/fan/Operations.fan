using mongo

class Operations {

  static Void persistObj(DB db, MongoDoc obj) {
    type := Type.of(obj)
    doc := serialize(obj)
    collectionName := Utils.mongoDocName(type)

    db.collection(collectionName).insert(doc)
  }

  internal static Str:Obj? serialize(MongoDoc obj) {
    doc := Str:Obj?[:]
    type := Type.of(obj)
    stack := MongoDocStack()
    fields := type.fields.dup

    while (true) {
      if (fields.isEmpty) {
        if (!stack.isEmpty) {
          // restore from stack
          element := stack.pop
          fields = element.parentFields.dup
          doc = element.parentMap.dup.add(element.name, doc)
          obj = element.parentObj
          continue

        } else
          break
      }

      field := fields.pop
      // don't persist transient and id fields
      if (isTransient(field) || Utils.isMongoDocId(field))
        continue

      fType := field.type
      value := field.get(obj)
      if (Utils.isParametrizedWithMongoDoc(fType))
        if (fType.fits(Map#))
          doc[field.name] = serializeMongoDocMap(value)
        else if (fType.fits(List#))
          doc[field.name] = serializeMongoDocList(value)
        else
          throw FanLinkSerializationErr("Unsupported parameterized type: ${fType}")
      else if (Utils.isSimpleType(fType))
        // persist simple field
        doc.add(field.name, field.get(obj))
      else if (Utils.isComplexType(fType) && value != null) {
        // put current data on stack
        stack.put(MongoDocStackElement {
          name = field.name
          parentFields = fields
          parentMap = doc
          parentObj = obj
        })
        // reset data
        doc = Str:Obj?[:]
        fields = field.type.fields.dup
        obj = value
      } else
        throw FanLinkSerializationErr("Cannot serialize object type ${fType} in obj ${type}")
    }

    return doc
  }

  internal static MongoDoc deserialize(Str:Obj? map, Type type) {
    fields := Field:Obj?[:]
    map.each |value, key| {
      fields[type.field(key)] = value.toImmutable
    }
    setFunc := Field.makeSetFunc(fields)
    result := type.make([ setFunc ])

    return result
  }

  internal static Bool isTransient(Field field) {
    return field.hasFacet(Transient#)
  }

  private static Str:Obj? serializeMongoDocMap(Map map) {
    result := Str:Obj?[:]
    map.each |mapValue, key| {
      result[key] = serialize(mapValue)
    }

    return result
  }

  private static [Str:Obj?][] serializeMongoDocList(List list) {
    result := Str:Obj?[,]
    list.each |listValue| {
      result.add(serialize(listValue))
    }

    return result
  }

}
