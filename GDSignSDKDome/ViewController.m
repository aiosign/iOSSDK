//
//  ViewController.m
//  GDSignSDKDome
//
//  Created by ioszhb on 2020/9/29.
//

#import "ViewController.h"
#import "AFNetworking.h"

#import <GDSignSDK/GDSignManager.h>


@interface ViewController ()<GDSignManagerDelegate>

//----------------UI------------------

/// Action:注册
@property (nonatomic, strong) UIButton *redButton;
/// Action:渲染
@property (nonatomic, strong) UIButton *blueButton;
/// Action:人脸识别
@property (nonatomic, strong) UIButton *yellowButton;
/// Action:预览PDF
@property (nonatomic, strong) UIButton *grayButton;

/// tipLabel:用户Id
@property (nonatomic, strong) UILabel *userIdLabel;
/// tipLabel:合同Id
@property (nonatomic, strong) UILabel *fileIdLabel;
/// 用户Id输入框
@property (nonatomic, strong) UITextView *userIdTextView;
/// 合同Id输入框
@property (nonatomic, strong) UITextView *fileIdTextView;

/// 模板x
@property (nonatomic, strong) UITextField *xFiled;
/// 模板y
@property (nonatomic, strong) UITextField *yFiled;
/// 页码
@property (nonatomic, strong) UITextField *pageFiled;

@property (nonatomic, strong) UIButton *addLocationButton;

@property (nonatomic, strong) UIButton *cleanLocationButton;

/// showTemplateLabel
@property (nonatomic, strong) UILabel *showLocationLabel;

//-----------------other-----------------

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableArray<GDSignTemplate *> *templateArray;

@end

@implementation ViewController

- (void)handleError:(NSError *)error jsonObj:(id)jsonObj {
    NSLog(@"🔥🔥%@🔥🔥%@🔥🔥", error, jsonObj);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _templateArray = [NSMutableArray array];
    [self setup];
}

- (void)setup {
    CGFloat totalWidth = UIScreen.mainScreen.bounds.size.width;
    
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.redButton];
    [self.view addSubview:self.blueButton];
    [self.view addSubview:self.yellowButton];
    [self.view addSubview:self.grayButton];
    CGFloat labelW = 50, textFieldW = self.view.frame.size.width - 5 - labelW - 5 - 5, height = 40;
    self.userIdLabel.frame = CGRectMake(5, 140, labelW, height);
    self.fileIdLabel.frame = CGRectMake(5, 200, labelW, height);
    self.userIdTextView.frame = CGRectMake(5+labelW+5, 140, textFieldW, height);
    self.fileIdTextView.frame = CGRectMake(5+labelW+5, 200, textFieldW, height);
    [self.view addSubview:self.userIdLabel];
    [self.view addSubview:self.fileIdLabel];
    [self.view addSubview:self.userIdTextView];
    [self.view addSubview:self.fileIdTextView];
    
    
    [self.view addSubview:self.xFiled];
    [self.view addSubview:self.yFiled];
    [self.view addSubview:self.pageFiled];
    [self.view addSubview:self.addLocationButton];
    [self.view addSubview:self.cleanLocationButton];
    [self.view addSubview:self.showLocationLabel];
    
    CGFloat filedWidth = ceil((totalWidth - 20) / 3 * 100) * 0.01;
    self.xFiled.frame = CGRectMake(5, CGRectGetMaxY(self.fileIdTextView.frame)+10, filedWidth, 40);
    self.yFiled.frame = CGRectMake(CGRectGetMaxX(self.xFiled.frame)+5, CGRectGetMaxY(self.fileIdTextView.frame)+10, filedWidth, 40);
    self.pageFiled.frame = CGRectMake(CGRectGetMaxX(self.yFiled.frame)+5, CGRectGetMaxY(self.fileIdTextView.frame)+10, filedWidth, 40);
    
    CGFloat locationButtonWidth = ceil((totalWidth - 30) / 2 * 100) * 0.01;
    self.addLocationButton.frame = CGRectMake(10, CGRectGetMaxY(self.xFiled.frame)+10, locationButtonWidth, 40);
    self.cleanLocationButton.frame = CGRectMake(CGRectGetMaxX(self.addLocationButton.frame)+10, CGRectGetMaxY(self.xFiled.frame)+10, locationButtonWidth, 40);

    self.showLocationLabel.frame = CGRectMake(10, CGRectGetMaxY(self.addLocationButton.frame)+10, totalWidth-20, 200);
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.view addGestureRecognizer:tapGesture];
}

