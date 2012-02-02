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
  
  static Bool isSimpleType(Type type) {
    nonNullable := type.toNonNullable
    return nonNullable == Str# || nonNullable == Int# || nonNullable == Float# ||
            nonNullable == Decimal# || nonNullable == Date# || nonNullable == Buf# ||
            nonNullable == List# || nonNullable == Bool# || nonNullable == Map# ||
            nonNullable == Code# || nonNullable == ObjectID#;
  }
  
}
