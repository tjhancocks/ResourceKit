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

#import "RKResourceFile.h"
#import "RKResourceFileParserPOD.h"
#import "RKTypePOD.h"
#import "RKResourcePOD.h"
#import "RKResourceFilePreambleParser.h"
#import "RKResourceFileMapParser.h"
#import "RKResourceFileTypeListParser.h"
#import "RKResourceFileResourceListParser.h"
#import "RKTypeBuilder.h"
#import "RKResourceBuilder.h"
#import "NSData+RKDataParser.h"
#import "NSFileHandle+RKDataParser.h"
#import "RKResource.h"
#import "RKType.h"

@implementation RKResourceFile {
    __strong NSString *_path;
    __strong NSMutableArray <RKType *> *_types;
}

#pragma mark - Initialisation

- (instancetype)initWithContentsOfFile:(NSString *)path
{
    if (self = [super init]) {
        _path = path.copy;
        if (![self parse]) {
            return nil;
        }
    }
    return self;
}


#pragma mark - Parsing

- (BOOL)parse
{
    // Attempt to open the file for reading.
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:_path];
    if (!fileHandle) {
        return NO;
    }
    
    // Ensure the file is going to be reading using the Mac OS Roman encoding.
    fileHandle.stringEncoding = NSMacOSRomanStringEncoding;
    
    // Setup PODs
    RKResourceFileParserPOD *resourceFilePod = RKResourceFileParserPOD.new;
    
    // Work through each of the parsers to extract all the data in a logical way
    // from the resource file.
    if (![RKResourceFilePreambleParser parseData:fileHandle againstObject:resourceFilePod] ||
        ![RKResourceFileMapParser parseData:fileHandle againstObject:resourceFilePod] ||
        ![RKResourceFileTypeListParser parseData:fileHandle againstObject:resourceFilePod] ||
        ![RKResourceFileResourceListParser parseData:fileHandle againstObject:resourceFilePod])
    {
        return NO;
    }
    
    // Build all the actual structures from the PODs
    _types = [[RKTypeBuilder buildFromArrayOfPODs:resourceFilePod.typePods] mutableCopy];
    
    NSArray <RKResource *> *allResources = [RKResourceBuilder buildFromArrayOfPODs:resourceFilePod.resourcePods];
    for (RKResource *resource in allResources) {
        [[self typeWithType:resource.type] addResource:resource];
    }
    
    // Close the file.
    [fileHandle closeFile];
    return YES;
}


#pragma mark - Type Management

- (nullable RKType *)typeWithType:(nullable RKType *)type
{
    for (RKType *potentialType in _types) {
        if ([potentialType isEqual:type]) {
            return potentialType;
        }
    }
    return nil;
}

- (nullable NSArray <RKResource *> *)resourcesWithType:(nullable RKType *)type
{
    RKType *foundType = [self typeWithType:type];
    if (!foundType) {
        return nil;
    }
    return foundType.allResources;
}

- (nullable RKResource *)resourceWithType:(nullable RKType *)type id:(int16_t)id
{
    RKType *foundType = [self typeWithType:type];
    if (!foundType) {
        return nil;
    }
    return [foundType resourceWithId:id];
}

#pragma mark - Calculated Properties

- (NSSet<RKType *> *)allTypes
{
    return _types.copy;
}

- (NSString *)path
{
    return _path.copy;
}

@end
