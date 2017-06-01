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

#import "RKResourceFileResourceListParser.h"

#import <ResourceKit/RKDataParserProtocol.h>
#import <ResourceKit/NSData+RKDataParser.h>
#import <ResourceKit/RKResourceFileParserPOD.h>
#import <ResourceKit/RKTypePOD.h>
#import <ResourceKit/RKResourcePOD.h>

#define RKResourceHeaderStructureDataLength   12

@implementation RKResourceFileResourceListParser

+ (BOOL)parseData:(id<RKDataParserProtocol>)data againstObject:(RKResourceFileParserPOD *)pod
{
    if (!data || !pod) {
        return NO;
    }
    
    pod.resourcePods = NSMutableArray.new;
    
    // Step through each of the Type PODs and extract each of the resources. Again
    // these will be extracted as PODs for the time being.
    for (RKTypePOD *typePod in pod.typePods) {
        
        // Step through each of the resources for the type. Each resource header is
        // 8 bytes long.
        for (NSUInteger idx = 0; idx < typePod.numberOfResources; ++idx) {
            
            // Seek to the start of the resource header for the type.
            data.position = pod.mapOffset + pod.typeListOffset + typePod.resourceOffset + (idx * RKResourceHeaderStructureDataLength);
            
            // Extract the resource header...
            RKResourcePOD *resourcePod = [data readDataOfLength:RKResourceHeaderStructureDataLength transform:^id(NSData *resourceData) {
                RKResourcePOD *resourcePod = RKResourcePOD.new;
                resourcePod.id = resourceData.readWord;
                resourcePod.nameOffset = resourceData.readWord;
                resourcePod.flags = resourceData.readByte;
                resourcePod.offset = (resourceData.readWord << 8) | resourceData.readByte;
                resourcePod.handleReserved = resourceData.readLong;
                return resourcePod;
            }];
            
            // Ensure the type is recorded for this POD.
            resourcePod.typeCode = typePod.code.copy;
            
            // Seek to the name of the resource and extract it. If there is no offset, then
            // no name is present to be extracted.
            if (resourcePod.nameOffset >= 0) {
                data.position = pod.mapOffset + pod.nameListOffset + resourcePod.nameOffset;
                resourcePod.name = data.readPString;
            }
            
            // Seek to the data of the resource and fetch the size.
            data.position = pod.dataOffset + resourcePod.offset;
            resourcePod.size = data.readLong;
            resourcePod.data = [data readDataOfLength:resourcePod.size transform:nil];
            
            // Finally store the resource pod for later.
            [pod.resourcePods addObject:resourcePod];
            
        }
        
    }
    
    return YES;
}

@end
