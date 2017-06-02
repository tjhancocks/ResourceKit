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

#import <ResourceKit/RKResourceContainer.h>

/// The merge strategy of the resource manager helps to determine how resources
/// from resource files will be merged into the resource manager.
///  - RKResourceManagerMergeByDroppingDuplicates:
///     When adding a new resource file to the resource manager, any resources
///     that are found to duplicate existing ones will be omitted.
///  - RKResourceManagerMergeByReplacingDuplicates:
///     When adding a new resource file to the resource manager, any resources
///     that are found to be duplicated will be replaced by the newer instance.
typedef NS_ENUM(NSUInteger, RKResourceManagerMergeStrategy)
{
    RKResourceManagerMergeByDroppingDuplicates = 0,
    RKResourceManagerMergeByReplacingDuplicates = 1,
};


@class RKResourceManager, RKResourceFile;

typedef void(^RKResourceManagerCallback)(RKResourceManager *_Nonnull);


@interface RKResourceManager : NSObject <RKResourceContainer>

/// An array of all the files that have currently supplied resources to the
/// resource manager.
@property (nonnull, atomic, copy, readonly) NSArray <RKResourceFile *> *resourceFiles;

/// The universally shared resource manager across the entire application.
+ (nonnull instancetype)sharedManager;

/// Add a single resource file to the resource manager. A merge strategy should
/// be provided which tells the resource manager how to include the resources
/// into the receivers resource graph.
- (void)addResourceFile:(nullable RKResourceFile *)resourceFile
               strategy:(RKResourceManagerMergeStrategy)strategy
             completion:(nullable RKResourceManagerCallback)completion;

/// Add a single resource file to the resource manager using the specified file
/// path. A merge strategy should be provided which tells the resource manager
/// how to include the resources into the receivers resource graph.
- (void)addResourceFileAtPath:(nonnull NSString *)resourcePath
                     strategy:(RKResourceManagerMergeStrategy)strategy
                   completion:(nullable RKResourceManagerCallback)completion;

/// Add multplie resource files to the resource manager in the order of the
/// specified file paths. A merge strategy should be provided which tells the
/// resource manager how to include the resources into the receivers resource
/// graph.
- (void)addResourceFilesAtPaths:(nonnull NSArray <NSString *> *)resourcePaths
                       strategy:(RKResourceManagerMergeStrategy)strategy
                     completion:(nullable RKResourceManagerCallback)completion;

@end
