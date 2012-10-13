Facebook+Batch
==============

Addon source code to allow easy Graph API Batch handling for the facebook-ios-sdk

The Facebook Graph API allows batching with up to 50 requests at once. By batching several HTTP requests you can gain performance in loading your data, and you can make awesome requests using input from one request into another in just one call.

Read more about the Graph API Batch possibilities: http://developers.facebook.com/docs/reference/api/batch/

Read more about the Facebook iOS SDK: https://developers.facebook.com/docs/reference/iossdk/

Using this is simple, you construct your Facebook instance as instructed in the Facebook tutorial: https://developers.facebook.com/docs/mobile/ios/build/

After that you construct and execute a batch request like so:

       FBRequest *fbRequest =  [[FBRequest alloc] init];
    [fbRequest batchAddRequestWithPath:@"yoururl1"];
    [fbRequest batchAddRequestWithPath:@"yoururl2"];
    
    fbRequest= [fbRequest batchRequest:yourtoken];
    
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [connection addRequest:fbRequest
         completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if(!error){
             [fbRequest batchResult:result];
         }
     }
     
     ];
     [connection start];

But it starts to be more power full if you start using fql queries inside the batch.
