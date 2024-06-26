//
//  InputConfig.h
//  iOSPlayerDemo
//
//  Created by garenwang on 2023/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputConfig : NSObject
+ (NSString *)bucketId;
+ (NSString *)object;
+ (NSString *)fileUrl;
+ (NSString *)appId;
+ (NSString *)playSkey;
@end

NS_ASSUME_NONNULL_END
