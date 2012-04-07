//
//  RNCreateAlbumViewController.m
//  RRSpring
//
//  Created by yi chen on 12-4-5.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "RNCreateAlbumViewController.h"
#import "RCMainUser.h"

//背景容器视图的尺寸
#define kMainBackViewY 44
#define kMainBackViewX 20 
#define kMainBackViewWidth 280
#define kMainBackViewHeight 250 
//相册权限类型拾取器的尺寸
#define kPickHiddenTop 500 //隐藏时候的高度
#define kPickShowTop 244
#define kPickWidth 320
#define kPickHeight 216

#define kSpace 80 //控件之间的空隙

#define kToolBarHeight 40 //pick工具栏

@implementation RNCreateAlbumViewController
@synthesize topNavView = _topNavView;
@synthesize mainBackView = _mainBackView;
@synthesize cancelButton = _cancelButton;
@synthesize confirmButton = _confirmButton;
@synthesize albumNameField = _albumNameField;
@synthesize albumTypeButton = _albumTypeButton;

@synthesize pickTypeView = _pickTypeView;
@synthesize toolBar = _toolBar;
@synthesize typesArray = _typesArray;
@synthesize passwordField = _passwordField;
@synthesize delegate = _delegate;
@synthesize requestAssistant = _requestAssistant;
- (void)dealloc{
	self.topNavView = nil;
	self.mainBackView = nil;
	self.cancelButton = nil;
	self.confirmButton = nil;
	self.albumNameField = nil;
	self.albumTypeButton = nil;
	self.pickTypeView = nil;
	self.toolBar = nil;
	
	self.typesArray = nil;
	self.passwordField = nil;
	self.delegate = nil;
	self.requestAssistant = nil;
	[super dealloc];
}

- (id)init{
	if (self = [super init]) {
		
		//网络请求初始化
		self.requestAssistant = [RCGeneralRequestAssistant requestAssistant];
		self.requestAssistant.onCompletion = ^(NSDictionary* result){
			[self requestDidSucceed:result];
		};
		
		self.requestAssistant.onError = ^(RCError* error) {
			[self requestDidError:error];
		};
		

	}
	return self;
}

#pragma -mark view lifecycle

- (void)loadView{
	[super loadView];
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	

	//后部主view容器
	_mainBackView = [[UIView alloc]initWithFrame:CGRectMake(kMainBackViewX, kMainBackViewY,
															kMainBackViewWidth, kMainBackViewHeight)];
	self.mainBackView.userInteractionEnabled = YES;
	self.mainBackView.backgroundColor = [UIColor clearColor]; //RGBCOLOR(50, 50, 50);
	[self.view addSubview:self.mainBackView];
	
	//相册名输入
	_albumNameField = [[UITextField alloc]initWithFrame:CGRectMake(20 , 20,
																   kMainBackViewWidth - 40,40)];
	[_albumNameField becomeFirstResponder];
	_albumNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_albumNameField.borderStyle = UITextBorderStyleRoundedRect;
	_albumNameField.delegate = self;
	_albumNameField.font = [UIFont fontWithName:MED_HEITI_FONT size:15];
	_albumNameField.placeholder = @"请输入相册名(30个字符以内)";
	_albumNameField.returnKeyType = UIReturnKeyDone;
	_albumNameField.textColor = RGBCOLOR(100, 0, 0);
	[self.mainBackView addSubview:self.albumNameField];
	
	
		
	//相册权限类型选择按钮
	_albumTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_albumTypeButton.frame = CGRectMake(20 , _albumNameField.origin.y + kSpace , kMainBackViewWidth - 40 , 40);
	[_albumTypeButton setTitle:@"所有人可见" forState:UIControlStateNormal];
	[_albumTypeButton addTarget:self action:@selector(onClickAlbumTypeButton) forControlEvents:UIControlEventTouchUpInside];
	[self.mainBackView addSubview:self.albumTypeButton];

	
	//密码输入框
	_passwordField = [[UITextField alloc]initWithFrame:CGRectMake(20, _albumTypeButton.origin.y + kSpace,
																  kMainBackViewWidth - 40,40)];

	_passwordField.alpha = 0.0;//默认隐藏
	_passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_passwordField.borderStyle = UITextBorderStyleRoundedRect;
	_passwordField.delegate = self;
	_passwordField.font = [UIFont fontWithName:MED_HEITI_FONT size:15];
	_passwordField.placeholder = @"请输入密码(13个字符以内)";
	_passwordField.returnKeyType = UIReturnKeyDone;
	_passwordField.textColor = RGBCOLOR(100, 0, 0);
	[self.mainBackView addSubview:self.passwordField];

	
	//导航栏
	UIImageView *topView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_bar.png"]];
	self.topNavView = topView;
	self.topNavView.userInteractionEnabled = YES;
	self.topNavView.frame = CGRectMake(0, 0, 320, 44);
	[topView release];
	[self.view addSubview: self.topNavView];
	
	
	//返回按键
	UIButton* concelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[concelButton setImage:[UIImage imageNamed:@"titlebar_cancel.png"]  
				  forState:UIControlStateNormal];
	CGSize buttonSize = [concelButton currentImage].size;
	concelButton.frame = CGRectMake(5, 0, buttonSize.width	,buttonSize.height);
	[concelButton addTarget:self action:@selector(onClickConcelButton) 
		   forControlEvents:UIControlEventTouchUpInside];
	[self.topNavView addSubview:concelButton];
	[self.view addSubview:self.topNavView];
	
	//确认按钮
	UIButton* confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[confirmButton setImage:[UIImage imageNamed:@"titlebar_confirm.png"] 
				   forState:UIControlStateNormal];
	CGSize confirmButtonSize = [confirmButton currentImage].size;
	confirmButton.frame = CGRectMake(270, 0, confirmButtonSize.width, confirmButtonSize.height);
	[confirmButton addTarget:self action:@selector(onClickConfirmButton) 
			forControlEvents:UIControlEventTouchUpInside];
	[self.topNavView addSubview:confirmButton];
	
	
	
	//相册类型数组
	_typesArray = [[NSArray alloc]initWithObjects:@"所有人可见",@"仅好友可见",@"用密码访问",@"仅自己可见", nil];
	
	_pickTypeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kPickHiddenTop, kPickWidth, kPickHeight)];
	_pickTypeView.delegate = self;
	_pickTypeView.dataSource = self;
	_pickTypeView.showsSelectionIndicator = YES;
	
	[self.view addSubview:_pickTypeView];
	
	_toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(_pickTypeView.origin.x, _pickTypeView.origin.y - kToolBarHeight, 
														 _pickTypeView.width, kToolBarHeight)];
	_toolBar.backgroundColor = [UIColor blackColor];
	NSMutableArray *myToolBarItems = [NSMutableArray array];
    UIBarButtonItem *flexibleSpaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                                          target:nil
                                                                                          action:nil];
    [myToolBarItems addObject:flexibleSpaceBarItem];//空白填充
    [flexibleSpaceBarItem release];
    
    UIBarButtonItem* doneBarBtnItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self 
                                                                                     action:@selector(toolbarAction)];
    [myToolBarItems addObject:doneBarBtnItem];
    [doneBarBtnItem release];
	[_toolBar setItems:myToolBarItems animated:YES];
	
	[self.view addSubview:_toolBar];
}