/// 注入获取userId,contractId, Token,sign
- (void)_registerInformation {
    [self _resignKeyboard];
    GDSignManager.sharedManager.delegate = self;
    __weak typeof(self)weakSelf = self;
//        NSString *userId = @"00748594463106551808";
//        NSString *fileId = @"c8d932ef4531511af7442a5092f73c71";
    NSString *userId = @"00748594463106551808";
    NSString *fileId = @"66225fa387ab91ae4c1ebe89a56d1ee0";
//    NSString *userId = self.userIdTextView.text;
//    NSString *fileId = self.fileIdTextView.text;
        
    //1.获取单例对象,并注入参数,监听内部事件回调及定位错误
    GDSignManager.sharedManager.delegate = self;
//    NSString *baseURL = @"http://119.163.197.219:8000/api";
//    NSString *tokenURL = @"http://192.168.1.201:9997/getToken";
//    NSString *signURL = @"http://192.168.1.201:9997/getSign";
    NSString *baseURL = @"https://open.aiosign.com/api";
    NSString *tokenURL = @"https://open.aiosign.com/open-demo/app-client/getToken";
    NSString *signURL = @"https://open.aiosign.com/open-demo/app-client/getSign";
    
    [GDSignManager.sharedManager registerBaseURL:baseURL userId:userId contractId:fileId buildToken:^(NSDictionary * _Nonnull params, int (^ _Nonnull callback)(NSString * _Nonnull)) {
        
        [weakSelf.sessionManager POST:tokenURL parameters:params headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //模拟:三方解析自己的业务数据
            if (responseObject==nil || ![responseObject isKindOfClass:NSDictionary.class]) { NSLog(@"🍵_responseObject为空"); return; }
            NSDictionary *data = responseObject[@"data"];
            NSString *token = data[@"access_token"];
            NSLog(@"1.👌获取token成功\n%@\n👌", token);
            callback(token);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf _showAlertWithTitle:@"获取token失败" message:error.localizedDescription];
        }];
        
    } buildSign:^(NSString * _Nonnull token, NSDictionary * _Nonnull params, int (^ _Nonnull callback)(NSString * _Nonnull)) {
        
        [weakSelf.sessionManager POST:signURL parameters:params headers:@{@"Authentication": token} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //模拟:三方解析自己的业务数据
            if (responseObject==nil || ![responseObject isKindOfClass:NSDictionary.class]) { NSLog(@"🍵_responseObject为空"); return; }
            NSDictionary *data = responseObject[@"data"];
            NSString *sign = data[@"sign"];
            NSLog(@"2.👌获取sign成功\n%@\n👌", sign);
            callback(sign);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf _showAlertWithTitle:@"获取sign失败" message:error.localizedDescription];
        }];
    }];
}

#pragma mark - *************************************************************************
#pragma mark Action: UIButton

/// Action: 预览
- (void)didClickedRedButton:(UIButton *)sender {
    [self _registerInformation];
    __weak typeof(self) weakSelf = self;
    [GDSignManager.sharedManager previewPDFViewController:^(UINavigationController * _Nonnull navigationController) {
        if (weakSelf.presentedViewController) return;
        [weakSelf presentViewController:navigationController animated:YES completion:nil];
    }];
}

/// Action:自由签署
- (void)didClickedBlueButton:(UIButton *)sender {
    [self _registerInformation];
    __weak typeof(self) weakSelf = self;
    [GDSignManager.sharedManager freeSignViewController:^(UINavigationController * _Nonnull navigationController) {
        if (weakSelf.presentedViewController) return;
        navigationController.topViewController.title = @"你好你好";
        [weakSelf presentViewController:navigationController animated:YES completion:nil];
    }];
}

