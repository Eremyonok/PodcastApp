import UIKit

final class CustomSlider: UISlider {
    
    // MARK: - Publc Properties
    var trackHeight: CGFloat = 1
    
    // MARK: - Init
    init(trackHeight: CGFloat) {
        super.init(frame: .zero)
        self.trackHeight = trackHeight
        setupSlider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        // устанавливаем высоту линии слайдера
        newRect.size.height = trackHeight
        return newRect
    }
    
    // MARK: - Private Methods
    private func setupSlider() {
        self.minimumTrackTintColor = #colorLiteral(red: 0.1607843137, green: 0.5085405111, blue: 0.9443863034, alpha: 1)
        self.maximumTrackTintColor = #colorLiteral(red: 0.1607843137, green: 0.5085405111, blue: 0.9443863034, alpha: 1)
        
        if let originalThumbImage = UIImage(systemName: "circle.fill") {
            // увлечинение бегунка
            let thumbSize = CGSize(
                width: originalThumbImage.size.width * 0.6,
                height: originalThumbImage.size.height * 0.6
            )
            
            let thumbImage = UIGraphicsImageRenderer(size: thumbSize).image { _ in
                originalThumbImage.draw(in: CGRect(origin: .zero, size: thumbSize))
            }
            
            let coloredThumbImage = thumbImage.withTintColor(#colorLiteral(red: 0.1607843137, green: 0.5085405111, blue: 0.9443863034, alpha: 1))
            
            self.setThumbImage(coloredThumbImage, for: .normal)
            self.setThumbImage(coloredThumbImage, for: .highlighted)
        }
    }
}
