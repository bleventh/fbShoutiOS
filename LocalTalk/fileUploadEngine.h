//
//  fileUploadEngine.h
//  LocalTalk
//
//  Created by Brandon Leventhal on 10/12/13.
//  Copyright (c) 2013 Scott Vanderlind. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface fileUploadEngine : MKNetworkEngine
- (MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path;
@end
