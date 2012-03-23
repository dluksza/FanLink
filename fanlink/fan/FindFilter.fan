**
** Object used for finding specific documents in MongoDB
**
const class FindFilter {

  **
  ** MongoDB document that will be used for filtering results.
  ** Only that are included in interestingFields will be used
  ** to build "where" statement. 
  **
  const MongoDoc filter

  **
  ** List of fields that should be used for "where" statement
  ** 
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
