
public struct FirstData: Codable {
    let data: [Images]
}

struct Images: Codable {

    let link: String


    enum CodingKeys: String, CodingKey {

        case link

    }
}
