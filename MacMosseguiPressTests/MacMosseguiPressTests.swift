//
//  MacMosseguiPressTests.swift
//  MacMosseguiPressTests
//
//  Created by MAC on 15/09/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import XCTest
@testable import MacMosseguiPress

class MacMosseguiPressTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicListElement() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let md = "* hola como estas"
        let expected = "<ul><li>hola como estas</li></ul>"
        let html = MacMosseguiPress.parseMarkdown(inputString: md)

        XCTAssertEqual(expected, html)
    }
    
    func test2ListElements() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let md = "* hola como estas \n* yo muy bien"
        let expected = "<ul><li>hola como estas</li><li>yo muy bien</li></ul>"
        let html = MacMosseguiPress.parseMarkdown(inputString: md)

        XCTAssertEqual(expected, html)
    }
    
    func test2ListElementsWithLinks() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let md = "* hola como estas \n* yo muy [bien](www.esunlink.com) \n* antes habia un link"
        let expected = "<ul><li>hola como estas</li><li>yo muy <a href=\"www.esunlink.com\">bien</a></li><li>antes habia un link</li></ul>"
        let html = MacMosseguiPress.parseMarkdown(inputString: md)

        XCTAssertEqual(expected, html)
    }
    
    func test3ListElementsWithLinks() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let md = "* hola como estas \n* yo muy [bien](www.esunlink.com) \n* antes habia un link \n* Aqui tambien hay un [link](www.mossegalapoma.cat)."
        let expected = "<ul><li>hola como estas</li><li>yo muy <a href=\"www.esunlink.com\">bien</a></li><li>antes habia un link</li><li>Aqui tambien hay un <a href=\"www.mossegalapoma.cat\">link</a>.</li></ul>"
        let html = MacMosseguiPress.parseMarkdown(inputString: md)

        XCTAssertEqual(expected, html)
    }
    
    func test3ListElementsWithLinksAndSpaces() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let md = "   * hola como estas \n   * yo muy [bien](www.esunlink.com) \n   * antes habia un link \n   * Aqui tambien hay un [link](www.mossegalapoma.cat)."
        let expected = "<ul><li>hola como estas</li><li>yo muy <a href=\"www.esunlink.com\">bien</a></li><li>antes habia un link</li><li>Aqui tambien hay un <a href=\"www.mossegalapoma.cat\">link</a>.</li></ul>"
        
        let html = MacMosseguiPress.parseMarkdown(inputString: md)

        XCTAssertEqual(expected, html)
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
