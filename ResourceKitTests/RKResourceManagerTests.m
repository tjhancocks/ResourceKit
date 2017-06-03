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
#import "XCTestCase+RKResourceAssertions.h"

@interface RKResourceManagerTests : XCTestCase
@end

@interface RKResourceManager ()
+ (void)invalidateSharedManager;
@end

@implementation RKResourceManagerTests

- (void)tearDown
{
    [RKResourceManager invalidateSharedManager];
    [super tearDown];
}

- (void)testResourceManager_singletonReturnsExpectedResult
{
    RKResourceManager *singleton = RKResourceManager.sharedManager;
    RKResourceManager *newInstance = RKResourceManager.new;
    RKResourceManager *newSingleton = RKResourceManager.sharedManager;
    
    XCTAssertNotNil(newInstance);
    XCTAssertNotEqual(newInstance, singleton);
    XCTAssertEqual(newSingleton, singleton);
}


- (void)testResourceManager_addFirstResourceFile_addsExpectedTypesAndResourcesToManager
{
    NSString *resourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest1" ofType:@"rsrc"];
    RKResourceFile *resourceFile = [RKResourceFile.alloc initWithContentsOfFile:resourceFilePath];
    
    RKResourceManager *manager = RKResourceManager.sharedManager;
    [manager addResourceFile:resourceFile strategy:RKResourceManagerMergeByReplacingDuplicates completion:nil];
    
    [self assert:manager has:[RKType withCode:@"AAAA"] with:nil];
    [self assert:manager has:[RKType withCode:@"BBBB"] with:nil];
    
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"AAAA"] withId:128] with:@"A1A1 Test Resource 1"];
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"AAAA"] withId:129] with:@"A2A2 Test Resource 2"];
    
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"BBBB"] withId:128] with:@"B1B1 Test Resource"];
    
}


- (void)testResourceManager_addSecondResourceFile_usingMergeByReplacingDuplicates_addsExpectedTypesAndResourcesToManager
{
    NSString *resourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest1" ofType:@"rsrc"];
    RKResourceFile *resourceFile = [RKResourceFile.alloc initWithContentsOfFile:resourceFilePath];
    
    NSString *secondResourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest2" ofType:@"rsrc"];
    RKResourceFile *secondResourceFile = [RKResourceFile.alloc initWithContentsOfFile:secondResourceFilePath];
    
    RKResourceManager *manager = RKResourceManager.sharedManager;
    [manager addResourceFile:resourceFile strategy:RKResourceManagerMergeByReplacingDuplicates completion:nil];
    [manager addResourceFile:secondResourceFile strategy:RKResourceManagerMergeByReplacingDuplicates completion:nil];
    
    [self assert:manager has:[RKType withCode:@"AAAA"] with:nil];
    [self assert:manager has:[RKType withCode:@"BBBB"] with:nil];
    [self assert:manager has:[RKType withCode:@"CCCC"] with:nil];
    
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"AAAA"] withId:128] with:@"A1A1 Test Resource 1"];
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"AAAA"] withId:129] with:@"A2A2 Test Resource 2"];
    
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"BBBB"] withId:128] with:@"Replacement Resource BBBB"];
    
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"CCCC"] withId:128] with:@"C1C1 Test Resource 1"];
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"CCCC"] withId:129] with:@"C2C2 Test Resource 2"];
}

- (void)testResourceManager_addSecondResourceFile_usingMergeByDroppingDuplicates_addsExpectedTypesAndResourcesToManager
{
    NSString *resourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest1" ofType:@"rsrc"];
    RKResourceFile *resourceFile = [RKResourceFile.alloc initWithContentsOfFile:resourceFilePath];
    
    NSString *secondResourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest2" ofType:@"rsrc"];
    RKResourceFile *secondResourceFile = [RKResourceFile.alloc initWithContentsOfFile:secondResourceFilePath];
    
    RKResourceManager *manager = RKResourceManager.sharedManager;
    [manager addResourceFile:resourceFile strategy:RKResourceManagerMergeByDroppingDuplicates completion:nil];
    [manager addResourceFile:secondResourceFile strategy:RKResourceManagerMergeByDroppingDuplicates completion:nil];
    
    [self assert:manager has:[RKType withCode:@"AAAA"] with:nil];
    [self assert:manager has:[RKType withCode:@"BBBB"] with:nil];
    [self assert:manager has:[RKType withCode:@"CCCC"] with:nil];
    
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"AAAA"] withId:128] with:@"A1A1 Test Resource 1"];
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"AAAA"] withId:129] with:@"A2A2 Test Resource 2"];
    
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"BBBB"] withId:128] with:@"B1B1 Test Resource"];
    
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"CCCC"] withId:128] with:@"C1C1 Test Resource 1"];
    [self assert:manager has:[RKResource ofType:[RKType withCode:@"CCCC"] withId:129] with:@"C2C2 Test Resource 2"];
}


