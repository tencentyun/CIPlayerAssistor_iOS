//
//  CIMediaInfo.h
//  CIPlugin
//
//  Created by garenwang on 2024/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMediaInfo : NSObject
@property (nonatomic,strong,readonly)NSString * appId;
@property (nonatomic,strong,readonly)NSString * fileUrl;
@property (nonatomic,strong,readonly)NSString * bucketId;
@property (nonatomic,strong,readonly)NSString * object;

-(instancetype)initWithObject:(NSString *)object bucket:(NSString *)bucketId fileUrl:(NSString *)fileUrl;
@end

NS_ASSUME_NONNULL_END
