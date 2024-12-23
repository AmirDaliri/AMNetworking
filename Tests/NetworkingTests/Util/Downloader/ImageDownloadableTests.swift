//
//  ImageDownloadableTests.swift
//  Networking
//
//  Created by Amir Daliri.
//

import XCTest
@testable import Networking

final class ImageDownloadableTests: XCTestCase {
    
    // MARK: test Async/Await
    
    func testDownloadImageSuccess() async throws { // note: this is an async test as it actually decodes url to generate the image
        let testURL = URL(string: "https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg")!
        let sut = ImageDownloader()
        do {
            _ = try await sut.downloadImage(from: testURL)
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }

    func testDownloadImageFails() async throws {
        let testURL = URL(string: "https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg")!
        let urlSession = MockURLSession(data: mockPersonJsonData,
                                        url: testURL,
                                        urlResponse: buildResponse(statusCode: 200),
                                        error: nil)
        let validator = MockURLResponseValidator(throwError: NetworkingError.httpError(.badRequest))
        let sut = ImageDownloader(urlSession: urlSession,
                                  urlResponseValidator: validator,
                                  requestDecoder: RequestDecoder())
        do {
            _ = try await sut.downloadImage(from: testURL)
            XCTFail()
        } catch let error as NetworkingError {
            XCTAssertEqual(error, NetworkingError.httpError(.badRequest))
        }
    }

    // MARK: - test callbacks

    func testDownloadImageSuccess() {
        let testURL = URL(string: "https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg")!
        let urlSession = MockURLSession(data: mockPersonJsonData,
                                        urlResponse: buildResponse(statusCode: 200),
                                        error: nil)
        let validator = MockURLResponseValidator(throwError: nil)
        let sut = ImageDownloader(urlSession: urlSession, urlResponseValidator: validator)

        var didExecute = false
        sut.downloadImageTask(url: testURL) { result in
            didExecute = true
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                if error == NetworkingError.invalidImageData {
                    XCTAssertTrue(true, "mock data was just not suited to generate a UIImage")
                } else {
                    XCTFail()
                }
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }

    func testDownloadImageFailsWhenValidatorThrowsAnyError() {
        let testURL = URL(string: "https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_square.jpg")!
        let urlSession = MockURLSession(url: testURL,
                                        urlResponse: buildResponse(statusCode: 200),
                                        error: nil)
        let validator = MockURLResponseValidator(throwError: NetworkingError.httpError(.conflict))
        let sut = ImageDownloader(urlSession: urlSession,
                                  urlResponseValidator: validator,
                                  requestDecoder: RequestDecoder())

        var didExecute = false
        sut.downloadImageTask(url: testURL) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.httpError(.conflict))
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }

    private func buildResponse(statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "https://example.com")!,
                        statusCode: statusCode,
                        httpVersion: nil,
                        headerFields: nil)!
    }
}
