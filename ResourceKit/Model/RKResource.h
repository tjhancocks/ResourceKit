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

@class RKType;

@interface RKResource : NSObject

/// The resource type of the receiever.
@property (nonnull, atomic, strong, readonly) RKType *type;

/// The resource id of the receiver.
@property (atomic, assign) int16_t id;

/// The resource name of the receiver.
@property (nullable, atomic, strong) NSString *name;

/// The actual resource data of the receiver.
@property (nullable, atomic, strong) NSData *data;


/// Create a new resource with the specified ID and type
+ (nonnull instancetype)ofType:(nonnull RKType *)type withId:(int16_t)id;

/// Assign the specified resource type to the type. This *must* match
/// the existing type of the resource, in order for potential data corruption
/// to be avoided.
/// This is called when adding the resource to a type group.
- (void)switchTypeTo:(nonnull RKType *)type;

@end
