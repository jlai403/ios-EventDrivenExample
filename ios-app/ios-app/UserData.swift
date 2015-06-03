import Foundation

class UserData {
    
    private let NICKNAME_KEY = "nickname"
    
    var nickname: String {
        return NSUserDefaults.standardUserDefaults().stringForKey(NICKNAME_KEY)!
    }
    
    func storeNickname(nickname: String) {
        NSUserDefaults.standardUserDefaults().setValue(nickname, forKey: NICKNAME_KEY)
    }
}