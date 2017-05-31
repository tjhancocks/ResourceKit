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

@interface RKResourceFileTests : XCTestCase
@end

@implementation RKResourceFileTests

- (void)testResourceFile_invalidFilePath_failsAndReturnsNil
{
    // TODO: Make this a truly random file name to avoid potential failures.
    XCTAssertNil([RKResourceFile.alloc initWithContentsOfFile:@"/tmp/test_file_rsrc.rsrc"]);
}

- (void)testResourceFile_successfullyParsesValidResourceFile_andReturnsInstance
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    XCTAssertNotNil([RKResourceFile.alloc initWithContentsOfFile:path]);
}

- (void)testResourceFile_invalidResourceFileFormat_failsAndReturnsNil
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"BadResourceFork" ofType:@"rsrc"];
    XCTAssertNil([RKResourceFile.alloc initWithContentsOfFile:path]);
}

- (void)testResourceFile_retainsCorrectFilePath
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    XCTAssertEqualObjects([RKResourceFile.alloc initWithContentsOfFile:path].path, path);
}

- (void)testResourceFile_hasExpectedResourceTypeCount
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:path];
    XCTAssertEqual(file.allTypes.count, 2);
}

- (void)testResourceFile_typeWithKnownType_returnsExpectedResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:path];
    
    RKType *type = [RKType withCode:@"UNIT"];
    RKType *result = [file typeWithType:type];
    XCTAssertNotNil(result);
    XCTAssertEqualObjects(type, result);
    XCTAssertNotEqual(type, result);
}

- (void)testResourceFile_typeWithUnknownType_returnsExpectedNilResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:path];
    
    RKType *type = [RKType withCode:@"NAME"];
    RKType *result = [file typeWithType:type];
    XCTAssertNil(result);
}

- (void)testResourceFile_typeWitNil_returnsExpectedNilResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:path];
    
    RKType *result = [file typeWithType:nil];
    XCTAssertNil(result);
}

- (void)testResourceFile_resourcesWithValidType_returnsExpectedResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:path];
    
    NSArray <RKResource *> *result = [file resourcesWithType:[RKType withCode:@"UNIT"]];
    XCTAssertEqual(result.count, 2);
    XCTAssertEqualObjects(result.firstObject.name, @"Test Resource 1");
}

- (void)testResourceFile_resourcesWithInvalidType_returnsNilResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:path];
    
    NSArray <RKResource *> *result = [file resourcesWithType:[RKType withCode:@"cicn"]];
    XCTAssertNil(result);
}

- (void)testResourceFile_resourceWithValidTypeAndId_returnsExpectedResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:path];
    
    RKResource *result = [file resourceWithType:[RKType withCode:@"UNIT"] id:128];
    XCTAssertEqual(result.id, 128);
    XCTAssertEqualObjects(result.name, @"Test Resource 1");
    XCTAssertEqualObjects(result.type, [RKType withCode:@"UNIT"]);
}

- (void)testResourceFile_resourceWithInvalidType_returnsNilResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:path];
    
    RKResource *result = [file resourceWithType:[RKType withCode:@"PIXT"] id:128];
    XCTAssertNil(result);
}

- (void)testResourceFile_resourceWithValidTypeAndInvalidId_returnsNilResult
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:path];
    
    RKResource *result = [file resourceWithType:[RKType withCode:@"UNIT"] id:16000];
    XCTAssertNil(result);
}

#pragma mark - Performance Tests

- (void)testResourceFile_parseSimpleResourceFilePerformance
{
    [self measureBlock:^{
        NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ResourceFork" ofType:@"rsrc"];
        (void)[RKResourceFile.alloc initWithContentsOfFile:path];
    }];
}

- (void)testResourceFile_parseComplexResourceFilePerformance
{
    [self measureBlock:^{
        NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"ComplexResourceFork" ofType:@"rsrc"];
        (void)[RKResourceFile.alloc initWithContentsOfFile:path];
    }];
}

@end
