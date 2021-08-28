//
//  FeedImagesMapper.swift
//  FeedAPIChallenge
//
//  Created by Arpad Zalan on 2021. 08. 28.
//  Copyright (c) 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

internal final class FeedImagesMapper {
	private static let OK_200: Int = 200

	private struct Root: Decodable {
		let items: [Item]
	}

	private struct Item: Decodable {
		let imageId: UUID
		let imageDesc: String?
		let imageLoc: String?
		let imageUrl: URL
	}

	internal static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == OK_200,
		      let root = try? jsonDecoder.decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
		return .success(root.items.map { FeedImage(id: $0.imageId, description: $0.imageDesc, location: $0.imageLoc, url: $0.imageUrl) })
	}

	private static var jsonDecoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}
}
