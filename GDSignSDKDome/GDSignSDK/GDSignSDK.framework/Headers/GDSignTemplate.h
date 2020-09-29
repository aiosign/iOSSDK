//
//  GDSignTemplate.h
//  GDSignSDK
//
//  Created by ioszhb on 2020/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 定义: 签署模板合同时, 印章/签字位置信息
@interface GDSignTemplate : NSObject

/// x 坐标  A4当前页面绝对坐标值  必填
@property (nonatomic, assign) float x;

/// y 坐标  A4当前页面绝对坐标值  必填
@property (nonatomic, assign) float y;

/// 页码值 待签署页码  必填
@property (nonatomic, assign) int page;

/// 签名域高亮显示时签名域名称，选填，如填写则展示该名称，数组内唯一
@property (nonatomic, copy) NSString *name;

/// 印章宽度  ***** 预留字段 暂时不填充，考虑为当前签名域固定宽度
@property (nonatomic, assign) float w;

/// 印章高度  ***** 预留字段 暂时不填充，考虑为当前签名域固定高度
@property (nonatomic, assign) float h;

/// 印章id ***** 预留字段 暂时不填充，可考虑为在用户印章列表中直接获取印章填充
@property (nonatomic, copy) NSString *sealId;

@end

NS_ASSUME_NONNULL_END
