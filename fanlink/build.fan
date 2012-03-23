/*******************************************************************************
 * Copyright (C) 2012, Dariusz Luksza <dariusz@luksza.org>
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

using build

class Build : BuildPod {

  new make() {
    podName = "fanlink"
    version = Version("0.1")
    summary = "Fantom objects to MongoDB mapper"
    srcDirs = [`test/`, `test/objects/`, `fan/`]
    depends = ["sys 1.0", "mongo 1.0"]
    meta = [
      "org.name": "87Threads",
      "license.name": "EPL-1.0",
      "vcs.name": "Git",
      "vcs.uri": "https://github.com/dluksza/FanLink"
    ]
  }

}