- (void)viewWillAppear:(BOOL)animated{
	[self.navigationController setNavigationBarHidden:YES animated: YES]; //隐藏导航栏
	
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//验证密码只能输入1 -- 13个字母、数字、下划线 
- (BOOL)checkPaw:(NSString *)str
{
	//[a-zA-Z]
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc] 
                                              initWithPattern:@"^[a-zA-Z0-9|_]{1,14}$"
                                              options:NSRegularExpressionCaseInsensitive 
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str 
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    [regularexpression release];
    
    if(numberofMatch > 0)
    {
        NSLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
    
    NSLog(@"%@ isNumbericString: NO", str);
    return NO;
}

#pragma  -mark 取消创建
- (void)onClickConcelButton{ //取消按钮
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark 确认创建 
- (void)onClickConfirmButton{//创建按钮
	
	UIAlertView* alert;
    NSString* newtitleText=@"",*newpwdText=@"";
	
    if([_albumNameField.text length]>0){
        newtitleText = [_albumNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if([_passwordField.text length]>0){
        newpwdText = [_passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if([newtitleText length] == 0){
        alert = [[UIAlertView alloc] initWithTitle:nil 
                                           message:@"请输入相册名称哦！亲！" 
                                          delegate:nil 
                                 cancelButtonTitle:nil 
                                 otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    if([newtitleText length] > 30){
        alert = [[UIAlertView alloc] initWithTitle:nil 
                                           message:@"相册名不可以超过30个字符哦！亲！"
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
	
	NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithCapacity:10];
	[dics setObject:_albumNameField.text forKey:@"name"]; //相册名称

	NSString * vissableType ;
	//设置相册可见性
	if(0 == albumTypeSelectedIndex ){
		vissableType = @"99";//所有人可见
	}else if(1 == albumTypeSelectedIndex){ 
		vissableType = @"1";//仅好友可见
	}else if(2 == albumTypeSelectedIndex){
		//检查密码的一些非法情况
		if([newpwdText length] == 0){
            alert = [[UIAlertView alloc] initWithTitle:nil 
                                               message:@"请输入密码" 
                                              delegate:nil 
                                     cancelButtonTitle:nil 
                                     otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
			
			[self.albumNameField becomeFirstResponder];
			
            return;
        }
        if([newpwdText length] > 13){
            alert = [[UIAlertView alloc] initWithTitle:nil 
                                               message:@"密码不可以超过13个字符哦！"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
            return;
        }
        if (![self checkPaw:newpwdText]) {
            alert = [[UIAlertView alloc] initWithTitle:nil 
                                               message:@"密码只支持数字、字母、下划线哦！"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
            return;
        }
		
		[dics setObject:newpwdText forKey:@"password"];//设定密码

	}else if(3 == albumTypeSelectedIndex){
		vissableType = @"-1"; //仅自己可见
	}
	
	if (2 != albumTypeSelectedIndex) {
		[dics setObject:vissableType forKey:@"visible"];//可见性
	}
	
	RCMainUser *mainUser = [RCMainUser getInstance];
	if (mainUser.msessionKey) {
		[dics setObject:mainUser.msessionKey forKey:@"session_key"];
		
		[self.requestAssistant sendQuery:dics withMethod:@"photos/createAlbum"];
	}
	

}
- (void)onClickAlbumTypeButton{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if(_pickTypeView.frame.origin.y > 300){
        [_albumNameField resignFirstResponder];
        [_passwordField resignFirstResponder];
        [self showPickTypeView];
    }
	
    if(albumTypeSelectedIndex == 2){
        [self moveMainBackViewUp];
        self.passwordField.alpha = 1.0;
    }
    [UIView commitAnimations];
}

//工具栏点击完成
- (void)toolbarAction{
	if (albumTypeSelectedIndex < [_typesArray count]) {
		[_albumTypeButton setTitle:(NSString *)[_typesArray objectAtIndex:albumTypeSelectedIndex]
						  forState:UIControlStateNormal];
	}
	
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self hiddenPickTypeView];
    if(albumTypeSelectedIndex == 2){
		[self moveMainBackViewUp];

        self.passwordField.alpha = 1.0;
    } else {
		[self moveMainBackViewDown];
        self.passwordField.alpha = 0.0;
    }
    [UIView commitAnimations];
	
    [self performSelector:@selector(animateStop) withObject:nil afterDelay:0.5];

}

//toolbar 完成按钮点击后执行
- (void)animateStop{
    if(albumTypeSelectedIndex == 2){
        [self.passwordField becomeFirstResponder];
    }
}

- (void)showPickTypeView{ //类型拾取器出现
	_pickTypeView.frame = CGRectMake(0, kPickShowTop, kPickWidth, kPickHeight);
	_toolBar.frame = CGRectMake(_pickTypeView.origin.x, _pickTypeView.origin.y - kToolBarHeight, _pickTypeView.width, kToolBarHeight);

}

- (void)hiddenPickTypeView{//类型拾取器隐藏
	
	_pickTypeView.frame = CGRectMake(0, kPickHiddenTop, kPickWidth, kPickHeight);
	_toolBar.frame = CGRectMake(_pickTypeView.origin.x, _pickTypeView.origin.y - kToolBarHeight, _pickTypeView.width, kToolBarHeight);

}


- (void)moveMainBackViewUp{ //下面的视图上移
    self.mainBackView.frame = CGRectMake(kMainBackViewX, kMainBackViewY - kSpace - 20 ,
										 kMainBackViewWidth, kMainBackViewHeight);
}
- (void)moveMainBackViewDown{
    self.mainBackView.frame = CGRectMake(kMainBackViewX, kMainBackViewY,
									kMainBackViewWidth, kMainBackViewHeight);
}

#pragma mark - keyboard show and hide
//出现键盘
- (void)keyboardWillShow:(NSNotification *)notification {
    if([_passwordField isFirstResponder]){
        if(albumTypeSelectedIndex == 2){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.5];
            [self moveMainBackViewUp];
            self.passwordField.alpha = 1.0;

            [UIView commitAnimations];
        } 
    }
    [self hiddenPickTypeView];

}

//隐藏键盘
- (void)keyboardWillHide:(NSNotification*)notification{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self  moveMainBackViewDown];
    if(albumTypeSelectedIndex == 2){
        self.passwordField.alpha = 1.0; 
    } else {
        self.passwordField.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void)passWordFieldShowOrNot{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if(albumTypeSelectedIndex == 2){
        [self moveMainBackViewUp];
        self.passwordField.alpha = 1.0;

    } else {
        [self moveMainBackViewDown];
        self.passwordField.alpha = 0.0;
    }
    [UIView commitAnimations];
}


#pragma -mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if([textField isEqual:_passwordField]){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.5];
        [self moveMainBackViewUp];
        self.passwordField.alpha = 1.0;

        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma - mark UIPickerViewDataSource


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [self.typesArray count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return 60;
}

#pragma -mark UIPickerViewDelegate


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	NSString *titleString = (NSString *)[self.typesArray objectAtIndex:row];
	return [titleString autorelease];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	albumTypeSelectedIndex = row; //选中标记
	
	[self.albumTypeButton setTitle:(NSString *)[_typesArray objectAtIndex:albumTypeSelectedIndex] 
						  forState:UIControlStateNormal];
	
	[self passWordFieldShowOrNot];
}

#pragma -mark 网络请求相关
- (void)requestDidSucceed:(NSDictionary *)result {
	UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:@"创建相册成功" delegate:nil
										cancelButtonTitle:@"取消" otherButtonTitles: nil];
	
	[view show];
	[view release];
	
	[self.navigationController popViewControllerAnimated: YES];
	//回调通知创建成功
	[self.delegate finishCreateAlbum];
}

//网络请求失败
- (void)requestDidError:(RCError *)error {
	UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:@"创建相册失败" delegate:nil
										cancelButtonTitle:@"取消" otherButtonTitles: nil];
	[view show];
	[view release];
}


@end
