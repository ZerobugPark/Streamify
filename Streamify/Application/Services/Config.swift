//
//  Configuration.swift
//  TestStreamify
//
//  Created by 조다은 on 3/21/25.
//

import Foundation

struct Config {
    static let shared = Config()
    
    let baseURL = "http://image.tmdb.org/t/p/"
    let secureURL = "https://image.tmdb.org/t/p/"
    
    private init() { }

    // enum은 인스턴스나, 메서스가 아니기 때문에, 구조체에서 바로 접근 가능 (구조체명.enum)
    enum BackdropSizes: String {
        case w300 = "w300"
        case w780 = "w780"
        case w1280 = "w1280"
        case original = "original"
    }
    
    enum LogoSizes: String {
        case w45 = "w45"
        case w92 = "w92"
        case w154 = "w154"
        case w185 = "w185"
        case w300 = "w300"
        case w500 = "w500"
        case original = "original"
    }
    
    enum PosterSizes: String {
        case w92 = "w92"
        case w154 = "w154"
        case w185 = "w185"
        case w342 = "w300"
        case w500 = "w500"
        case w780 = "w780"
        case original = "original"
    }
    
    enum ProfileSizes: String {
        case w45 = "w45"
        case w185 = "w185"
        case h632 = "h632"
        case original = "original"
    }
    
    enum StillSizes: String {
        case w92 = "w92"
        case w185 = "w185"
        case w300 = "w300"
        case original = "original"
    }
    
    
    // 장르 검색 방법: https://api.themoviedb.org/3/genre/movie/list?language=ko
    enum Genres: Int {
        
        case adventure = 12
        case fantasy = 14
        case animation = 16
        case drama = 18
        case horror = 27
        case action = 28
        case comedy = 35
        case history = 36
        case western = 37
        case thriller = 53
        case crime = 80
        case documentary = 99
        case scienceFiction = 878
        case mystery = 9648
        case music = 10402
        case romance = 10749
        case family = 10751
        case war = 10752
        case tVMovie = 10770
        
        var genre: String {
            switch self {
            case .adventure: return "모험"
            case .fantasy: return "판타지"
            case .animation: return "애니메이션"
            case .drama: return "드라마"
            case .horror: return "공포"
            case .action: return "액션"
            case .comedy: return "코미디"
            case .history: return "역사"
            case .western: return "서부"
            case .thriller: return "스릴러"
            case .crime: return "범죄"
            case .documentary: return "다큐멘터리"
            case .scienceFiction: return "SF"
            case .mystery: return "미스터리"
            case .music: return "음악"
            case .romance: return "로맨스"
            case .family: return "가족"
            case .war: return "전쟁"
            case .tVMovie: return "TV 영화"
            }
            
        }
    }
    
    enum Language: String {
        case korean = "ko-KR"
        case english = "en-US"
    }

}

