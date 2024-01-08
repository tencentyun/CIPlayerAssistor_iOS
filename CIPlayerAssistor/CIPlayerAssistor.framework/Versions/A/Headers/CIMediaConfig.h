//
//  CIMediaConfig.h
//  CIMediaConfig
//
//  Created by garenwang on 2023/11/22.
//

#import <Foundation/Foundation.h>
#import "CIMediaInfo.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CIM3u8TypeStandard,
    CIM3u8TypePrivate,
} CIM3u8Type;

@interface CIMediaConfig : NSObject

@property (nonatomic,strong,readonly)NSString * publicKey;
@property (nonatomic,strong,readonly)CIMediaInfo * mediaInfo;
@property (nonatomic,assign,readonly)CIM3u8Type type;

/// 过期时间 默认7200
@property (nonatomic,assign)NSInteger expires;

-(instancetype)initWithMediaInfo:(CIMediaInfo *)mediaInfo
                        m3u8Type:(CIM3u8Type) type;

@end

NS_ASSUME_NONNULL_END
