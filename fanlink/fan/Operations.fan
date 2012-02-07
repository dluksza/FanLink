using mongo

class Operations {

  static Void persistObj(DB db, MongoDoc obj) {
    type := Type.of(obj)
    doc := serialize(obj)
    collectionName := Utils.mongoDocName(type)

    db.collection(collectionName).insert(doc)
  }
  
  static MongoDoc[] find(DB db, Type type) {
    collectionName := Utils.mongoDocName(type)
    collections := db.collection(collectionName).find
    result := MongoDoc[,]
    collections.each |element| { 
      result.add(deserialize(element, type))
    }
    
    return result.toImmutable
  }

  internal static Str:Obj? serialize(MongoDoc obj) {
    doc := Str:Obj?[:]
    type := Type.of(obj)
    stack := SerializeStack()
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
        stack.put(SerializeStackElement {
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
    fieldsMap := Field:Obj?[:]
    Str? key := null
    Obj? value := null
    stack := DeserializeStack()
    while (true) {
      if (!map.isEmpty) {
        key = map.keys.peek
        value = map.remove(key)
      } else {
        if (!stack.isEmpty) {
          obj := createObj(type, fieldsMap)
          element := stack.pop
          type = element.type
          map = element.map.dup
          field := element.field
          fieldsMap = element.fieldsMap.dup.add(field, obj)
          continue
        } else
          break
      }
      
      field := type.field(key)
      fType := field.type
      if (Utils.isParametrizedWithMongoDoc(fType)) {
        parameter := Utils.getParameterType(fType)
        if (fType.fits(Map#))
          fieldsMap[field] = deserializeMongoDocMap(value, parameter)
        else if (fType.fits(List#)) {
          fieldsMap[field] = deserializeMongoDocList(value, parameter)
        }
        else
          throw FanLinkDeserializationErr("Unknown parameterized type: ${fType}")
      } else if (Utils.isSimpleType(fType))
        fieldsMap[field] = getSimpleValue(field.type, value)
      else if (Utils.isComplexType(fType)) {
        stack.put(DeserializeStackElement {
          it.map = map
          it.type = type
          it.field = field
          it.fieldsMap = fieldsMap
        })
        map = value
        fieldsMap = [:]
        type = field.type
      }
    }

    return createObj(type, fieldsMap)
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
  
  private static Obj? getSimpleValue(Type type, Obj? value) {
    if (value == null)
      return null
    
    type = type.toImmutable
    if (value is Num) {
      numValue := (Num) value
      if (type.fits(Decimal#))
        return numValue.toDecimal.toImmutable
      else if (type.fits(Float#))
        return numValue.toFloat.toImmutable
      else if (type.fits(Int#))
        return numValue.toInt.toImmutable
    } else if (type.fits(List#)) { // value should also be List
      list := (List) value
      parameter := Utils.getParameterType(type)
      result := List(parameter, list.size)
      list.each |e| {
        result.add(getSimpleValue(parameter, e))
      } 

      return result.toImmutable
    } else if (type.fits(Map#)) { // value should also be map
      result := Map(type)
      parameter := Utils.getParameterType(type)
      ((Map) value).each |v, key|{
        result[key] = getSimpleValue(parameter, v)
      }

      return result.toImmutable
    }
   
    return value.toImmutable
  }

  private static MongoDoc createObj(Type type, Field:Obj? fields) {
    setFunc := Field.makeSetFunc(fields)
    obj := type.make([ setFunc ])
    
    return obj
  }

  private static Obj:MongoDoc? deserializeMongoDocMap(Str:Str:Obj? map, Type type) {
    result := Obj:MongoDoc?[:]
    map.each |value, key| {
      result[key] = deserialize(value, type)
    }

    return result.toImmutable
  }

  private static List deserializeMongoDocList([Str:Obj?][] list, Type type) {
    result := List(type, list.size)
    list.each |value| {
      result.add(deserialize(value, type))
    }

    return result.toImmutable
  }

}
