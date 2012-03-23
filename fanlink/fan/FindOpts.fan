/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

**
** List of additional options that could be
** passed into find method
**
const class FindOpts {

  **
  ** Skip this number of documents in the result set
  **
  const Int? skip

  **
  ** The maximum number of results to return
  **
  const Int? limit

  **
  ** The max number of documents to return in any
  ** intermediate fetch while iterating the Cursor
  **
  const Int? batchsize

  **
  ** A List of the field names to return, such that
  ** the entire object is not retrieved
  **
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