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

@interface RKTypeTests : XCTestCase
@end

@implementation RKTypeTests

- (void)testType_hasCorrectCodeOnCreation
{
    XCTAssertEqualObjects([RKType withCode:@"TYPE"].code, @"TYPE");
}


- (void)testType_equatesItself_true
{
    RKType *type = [RKType withCode:@"TYPE"];
    XCTAssertTrue([type isEqualTo:type]);
}

- (void)testType_equatesTwoTypesWithSameCode_true
{
    XCTAssertEqualObjects([RKType withCode:@"TYPE"], [RKType withCode:@"TYPE"]);
}

- (void)testType_equatesTwoTypesWithDifferentCode_false
{
    XCTAssertNotEqualObjects([RKType withCode:@"TYPE"], [RKType withCode:@"TEST"]);
}

- (void)testType_equatesTypeAndNumber_false
{
    XCTAssertNotEqualObjects([RKType withCode:@"TYPE"], @(1));
}


- (void)testType_addValidResource_storesResourceAndTypeCountReflects
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    
    [type addResource:resource];
    
    XCTAssertEqual(type.resourceCount, 1);
    XCTAssertEqual(resource.type, type);
}

- (void)testType_addInvalidResource_doesNotStoreResourceAndTypeCountReflects
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TEST"] withId:128];
    
    [type addResource:resource];
    
    XCTAssertEqual(type.resourceCount, 0);
    XCTAssertNotEqual(resource.type, type);
}

- (void)testType_addValidResource_replacingDuplicates_storesResourceAndTypeCountReflects
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:resource];
    
    RKResource *replacementResource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:replacementResource replacingDuplicates:YES];
    
    XCTAssertEqual(type.resourceCount, 1);
    XCTAssertEqual(replacementResource.type, type);
}

- (void)testType_addValidResource_notReplacingDuplicates_ignoresResourceAndTypeCountReflects
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:resource];
    
    RKResource *replacementResource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:replacementResource replacingDuplicates:NO];
    
    XCTAssertEqual(type.resourceCount, 1);
    XCTAssertNotEqual(replacementResource.type, type);
}


- (void)testType_mergeType_replacingDuplicates_storesResourceAndTypeCountReflects
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:resource];
    
    RKType *newType = [RKType withCode:@"TYPE"];
    RKResource *newResource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [newType addResource:newResource];
    
    [type mergeType:newType replacingDuplicates:YES];
    
    XCTAssertEqual(type.resourceCount, 1);
    XCTAssertEqual(newResource.type, type);
}


- (void)testType_mergeType_notReplacingDuplicates_ignoresResourceAndTypeCountReflects
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:resource];
    
    RKType *newType = [RKType withCode:@"TYPE"];
    RKResource *newResource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [newType addResource:newResource];
    
    [type mergeType:newType replacingDuplicates:NO];
    
    XCTAssertEqual(type.resourceCount, 1);
    XCTAssertNotEqual(newResource.type, type);
}

- (void)testType_mergeType_noDuplicationSpecified_replacesDuplicates
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:resource];
    
    RKType *newType = [RKType withCode:@"TYPE"];
    RKResource *newResource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [newType addResource:newResource];
    
    [type mergeType:newType];
    
    XCTAssertEqual(type.resourceCount, 1);
    XCTAssertEqual(newResource.type, type);
}


- (void)testType_retrieveResourceWithValidId_returnsResourceInstance
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:resource];
    
    XCTAssertEqualObjects([type resourceWithId:128], resource);
}

- (void)testType_retrieveResourceWithInvalidId_returnsNil
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:resource];
    
    XCTAssertNil([type resourceWithId:12]);
}

- (void)testType_retrieveAllResources_returnsExpectedResult
{
    RKType *type = [RKType withCode:@"TYPE"];
    RKResource *resource = [RKResource ofType:[RKType withCode:@"TYPE"] withId:128];
    [type addResource:resource];
    
    XCTAssertEqual(type.allResources.count, 1);
    XCTAssertEqual(type.allResources.firstObject, resource);
}

@end
