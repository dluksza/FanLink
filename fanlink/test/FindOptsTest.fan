/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

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
