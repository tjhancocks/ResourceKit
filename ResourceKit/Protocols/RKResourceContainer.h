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

#import <Foundation/Foundation.h>

@class RKType, RKResource;

@protocol RKResourceContainer <NSObject>

/// A set of all resource types available in the file.
@property (nonnull, atomic, strong, readonly) NSArray <RKType *> *allTypes;

/// Using the specified type, attempt to match it to one of the types in the
/// resource file. If a match is made then the type instance from the resource
/// file will be returned. Otherwise nil will be returned.
- (nullable RKType *)typeWithType:(nullable RKType *)type;

/// Retrieve all resources with the specified type. This is more of a convience
/// method for -typeWithType:.
- (nullable NSArray <RKResource *> *)resourcesWithType:(nullable RKType *)type;

/// Retrieve a specific resource if it exists. If it does not exist, then
/// nil will be returned.
- (nullable RKResource *)resourceWithType:(nullable RKType *)type id:(int16_t)id;

@end
