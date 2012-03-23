/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

internal class Serializer {

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
