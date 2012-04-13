//
//  RNModel.m
//  RRSpring
//
//  Created by hai zhang on 3/6/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import "RNModel.h"
#import "RCBaseRequest.h"
#import "RCMainUser.h"


//////////////////////////////////
@implementation RNModel
@synthesize query = _query;
@synthesize method = _method;
@synthesize delegates = _delegates;
@synthesize request = _request;
@synthesize result = _result;

- (void)dealloc {
    self.query = nil;
    self.method = nil;
    //self.delegates = nil;
    RL_RELEASE_SAFELY(_delegates);
    self.request = nil;
    self.result = nil;
    
    [super dealloc];
}


- (id)init {
    if (self = [super init]) {
        self.query = [NSMutableDictionary dictionary];
        RCMainUser *mainUser = [RCMainUser getInstance];
        [self.query setValue:mainUser.msessionKey forKey:@"session_key"];
        
        self.method = nil;
        self.delegates = [NSMutableArray array];
        
        RCBaseRequest *request = [[RCBaseRequest alloc] init];
        request.onCompletion = ^(id result){
            [self didFinishLoad:result];
        };
        
        request.onError = ^(RCError* error) {
            [self didFailLoadWithError:error];
        };
        
        self.request = request;
        RL_RELEASE_SAFELY(request);
    }
    
    return self;
}

- (void)load:(BOOL)more {
    if (self.method == nil) {
        return;
    }
    [_request sendQuery:_query withMethod:_method];
    [self didStartLoad];
}

- (void) search:(NSString *)text 
{

}

#pragma mark - 网络回调
- (void)didStartLoad {
    [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
}

- (void)didFinishLoad:(id)result {
    self.result = result;
    
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}


- (void)didFailLoadWithError:(RCError *)error {
    [_delegates perform:@selector(model:didFailLoadWithError:) withObject:self
             withObject:error];
}

- (void)didCancelLoad {
    [self.request cancelRequest];
    [_delegates perform:@selector(modelDidCancelLoad:) withObject:self];
}


@end
