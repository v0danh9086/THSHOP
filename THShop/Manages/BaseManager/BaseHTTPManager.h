//
//  BaseHTTP.h
//  JK_Template
//
//  Created by JackyChain on 12/17/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BaseHTTPManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;
- (instancetype)initInstanceWithURL:(NSURL *)url;

@end
