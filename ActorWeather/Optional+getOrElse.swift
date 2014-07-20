// An extension to Optional type:
// getOrElse() will return optional's value if exists, otherwise the default value provided as argument will be returned.
//
// (c) Tomek Cejner 2014
// @tomekcejner
extension Optional {
    func getOrElse(val:T) -> T  {
        if getLogicValue() {
            return self!
        } else {
            return val
        }
        
    }
}
