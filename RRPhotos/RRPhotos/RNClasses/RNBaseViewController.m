//
//  RNBaseViewController.m
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNBaseViewController.h"

@implementation RNBaseViewController
@synthesize  requestAssistant =  _requestAssistant;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { 
		if (_requestAssistant) {
			TT_RELEASE_SAFELY(_requestAssistant);	
		}
		_requestAssistant = [[RCBaseRequest alloc]init];
		_requestAssistant.onCompletion = ^(NSDictionary* result){
			[self requestDidSucceed:result];//请求成功回调
		};
		
		_requestAssistant.onError = ^(RCError* error) { 
			[self requestDidError:error];//请求错误回调
		};

        // Custom initialization
	}
    
    return self;
}

- (id)initWithObjects:(NSArray *)objects {
    if (self = [super init]) {
        
    }
    
    return self;
}

#pragma mark - NetWork

//发送网络请求
- (void)sendQueryWithDic:(NSDictionary *)dic andMethod:(NSString *)method {
	
	[self.requestAssistant sendQuery:dic withMethod:method];
	
}

//网络请求成功
- (void)requestDidSucceed:(NSDictionary *)result {
    //子类实现
}

//网络请求失败
- (void)requestDidError:(RCError *)error {
    //子类实现
}



#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
	
	 [super viewDidLoad];
 }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
