//
//  TokenBuilder.h
//  iOSPlayerDemo
//
//  Created by garenwang on 2023/11/22.
//

#import <Foundation/Foundation.h>
#import "InputConfig.h"
#import <CIPlayerAssistor/CIOpenSSL.h>
NS_ASSUME_NONNULL_BEGIN

@interface TokenBuilder : NSObject
@property (nonatomic,strong)NSString * pubulicKey;
-(NSString *)buildToken;
-(instancetype)initWithType:(NSInteger)type withPublicKey:(NSString *)publickey;//0 标准加密 1 私有加密

+ (void)getToken:(NSString *)publickey fileURL:(NSString *)fileURL protectContentKey:(int)protect callBack:(void (^)(NSString * token ,NSString * signature))callBack;
@end

NS_ASSUME_NONNULL_END
