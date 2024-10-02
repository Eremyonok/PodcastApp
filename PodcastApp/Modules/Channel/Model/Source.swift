import UIKit

struct Channel {
    let name: String
#warning("Change UIColor to UIImage")
    let image: UIColor
    let numberOfEpizode: String
    let totalTime: String
}

struct Color{
    static let color = [UIColor(red: 0.94, green: 0.84, blue: 0.83, alpha: 1), UIColor(red: 0.67, green: 0.88, blue: 0.96, alpha: 1),UIColor(red: 0.75, green: 0.87, blue: 0.96, alpha: 1), UIColor(red: 1, green: 0.86, blue: 0.86, alpha: 1), UIColor(red: 0.59, green: 0.84, blue: 0.95, alpha: 1),UIColor(red: 0.97, green: 0.63, blue: 0.74, alpha: 1) ]
    
    static func randomColor() -> UIColor{
        return color.randomElement() ?? .cyan
    }
}

struct Source {
    static func makeChanel() -> [Channel]{
        [
            .init(name: "Between love and career  and many many more text on next row", image: Color.randomColor(), numberOfEpizode: "56 Eps", totalTime: "56:38"),
            .init(name: "The powerful way to move on", image: Color.randomColor(), numberOfEpizode: "55 Eps", totalTime: "58:40"),
            .init(name: "Monkey love makes me curious", image: Color.randomColor(), numberOfEpizode: "54 Eps", totalTime: "1:40:40"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
            .init(name: "My love is blocked by Covid-19", image: Color.randomColor(), numberOfEpizode: "53 Eps", totalTime: "1:45:20"),
        ]
    }
}
