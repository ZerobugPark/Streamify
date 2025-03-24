//
//  Reusable.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit

extension UITableViewCell {
    static var id: String {
       return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var id: String {
       return String(describing: self)
    }
}

//UICollectionViewCell이 UICollectionReusableView를 상속받기 때문에, 익스텐션 오류 발생
extension UICollectionReusableView {
    static var reuseId: String {
       return String(describing: self)
    }
}
