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

#import <objc/runtime.h>
#import "NSFileHandle+RKDataParser.h"
#import "NSData+RKDataParser.h"

static void *RKFileHandleEncoding = &RKFileHandleEncoding;

@implementation NSFileHandle (RKDataParser)

#pragma mark - Caclulated Properties

- (NSUInteger)position
{
    return (NSUInteger)self.offsetInFile;
}

- (void)setPosition:(NSUInteger)position
{
    [self seekToFileOffset:position];
}

- (NSStringEncoding)stringEncoding
{
    return (NSStringEncoding)((NSNumber *)objc_getAssociatedObject(self, RKFileHandleEncoding)).unsignedIntegerValue;
}

- (void)setStringEncoding:(NSStringEncoding)stringEncoding
{
    objc_setAssociatedObject(self, RKFileHandleEncoding, @((NSUInteger)stringEncoding), OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - Basic Value Reading

- (uint8_t)readByte
{
    uint8_t value;
    [[self readDataOfLength:sizeof(value) transform:nil] getBytes:&value length:sizeof(value)];
    return value;
}

- (uint16_t)readWord
{
    uint16_t value;
    [[self readDataOfLength:sizeof(value) transform:nil] getBytes:&value length:sizeof(value)];
    return OSSwapBigToHostInt16(value);
}

- (uint32_t)readLong
{
    uint32_t value;
    [[self readDataOfLength:sizeof(value) transform:nil] getBytes:&value length:sizeof(value)];
    return OSSwapBigToHostInt32(value);
}


#pragma mark - String Reading

- (NSString *)readStringOfLength:(NSUInteger)length
{
    __weak __typeof(self) weakSelf = self;
    return [self readDataOfLength:length transform:^id(NSData *data) {
        char *raw = calloc(length + 1, sizeof(*raw));
        [data getBytes:raw length:length];
        NSString *result = [NSString stringWithCString:raw encoding:weakSelf.stringEncoding];
        free(raw);
        return result;
    }];
}

- (NSString *)readPString
{
    return [self readStringOfLength:self.readByte];
}

- (NSString *)readCString
{
    NSUInteger start = self.position;
    while (self.readByte != 0);
    NSUInteger length = self.position - start;
    self.position = start;
    return [self readStringOfLength:length];
}


#pragma mark - Data Reading

- (id)readDataOfLength:(NSUInteger)length transform:(id (^)(NSData *))transform
{
    NSData *data = [self readDataOfLength:length];
    data.stringEncoding = self.stringEncoding;
    id result = !transform ? data : transform(data);
    return result;
}

@end