- (void)testResourceManager_whenAddingResourceFiles_resourceFilesAreCorrectlyStoredAndReturned
{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Add Resource File calls completion"];
    
    NSString *resourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest1" ofType:@"rsrc"];
    RKResourceFile *resourceFile = [RKResourceFile.alloc initWithContentsOfFile:resourceFilePath];
    
    NSString *secondResourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest2" ofType:@"rsrc"];
    RKResourceFile *secondResourceFile = [RKResourceFile.alloc initWithContentsOfFile:secondResourceFilePath];
    
    RKResourceManager *manager = RKResourceManager.sharedManager;
    [manager addResourceFile:resourceFile strategy:RKResourceManagerMergeByDroppingDuplicates completion:nil];
    [manager addResourceFile:secondResourceFile strategy:RKResourceManagerMergeByDroppingDuplicates completion:^(RKResourceManager *manager) {
        [completionExpectation fulfill];
    }];
    
    XCTAssertEqual(manager.resourceFiles[0], resourceFile);
    XCTAssertEqual(manager.resourceFiles[1], secondResourceFile);
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
}


- (void)testResourceManager_addResourceFileWithPath_correctlyAddsResource
{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Add Resource File calls completion"];
    
    NSString *resourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest1" ofType:@"rsrc"];
    [RKResourceManager.sharedManager addResourceFileAtPath:resourceFilePath strategy:RKResourceManagerMergeByDroppingDuplicates completion:^(RKResourceManager *manager) {
        [completionExpectation fulfill];
    }];
    
    XCTAssertEqualObjects(RKResourceManager.sharedManager.resourceFiles[0].path, resourceFilePath);
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
}

- (void)testResourceManager_addResourceFilesWithPaths_correctlyAddsResources
{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Add Resource File calls completion"];
    
    NSString *resourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest1" ofType:@"rsrc"];
    NSString *secondResourceFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceManagerTest1" ofType:@"rsrc"];
    
    [RKResourceManager.sharedManager addResourceFilesAtPaths:@[resourceFilePath, secondResourceFilePath]
                                                    strategy:RKResourceManagerMergeByDroppingDuplicates
                                                  completion:^(RKResourceManager *manager) {
        [completionExpectation fulfill];
    }];
    
    XCTAssertEqualObjects(RKResourceManager.sharedManager.resourceFiles[0].path, resourceFilePath);
    XCTAssertEqualObjects(RKResourceManager.sharedManager.resourceFiles[1].path, secondResourceFilePath);
    
    [self waitForExpectationsWithTimeout:0.1 handler:nil];
}


- (void)testResourceManager_resourcesWithValidType_returnsExpectedResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    [RKResourceManager.sharedManager addResourceFileAtPath:path strategy:RKResourceManagerMergeByDroppingDuplicates completion:nil];
    
    NSArray <RKResource *> *result = [RKResourceManager.sharedManager resourcesWithType:[RKType withCode:@"UNIT"]];
    XCTAssertEqual(result.count, 2);
    XCTAssertEqualObjects(result.firstObject.name, @"Test Resource 1");
}

- (void)testResourceManager_resourcesWithInvalidType_returnsNilResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    [RKResourceManager.sharedManager addResourceFileAtPath:path strategy:RKResourceManagerMergeByDroppingDuplicates completion:nil];
    
    NSArray <RKResource *> *result = [RKResourceManager.sharedManager resourcesWithType:[RKType withCode:@"cicn"]];
    XCTAssertNil(result);
}

- (void)testResourceManager_resourceWithValidTypeAndId_returnsExpectedResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    [RKResourceManager.sharedManager addResourceFileAtPath:path strategy:RKResourceManagerMergeByDroppingDuplicates completion:nil];
    
    RKResource *result = [RKResourceManager.sharedManager resourceWithType:[RKType withCode:@"UNIT"] id:128];
    XCTAssertEqual(result.id, 128);
    XCTAssertEqualObjects(result.name, @"Test Resource 1");
    XCTAssertEqualObjects(result.type, [RKType withCode:@"UNIT"]);
}

- (void)testResourceManager_resourceWithInvalidType_returnsNilResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    [RKResourceManager.sharedManager addResourceFileAtPath:path strategy:RKResourceManagerMergeByDroppingDuplicates completion:nil];
    
    RKResource *result = [RKResourceManager.sharedManager resourceWithType:[RKType withCode:@"PIXT"] id:128];
    XCTAssertNil(result);
}

- (void)testResourceManager_resourceWithValidTypeAndInvalidId_returnsNilResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    [RKResourceManager.sharedManager addResourceFileAtPath:path strategy:RKResourceManagerMergeByDroppingDuplicates completion:nil];
    
    RKResource *result = [RKResourceManager.sharedManager resourceWithType:[RKType withCode:@"UNIT"] id:16000];
    XCTAssertNil(result);
}


@end
