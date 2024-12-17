//
//  CILogger.h
//  CIPlayerAssistor
//
//  Created by garenwang on 2024/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define CILog(frmt, ...) \
    [CILogger logger:(frmt), ##__VA_ARGS__]

@interface CILogger : NSObject

+(void)logger:(NSString *)format, ...;

+(void)setDebug:(BOOL)isDebug;

@end

NS_ASSUME_NONNULL_END
