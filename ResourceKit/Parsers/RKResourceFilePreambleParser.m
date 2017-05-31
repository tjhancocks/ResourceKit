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

#import "RKResourceFilePreambleParser.h"
#import "RKResourceFileParserPOD.h"

@implementation RKResourceFilePreambleParser

+ (BOOL)parseData:(id<RKDataParserProtocol>)data againstObject:(RKResourceFileParserPOD *)pod
{
    if (!data || !pod) {
        return NO;
    }
    
    // Seek to the start of the resource file, and read the first 4 long values.
    data.position = 0;
    
    pod.dataOffset = data.readLong;
    pod.mapOffset = data.readLong;
    pod.dataSize = data.readLong;
    pod.mapSize = data.readLong;
    
    return YES;
}

@end
