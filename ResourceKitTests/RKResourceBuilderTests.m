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
#import "RKResourcePOD.h"
#import "RKResourceBuilder.h"
#import <XCTest/XCTest.h>

@interface RKResourceBuilderTests : XCTestCase
@end

@implementation RKResourceBuilderTests

- (void)testResourceBuilder_buildTypeForSinglePOD
{
    RKResourcePOD *pod = RKResourcePOD.new;
    pod.typeCode = @"TEST";
    pod.name = @"Test Resource";
    pod.id = 128;
    
    RKResource *resource = [RKResourceBuilder buildFromPOD:pod];
    XCTAssertEqualObjects(resource, [RKResource ofType:[RKType withCode:@"TEST"] withId:128]);
    XCTAssertEqualObjects(resource.name, @"Test Resource");
}

- (void)testResourceBuilder_failsForNilPOD
{
    XCTAssertNil([RKResourceBuilder buildFromPOD:nil]);
}

- (void)testResourceBuilder_buildTypeForArrayOfPODs
{
    RKResourcePOD *pod1 = RKResourcePOD.new;
    pod1.typeCode = @"TEST";
    pod1.name = @"Test Resource";
    pod1.id = 128;
    
    RKResourcePOD *pod2 = RKResourcePOD.new;
    pod2.typeCode = @"TEST";
    pod2.name = @"Second Resource";
    pod2.id = 129;
    
    NSArray <RKResource *> *result = [RKResourceBuilder buildFromArrayOfPODs:@[pod1, pod2]];
    
    XCTAssertEqual(result[0].id, 128);
    XCTAssertEqualObjects(result[0].type, [RKType withCode:@"TEST"]);
    XCTAssertEqualObjects(result[0].name, @"Test Resource");
    
    XCTAssertEqual(result[1].id, 129);
    XCTAssertEqualObjects(result[1].type, [RKType withCode:@"TEST"]);
    XCTAssertEqualObjects(result[1].name, @"Second Resource");
}

@end
