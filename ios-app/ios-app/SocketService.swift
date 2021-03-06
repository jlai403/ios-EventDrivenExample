class SocketService {
    
    static let sharedInstance = SocketService()
    
    private let SOCKET_URL = "localhost:1337"
    private let socket: SocketIOClient
    
    private var shouldReconnect: Bool
    
    private init() {
        var queryParams = ["userId": UserData().nickname]
        var connectOptions = ["connectParams": queryParams]
        socket = SocketIOClient(socketURL: SOCKET_URL, options: connectOptions)
        shouldReconnect = false
    }
    
    func establishConnection() {
        if shouldReconnect {
            self.socket.reconnect()
        } else {
            self.socket.connect()
        }
    }
    
    func closeConnection() {
        self.socket.close(fast: true)
    }
    
    func addEventHandler(name: String, callback: NormalCallback) {
        self.socket.on(name, callback: callback)
    }
    
    func isConnected() -> Bool {
        return self.socket.connected
    }
}