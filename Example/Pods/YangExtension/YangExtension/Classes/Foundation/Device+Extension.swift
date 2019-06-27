
import YangKeychainStore
import DeviceKit

public struct YangDevice {
    
    private var _deviceId: String?
    
    public init() {
        
        _deviceId = YangKeychainStore.get("deviceId")
        
        if _deviceId == nil {
            
            let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? NSUUID().uuidString
            
            YangKeychainStore.set(deviceId, forKey: "deviceId")
            
            _deviceId = deviceId
            
        }
        
    }
    
}

public extension YangDevice {
    
    var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    var deviceId: String? {
        return _deviceId
    }
    
    var systemVersion: String {
        return Device.current.systemVersion ?? UIDevice.current.systemVersion
    }
    
    var deviceMode: String {
        return Device.current.description
    }
    
    var isXSeries: Bool {
        switch Device.current {
        case .simulator(let device):
            return device.isXSeries
        default:
            return Device.current.isXSeries
        }
    }
    
}

public extension Device {
    
    var isXSeries: Bool {
        switch self {
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
            return true
        default:
            return false
        }
    }
    
    var appName: String? {
        return YangDevice().appName
    }
    
    var appVersion: String? {
        return YangDevice().appVersion
    }
    
    var buildNumber: String? {
        return YangDevice().buildNumber
    }
    
    var deviceId: String? {
        return YangDevice().deviceId
    }
}
