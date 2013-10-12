//
//  TwerkAPI.h
//  Twerk With Friends
//
//  Created by Scott Vanderlind on 9/8/13.
//  Copyright (c) 2013 Bing Bang Boom. All rights reserved.
//
#define URL_BASE @"http://scottshout.y2klol.com/0.1"
#define URL_BASE_NO_HTTP @"scottshout.y2klol.com/0.1"
#import <Foundation/Foundation.h>

typedef void (^FetchBlock)(NSDictionary *items, NSError *error);

@interface TwerkAPI : NSObject

@property (strong) NSOperationQueue *operationQueue;

+ (id)sharedAPI;
- (void)getGlobalLeaderboard:(NSNumber *)limit offset:(NSNumber *)offset block:(FetchBlock)block;
- (void)getLocalLeaderboard:(NSNumber *)limit offset:(NSNumber *)offset block:(FetchBlock)block;
- (void)getEndpoint:(NSString *)endpoint parameters:(NSMutableDictionary *)params block:(FetchBlock)block;
- (void)postEndpoint:(NSString *)endpoint parameters:(NSMutableDictionary *)params block:(FetchBlock)block;
- (void)getLoggedin:(NSString *)username password:(NSString *)password block:(FetchBlock)block;

/*
- (NSDictionary *)testConnection;
- (NSDictionary *)getTop:(NSNumber *)limit offset:(NSNumber *)offset;
- (NSDictionary *)getLocal:(NSNumber *)limit offset:(NSNumber *)offset;
- (NSDictionary *)getAlert;
- (NSDictionary *)post:(NSString *)endpoint parameters:(NSMutableDictionary *)params;
*/

@property (strong, nonatomic, readonly) NSString *authkey;

@end
