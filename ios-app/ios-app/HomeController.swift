import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var connectionStatusTextLabel: UILabel!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    override func viewDidLoad() {
        hideElements()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        addEventHandlers()
        establishConnection()
    }
    
    override func viewWillDisappear(animated: Bool) {
        SocketService.sharedInstance.closeConnection()
        renderDisconnected()
    }
    
    private func addEventHandlers() {
        SocketService.sharedInstance.addEventHandler("message") { [weak self] (data, ack) in
            if let result = data?[0] as? String {
                self!.resultsLabel.text = result
                self!.resultsLabel.hidden = false
            }
        }
    }
    
    private func establishConnection() {
        SocketService.sharedInstance.establishConnection()
        
        renderConnecting()
        
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            if SocketService.sharedInstance.isConnected() {
                self.renderConnected()
            }
        }
    }
    
    
    // MARK: - Render
    private func hideElements() {
        resultsLabel.hidden = true
    }
    
    private func renderConnecting() {
        connectionStatusLabel.textColor = UIColor.yellowColor()
        connectionStatusTextLabel.text = "Connecting..."
    }
    
    private func renderConnected() {
        self.connectionStatusLabel.textColor = UIColor.greenColor()
        self.connectionStatusTextLabel.text = "Connected"
    }
    
    private func renderDisconnected() {
        self.connectionStatusLabel.textColor = UIColor.redColor()
        self.connectionStatusTextLabel.text = "Disconnected"
    }
}

