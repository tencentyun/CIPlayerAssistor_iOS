//
//  CIMediaConfig.h
//  CIMediaConfig
//
//  Created by garenwang on 2023/11/23.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CIM3u8TypeStandard,
    CIM3u8TypePrivate,
} CIM3u8Type;

@interface CIMediaConfig : NSObject

@property (nonatomic,strong)NSString * privateKey;
@property (nonatomic,strong)NSString * publicKey;
@property (nonatomic,strong,readonly)NSString * fileUrl;
@property (nonatomic,assign,readonly)CIM3u8Type type;
/// 过期时间 默认7200
@property (nonatomic,assign)NSInteger expires;

-(instancetype)initWithFileUrl:(NSString *)fileUrl;

-(instancetype)initWithFileUrl:(NSString *)fileUrl
                      m3u8Type:(CIM3u8Type)type;

-(instancetype)initWithFileUrl:(NSString *)fileUrl
                    privateKey:(NSString *)privateKey;
@end

NS_ASSUME_NONNULL_END
