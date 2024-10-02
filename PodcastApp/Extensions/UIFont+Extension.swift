import UIKit

extension UIFont {
    
    enum FontName: String {
        case manrope700 = "manrope-medium"
        case manrope400 = "manrope-light"
        case plusJakartaSans700 = "PlusJakartaSans-Bold"
        case plusJakartaSans600 = "PlusJakartaSans-SemiBold"
        case plusJakartaSans500 = "PlusJakartaSans-Medium"
    }
    
    static func custome(name: FontName, size: CGFloat) -> UIFont?{
        UIFont(name: name.rawValue, size: size)
    }
    
}
