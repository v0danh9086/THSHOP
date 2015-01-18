//
//  BaseHTTP.m
//  JK_Template
//
//  Created by JackyChain on 12/17/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "BaseHTTPManager.h"

@implementation BaseHTTPManager

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_SERVER_HOST]];
    });
    
    return _sharedInstance;
}

- (instancetype)initInstanceWithURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFImageResponseSerializer serializer];
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    }
    
    return self;
}
@end
