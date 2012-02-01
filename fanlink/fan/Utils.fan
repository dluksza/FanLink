using mongo

internal final class Utils {
  
  private new make() { /* prevent from creating instances */ }
  
  static Str mongoDocName(Type type) {
    return type.pod.name + "_" + type.name
  }
  
  static Bool isMongoDocId(Field field) {
    return field.type == ObjectID# && field.name == "id"
  }
  
  static Bool isComplexType(Type type) {
    return type == MongoDoc#;
  }
  
  static Bool isSimpleType(Type type) {
    return type == Str# || type == Int# || type == Float# ||
            type == Decimal# || type == Date# || type == Buf# ||
            type == List# || type == Bool# || type == Map# ||
            type == Code# || type == ObjectID#;
  }
  
}
