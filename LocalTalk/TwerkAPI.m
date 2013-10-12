//
//  TwerkAPI.m
//  Twerk With Friends
//
//  Created by Scott Vanderlind on 9/8/13.
//  Copyright (c) 2013 Bing Bang Boom. All rights reserved.
//

#import "TwerkAPI.h"
#import "SecureUDID.h"



@interface TwerkAPI()

@property (strong, nonatomic) NSString *domain;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *authkey;
@end

@implementation TwerkAPI



- (id)init
{
    self.authkey = @"";
    
    // UUID generation things
    self.domain = @"com.bingbangboom.LocalTalk";
    self.key = @"TitsOrGTFO";
    
    self.uuid = [SecureUDID UDIDForDomain:self.domain usingKey:self.key];
    
    if ( ( self = [super init] ) )
    {
        // The maxConcurrentOperationCount should reflect the number of open
        // connections the server can handle. Right now, limit it to two for
        // the sake of this example.
        
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 2;
    }
    
    return self;
}

+ (id)sharedAPI
{
    static dispatch_once_t onceToken;
    static id sharedAPI = nil;
    
    dispatch_once( &onceToken, ^{
        sharedAPI = [[[self class] alloc] init];
    });
    
    return sharedAPI;
}

- (void)hitEndpoint:(NSString *)endpoint
             method:(NSString *)method
         parameters:(NSMutableDictionary *)params
              block:(FetchBlock)block
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        // Turn on the network spinner.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSError *error = nil;
        NSURLResponse *response = nil;
        
        
        NSMutableArray *parts = [[NSMutableArray alloc] init];
        for (NSString *key in [params allKeys]) {
            NSString *value = [params objectForKey: key];
            NSString *part = [NSString stringWithFormat: @"%@=%@",
                              [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                              [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            [parts addObject: part];
        }
        NSString *bodyData = [parts componentsJoinedByString: @"&"];
        
        //NSString *bodyData = [NSString stringWithFormat:@"%@", [self urlEncodedString:params]];
        NSString *url = [NSString stringWithFormat:@"%@", [URL_BASE stringByAppendingString:endpoint]];

        if([method isEqualToString:@"GET"] && bodyData) {
            url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@", bodyData]];
        }

        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [postRequest addValue:@"Shout v0.1" forHTTPHeaderField:@"User-Agent"];
        [postRequest addValue:self.authkey forHTTPHeaderField:@"TALK-KEY"];
        [postRequest setHTTPMethod:method];
        

        if([method isEqualToString:@"POST"] && bodyData) {
            [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:[bodyData length]]];
        }
        
        NSData *received = [NSURLConnection sendSynchronousRequest:postRequest
                                                 returningResponse:&response
                                                             error:&error];
        NSDictionary *json = nil;
        if (error != nil || received == nil) {
            NSLog(@"API Error; Do you have an internet connection?");
        } else {
            //NSLog(@"%@", [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding]);
            json = [NSJSONSerialization
                      JSONObjectWithData:received
                      options:kNilOptions
                      error:&error];
        }
        
        // Turn off the network spinner now.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error)
                block(nil, error);
            else
                block(json, nil);
        }];
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [self.operationQueue addOperation:operation];
    
}


- (void)postEndpoint:(NSString *)endpoint parameters:(NSMutableDictionary *)params block:(FetchBlock)block
{
    [params setValue:self.uuid forKey:@"uuid"];
    [self hitEndpoint:endpoint method:@"POST" parameters:params block:block];
}
- (void)getEndpoint:(NSString *)endpoint parameters:(NSMutableDictionary *)params block:(FetchBlock)block
{
    [self hitEndpoint:endpoint method:@"GET" parameters:params block:block];
}

- (void)getGlobalLeaderboard:(NSNumber *)limit offset:(NSNumber *)offset block:(FetchBlock)block
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[limit stringValue] forKey:@"limit"];
    [params setValue:[offset stringValue] forKey:@"offset"];
    [self getEndpoint:@"/top" parameters:params block:block];
}

- (void)getLocalLeaderboard:(NSNumber *)limit offset:(NSNumber *)offset block:(FetchBlock)block
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[limit stringValue] forKey:@"limit"];
    [params setValue:[offset stringValue] forKey:@"offset"];
    [params setValue:self.uuid forKey:@"uuid"];
    [self getEndpoint:@"/top" parameters:params block:block];
}

// helper function: get the url encoded string form of any object
- (NSString *) urlEncode:(NSString *)theString
{
    return [theString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

// Turn a dictionary into a query string
-(NSString*) urlEncodedString:(NSMutableDictionary *)params
{
    NSMutableArray *parts = [NSMutableArray array];
    for (NSString *key in [params allKeys]) {
        NSString *value = [params objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", [self urlEncode:key], [self urlEncode:value]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

- (void)getLoggedin:(NSString *)username password:(NSString *)password block:(FetchBlock)block
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:username forKey:@"username"];
    [dic setValue:password forKey:@"password"];
    
    [self postEndpoint:@"/login" parameters:dic block:^(NSDictionary *items, NSError *error) {
        if(error == nil && [[items valueForKey:@"status"] isEqualToString:@"success"]) {
            self.authkey = [items valueForKey:@"key"];
            //NSLog(@"Set key to %@", self.authkey);
            block(items, error);
        } else {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Login Failed." forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"com.bingbangboom.localtalk" code:100 userInfo:errorDetail];
            block(items, error);
        }
    }];
}

@end
