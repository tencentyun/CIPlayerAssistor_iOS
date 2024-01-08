//
//  CIPlayerAssistor.h
//  CIPlayerAssistor
//
//  Created by garenwang on 2024/1/3.
//


#import "CIMediaConfig.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^CIPlayerAssistorCallBack)(NSString * _Nullable  url,NSError * _Nullable error);

typedef void (^CIPlayerAssistorGetTokenCallBack)(NSString * _Nullable  token);

typedef void (^CIPlayerAssistorGetToken)(CIMediaConfig * _Nullable  config,CIPlayerAssistorGetTokenCallBack callBack);

@interface CIPlayerAssistor : NSObject

+(instancetype)singleAssistor;

-(void)setPort:(NSInteger)port;

-(void)buildPlayerUrlWithConfig:(CIMediaConfig *)config
                  getTokenBlock:(CIPlayerAssistorGetToken)getTokenBlock
               buildUrlcallBack:(CIPlayerAssistorCallBack)callBack;
@end

NS_ASSUME_NONNULL_END
