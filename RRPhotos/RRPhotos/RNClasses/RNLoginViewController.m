//
//  RNLoginViewController.m
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNLoginViewController.h"
#import "AppDelegate.h"
#import "RCMainUser.h"
//#import "RNMainViewController.h"
//#import "RNDrawLineView.h"
//#import "RNRegistrationViewController.h"

// #import "RRLoginModel.h"
//#import "RCResManager.h"
#import "RNMainViewController.h"

#define EMAIL_FIELD_TOP_EDGE 0
#define PASSWORD_FIELD_TOP_EDGE 20
@implementation RNLoginViewController

@synthesize emailField;
@synthesize passwordField;
@synthesize registButton;
@synthesize lastUsername = _lastUsername;
@synthesize lastPassword = _lastPassword;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize loginDelegate = _loginDelegat;

- (void)dealloc {	
	[emailField release];
	[passwordField release];
	TT_RELEASE_SAFELY(_activityIndicatorView);
	TT_RELEASE_SAFELY(_lastUsername);
	TT_RELEASE_SAFELY(_lastPassword);
	
    [super dealloc];
}

- (id)init {
	
	if (self = [super init]) {
		self.activityIndicatorView = [self getActivityIndicatorView]; 
	}
    
	return self;
}


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) { 
//		self.activityIndicatorView = [self getActivityIndicatorView];//获取正在登陆动画
//	}
//    
//    return self;
//}

/**
 *请求成功回调
 */
- (void)requestDidSucceed:(NSDictionary *)result {
    [_activityIndicatorView removeFromSuperview];
    // 保存登录信息
    RCMainUser* mainUser = [RCMainUser getInstance];
    mainUser.msessionKey = [result objectForKey:@"session_key"];
    
    mainUser.mticket = [result objectForKey:@"ticket"];
    mainUser.ticket = mainUser.mticket;
    
    mainUser.userId = [result objectForKey:@"uid"];
    mainUser.mprivateSecretKey = [result objectForKey:@"secret_key"];
    //	mainUser.loginStatus = RRLoginStatusLogined;
    mainUser.userName = [result objectForKey:@"user_name"];
    NSNumber * checkValue = [result objectForKey:@"fill_stage"];
    switch ([checkValue intValue]) {
        case 1:
            mainUser.checkIsNewUser = YES;
            break;
        default:
            mainUser.checkIsNewUser = NO;
            break;
    }
//	
//	UIViewController *view = [[UIViewController alloc]init ];//登陆后的界面
//	view.navigationItem.leftBarButtonItem = nil;
//	view.navigationItem.rightBarButtonItem = nil;
//	[self.navigationController setNavigationBarHidden:YES]; //暂时这样处理
//	[self.navigationController pushViewController:view animated:NO];
	//进入主界面

//	[self dismissModalViewControllerAnimated:YES];
	
	
//	if (_loginDelegat) {
//		if ([_loginDelegat performSelector:@selector(finishLogin)]) {
//			[_loginDelegat finishLogin ];//通知登陆完毕
//		}
//	}
	
	RNMainViewController *mainController = [[RNMainViewController alloc]init];
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication 
											   sharedApplication].delegate;
	UIViewController *view = [[UIViewController alloc]init ];
	view.view.backgroundColor = [UIColor greenColor];
	[appDelegate.rootNavController pushViewController:mainController animated:YES];
	[mainController release];
}


/**
 *请求错误回调
 */
- (void)requestDidError:(RCError *)error {
    [_activityIndicatorView removeFromSuperview];
    emailField.enabled = TRUE;
    passwordField.enabled = TRUE;
    [passwordField becomeFirstResponder];
    // 错误处理 
    UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:@"出错了" message:[error titleForError] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
    
    [pAlert show];
    [pAlert release];
}

