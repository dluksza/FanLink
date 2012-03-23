/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

class Deserializer {

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

}