/// Action: 模板签署
- (void)didClickedYellowButton:(UIButton *)sender {
    [self _registerInformation];
    
    __weak typeof(self) weakSelf = self;
    [GDSignManager.sharedManager templateSignWithInfo:self.templateArray by:^(UINavigationController * _Nonnull navigationController) {
        if (weakSelf.presentedViewController) return;
        navigationController.topViewController.title = @"你好你好";
        [weakSelf presentViewController:navigationController animated:YES completion:nil];
    }];
}

/// Action:人脸认证
- (void)didClickedGrayButton:(UIButton *)sender {
    [self _registerInformation];
    __weak typeof(self) weakSelf = self;
    [GDSignManager.sharedManager faceAuthenWithName:@"姓名" cardId:@"身份证号" edit:YES by:^(UINavigationController * _Nonnull navigationController) {
        if (weakSelf.presentedViewController) return;
        [weakSelf presentViewController:navigationController animated:YES completion:nil];
    }];
}


/// Action:添加坐标
- (void)didClickAddLocationButton:(UIButton *)sender {
    NSString *xStr = self.xFiled.text;
    NSString *yStr = self.yFiled.text;
    NSString *pageStr = self.pageFiled.text;
    if (xStr == nil || yStr == nil || pageStr == nil) return;
    if (xStr.length<1 || yStr.length<1 || pageStr.length<1) return;
    
    CGFloat x = [xStr floatValue];
    CGFloat y = [yStr floatValue];
    int page = [pageStr intValue];
    
    GDSignTemplate *template = [[GDSignTemplate alloc] init];
    template.x = x; template.y = y; template.page = page;
    
    NSString *appendString = [NSString stringWithFormat:@"第%zd个:x:%.2lf, y:%.2lf, page:%d\n", self.templateArray.count+1, x, y, page];
    NSString *showString = [NSString stringWithFormat:@"%@%@",self.showLocationLabel.text?:@"", appendString];
    [self.templateArray addObject:template];
    self.showLocationLabel.text = showString;
    
    self.xFiled.text = nil;
    self.yFiled.text = nil;
    self.pageFiled.text = nil;
}

/// Action: 清除坐标
- (void)didClickCleanLocationButton:(UIButton *)sender {
    self.showLocationLabel.text = nil;
    [self.templateArray removeAllObjects];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    [self _resignKeyboard];
}

#pragma mark - *************************************************************************
#pragma mark private


- (void)_resignKeyboard {
    if ([self.userIdTextView isFirstResponder]) {
        [self.userIdTextView resignFirstResponder];
    }
    if ([self.fileIdTextView isFirstResponder]) {
        [self.fileIdTextView resignFirstResponder];
    }
    [self.view resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)_showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self _resignKeyboard];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"我知道了" style:1 handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}


#pragma mark - *************************************************************************
#pragma mark UI/Other: Getter

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = 30.f;
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json", @"text/json", @"application/text", @"text/javascript",@"text/plain",@"image/jpeg", nil];
    }
    return _sessionManager;
}

