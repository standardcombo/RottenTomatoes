//
//  GetLeaderboardCall.h
//  LazyTableImages
//
//  Created by Gabriel Santos on 1/9/15.
//
//


@interface GetLeaderboardCall : NSObject

@property (nonatomic, strong) NSMutableArray *picDataArray;
@property (nonatomic, strong) NSString *themeId;
@property (nonatomic) int count;

@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startCall;

@end