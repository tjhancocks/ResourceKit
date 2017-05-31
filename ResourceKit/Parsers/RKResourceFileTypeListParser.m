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

#import "RKResourceFileTypeListParser.h"
#import "RKResourceFileParserPOD.h"
#import "RKTypePOD.h"

#define RKTypeStructureDataLength   8

@implementation RKResourceFileTypeListParser

+ (BOOL)parseData:(id<RKDataParserProtocol>)data againstObject:(RKResourceFileParserPOD *)pod
{
    if (!data || !pod) {
        return NO;
    }
    
    // Seek to the start of the resource map, and check to ensure that it is valid.
    // This is done by confirming the values currently in the POD.
    data.position = pod.mapOffset + pod.typeListOffset;
    
    // Read in the resource count. This is a final index value.
    pod.lastTypeIndex = data.readWord;
    
    // Step through each resource type structure in the map. Each entry is 8 bytes
    // long.
    pod.typePods = NSMutableArray.new;
    for (NSInteger i = 0; i <= pod.lastTypeIndex; ++i) {
        
        RKTypePOD *newTypePod = [data readDataOfLength:RKTypeStructureDataLength transform:^id(NSData *typeData) {
            RKTypePOD *typePod = RKTypePOD.new;
            typePod.code = [typeData readStringOfLength:4];
            typePod.lastResourceIndex = typeData.readWord;
            typePod.resourceOffset = typeData.readWord;
            return typePod;
        }];
        [pod.typePods addObject:newTypePod];
        
    }
    
    return YES;
}

@end
