//
//  Image.swift
//  Imgur Gallery
//
//  Created by Mariana Brasil on 03/09/21.
//

import Foundation

// MARK: - Data
public struct FirstData: Codable {
    let data: [Datum]
}

// MARK: - Datum
public struct Datum: Codable {
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case images
    }
}

// MARK: - Image
public struct Image: Codable {
    let link: String

    enum CodingKeys: String, CodingKey {
        case link
    }
}
