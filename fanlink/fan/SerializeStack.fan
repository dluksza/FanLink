/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

internal const class SerializeStackElement {

  const Str name

  const Field[] parentFields

  const Str:Obj? parentMap
  
  const Obj parentObj

  new make(|This f| f) {
    f(this)
  }

}

internal class SerializeStack {
  
  private SerializeStackElement[] stack := [,]
  
  SerializeStackElement? pop() {
    stack.pop
  }
  
  Void put(SerializeStackElement element) {
    stack.add(element)
  }
  
  Bool isEmpty() {
    stack.isEmpty
  }
  
}
