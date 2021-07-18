import Foundation

// MARK: - Result

/// A result data object
public struct ResultVO: Codable {
    public let popularity: Double?
    public let voteCount: Int?
    public let video: Bool?
    public let posterPath: String?
    public let id: Int?
    public let adult: Bool?
    public let backdropPath: String?
    public let originalLanguage: String?
    public let originalTitle: String?
    public let genreIDS: [Int]?
    public let title: String?
    public let voteAverage: Double?
    public let overview: String?
    public let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case popularity = "popularity"
        case voteCount = "vote_count"
        case video = "video"
        case posterPath = "poster_path"
        case id = "id"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case title = "title"
        case voteAverage = "vote_average"
        case overview = "overview"
        case releaseDate = "release_date"
    }

    public init(popularity: Double?, voteCount: Int?, video: Bool?, posterPath: String?, id: Int?, adult: Bool?, backdropPath: String?, originalLanguage: String?, originalTitle: String?, genreIDS: [Int]?, title: String?, voteAverage: Double?, overview: String?, releaseDate: String?) {
        self.popularity = popularity
        self.voteCount = voteCount
        self.video = video
        self.posterPath = posterPath
        self.id = id
        self.adult = adult
        self.backdropPath = backdropPath
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.genreIDS = genreIDS
        self.title = title
        self.voteAverage = voteAverage
        self.overview = overview
        self.releaseDate = releaseDate
    }
}
