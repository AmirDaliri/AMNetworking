//
//  RequestPerformerTests.swift
//  Networking
//
//  Created by Amir Daliri.
//

import UIKit
import XCTest
@testable import Networking

final class RequestPerformerTests: XCTestCase {

    // MARK: Unit tests for perform using Completion Handler

    func testPerformWithCompletionHandlerDoesDecodePerson() {
        let urlSession = MockURLSession(
            data: mockPersonJsonData,
            urlResponse: buildResponse(statusCode: 200),
            error: nil
        )
        let validator = MockURLResponseValidator(throwError: nil)
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request, decodeTo: Person.self) { result in
            didExecute = true
            switch result {
            case .success(let person):
                XCTAssertEqual(person.name, "John")
                XCTAssertEqual(person.age, 30)
            case .failure:
                XCTFail()
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    func testPerformWithCompletionHandlerWithErrorFails() {
        let urlSession = MockURLSession(
            data: mockPersonJsonData,
            urlResponse: buildResponse(statusCode: 200),
            error: HTTPNetworkingError.forbidden
        )
        let validator = MockURLResponseValidator(throwError: NetworkingError.httpError(.forbidden))
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request, decodeTo: Person.self) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.httpError(.forbidden))
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    func testPerformWithCompletionHandlerWithBadStatusCodeFails() {
        let urlSession = MockURLSession(
            data: mockPersonJsonData,
            urlResponse: buildResponse(statusCode: 400),
            error: nil
        )
        let validator = MockURLResponseValidator(throwError: NetworkingError.httpError(.badRequest))
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request, decodeTo: Person.self) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.httpError(.badRequest))
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    func testPerformWithCompletionHandlerWithInvalidData() {
        let urlSession = MockURLSession(
            data: invalidMockPersonJsonData,
            urlResponse: buildResponse(statusCode: 200),
            error: nil
        )
        let validator = MockURLResponseValidator(throwError: nil)
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request, decodeTo: Person.self) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.couldNotParse)
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    func testPerformWithCompletionHandlerWithNilData() {
        let urlSession = MockURLSession(
            data: nil,
            urlResponse: buildResponse(statusCode: 200),
            error: nil
        )
        let validator = MockURLResponseValidator(throwError: nil)
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request, decodeTo: Person.self) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.noData)
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    func testPerformWithCompletionHandlerWithNilResponse() {
        let urlSession = MockURLSession(
            data: invalidMockPersonJsonData,
            urlResponse: nil,
            error: nil
        )
        let validator = MockURLResponseValidator(throwError: nil)
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request, decodeTo: Person.self) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.couldNotParse)
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    // MARK: Unit tests for perform using Completion Handler without Decodable response
    
    func testPerformWithCompletionHandlerWithoutDecodableDoesDecodePerson() {
        let urlSession = MockURLSession(
            data: mockPersonJsonData,
            urlResponse: buildResponse(statusCode: 200),
            error: nil
        )
        let validator = MockURLResponseValidator(throwError: nil)
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request) { result in
            didExecute = true
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTFail()
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    func testPerformWithCompletionHandlerWithoutDecodableWithErrorFails() {
        let urlSession = MockURLSession(
            data: mockPersonJsonData,
            urlResponse: buildResponse(statusCode: 200),
            error: NetworkingError.httpError(.forbidden)
        )
        let validator = MockURLResponseValidator(throwError: NetworkingError.httpError(.forbidden))
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.httpError(.forbidden))
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    func testPerformWithCompletionHandlerWithoutDecodableWithBadStatusCodeFails() {
        let urlSession = MockURLSession(
            data: mockPersonJsonData,
            urlResponse: buildResponse(statusCode: 400),
            error: nil
        )
        let validator = URLResponseValidatorImpl()
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.httpError(.badRequest))
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    func testPerformWithCompletionHandlerWithoutDecodableWithNilData() {
        let urlSession = MockURLSession(
            data: nil,
            urlResponse: buildResponse(statusCode: 200),
            error: nil
        )
        let validator = URLResponseValidatorImpl()
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.noData)
            }
        }.resume()
        XCTAssertTrue(didExecute)
    }
    
    func testPerformWithCompletionHandlerWithoutDecodableWithNilResponse() {
        let urlSession = MockURLSession(
            data: invalidMockPersonJsonData,
            urlResponse: nil,
            error: nil
        )
        let validator = URLResponseValidatorImpl()
        let decoder = RequestDecoder()
        let sut = RequestPerformer(urlSession: urlSession, urlResponseValidator: validator, requestDecoder: decoder)
        
        guard let request = RequestBuilder().build(httpMethod: .GET, urlString: "https://www.example.com", parameters: nil) else {
            XCTFail()
            return
        }
        
        var didExecute = false
        sut.performTask(request: request) { result in
            didExecute = true
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkingError.noResponse)
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
