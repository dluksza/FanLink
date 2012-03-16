class FindOptsTest : Test {
  
  Void testReturnEmptyMapWhenAllOptionsAreNull() {
  	// given
    opts := FindOpts {}
  	
  	// when
    result := FindOpts.convertToMap(opts)
  
  	// then
    verifyNotNull(result)
  	verify(result.isEmpty)
  }

  Void testReturnOneEntryWhenSingleOptionIsSet() {
  	// given
    opts := FindOpts { limit = 10 }

  	// when
    result := FindOpts.convertToMap(opts)

  	// then
  	verifyNotNull(result)
    verifyEq(result.size, 1)
    verify(result.containsKey("limit"))
    verifyEq(result["limit"], 10)
  }

}
