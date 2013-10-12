//
//  fileUploadEngine.m
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/12/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "fileUploadEngine.h"

@implementation fileUploadEngine
- (MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
   MKNetworkOperation *op = [self operationWithPath:path params:params httpMethod:@"POST" ssl:NO];
   return op;
}
@end
