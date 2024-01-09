//
//  TokenBuilder.m
//  iOSPlayerDemo
//
//  Created by garenwang on 2023/11/22.
//

#import "TokenBuilder.h"
#import <AVFoundation/AVFoundation.h>
#import <Security/Security.h>
#import "QCloudJWTToken.h"

@interface TokenBuilder (){
    NSInteger timestamp;
    NSInteger _type;
}

@end

@implementation TokenBuilder

-(instancetype)initWithType:(NSInteger)type withPublicKey:(NSString *)publickey{
    if(self = [super init]){
        _type = type;
        self.pubulicKey = publickey;
    }
    return self;
}

- (NSString *)base64Str:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

-(NSDictionary *)Header{
    return @{
        @"typ": @"JWT",
        @"alg": @"HS256"
    };
}



-(NSDictionary *)Payload{
    if(!timestamp){
        timestamp = [[NSDate date] timeIntervalSince1970];
    }

    NSMutableDictionary *payload=@{
        @"Type": @"CosCiToken",
        @"AppId": InputConfig.appId,
        @"BucketId": InputConfig.bucketId,
        @"Object": InputConfig.object,
        @"Issuer": @"client",
        @"IssuedTimeStamp": @(timestamp),
        @"ExpireTimeStamp": @(timestamp + 7200),
        @"UsageLimit": @100,
    }.mutableCopy;
   
    if(_type == 1){
        [payload addEntriesFromDictionary:@{
                    @"ProtectSchema": @"rsa1024",
                    @"ProtectContentKey": @1,
                    @"PublicKey":[self base64Str:self.pubulicKey]?:@""
        }];
    }
    return payload.copy;
}

-(NSString *)buildToken{
    return [QCloudJWTToken encodePayload:[self Payload] withSecret:InputConfig.playSkey withHeaders:[self Header]];
}
@end
