import Foundation

struct Slide {
    let imageName: String
    let title: String
    let secontTitle: String
}

extension Slide {
    static func getInfoSlides() -> [Slide] {
        [Slide(
            imageName: "1",
            title: "Open up the world of podcasts and start exploring engaging content.",
            secontTitle: "Listen to your favourite authors and discover new and interesting podcasts."
        ),
         Slide(
            imageName: "2",
            title: "Save your favourite podcasts",
            secontTitle: "Don't miss out on any interesting programmes. Save your favourite podcasts so you always have access to them."
         ),
         Slide(
            imageName: "3",
            title: "Create your own playlists",
            secontTitle: "Organise your podcasts into easy-to-use playlists. Create your own compilations for different moods and situations."
         )]
    }
}
