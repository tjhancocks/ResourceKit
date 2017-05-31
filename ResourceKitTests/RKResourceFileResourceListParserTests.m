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
#import "RKResourceFileResourceListParser.h"
#import "RKResourceFileParserPOD.h"
#import "RKTypePOD.h"
#import "RKResourcePOD.h"
#import <XCTest/XCTest.h>

@interface RKResourceFileResourceListParserTests : XCTestCase
@end

@implementation RKResourceFileResourceListParserTests{
    __strong NSFileHandle *fileHandle;
    __strong RKResourceFileParserPOD *pod;
}

- (void)setUp
{
    [super setUp];
    NSString *fileHandlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"RsrcResourceHeaders" ofType:@"hex"];
    fileHandle = [NSFileHandle fileHandleForReadingAtPath:fileHandlePath];
    
    pod = RKResourceFileParserPOD.new;
    pod.dataOffset = 0x00;
    pod.mapOffset = 0x20;
    pod.dataSize = 0x20;
    pod.mapSize = 0x25;
    
    pod.typeListOffset = 0x00;
    pod.nameListOffset = 0x10;
    
    RKTypePOD *testType = RKTypePOD.new;
    testType.code = @"TEST";
    testType.resourceOffset = 0;
    testType.lastResourceIndex = 1;
    pod.typePods = @[testType].mutableCopy;
}

- (void)tearDown
{
    [fileHandle closeFile];
    fileHandle = nil;
    pod = nil;
    [super tearDown];
}


- (void)testParser_correctlyReadsResourceHeaders_setsPODValuesAsExpected
{
    XCTAssertTrue([RKResourceFileResourceListParser parseData:fileHandle againstObject:pod]);
    
    XCTAssertEqual(pod.resourcePods.count, 2);
    
    XCTAssertEqual(pod.resourcePods[0].id, 128);
    XCTAssertEqual(pod.resourcePods[0].flags, 0);
    XCTAssertEqual(pod.resourcePods[0].offset, 0);
    XCTAssertEqual(pod.resourcePods[0].nameOffset, 0);
    XCTAssertEqual(pod.resourcePods[0].size, 6);
    XCTAssertEqualObjects(pod.resourcePods[0].name, @"Greeting String");
    XCTAssertEqualObjects(pod.resourcePods[0].typeCode, @"TEST");
    XCTAssertEqualObjects(pod.resourcePods[0].data.readCString, @"Hello");
    
    XCTAssertEqual(pod.resourcePods[1].id, 129);
    XCTAssertEqual(pod.resourcePods[1].flags, 0);
    XCTAssertEqual(pod.resourcePods[1].offset, 10);
    XCTAssertEqual(pod.resourcePods[1].nameOffset, 16);
    XCTAssertEqual(pod.resourcePods[1].size, 9);
    XCTAssertEqualObjects(pod.resourcePods[1].name, @"Bye!");
    XCTAssertEqualObjects(pod.resourcePods[1].typeCode, @"TEST");
    XCTAssertEqualObjects(pod.resourcePods[1].data.readCString, @"Goodbye!");
}

- (void)testParser_failsWhenNoDataProvided
{
    XCTAssertFalse([RKResourceFileResourceListParser parseData:nil againstObject:RKResourceFileParserPOD.new]);
}

- (void)testParser_failsWhenNoPODProvided
{
    XCTAssertFalse([RKResourceFileResourceListParser parseData:fileHandle againstObject:nil]);
}

@end
