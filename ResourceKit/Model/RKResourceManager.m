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

#import "RKResourceManager.h"
#import "RKType.h"
#import "RKResource.h"
#import "RKResourceFile.h"

static RKResourceManager *__RKResourceManagerSharedManager = nil;
static dispatch_once_t __RKResourceManagerSingletonToken;

@implementation RKResourceManager {
    __strong NSMutableArray <RKResourceFile *> *_files;
    __strong NSMutableArray <RKType *> *_types;
}

#pragma mark - Singleton

+ (instancetype)sharedManager
{
    dispatch_once(&__RKResourceManagerSingletonToken, ^{
        __RKResourceManagerSharedManager = [self.alloc init];
    });
    return __RKResourceManagerSharedManager;
}

+ (void)invalidateSharedManager
{
    __RKResourceManagerSharedManager = nil;
    __RKResourceManagerSingletonToken = 0;
}


#pragma mark - Initialisation

- (instancetype)init
{
    if (self = [super init]) {
        _files = NSMutableArray.new;
        _types = NSMutableArray.new;
    }
    return self;
}


#pragma mark - Calculated Properties

- (NSArray<RKType *> *)allTypes
{
    return _types.copy;
}

- (NSArray<RKResourceFile *> *)resourceFiles
{
    return _files.copy;
}


#pragma mark - Resource File Management

- (void)addResourceFile:(nullable RKResourceFile *)resourceFile
               strategy:(RKResourceManagerMergeStrategy)strategy
             completion:(nullable RKResourceManagerCallback)completion
{
    [_files addObject:resourceFile];
    
    for (RKType *type in resourceFile.allTypes) {
        RKType *currentType = [self typeWithType:type];
        if (currentType) {
            [currentType mergeType:type replacingDuplicates:(strategy == RKResourceManagerMergeByReplacingDuplicates)];
        }
        else {
            [_types addObject:type];
        }
    }
    
    !completion ?: completion(self);
}

- (void)addResourceFileAtPath:(nonnull NSString *)resourcePath
                     strategy:(RKResourceManagerMergeStrategy)strategy
                   completion:(nullable RKResourceManagerCallback)completion
{
    RKResourceFile *file = [RKResourceFile.alloc initWithContentsOfFile:resourcePath];
    [self addResourceFile:file strategy:strategy completion:completion];
}

- (void)addResourceFilesAtPaths:(nonnull NSArray <NSString *> *)resourcePaths
                       strategy:(RKResourceManagerMergeStrategy)strategy
                     completion:(nullable RKResourceManagerCallback)completion
{
    for (NSString *path in resourcePaths) {
        [self addResourceFileAtPath:path strategy:strategy completion:nil];
    }
    !completion ?: completion(self);
}

         
#pragma mark - Resource Management

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


@end
