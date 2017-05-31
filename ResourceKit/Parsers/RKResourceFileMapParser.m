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

#import "RKResourceFileMapParser.h"
#import "RKResourceFileParserPOD.h"

@implementation RKResourceFileMapParser

+ (BOOL)parseData:(id<RKDataParserProtocol>)data againstObject:(RKResourceFileParserPOD *)pod
{
    if (!data || !pod) {
        return NO;
    }
    
    // Seek to the start of the resource map, and check to ensure that it is valid.
    // This is done by confirming the values currently in the POD.
    data.position = pod.mapOffset;
    
    if (pod.dataOffset != data.readLong ||
        pod.mapOffset != data.readLong ||
        pod.dataSize != data.readLong ||
        pod.mapSize != data.readLong)
    {
        return NO;
    }
    
    // Skip the next 6 bytes as they appear to be unused.
    data.position += 6;
    
    // We now have a flags field.
    pod.mainFlags = data.readWord;
    if (pod.mainFlags & 0x0040) {
        // Compressed. Can't handle this!
        return NO;
    }
    
    // Finally read some more offsets.
    pod.typeListOffset = data.readWord;
    pod.nameListOffset = data.readWord;
    
    return YES;
}

@end
