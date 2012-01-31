using mongo

internal final class Utils {
  
  private new make() { /* prevent from creating instances */ }
  
  static Str mongoDocName(Type type) {
    return type.pod.name + "_" + type.name
  }
  
  static Bool isMongoDocId(Field field) {
    return field.type == ObjectID# && field.name == "id"
  }
  
}
