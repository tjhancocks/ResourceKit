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

typedef NS_ENUM(NSUInteger, RKResourceForkAttributes)
{
    RKResourceForkReadOnly = 0x80,
    RKResourceForkCompact = 0x40,
    RKResourceForkChanged = 0x20,
};

@interface RKResourceFile : NSObject <RKResourceContainer>

/// The location of the file on disk.
@property (nonnull, atomic, strong, readonly) NSString *path;

/// The Resource Fork attributes.
@property (atomic, assign) RKResourceForkAttributes attributes;

/// Initialise a new resource file at the specified file path. This will
/// kick off parsing the resource fork immediately, and if parsing
/// fails the initialiser will return nil.
- (nullable instancetype)initWithContentsOfFile:(nonnull NSString *)path;

@end
