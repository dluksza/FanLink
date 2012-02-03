using mongo

internal final class Utils {
  
  private new make() { /* prevent from creating instances */ }
  
  static Str mongoDocName(Type type) {
    return type.pod.name + "_" + type.name
  }
  
  static Bool isMongoDocId(Field field) {
    nonNullable := field.type.toNonNullable
    return nonNullable == ObjectID# && field.name == "id"
  }
  
  static Bool isComplexType(Type type) {
    return type.mixins.contains(MongoDoc#)
  }
  
  static Bool isSimpleType(Obj obj) {
    return obj is Str || obj is Int || obj is Float ||
            obj is Decimal || obj is Date || obj is Buf ||
            obj is List || obj is Bool || obj is Map ||
            obj is Code || obj is ObjectID;
  }
  
  static Bool isParametrizedWithMongoDoc(Type type) {
    parameter := type.params["V"]
    return parameter?.fits(MongoDoc#) ?: false
  }
  
}
