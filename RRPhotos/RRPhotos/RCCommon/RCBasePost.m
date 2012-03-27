//
//  RCBasePost.m
//  RRSpring
//
//  Created by jiachengwen on 12-2-28.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "RCBasePost.h"

@implementation RCPostState

@synthesize ePostState = _ePostState;
@synthesize error = _error;
@synthesize title = _title;
@synthesize description = _description;
@synthesize uniqueIdentifier = _uniqueIdentifier;
@synthesize itemType = _itemType;
@synthesize canRemoveFromQueue = _canRemoveFromQueue;


-(id)init
{
    self = [super init];
    if(self)
    {
        _ePostState = EPostStateReady;
        _error = nil;
        _title = nil;
        _description = nil;
        _uniqueIdentifier = nil;
        _itemType = EPostTypeNone;
        _canRemoveFromQueue = YES;
    }
    return self;
}

-(void)dealloc
{
    RL_RELEASE_SAFELY(_error);
    RL_RELEASE_SAFELY(_title);
    RL_RELEASE_SAFELY(_description);
    RL_RELEASE_SAFELY(_uniqueIdentifier);
    [super dealloc];
}

@end


@implementation RCBasePost

@synthesize postStateChanged = _postStateChanged;
@synthesize postState = _postState;

-(id)init
{
    if(self = [super init])
    {
        _postState = [[RCPostState alloc] init];
        // 
        self.operationStateChangedHandler = ^(MKNetworkOperationState newState) {
            switch (newState) {
                case MKNetworkOperationStateReady:
                {
                    self.postState.ePostState = EPostStateReady;
                    if(self.postStateChanged)
                        self.postStateChanged(self);

                    break;
                }
                    
                case MKNetworkOperationStateExecuting:
                {
                    self.postState.ePostState = EPostStateExecuting;
                    if(self.postStateChanged)
                        self.postStateChanged(self);
                    break;
                }
                 
                // 由operationSucceeded和operationFailedWithError处理这个状态
          //      case MKNetworkOperationStateFinished:
          //          self.postState.ePostState = EPostStateFinished;
          //          break;
                    
                default:
                    break;
            }
            
        };
    }
    
    return self;
}

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params
             httpMethod:(NSString *)method
{
    self = [super initWithURLString:aURLString params:params httpMethod:method];
    if(self)
    {
        _postState = [[RCPostState alloc] init];
        self.operationStateChangedHandler = ^(MKNetworkOperationState newState) {
            switch (newState) {
                case MKNetworkOperationStateReady:
                {
                    self.postState.ePostState = EPostStateReady;
                    if(self.postStateChanged)
                        self.postStateChanged(self);
                    
                    break;
                }
                    
                case MKNetworkOperationStateExecuting:
                {
                    self.postState.ePostState = EPostStateExecuting;
                    if(self.postStateChanged)
                        self.postStateChanged(self);
                    break;
                }
                    
                default:
                    break;
            }
        };
    }
    return self;
}

-(void)dealloc
{
    RL_RELEASE_SAFELY(_postState);
    [super dealloc];
}

-(void)operationSucceeded
{
    if(self.postStateChanged)
    {
        self.postState.ePostState = EPostStateFinished;
        self.postStateChanged(self);
    }

    [super operationSucceeded];
}

-(void)operationFailedWithError:(NSError *)error
{
    if(self.postStateChanged)
    {
        self.postState.ePostState = EPostStateError;
        self.postState.error = error;
        self.postStateChanged(self);
    }
    
    [super operationFailedWithError:error];
}

-(RCPostState *)postState
{
    _postState.title = @"title";
    _postState.description = @"description";
    _postState.uniqueIdentifier = [super uniqueIdentifier];
    
    return _postState;
}

@end