- (UIButton *)redButton {
    if (_redButton == nil) {
        _redButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _redButton.backgroundColor = UIColor.redColor;
        _redButton.frame = CGRectMake(10, 100, 60, 30);
        [_redButton setTitle:@"预览" forState:UIControlStateNormal];
        [_redButton addTarget:self action:@selector(didClickedRedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redButton;
}

- (UIButton *)blueButton {
    if (_blueButton == nil) {
        _blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _blueButton.backgroundColor = UIColor.blueColor;
        _blueButton.frame = CGRectMake(90, 100, 60, 30);
        [_blueButton setTitle:@"签署" forState:UIControlStateNormal];
        [_blueButton addTarget:self action:@selector(didClickedBlueButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _blueButton;
}

- (UIButton *)yellowButton {
    if (_yellowButton == nil) {
        _yellowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _yellowButton.backgroundColor = UIColor.yellowColor;
        _yellowButton.frame = CGRectMake(170, 100, 60, 30);
        [_yellowButton setTitle:@"模版" forState:UIControlStateNormal];
        [_yellowButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [_yellowButton addTarget:self action:@selector(didClickedYellowButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yellowButton;
}

- (UIButton *)grayButton {
    if (_grayButton == nil) {
        _grayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _grayButton.backgroundColor = UIColor.grayColor;
        _grayButton.frame = CGRectMake(250, 100, 60, 30);
        [_grayButton setTitle:@"人脸" forState:UIControlStateNormal];
        [_grayButton addTarget:self action:@selector(didClickedGrayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _grayButton;
}


- (UILabel *)userIdLabel {
    if (_userIdLabel == nil) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.textAlignment = NSTextAlignmentLeft;
        _userIdLabel.font = [UIFont systemFontOfSize:16];
        _userIdLabel.textColor = UIColor.redColor;
        _userIdLabel.text = @"用户Id";
    }
    return _userIdLabel;
}

- (UILabel *)fileIdLabel {
    if (_fileIdLabel == nil) {
        _fileIdLabel = [[UILabel alloc] init];
        _fileIdLabel.textAlignment = NSTextAlignmentLeft;
        _fileIdLabel.font = [UIFont systemFontOfSize:16];
        _fileIdLabel.textColor = UIColor.redColor;
        _fileIdLabel.text = @"合同Id";
    }
    return _fileIdLabel;
}

- (UITextView *)userIdTextView {
    if (_userIdTextView == nil) {
        _userIdTextView = [self _buildTextViewWithTitle:@"10728297460485214208"];
    }
    return _userIdTextView;
}

- (UITextView *)fileIdTextView {
    if (_fileIdTextView == nil) {
        _fileIdTextView = [self _buildTextViewWithTitle:@"b33aa32428cfcb9b8c2954332ecd98ad"];
    }
    return _fileIdTextView;
}

- (UITextField *)xFiled {
    if (!_xFiled) {
        _xFiled = [self _buildTextFieldWithTipMsg:@"X坐标"];
    }
    return _xFiled;
}

- (UITextField *)yFiled {
    if (!_yFiled) {
        _yFiled = [self _buildTextFieldWithTipMsg:@"Y坐标"];
    }
    return _yFiled;
}

- (UITextField *)pageFiled {
    if (!_pageFiled) {
        _pageFiled = [self _buildTextFieldWithTipMsg:@"页码"];
    }
    return _pageFiled;
}

- (UILabel *)showLocationLabel {
    if (!_showLocationLabel) {
        _showLocationLabel = [[UILabel alloc] init];
        _showLocationLabel.numberOfLines = 0;
        _showLocationLabel.textColor = UIColor.redColor;
        _showLocationLabel.backgroundColor = [UIColor colorWithRed:(245.0/255.0) green:(245.0/255.0) blue:(245.0/255.0) alpha:1];
        _showLocationLabel.layer.borderColor = [UIColor.grayColor CGColor];
        _showLocationLabel.layer.borderWidth = 1;
    }
    return _showLocationLabel;
}

- (UIButton *)addLocationButton {
    if (!_addLocationButton) {
        _addLocationButton = [[UIButton alloc] init];
        _addLocationButton.backgroundColor = UIColor.yellowColor;
        [_addLocationButton setTitle:@"添加坐标" forState:UIControlStateNormal];
        [_addLocationButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [_addLocationButton addTarget:self action:@selector(didClickAddLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addLocationButton;
}

- (UIButton *)cleanLocationButton {
    if (!_cleanLocationButton) {
        _cleanLocationButton = [[UIButton alloc] init];
        _cleanLocationButton.backgroundColor = UIColor.yellowColor;
        [_cleanLocationButton setTitle:@"清除坐标" forState:UIControlStateNormal];
        [_cleanLocationButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [_cleanLocationButton addTarget:self action:@selector(didClickCleanLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanLocationButton;
}



- (UITextView *)_buildTextViewWithTitle:(NSString *)title {
    UITextView *textView = [[UITextView alloc] init];
    textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    textView.layer.borderColor = [UIColor.redColor CGColor];
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 6;
    textView.text =  title;
    textView.font = [UIFont systemFontOfSize:10];
    return textView;
}

- (UITextField *)_buildTextFieldWithTipMsg:(NSString *)tipMsg {
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.borderStyle = UITextBorderStyleRoundedRect;
    textFiled.placeholder = tipMsg;
    textFiled.font = [UIFont systemFontOfSize:14];
    textFiled.keyboardType = UIKeyboardTypeDecimalPad;
    return textFiled;
}

@end
