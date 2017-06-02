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

#import "XCTestCase+RKResourceAssertions.h"
#import <ResourceKit/ResourceKit.h>

@implementation XCTestCase (RKResourceAssertions)

- (void)assert:(nullable id<RKResourceContainer>)container has:(nullable id)instance with:(nullable id)object
{
    if (!container) {
        XCTAssertNotNil(container);
        return;
    }
    
    if (!instance) {
        XCTAssertNotNil(instance);
        return;
    }
    
    // RKType
    if ([instance isMemberOfClass:RKType.class]) {
        XCTAssertTrue([container.allTypes containsObject:instance]);
        return;
    }
    
    // RKResource
    else if ([instance isMemberOfClass:RKResource.class]) {
        for (RKType *type in container.allTypes) {
            for (RKResource *resource in type.allResources) {
                if ([resource isEqual:instance] && ((!object) || (object && [resource.name isEqual:object]))) {
                    return;
                }
            }
        }
        XCTFail(@"Could not find a resource of type \"%@\" and ID %d in the container.",
                [[(RKResource *)instance type] code],
                [instance id]);
    }
    
    // Unrecognised type...
    XCTFail(@"Could not check for an instance of \"%@\" in the container \"%@\".", [instance class], [container class]);
}

- (void)assert:(nullable id<RKResourceContainer>)container hasNot:(nullable id)instance with:(nullable id)object
{
    if (!container) {
        XCTAssertNotNil(container);
        return;
    }
    
    if (!instance) {
        XCTAssertNotNil(instance);
        return;
    }
    
    // RKType
    if ([instance isMemberOfClass:RKType.class]) {
        XCTAssertFalse([container.allTypes containsObject:instance]);
        return;
    }
    
    // RKResource
    else if ([instance isMemberOfClass:RKResource.class]) {
        for (RKType *type in container.allTypes) {
            for (RKResource *resource in type.allResources) {
                if ([resource isEqual:instance] && ((!object) || (object && [resource.name isEqual:object]))) {
                    XCTFail(@"Found a resource of type \"%@\" and ID %d in the container.",
                            [[(RKResource *)instance type] code],
                            [instance id]);
                    return;
                }
            }
        }
        return;
    }
    
    // Unrecognised type...
    XCTFail(@"Could not check for an instance of \"%@\" in the container \"%@\".", [instance class], [container class]);
}

@end
