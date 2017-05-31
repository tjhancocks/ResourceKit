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
#import "RKResourceFileTypeListParser.h"
#import "RKResourceFileParserPOD.h"
#import "RKTypePOD.h"
#import <XCTest/XCTest.h>

@interface RKResourceFileTypeListParserTests : XCTestCase
@end

@implementation RKResourceFileTypeListParserTests {
    __strong NSFileHandle *fileHandle;
    __strong RKResourceFileParserPOD *pod;
}

- (void)setUp
{
    [super setUp];
    NSString *fileHandlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"RsrcTypeList" ofType:@"hex"];
    fileHandle = [NSFileHandle fileHandleForReadingAtPath:fileHandlePath];
    
    pod = RKResourceFileParserPOD.new;
    pod.dataOffset = 0x00;
    pod.mapOffset = 0x00;
    pod.dataSize = 0x00;
    pod.mapSize = 0x00;
    pod.typeListOffset = 0x00;
    pod.nameListOffset = 0x00;
}

- (void)tearDown
{
    [fileHandle closeFile];
    fileHandle = nil;
    pod = nil;
    [super tearDown];
}


- (void)testParser_correctlyReadsResourceMapMetaData_setsPODValuesAsExpected
{
    XCTAssertTrue([RKResourceFileTypeListParser parseData:fileHandle againstObject:pod]);
    
    XCTAssertEqual(pod.typePods.count, 3);
    XCTAssertEqual(pod.lastTypeIndex, 2);
    
    XCTAssertEqualObjects(pod.typePods[0].code, @"TYPE");
    XCTAssertEqual(pod.typePods[0].lastResourceIndex, 1);
    XCTAssertEqual(pod.typePods[0].resourceOffset, 0x1000);
    
    XCTAssertEqualObjects(pod.typePods[1].code, @"TEST");
    XCTAssertEqual(pod.typePods[1].lastResourceIndex, 2);
    XCTAssertEqual(pod.typePods[1].resourceOffset, 0x2000);
    
    XCTAssertEqualObjects(pod.typePods[2].code, @"PICT");
    XCTAssertEqual(pod.typePods[2].lastResourceIndex, 3);
    XCTAssertEqual(pod.typePods[2].resourceOffset, 0x3000);
}

- (void)testParser_failsWhenNoDataProvided
{
    XCTAssertFalse([RKResourceFileTypeListParser parseData:nil againstObject:RKResourceFileParserPOD.new]);
}

- (void)testParser_failsWhenNoPODProvided
{
    XCTAssertFalse([RKResourceFileTypeListParser parseData:fileHandle againstObject:nil]);
}

@end
