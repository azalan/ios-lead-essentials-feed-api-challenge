//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
		client.get(from: url) { result in
			switch result {
			case let .success((_, response)):
				completion(Self.map(from: response))
			default:
				completion(.failure(Error.connectivity))
			}
		}
	}
}

private extension RemoteFeedLoader {
	static let OK_200: Int = 200

	static func map(from response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == OK_200 else {
			return .failure(Error.invalidData)
		}
		return .success([])
	}
}
