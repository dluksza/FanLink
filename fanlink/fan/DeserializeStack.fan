/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

internal const class DeserializeStackElement {

  const Type type

  const Field field

  const Str:Obj? map

  const Field:Obj? fieldsMap
  
  new make(|This f| f) {
    f(this)
  }
  
}

internal class DeserializeStack {
  
  private DeserializeStackElement[] stack := [,]
  
  DeserializeStackElement? pop() {
    stack.pop
  }
  
  Void put(DeserializeStackElement element) {
    stack.add(element)
  }
  
  Bool isEmpty() {
    stack.isEmpty
  }
  
}
