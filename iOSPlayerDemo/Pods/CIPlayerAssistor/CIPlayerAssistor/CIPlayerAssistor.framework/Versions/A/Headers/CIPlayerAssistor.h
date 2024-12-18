//
//  CIPlayerAssistor.h
//  CIPlayerAssistor
//
//  Created by garenwang on 2024/1/3.
//


#import "CIMediaConfig.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^CIPlayerAssistorCallBack)(NSString * _Nullable  url,NSError * _Nullable error);

@interface CIPlayerAssistor : NSObject


+(instancetype)singleAssistor;

-(void)setDebug:(BOOL)isDebug;

/// 指定端口
+(instancetype)singleAssistorWithPort:(NSInteger)port;

/// 获取token，适用于共有读文件
/// - Parameters:
///   - config: 媒体配置
///   - token: token
///   - callBack: 返回构建结果
-(void)buildPlayerUrlWithConfig:(CIMediaConfig *)config
                      withToken:(NSString *)token
               buildUrlcallBack:(CIPlayerAssistorCallBack)callBack;

/// 获取token 以及鉴权签名 signature
/// - Parameters:
///   - config:  媒体配置
///   - token: token
///   - signature: 鉴权签名 signature
///   - callBack: 返回构建结果
-(void)buildPlayerUrlWithConfig:(CIMediaConfig *)config
                      withToken:(NSString *)token
                  withSignature:(NSString *)signature
               buildUrlcallBack:(CIPlayerAssistorCallBack)callBack;
@end

NS_ASSUME_NONNULL_END