- (UIView*)getActivityIndicatorView {
	UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(20,EMAIL_FIELD_TOP_EDGE,280,80)] autorelease];
	view.backgroundColor = [UIColor whiteColor];
	
	UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[indicatorView startAnimating];
	indicatorView.frame = CGRectMake(40, 25, 30, 30);
	[view addSubview:indicatorView];
	//indicatorView.backgroundColor = RGBCOLOR(0xCE,0xDE,0xF6);
	[indicatorView release];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 100, 30)];
	label.text = @"正在登录...";
	//	label.textColor = RGBCOLOR(70,70,70);
	label.backgroundColor = [UIColor clearColor];
	[view addSubview:label];
	[label release];
	return view;
}

- (void)loadView {
	
	[super loadView];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rr_main_background.png"]];		
    
	UIView* emailInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
	UIView* passwordInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 280, 40)];
    UIView* loginView=[[UIView alloc]initWithFrame:CGRectMake(20, EMAIL_FIELD_TOP_EDGE, 280, 80)];

    //将登陆框边框设置为圆脚  by songzengbin at  2.24
	loginView.layer.cornerRadius = 8;
    loginView.layer.masksToBounds = YES;
    //给登陆框添加一个有色边框
    loginView.layer.borderWidth = 1;
    loginView.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
	
    //添加登陆框中间的那条线
    RNDrawLineView *line=[[ RNDrawLineView alloc]initWithFrame:CGRectMake(0, 40, 280, 80)];
    line.backgroundColor=[UIColor clearColor];//将背景设为透明
    emailInputView.backgroundColor = [UIColor whiteColor];;
	emailInputView.alpha = 1;
    
    //注册button
//    registButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    registButton.frame = CGRectMake(30, EMAIL_FIELD_TOP_EDGE + 100, 80, 30);
//    [registButton setTitle:@"注册" forState:UIControlStateNormal];
//    [registButton addTarget:self action:@selector(registButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	passwordInputView.backgroundColor = [UIColor whiteColor];;
	passwordInputView.alpha = 1;
	[loginView addSubview:emailInputView];
	[loginView addSubview:passwordInputView];
    [loginView addSubview:line];
    [self.view  addSubview:loginView];
//    [self.view addSubview:registButton];
	[emailInputView release];
	[passwordInputView release];
    [loginView release];

	
	// 取出最后一次登录用户名。　
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.lastUsername = [defaults objectForKey:@"loginUserName"];
    if(self.lastUsername )
        self.emailField = [RNLoginViewController textInputFieldForCellWithValue:self.lastUsername secure:NO];
    else
		self.emailField = [RNLoginViewController textInputFieldForCellWithValue:@"" secure:NO];
	emailField.placeholder = @"邮箱/手机号/用户名";
	emailField.delegate = self;
	emailField.keyboardType = UIKeyboardTypeEmailAddress;
	emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
	[emailInputView addSubview:[self containerCellWithTitle:@"帐号" view:emailField]];
	
	self.lastPassword = [defaults objectForKey:@"loginPassword"];
	self.passwordField = [RNLoginViewController textInputFieldForCellWithValue:self.lastPassword secure:YES];
	passwordField.delegate = self;
	passwordField.keyboardType = UIKeyboardTypeASCIICapable;
	passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
	[passwordInputView addSubview:[self containerCellWithTitle:@"密码" view:passwordField]];
	
	UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] 
									 initWithTitle:@"注册"
									 style:UIBarButtonItemStylePlain
									 target:self 
									 action:@selector(registerAction)];
	
	[[self navigationItem] setLeftBarButtonItem:logoutButton];
	[logoutButton release];
}

- (void)registerAction{
	[emailField endEditing:YES];
	[passwordField endEditing:YES];
    
}


