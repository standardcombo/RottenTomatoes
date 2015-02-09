//
//  GetLeaderboardCall.m
//  LazyTableImages
//
//  Created by Gabriel Santos on 1/9/15.
//
//

//#import "ParseLeaderboardOperation.h"
#import "GetLeaderboardCall.h"

#import <CFNetwork/CFNetwork.h>


static NSString *const Endpoint =
@"http://api.r2c.co/leaderboard.php?access_token=CAACEdEose0cBANqaVaBbrwP7hkx0N&theme_id=%@&n=%d";


@interface GetLeaderboardCall () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) NSOperationQueue *queue;
// RSS feed network connection to the App Store
@property (nonatomic, strong) NSURLConnection *getLeaderboardConnection;
@property (nonatomic, strong) NSMutableData *appListData;

@end


@implementation GetLeaderboardCall

// -------------------------------------------------------------------------------
//	Begin fetching the leaderboard data, which is an array of PicData
// -------------------------------------------------------------------------------
- (void)startCall
{
    NSString *url = [NSString stringWithFormat:Endpoint, _themeId, _count];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    _getLeaderboardConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // Test the validity of the connection object. The most likely reason for the connection object
    // to be nil is a malformed URL, which is a programmatic error easily detected during development
    // If the URL is more dynamic, then you should implement a more flexible validation technique, and
    // be able to both recover from errors and communicate problems to the user in an unobtrusive manner.
    //
    NSAssert(self.getLeaderboardConnection != nil, @"Failure to create URL connection.");
}

// -------------------------------------------------------------------------------
//	handleError:error
//  Reports any error with an alert which was received from connection or loading failures.
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Show Leaderboard"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

// The following are delegate methods for NSURLConnection. Similar to callback functions, this is how
// the connection object,  which is working in the background, can asynchronously communicate back to
// its delegate on the thread from which it was started - in this case, the main thread.
//
#pragma mark - NSURLConnectionDelegate

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
//  Will be called at most once, if an error occurs during a resource load.
//  No other callbacks will be made after.
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (error.code == kCFURLErrorNotConnectedToInternet)
    {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"No Connection Error"};
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfo];
        [self handleError:noConnectionError];
    }
    else
    {
        // otherwise handle the error generically
        [self handleError:error];
    }
    
    self.getLeaderboardConnection = nil;   // release our connection
}

#pragma mark - NSURLConnectionDataDelegate

// -------------------------------------------------------------------------------
//	connection:didReceiveResponse:response
//  Called when enough data has been read to construct an NSURLResponse object.
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.appListData = [NSMutableData data];    // start off with new data
}

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
//  Called with a single immutable NSData object to the delegate, representing the next
//  portion of the data loaded from the connection.
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.appListData appendData:data];  // append incoming data
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
//  Called when all connection processing has completed successfully, before the delegate
//  is released by the connection.
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    self.getLeaderboardConnection = nil;   // release our connection
//    
//    // create the queue to run our ParseOperation
//    self.queue = [[NSOperationQueue alloc] init];
//    
//    _picDataArray = [NSMutableArray array];
//    
//    // create an ParseOperation (NSOperation subclass) to parse the data
//    // so that the UI is not blocked
//    ParseLeaderboardOperation *parser = [[ParseLeaderboardOperation alloc] initWithJsonData:self.appListData result:_picDataArray];
//    
//    parser.errorHandler = ^(NSError *parseError) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self handleError:parseError];
//        });
//    };
//    
//    // Referencing parser from within its completionBlock would create a retain cycle.
//    //    __weak ParseLeaderboardOperation *weakParser = parser;
//    
//    parser.completionBlock = ^(void) {
//            // Parser may conclude on any thread. Return the completion onto the main thread
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if (self.completionHandler)
//                {
//                    self.completionHandler();
//                }
//            });
//        
//        // we are finished with the queue and our ParseOperation
//        self.queue = nil;
//    };
//    
//    [self.queue addOperation:parser]; // this will start the "ParseOperation"
//    
//    // ownership of appListData has been transferred to the parse operation
//    // and should no longer be referenced in this thread
//    self.appListData = nil;
}
@end