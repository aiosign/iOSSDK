//
//  GDSignTemplate.h
//  GDSignSDK
//
//  Created by ioszhb on 2020/9/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// 定义: 签署模板合同时, 印章/签字位置信息
@interface GDSignTemplate : NSObject

/// x 坐标  A4/A3当前页面绝对坐标值  必填
@property (nonatomic, assign) float x;

/// y 坐标  A4/A3当前页面绝对坐标值  必填
@property (nonatomic, assign) float y;

/// y 坐标  A4/A3当前页面绝对大小,  非必填
@property (nonatomic, assign) CGSize size;

/// 当签署类型是签字时,是否可以缩放,默认NO
@property (nonatomic, assign) BOOL enableScale;

/// 是否需要自定义Size,默认NO
@property (nonatomic, assign) BOOL needCustomSize;


/// 页码值 待签署页码  必填
@property (nonatomic, assign) int page;

/// 签名域高亮显示时签名域名称，选填，如填写则展示该名称，数组内唯一
@property (nonatomic, copy) NSString *name;

/// 印章id ***** 预留字段 暂时不填充，可考虑为在用户印章列表中直接获取印章填充
@property (nonatomic, copy) NSString *sealId;

@end

NS_ASSUME_NONNULL_END
