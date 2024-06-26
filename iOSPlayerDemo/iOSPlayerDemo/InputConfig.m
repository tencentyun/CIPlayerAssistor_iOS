//
//  InputConfig.m
//  iOSPlayerDemo
//
//  Created by garenwang on 2023/11/23.
//

#import "InputConfig.h"

@implementation InputConfig
+ (NSString *)bucketId{
    return @"ci-h5-bj-1258125638";
}
+ (NSString *)object{
    return @"hls/BigBuckBunny.m3u8";
}
+ (NSString *)fileUrl{
    return   @"https://ci-h5-bj-1258125638.cos.ap-beijing.myqcloud.com/hls/BigBuckBunny.m3u8?ci-process=pm3u8";
}

+ (NSString *)playSkey{
    return @"playkey";
}

+ (NSString *)appId{
    return @"1258125638";
}


@end
