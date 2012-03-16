const class FindFilter {

  const MongoDoc filter

  const Field[] interestingFields
  
  internal const Str[] fieldNames

  new make(|This f| f) {
    f(this)
    tmpFieldNames := List(Str#, interestingFields.size)
    interestingFields.each |field| {
      tmpFieldNames.add(field.name)
    }
    fieldNames = tmpFieldNames.toImmutable
  }

}
