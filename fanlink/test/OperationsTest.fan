
class OperationsTest : Test {
  
  Void testIsTransient() {
    // given
    transient := TestObjWithTransient#.field("transient")
    persistent := TestObjWithTransient#.field("persistent")
    
    // when
    shouldBeTransient := Operations.isTransient(transient)
    shouldNotBeTransient := Operations.isTransient(persistent)
    
    // then
    verify(shouldBeTransient)
    verify(!shouldNotBeTransient)
  }
  
}
