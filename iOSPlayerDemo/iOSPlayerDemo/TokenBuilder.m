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

-(instancetype)initWithType:(NSInteger)type{
    if(self = [super init]){
        _type = type;
    }
    return self;
}

- (NSString *)privateKey{
    return
    @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANNtnpw0f0+B0XrRpAq94vPcVNqXLMdDBunrTXLvtLOYYdfcXk2hVRlt0rtQx2gIsrgUHOJN7BgP0Na8AStdmj0EW4j3psCinzB+XVWRnLIdNzOfE0kUZJB38HvT8TEyAwGkTCQAB3JSoiMh1UaHUVAr/hpzBLf1hfBtL4iUew9JAgMBAAECgYA1tGeQmAkqofga8XtwuxEWDoaDS9k0+EKeUoXGxzqoT/GyiihuIafjILFhoUA1ndf/yCQaG973sbTDhtfpMwqFNQq13+JAownslTjWgr7Hwf7qplYW92R7CU0v7wFfjqm1t/2FKU9JkHfaHfb7qqESMIbO/VMjER9o4tEx58uXDQJBAO0O4lnWDVjr1gN02cqvxPOtTY6DgFbQDeaAZF8obb6XqvCqGW/AVms3Bh8nVlUwdQ2K/xte8tHxjW9FtBQTLd8CQQDkUncO35gAqUF9Bhsdzrs7nO1J3VjLrM0ITrepqjqtVEvdXZc+1/UrkWVaIigWAXjQCVfmQzScdbznhYXPz5fXAkEAgB3KMRkhL4yNpmKRjhw+ih+ASeRCCSj6Sjfbhx4XaakYZmbXxnChg+JB+bZNz06YBFC5nLZM7y/n61o1f5/56wJBALw+ZVzE6ly5L34114uG04W9x0HcFgau7MiJphFjgUdAtd/H9xfgE4odMRPUD3q9Me9LlMYK6MiKpfm4c2+3dzcCQQC8y37NPgpNEkd9smMwPpSEjPW41aMlfcKvP4Da3z7G5bGlmuICrva9YDAiaAyDGGCK8LxC8K6HpKrFgYrXkRtt";
}

- (NSString *)pubulicKey{
    return @"-----BEGIN PUBLIC KEY-----\n"
"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTbZ6cNH9PgdF60aQKveLz3FTalyzHQwbp601y77SzmGHX3F5NoVUZbdK7UMdoCLK4FBziTewYD9DWvAErXZo9BFuI96bAop8wfl1VkZyyHTcznxNJFGSQd/B70/ExMgMBpEwkAAdyUqIjIdVGh1FQK/4acwS39YXwbS+IlHsPSQIDAQAB\n"
"-----END PUBLIC KEY-----";
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
    timestamp = 1704287736;
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