- (void)handleCancelLogin:(id)sender {
	//	[self.model cancel];
	
	[self.activityIndicatorView removeFromSuperview];
	emailField.enabled = TRUE;
	passwordField.enabled = TRUE;
	self.navigationItem.leftBarButtonItem.enabled = TRUE;
	self.navigationItem.rightBarButtonItem = nil;
	
	[passwordField becomeFirstResponder];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// 在新版three20下会崩溃, 暂注掉
	[emailField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// 回收键盘。
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[self goAction];
    return YES;
}

+ (UITextField*)textInputFieldForCellWithValue:(NSString*)value secure:(BOOL)secure {
	
	UITextField *textField = [[[UITextField alloc] 
							   initWithFrame:CGRectMake(50,0, 210, 24)] autorelease];
	textField.text = value;
	textField.placeholder = @"";
	textField.secureTextEntry = secure;
	textField.keyboardType = UIKeyboardTypeASCIICapable;
	textField.returnKeyType = UIReturnKeyGo;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	//	textField.textColor = RGBCOLOR(0,0,0);
	//*/
	
	return textField;
	
}

- (UIView*)containerCellWithTitle:(NSString*)title view:(UIView*)view {
	UIView *cell = [[[UIView alloc] initWithFrame:CGRectMake(10, 10, 260, 50)] autorelease];
	UITextField* label = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
	label.text = title;
	label.enabled = NO;
	[cell addSubview:label];
	[label autorelease];
	
	[cell addSubview:view];
	
	return cell;
}

// 点击GO时执行。
- (void)goAction {	
	
	NSString* pwd = [passwordField text];
	NSString* u = [emailField text];
	
	if (u == nil || pwd == nil || [u length] <= 0 || [pwd length] <= 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:@"帐号/密码不能为空"
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	} else {
		emailField.enabled = FALSE;
		passwordField.enabled = FALSE;
		[emailField endEditing:YES];
		[passwordField endEditing:YES];
        registButton.enabled = NO;
		
		[emailField resignFirstResponder];
		[passwordField resignFirstResponder];
		
		[self.view addSubview:self.activityIndicatorView];
		[self.navigationItem.leftBarButtonItem setEnabled:NO];
		
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:u forKey:@"loginUserName"];
        [defaults setObject:pwd forKey:@"loginPassword"];
        
        NSMutableDictionary* dics = [NSMutableDictionary dictionary];
        [dics setObject:[passwordField.text md5] forKey:@"password"];
        [dics setObject:emailField.text forKey:@"user"];
		//        RNModel *model = [[RNModel alloc] initWithQuery:dics andMethod:@"client/login"];
		//        self.model = model;
		//        RL_RELEASE_SAFELY(model);
		[self sendQueryWithDic:dics andMethod:@"client/login"];//chenyi modify		
	}
	
	
	UIBarButtonItem *cancelLoginItem = [[UIBarButtonItem alloc] 
										initWithTitle:@"取消"
										style:UIBarButtonItemStylePlain
										target:self 
										action:@selector(handleCancelLogin:)];
	
	[[self navigationItem] setRightBarButtonItem:cancelLoginItem];
	[cancelLoginItem release];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self.view];
	if(touchPoint.y < PASSWORD_FIELD_TOP_EDGE && touchPoint.y > EMAIL_FIELD_TOP_EDGE) [emailField becomeFirstResponder];
	else if(touchPoint.y >PASSWORD_FIELD_TOP_EDGE && touchPoint.y < PASSWORD_FIELD_TOP_EDGE+40) [passwordField becomeFirstResponder];
	
}

- (void)handleMultiLogin {
	
}

- (void)registButtonPressed:(id)sender
{
//    RNRegistrationViewController *aRegistrationViewController = [[RNRegistrationViewController alloc] init];
//    [self.navigationController pushViewController:aRegistrationViewController animated:NO];
//    [aRegistrationViewController release];
}


@end

/**
 * 画出中间的线
 */
@implementation RNDrawLineView
-(void) drawRect:(CGRect)rect
{
    
    CGContextRef context=UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextStrokePath(context);
}
@end

