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

@interface RKDataParserFileHandleTests : XCTestCase
@end

@implementation RKDataParserFileHandleTests {
    __strong NSFileHandle *fileHandle;
}

- (void)setUp
{
    [super setUp];
    NSString *testFile = [[NSBundle bundleForClass:self.class] pathForResource:@"RawTestData" ofType:@"hex"];
    fileHandle = [NSFileHandle fileHandleForReadingAtPath:testFile];
}

- (void)tearDown
{
    [fileHandle closeFile];
    fileHandle = nil;
    [super tearDown];
}


- (void)testDataParser_setStringEncoding_returnsCorrectStringEncoding
{
    fileHandle.stringEncoding = NSASCIIStringEncoding;
    XCTAssertEqual(fileHandle.stringEncoding, NSASCIIStringEncoding);
}


- (void)testDataParser_readByte_returnsExpectedValue
{
    fileHandle.position = 0;
    XCTAssertEqual(fileHandle.readByte, 0x03);
}

- (void)testDataParser_readWord_returnsExpectedValue
{
    fileHandle.position = 1;
    XCTAssertEqual(fileHandle.readWord, 0x0100);
}

- (void)testDataParser_readLong_returnsExpectedValue
{
    fileHandle.position = 3;
    XCTAssertEqual(fileHandle.readLong, 0x00020001);
}

- (void)testDataParser_readPString_returnsExpectedValue
{
    fileHandle.position = 7;
    XCTAssertEqualObjects(fileHandle.readPString, @"Hello");
}

- (void)testDataParser_readCString_returnsExpectedValue
{
    fileHandle.position = 13;
    XCTAssertEqualObjects(fileHandle.readCString, @"World");
}

- (void)testDataParser_readFixedLengthString_returnsExpectedValue
{
    fileHandle.position = 19;
    XCTAssertEqualObjects([fileHandle readStringOfLength:4], @"TYPE");
}

@end
