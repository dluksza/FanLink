FanLink
=======

FanLink allows you easily save and find [Fantom](http://www.fantom.org/) objects in [MongoDB](http://www.mongodb.org/). It uses Fantom reflection API to convert MongoDoc object to Str:Obj? map then [fantomongo](https://bitbucket.org/liamstask/fantomongo/wiki/Home) to persist this map in MongoDB. De serialization works other way around.

Mongo collection name is automatically created based on pod name and object name eg. class User in pod example will be saved in example_User collection.

Nested objects are converted into nested maps, FanLink doesn't support DBRef.

Examples
========

Each persist able object must:

 * be a const class,
 * extend MongoDoc mixin,
 * define it-block-constructor and
 * define storage for _id eg:

```fantom
using fanlink
using fantomongo

const class SimpleMongoObj : MongoDoc {
  const Str name
  const Str surname
  const Decimal number?
  override const ObjectID? _id

  new make(|This f| f) {
    f(this)
  }
}
```

All simple types like:

 * Str,
 * Bool,
 * Decimal,
 * Float,
 * Int,
 * Date,
 * Buf

are supported. Also nested List and Map are supported, same as nested instances of MongoDoc, List[MongoDoc] and Map[x, MongoDoc].

To persist object simply call:

```fantom
db := Mongo().db("test")
Operations.insert(db, SimpleMongoObj{ name = "John"; surname = "Doe" })
```

When you want get all documents of given type call just:

```fantom
allDocuments := Operations.findAll(db, SimpleMongoObj#)
```

In case of finding all documents where name attribute has value "John" run:

```fantom
filterObj := SimpleMongoObj {
  name = "John"
  surname = "required by language syntax"
}
findFilter := FindFilter {
  filter = filterObj
  interestingFields = [SimpleMongoObj#name]
}
allJohnes := Operations.find(db, findFilter)
```


If you want find first 5 SimpleMongoObj documents with number field set to 8 call:

```fantom
filterObj := SimpleMongoObj {
  name = "uninteresting"
  surname = "uninteresting"
  number = 8d
}
findFilter := FindFilter {
  filter = filterObj
  interestingFields = [SimpleMongoObj#number]
}
number8 := Operations.find(db, findFilter, FindOpts { limit = 5 })
```

For more examples see Operations*Test.fan inside test directory
