# GDSignSDK使用说明

[![CI Status](https://img.shields.io/travis/developzhb/XYActionSheet.svg?style=flat)](https://travis-ci.org/developzhb/XYActionSheet)

#### 一. 如何开始?

1. 现在demo示例,讲GDSignSDK.frame拖入项目
2. 项目配置
   1. target > General > Framework,libraries,andEmbedded Content 添加GDSignSDK.framework,且Embed设置为Embed & Sign
   2. target > BuildPhases > LinkBinaryWithLibraries中添加GDSignSDK.framework,且Status设置为Required
   3. target>BuildPhases>EmbedFrameworks 中添加GDSignSDK.framework
   4. 活体认证需要用户允许访问相机/麦克风权限

#### 二. 如何使用?

1. 引入头文件 #import <GDSignSDK/GDSignManager.h>
2. 注入参数(见下示例)
3. 获取展示对应功能的UINavigationController(见下示例)

#### 三. 如何调试,定位错误?

1. 设置GDSignManager.sharedManager.delegate
2. 实现-handleError: jsonObj:

#### 四. 注意事项,功能介绍

1. 获取单例对象(GDSignManager.sharedManager)
2. 必须先注入参数(registerBaseURL:userId:contractId:buildToken:buildSign:),且参数不能为nil
3. 获取对应功能的UINavigationController
   1. freeSignViewController: 用户选择印章/签字后,可自定义位置.
   2. previewPDFViewController:浏览pdf文件
   3. templateSignWitInfo:by: 给定签名域签署
      1. 签名域的定义通过GDSignTemplate来定义,只有x,y,page作为参照,其他属性均被忽略. 
      2. templateArray不能为空 
      3. templateArray中的数据超出范围被视为error(可handleError:jsonObj:观察)
      4. GDSignTemplate: page:{1, 文档总页数}, x{0, 所在页最大宽度}), y{0, 所在页最大高度})
4. 返回的UINavigationController采用modal的方式弹出
5. 统一配置UINavigationBar的背景色, 文字值
6. 可获取topViewController设置标题.

#### 五. 使用示例

```objc
//以下简称:
//使用sdk者: 服务使用方.   sdk开发者: 服务提供方

//1.服务使用方:引入头文件
#import <GDSignSDK/GDSignManager.h>

//2.模拟 服务使用方: 预览流程
- (void)didClickPreviewButton:(UIButton *)sender 
{ 
  //一,使用单例对象注入参数,当前ViewController(self)成为代理
	GDSignManager.sharedManager.delegate = self;
  
  //二,注入参数
  //baseURL:服务提供方的开放平台域名
  //userId: 服务使用方的用户id
  //contractId: 服务使用方的合同id
  //buildToken: 获取token的回调,需服务使用方写实现,token获取方式一般为:服务使用方找自家后台开发接口生成token,请求参数params 
  //buildSign: 获取Sign的回调,需服务使用方写实现,sign获取方式一般为:服务使用方找自家后台开发接口生成sign,请求参数params, token(参数/请求头) 
  [GDSignManager.sharedManager registerBaseURL:@"http://119.163.197.219:8000/api" userId:userId contractId:contractId buildToken:^(NSDictionary * _Nonnull params, int (^ _Nonnull callback)(NSString * _Nonnull)) {
        
    		//模拟:服务使用方获取token的实现.
        [weakSelf.sessionManager POST:@"http://192.168.1.201:9997/getToken" parameters:params headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (responseObject==nil || ![responseObject isKindOfClass:NSDictionary.class]) { NSLog(@"🍵_responseObject为空"); return; }
            NSDictionary *data = responseObject[@"data"];
            NSString *token = data[@"access_token"];
            NSLog(@"1.👌获取token成功\n%@\n👌", token);
						//必须回传sign
            callback(token);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf _showAlertWithTitle:@"获取token失败" message:error.localizedDescription];
        }];
        
    } buildSign:^(NSString * _Nonnull token, NSDictionary * _Nonnull params, int (^ _Nonnull callback)(NSString * _Nonnull)) {
    
				//模拟:服务使用方获取sign的实现.
        [weakSelf.sessionManager POST:@"http://192.168.1.201:9997/getSign" parameters:params headers:@{@"Authentication": token} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (responseObject==nil || ![responseObject isKindOfClass:NSDictionary.class]) { NSLog(@"🍵_responseObject为空"); return; }
            NSDictionary *data = responseObject[@"data"];
            NSString *sign = data[@"sign"];
            NSLog(@"2.👌获取sign成功\n%@\n👌", sign);
            //必须回传sign
            callback(sign);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf _showAlertWithTitle:@"获取sign失败" message:error.localizedDescription];
        }];
    }];
  
  //三,获取对应签署界面
    [GDSignManager.sharedManager previewPDFViewController:^(UINavigationController * _Nonnull navigationController) {
        if (weakSelf.presentedViewController) return;
        [weakSelf presentViewController:navigationController animated:YES completion:nil];
    }];
}
```





