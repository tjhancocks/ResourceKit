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

@interface RKResourceTests : XCTestCase
@end

@implementation RKResourceTests

- (void)testResource_hasCorrectTypeAndIdOnCreation
{
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    XCTAssertEqualObjects(resource.type, [RKType withCode:@"TEST"]);
    XCTAssertEqual(resource.id, 128);
}


- (void)testResource_equatesItself_true
{
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    XCTAssertTrue([resource isEqualTo:resource]);
}

- (void)testResource_equatesTwoResourcesWithSameCodeAndId_true
{
    RKResource *resource1 = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    RKResource *resource2 = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    XCTAssertEqualObjects(resource1, resource2);
}

- (void)testResource_equatesTwoResourcesWithDifferentCodeAndId_false
{
    RKResource *resource1 = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    RKResource *resource2 = [RKResource ofType:[RKType withCode:@"TEST"] withId:1358];
    XCTAssertNotEqualObjects(resource1, resource2);
}

- (void)testResource_equatesTwoResourcesWithDifferentCode_false
{
    RKResource *resource1 = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    RKResource *resource2 = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    XCTAssertNotEqualObjects(resource1, resource2);
}

- (void)testResource_equatesTwoResourcesWithDifferentId_false
{
    RKResource *resource1 = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    RKResource *resource2 = [RKResource ofType:[RKType withCode:@"TEST"] withId:1223];
    XCTAssertNotEqualObjects(resource1, resource2);
}

- (void)testResource_equatesResourceAndType_false
{
    XCTAssertNotEqualObjects([RKResource ofType:[RKType withCode:@"TEST"] withId:128], [RKType withCode:@"TEST"]);
}


- (void)testResource_setName_nameReturnsNewValue
{
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    resource.name = @"Test Name";
    XCTAssertEqualObjects(resource.name, @"Test Name");
}

- (void)testResource_setId_idReturnsNewValue
{
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    resource.id = 130;
    XCTAssertEqual(resource.id, 130);
}

- (void)testResource_setData_idReturnsNewValue
{
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    NSData *originalData = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
    resource.data = originalData;
    XCTAssertNotEqual(resource.data, originalData);
    XCTAssertEqualObjects(resource.data, originalData);
}


- (void)testResource_switchTypeToValidType_switchesTypeCorrectly
{
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    RKType *newType = [RKType withCode:@"TEST"];
    
    XCTAssertNotEqual(resource.type, newType);
    
    [resource switchTypeTo:newType];
    
    XCTAssertEqual(resource.type, newType);
}


- (void)testResource_switchTypeToInvalidType_doesNotSwitchType
{
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    RKType *newType = [RKType withCode:@"TYPE"];
    
    XCTAssertNotEqual(resource.type, newType);
    
    [resource switchTypeTo:newType];
    
    XCTAssertNotEqual(resource.type, newType);
}


@end
