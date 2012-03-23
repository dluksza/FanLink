using mongo

**
** Base type for all MongoDB documents
**
const mixin MongoDoc {

  **
  ** Unique document id
  **
  abstract ObjectID? _id()

}
