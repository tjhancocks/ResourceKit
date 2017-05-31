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
#import "RKResourceFileMapParser.h"
#import "RKResourceFileParserPOD.h"
#import <XCTest/XCTest.h>

@interface RKResourceFileMapParserTests : XCTestCase
@end

@implementation RKResourceFileMapParserTests {
    __strong NSFileHandle *validMapFileHandle;
    __strong NSFileHandle *compressedMapFileHandle;
    __strong RKResourceFileParserPOD *pod;
}

- (void)setUp
{
    [super setUp];
    NSString *validMapPath = [[NSBundle bundleForClass:self.class] pathForResource:@"RsrcMapMetaData" ofType:@"hex"];
    validMapFileHandle = [NSFileHandle fileHandleForReadingAtPath:validMapPath];
    
    NSString *compressedPath = [[NSBundle bundleForClass:self.class] pathForResource:@"RsrcMapCompressedFlag" ofType:@"hex"];
    compressedMapFileHandle = [NSFileHandle fileHandleForReadingAtPath:compressedPath];
    
    pod = RKResourceFileParserPOD.new;
    pod.dataOffset = 0xA0;
    pod.mapOffset = 0x100;
    pod.dataSize = 0xFF;
    pod.mapSize = 0xEE;
}

- (void)tearDown
{
    [validMapFileHandle closeFile];
    [compressedMapFileHandle closeFile];
    validMapFileHandle = nil;
    compressedMapFileHandle = nil;
    pod = nil;
    [super tearDown];
}


- (void)testParser_correctlyReadsResourceMapMetaData_setsPODValuesAsExpected
{
    XCTAssertTrue([RKResourceFileMapParser parseData:validMapFileHandle againstObject:pod]);
    
    XCTAssertEqual(pod.mainFlags, 0);
    XCTAssertEqual(pod.typeListOffset, 0xAABB);
    XCTAssertEqual(pod.nameListOffset, 0xDDEE);
}

- (void)testParser_failsWhenPreambleVerificationFails
{
    pod.dataOffset = 0x00;
    XCTAssertFalse([RKResourceFileMapParser parseData:validMapFileHandle againstObject:pod]);
}

- (void)testParser_failsWhenDataProvidedWithCompressedFlag
{
    XCTAssertFalse([RKResourceFileMapParser parseData:compressedMapFileHandle againstObject:pod]);
}

- (void)testParser_failsWhenNoDataProvided
{
    XCTAssertFalse([RKResourceFileMapParser parseData:nil againstObject:RKResourceFileParserPOD.new]);
}

- (void)testParser_failsWhenNoPODProvided
{
    XCTAssertFalse([RKResourceFileMapParser parseData:validMapFileHandle againstObject:nil]);
}

@end
