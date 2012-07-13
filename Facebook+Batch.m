//
//  Copyright (c) 2012 Profios Ltd. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Facebook+Batch.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "objc/runtime.h"

// Defaults values for JSON requests
// https://developers.facebook.com/docs/reference/api/batch/
static NSString *kFacebookBatchKeyPath = @"relative_url";
static NSString *kFacebookBatchKeyName = @"name";
static NSString *kFacebookBatchKeyMethod = @"method";
static NSString *kFacebookBatchKeyBody = @"body";
static NSString *kFacebookBatchKeyOmit = @"omit_response_on_success";

/** Static pointer for associating the batch request data with the Facebook instance */
static void *kFBBatchKey = &kFBBatchKey;

@implementation Facebook (Batch)

#pragma mark - Convenience wrapper methods

- (void)batchAddRequestWithPath:(NSString *)path
{
    [self batchAddRequestWithPath:path
                             name:nil
                           method:@"GET"
                             body:nil
                     omitResponse:NO];
}

- (void)batchAddRequestWithPath:(NSString *)path
                           name:(NSString *)name
{
    [self batchAddRequestWithPath:path
                             name:name
                           method:@"GET"
                             body:nil
                     omitResponse:NO];    
}

- (void)batchAddRequestWithPath:(NSString *)path
                           name:(NSString *)name
                         method:(NSString *)method
{
    [self batchAddRequestWithPath:path
                             name:nil
                           method:method
                             body:nil
                     omitResponse:NO];
}

- (void)batchAddRequestWithPath:(NSString *)path
                           name:(NSString *)name
                         method:(NSString *)method
                           body:(NSString *)body
{
        [self batchAddRequestWithPath:path
                                 name:name
                               method:method
                                 body:body
                         omitResponse:NO];
}

#pragma mark - Add Request implementation

- (void)batchAddRequestWithPath:(NSString *)path
                           name:(NSString *)name
                         method:(NSString *)method
                           body:(NSString *)body
                   omitResponse:(BOOL)omit
{
    assert(path != nil);
    assert(method != nil);
    // Create a dictionary to contain the properties for this request
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // Add all properties required
    [dict setObject:path forKey:kFacebookBatchKeyPath];
    if (name != nil) {
        [dict setObject:name forKey:kFacebookBatchKeyName];
    }
    [dict setObject:method forKey:kFacebookBatchKeyMethod];
    if (body != nil) {
        [dict setObject:body forKey:kFacebookBatchKeyBody];
    }
    [dict setObject:[NSNumber numberWithBool:omit] forKey:kFacebookBatchKeyOmit];
    
    // Retrieve an already associated requests array
    NSMutableArray *requests = (NSMutableArray*)objc_getAssociatedObject(self, kFBBatchKey);
    // Create the requests array instance if needed
    if (requests == nil) {
        requests = [NSMutableArray array];
        // Associate the array with this Facebook instance
        objc_setAssociatedObject(self, kFBBatchKey, requests, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    // Add the request to the batch
    [requests addObject:dict];
}

#pragma mark - Batch request execution

- (FBRequest *)batchRequestWithDelegate:(id<FBRequestDelegate>)delegate
{
    // Retrieve the already associated requests array
    NSMutableArray *requests = (NSMutableArray*)objc_getAssociatedObject(self, kFBBatchKey);
    assert(requests != nil);
    assert([requests count] > 0);
    // Remove the associated requests array, after this we don't need it anymore
    objc_setAssociatedObject(self, kFBBatchKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableDictionary *batchRequest = [NSMutableDictionary dictionaryWithObject:[requests JSONRepresentation]
                                                                           forKey:@"batch"];
    // Perform the actual batch request, always via HTTP method POST
    return [self requestWithGraphPath:@""
                            andParams:batchRequest
                        andHttpMethod:@"POST"
                          andDelegate:delegate];
}

#pragma mark - Result handling implementation

- (NSArray *)batchResult:(id)result;
{
    NSMutableArray *batchResult = nil;
    if ([result isKindOfClass:[NSArray class]]) {
        batchResult = [NSMutableArray arrayWithCapacity:[result count]];
        for (id batch in result) {
            if ([batch isKindOfClass:[NSDictionary class]]) {
                NSString *body = [batch objectForKey:@"body"];
                [batchResult addObject:[body JSONValue]];
            } else {
                [batchResult addObject:batch];
            }
        }
    }
    return batchResult;
}

@end
