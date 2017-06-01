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

@class RKTypePOD, RKResourcePOD;

@interface RKResourceFileParserPOD : NSObject

@property (nonatomic, assign) uint32_t dataOffset;
@property (nonatomic, assign) uint32_t mapOffset;
@property (nonatomic, assign) uint32_t dataSize;
@property (nonatomic, assign) uint32_t mapSize;

@property (nonatomic, assign) uint32_t handleToNextResouceMapReserved;
@property (nonatomic, assign) uint16_t fileReferenceNumberReserved;

@property (nonatomic, assign) uint16_t mainFlags;

@property (nonatomic, assign) uint16_t typeListOffset;
@property (nonatomic, assign) uint16_t nameListOffset;

@property (nonatomic, assign) uint16_t numberOfTypes;

@property (nonatomic, strong) NSMutableArray <RKTypePOD *> *typePods;
@property (nonatomic, strong) NSMutableArray <RKResourcePOD *> *resourcePods;

@end
