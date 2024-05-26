import Foundation
import SwiftUI
import SwiftData
import URLImage

class URLImageService {
    static let shared = URLImageService()
    private let cache = URLImageCache()

    func getImage(url: URL) -> Image {
        if let image = cache.get(forKey: url.absoluteString) {
            return image
        } else {
            let image = ImageLoaderView(url: url, cache: cache)
            return Image(uiImage: UIImage()) // Placeholder image while loading
        }
    }
}

class ImageLoaderView: ObservableObject {
    @Published var image: Image?

    init(url: URL, cache: URLImageCache) {
        if let savedImage = cache.get(forKey: url.absoluteString) {
            image = savedImage
        } else {
            loadImage(url: url, cache: cache)
        }
    }

    func loadImage(url: URL, cache: URLImageCache) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let uiImage = UIImage(data: data) else {
                return
            }
            let image = Image(uiImage: uiImage)
            cache.set(image, forKey: url.absoluteString)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

struct URLImageCache {
    private let cache = NSCache<NSString, ImageWrapper>()

    func set(_ image: Image, forKey key: String) {
        cache.setObject(ImageWrapper(image: image), forKey: key as NSString)
    }

    func get(forKey key: String) -> Image? {
        return cache.object(forKey: key as NSString)?.image
    }
}

class ImageWrapper {
    let image: Image
    init(image: Image) {
        self.image = image
    }
}

@Model
class TrainingEntity {
    var id: String
    var trainingDate: Date
    var trainingName: String
    var exercises: [ExcerciseEntity]
    var trainingNote: String
    var trainingImage: String?
    
    init(id: String, trainingDate: Date, trainingName: String, exercises: [ExcerciseEntity], trainingNote: String, trainingImage: String? = nil) {
        self.id = id
        self.trainingDate = trainingDate
        self.trainingName = trainingName
        self.exercises = exercises
        self.trainingNote = trainingNote
        self.trainingImage = trainingImage
    }
}

@Model
class ExcerciseEntity {
    var id: String
    var name: String
    var time: Float?
    var distance: Float?
    var weight: Float?
    var sets: Int?
    var repetitions: Int?
    var notes: String
    
    init(id: String, name: String, time: Float? = nil, distance: Float? = nil, weight: Float? = nil, sets: Int? = nil, repetitions: Int? = nil, notes: String) {
        self.id = id
        self.name = name
        self.time = time
        self.distance = distance
        self.weight = weight
        self.sets = sets
        self.repetitions = repetitions
        self.notes = notes
    }
}
