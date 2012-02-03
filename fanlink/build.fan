using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "fanlink"
    version = Version("0.1")
    summary = "Fantom MongoDb mapper"
    srcDirs = [`test/`, `test/objects/`, `fan/`]
    depends = ["sys 1.0", "mongo 1.0"]
  }
}
