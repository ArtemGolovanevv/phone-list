//
//  PhonesModel.swift
//  S.E.P
//
//  Created by Artem Golovanev on 11.05.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import Foundation


class DataModel: Codable {
    let namePhone: String
    let descriptionPhone: String
    let pricePhone: String
    let imagePhone: String

    init(namePhone: String, descriptionPhone: String, imagePhone: String, pricePhone: String) {
        self.namePhone = namePhone
        self.descriptionPhone = descriptionPhone
        self.pricePhone = pricePhone
        self.imagePhone = imagePhone
    }

    enum CodingKeys: String, CodingKey {
        case namePhone = "title"
        case pricePhone = "price"
        case imagePhone = "img"
        case descriptionPhone = "descr"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(namePhone, forKey: .namePhone)
        try container.encode(pricePhone, forKey: .pricePhone)
        try container.encode(imagePhone, forKey: .imagePhone)
        try container.encode(descriptionPhone, forKey: .descriptionPhone)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        namePhone = try values.decode(String.self, forKey: .namePhone)
        descriptionPhone = try values.decode(String.self, forKey: .descriptionPhone)
        pricePhone = try values.decode(String.self, forKey: .pricePhone)
        imagePhone = try values.decode(String.self, forKey: .imagePhone)
    }

}
