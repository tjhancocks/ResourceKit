//
// MIT License
//
// Copyright (c) 2017 Tom Hancocks
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import <ResourceKit/ResourceKit.h>
#import <XCTest/XCTest.h>

@interface RKDataParserDataTests : XCTestCase
@end

@implementation RKDataParserDataTests {
    __strong NSData *data;
}

- (void)setUp
{
    [super setUp];
    NSString *testFile = [[NSBundle bundleForClass:self.class] pathForResource:@"RawTestData" ofType:@"hex"];
    data = [NSData dataWithContentsOfFile:testFile];
}

- (void)tearDown
{
    data = nil;
    [super tearDown];
}


- (void)testDataParser_setStringEncoding_returnsCorrectStringEncoding
{
    data.stringEncoding = NSASCIIStringEncoding;
    XCTAssertEqual(data.stringEncoding, NSASCIIStringEncoding);
}


- (void)testDataParser_readByte_returnsExpectedValue
{
    data.position = 0;
    XCTAssertEqual(data.readByte, 0x03);
}

- (void)testDataParser_readWord_returnsExpectedValue
{
    data.position = 1;
    XCTAssertEqual(data.readWord, 0x0100);
}

- (void)testDataParser_readLong_returnsExpectedValue
{
    data.position = 3;
    XCTAssertEqual(data.readLong, 0x00020001);
}

- (void)testDataParser_readPString_returnsExpectedValue
{
    data.position = 7;
    XCTAssertEqualObjects(data.readPString, @"Hello");
}

- (void)testDataParser_readCString_returnsExpectedValue
{
    data.position = 13;
    XCTAssertEqualObjects(data.readCString, @"World");
}

- (void)testDataParser_readFixedLengthString_returnsExpectedValue
{
    data.position = 19;
    XCTAssertEqualObjects([data readStringOfLength:4], @"TYPE");
}

@end
