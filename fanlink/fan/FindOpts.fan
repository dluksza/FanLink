const class FindOpts {

  const Int? skip

  const Int? limit

  const Int? batchsize

  const Str[]? fields

  new make(|This f| f) {
    f(this)
  }

  internal static Str:Obj convertToMap(FindOpts opts) {
    result := Str:Obj[:]
    FindOpts#.fields.each |field| {
      value := field.get(opts)
      if (value != null)
        result[field.name] = value
    }

    return result
  }

}