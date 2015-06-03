import UIKit

class SetupController: UIViewController {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBAction func saveNickname(sender: AnyObject) {
        UserData().storeNickname(nicknameTextField.text)
    }
}