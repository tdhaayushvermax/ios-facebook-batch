Facebook+Batch
==============

Addon source code to allow easy Graph API Batch handling for the facebook-ios-sdk

The Facebook Graph API allows batching with up to 50 requests at once. By batching several HTTP requests you can gain performance in loading your data, and you can make awesome requests using input from one request into another in just one call.

Read more about the Graph API Batch possibilities: http://developers.facebook.com/docs/reference/api/batch/

Read more about the Facebook iOS SDK: https://developers.facebook.com/docs/reference/iossdk/

Using this is simple, you construct your Facebook instance as instructed in the Facebook tutorial: https://developers.facebook.com/docs/mobile/ios/build/

After that you construct and execute a batch request like so:

    // Facebook instance initialized and ready as facebook
    [facebook batchAddRequestWithPath:@"me"];
    [facebook batchAddRequestWithPath:@"me/friends?fields=id&limit=5"
                                 name:@"myfriends"
                               method:@"GET"
                                 body:nil
                         omitResponse:YES];
    [facebook batchAddRequestWithPath:@"?ids={result=myfriends:$.data.*.id}"];
    FBRequest *batchRequest = [facebook batchRequestWithDelegate:self];
    // expect results in your FBRequestDelegate implementation

But it starts to be more power full if you start using fql queries inside the batch.
