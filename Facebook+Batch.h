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

/**
 Addon source code to allow easy Graph API Batch handling for the [facebook-ios-sdk](https://github.com/facebook/facebook-ios-sdk/)
 
 The Facebook Graph API allows batching with up to 50 requests at once.
 By batching several HTTP requests you can gain performance in loading your data,
 and you can make awesome requests using input from one request into another in just one call.
 
 Read more about the Graph API Batch possibilities:
 http://developers.facebook.com/docs/reference/api/batch/
 
 Read more about the Facebook iOS SDK:
 https://developers.facebook.com/docs/reference/iossdk/
 
 Using this is simple, you construct your Facebook instance as instructed in the Facebook tutorial:
 https://developers.facebook.com/docs/mobile/ios/build/
 
 After that you construct and execute a batch request like so:
 
        // Facebook instance initialized and ready as facebook
        [facebook batchAddRequestWithPath:@"me"];   // Request my info
        [facebook batchAddRequestWithPath:@"me/friends?fields=id&limit=5"
                                     name:@"myfriends"
                                   method:@"GET"
                                     body:nil
                             omitResponse:YES];     // Request 5 friends
        // But we'll just use that info as input to the next request
        [facebook batchAddRequestWithPath:@"?ids={result=myfriends:$.data.*.id}"];
        FBRequest *batchRequest = [facebook batchRequestWithDelegate:self];
        // expect results in your FBRequestDelegate implementation
 
 But it starts to be more power full if you start using FQL queries inside the batch.
 */

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface Facebook (Batch)

/// ------------------------------------------------------------------------
/// @name Adding requests to the Batch
/// ------------------------------------------------------------------------

/**
 Add request to the batch with relative_url specified
 HTTP method = GET, omit_response_on_success = false, no name
 @param path relative_url parameter for the request
 @see batchAddRequestWithPath:name:method:body:omitResponse:
 */
- (void)batchAddRequestWithPath:(NSString *)path;

/**
 Add request to the batch with relative_url and name properties specified.
 HTTP method = GET, omit_response_on_success = false
 @param path relative_url parameter for the request
 @param name name parameter for the request
 @see batchAddRequestWithPath:name:method:body:omitResponse:
 */
-(void)batchAddRequestWithPath:(NSString *)path
                          name:(NSString *)name;

/**
 Add request to the batch with relative_url, name and HTTP method properties specified.
 omit_response_on_success = false
 @param path relative_url parameter for the request
 @param name name parameter for the request
 @param method HTTP method in NSString
 @see batchAddRequestWithPath:name:method:body:omitResponse:
 */
-(void)batchAddRequestWithPath:(NSString *)path
                          name:(NSString *)name
                        method:(NSString *)method;

/**
 Add request to the batch with relative_url, name, HTTP method and body properties specified.
 omit_response_on_success = false
 @param path relative_url parameter for the request
 @param name name parameter for the request
 @param method HTTP method in NSString
 @param body body parameter for the requests
 @see batchAddRequestWithPath:name:method:body:omitResponse:
 */
-(void)batchAddRequestWithPath:(NSString *)path
                          name:(NSString *)name
                        method:(NSString *)method
                          body:(NSString *)body;

/**
 Add request to the batch with relative_url, name, HTTP method and body properties specified.
 @param path relative_url parameter for the request
 @param name name parameter for the request
 @param method HTTP method in NSString
 @param body body parameter for the requests
 @param omit BOOL value to set the parameter omit_response_on_success
 */
-(void)batchAddRequestWithPath:(NSString *)path
                          name:(NSString *)name
                        method:(NSString *)method
                          body:(NSString *)body
                  omitResponse:(BOOL)omit;

/// ------------------------------------------------------------------------
/// @name Execute the Batch request
/// ------------------------------------------------------------------------

/**
 Perform the batched request to the Facebook Graph API in the correct way.
 After calling this method a new batch request can be constructed immediately
 @param delegate FBRequestDelegate handling the response
 @result FBRequest instance
 */
- (FBRequest *)batchRequestWithDelegate:(id<FBRequestDelegate>)delegate;

/// ------------------------------------------------------------------------
/// @name Result handling
/// ------------------------------------------------------------------------

/**
 As simple convenience function to parse the result data to an easier to use
 array.
 @param result Result received in the FBRequestDelegate callback
 @result NSArray Array containing the result body fields ordered in request
 @note The array can contain NSNull objects for omitted responses.
 */
- (NSArray *)batchResult:(id)result;

@end
