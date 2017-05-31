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

#import "RKResource.h"
#import "RKType.h"

@implementation RKResource {
    __strong RKType *_type;
    __strong NSString *_name;
    __strong NSData *_data;
    int16_t _id;
}

#pragma mark - Initialisation

+ (nonnull instancetype)ofType:(nonnull RKType *)type withId:(int16_t)id
{
    RKResource *resource = RKResource.new;
    resource->_id = id;
    resource->_type = type;
    return resource;
}


#pragma mark - Calculated Properties

- (RKType *)type
{
    return _type;
}

- (NSString *)name
{
    return _name.copy;
}

- (void)setName:(NSString *)name
{
    _name = name.copy;
}

- (int16_t)id
{
    return _id;
}

- (void)setId:(int16_t)id
{
    _id = id;
}

- (NSData *)data
{
    return _data.copy;
}

- (void)setData:(NSData *)data
{
    _data = data.copy;
}


#pragma mark - Type Management

- (void)switchTypeTo:(RKType *)type
{
    if ([_type isEqual:type]) {
        _type = type;
    }
}


#pragma mark - Equality

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    else if (![object isMemberOfClass:self.class]) {
        return NO;
    }
    else {
        RKResource *resourceObject = (RKResource *)object;
        return (resourceObject.id == _id) && ([resourceObject.type isEqual:_type]);
    }
}

- (BOOL)isEqualTo:(id)object
{
    return [self isEqual:object];
}


@end
