//
//  GDSignManager.h
//  GMSignFramework
//
//  Created by ioszhb on 2020/9/4.
//  Copyright © 2020 ioszhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GDSignSDK/GDSignTemplate.h>

FOUNDATION_EXPORT NSString * _Nonnull const GDSignSDKErrorDomain;
FOUNDATION_EXPORT NSString * _Nonnull const GDSignSDKErrorKey;



NS_ASSUME_NONNULL_BEGIN

/// 处理错误回调,用于开发调试,提示toast信息
@protocol GDSignManagerDelegate;

@interface GDSignManager : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedManager;

/// 导航栏的背景颜色
@property (nonatomic, strong) UIColor *navigationBarColor;

/// 导航栏的文字颜色
@property (nonatomic, strong) UIColor *navigationBarTintColor;

/// 事件代理
@property (nonatomic, weak) id<GDSignManagerDelegate> delegate;


/// 注入参数
/// @param baseURL 请求域:示例:https://open.aiosign.com/api
/// @param userId 用户id
/// @param contractId 合同id
/// @param buildTokenBlock 构建token的闭包(构建token,一般是与服务器对接,将网络请求写在闭包中,且解析token,并用callback(token)回传)
/// @param buildSignBlock 构建sign的闭包(构建sign,一般是与服务器对接,将网络请求写在闭包中,且解析sign,并用callback(sign)回传)
- (void)registerBaseURL:(NSString *)baseURL userId:(NSString *)userId contractId:(NSString *)contractId buildToken:(void(^)(NSDictionary *params, int(^callback)(NSString *token)))buildTokenBlock buildSign:(void(^)(NSString *token, NSDictionary *params, int(^callback)(NSString *sign)))buildSignBlock;

/// 获取自由签署pdf的UINavigationController
/// @param backViewController 结果闭包,回传给一个UINavigationController对象,即可modal使用
- (void)freeSignViewController:(void(^)(UINavigationController *navigationController))backViewController;

/// 获取预览pdf的UINavigationController
/// @param backViewController 结果闭包,回传给一个UINavigationController对象,即可modal使用
- (void)previewPDFViewController:(void(^)(UINavigationController *navigationController))backViewController;

/// 获取模板签署pdf的UINavigationController
/// @param backViewController 结果闭包,回传给一个UINavigationController对象,即可modal使用
- (void)templateSignWithInfo:(NSArray<GDSignTemplate *> *)templateArray by:(void(^)(UINavigationController *navigationController))backViewController;


/// 获取人脸认证的UINavigationController
/// @param backViewController 结果闭包,回传给一个UIViewController对象,即可modal使用
- (void)faceViewController:(void(^)(UINavigationController *navigationController))backViewController;


/// 清空注入的参数
- (void)cleanRegister;

@end




@protocol GDSignManagerDelegate <NSObject>
@optional

/// 处理各种错误,用于开发调试,提示toast信息
/// @param error 网络错误或山东国盾服务端返回的错误对象
/// @param jsonObj 山东国盾服务端返回的错误信息,取值类型(nil, NSArray, NSDictionary)
- (void)handleError:(NSError *)error jsonObj:(id)jsonObj;


/// 处理签署回调结果
/// @param jsonObj pass返回的数据
/// @param error 错误信息
- (void)handleSignResult:(id)jsonObj error:(NSError *)error;


/// 处理拒绝签署回调结果
/// @param jsonObj pass返回的数据
/// @param error 错误信息
- (void)handleRefuseResult:(id)jsonObj error:(NSError *)error;


/// 处理签署回调结果
/// @param jsonObj sdk返回的数据 key: 1)user_name:用户姓名, 2)user_code:用户身份证号 3)user_icon:用户认证时最清晰图片 4)verify_result:认证结果
- (void)handleFaceVerifyResult:(NSDictionary *)jsonObj;


@end

NS_ASSUME_NONNULL_END
