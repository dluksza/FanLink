using mongo

internal final class Utils {

  private new make() { /* prevent from creating instances */ }

  static Str mongoDocName(Type type) {
    return type.pod.name + "_" + type.name
  }

  static Bool isMongoDocId(Field field) {
    nonNullable := field.type.toNonNullable
    return nonNullable == ObjectID# && field.name == "_id"
  }

  static Bool isComplexType(Type type) {
    return type.mixins.contains(MongoDoc#)
  }

  static Bool isSimpleType(Type type) {
    nonNullable := type.toNonNullable
    return nonNullable.fits(Str#) || nonNullable.fits(Int#) ||
            nonNullable.fits(Float#) || nonNullable.fits(Decimal#) ||
            nonNullable.fits(Date#) || nonNullable.fits(Buf#) ||
            nonNullable.fits(List#) || nonNullable.fits(Bool#) ||
            nonNullable.fits(Map#) || nonNullable.fits(Code#) ||
            nonNullable.fits(ObjectID#);
  }

  static Bool isParametrizedWithMongoDoc(Type type) {
    parameter := getParameterType(type)

    return parameter?.fits(MongoDoc#) ?: false
  }

  static Type? getParameterType(Type type) {
    return type.params["V"]
  }

}
