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
    enum Genres: Int, CaseIterable {
        case actionAdventure = 10759
        case animation = 16
        case comedy = 35
        case crime = 80
        case documentary = 99
        case drama = 18
        case family = 10751
        case kids = 10762
        case mystery = 9648
        case news = 10763
        case reality = 10764
        case sciFiFantasy = 10765
        case soap = 10766
        case talk = 10767
        case warPolitics = 10768
        case western = 37
        
        var genre: String {
            switch self {
            case .actionAdventure: return "액션 & 모험"
            case .animation: return "애니메이션"
            case .comedy: return "코미디"
            case .crime: return "범죄"
            case .documentary: return "다큐멘터리"
            case .drama: return "드라마"
            case .family: return "가족"
            case .kids: return "어린이"
            case .mystery: return "미스터리"
            case .news: return "뉴스"
            case .reality: return "리얼리티"
            case .sciFiFantasy: return "SF & 판타지"
            case .soap: return "연속극"
            case .talk: return "토크쇼"
            case .warPolitics: return "전쟁 & 정치"
            case .western: return "서부극"
            }
        }
    }
    
    enum Language: String {
        case korean = "ko-KR"
        case english = "en-US"
    }
    
}

extension Config.Genres {
    var toGenre: Genre {
        return Genre(id: self.rawValue, name: self.genre)
    }

    static var genreList: [Genre] {
        return Config.Genres.allCases.map { $0.toGenre }
    }
}
