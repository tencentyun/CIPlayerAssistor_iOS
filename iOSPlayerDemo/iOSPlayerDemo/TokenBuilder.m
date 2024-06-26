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

+ (void)getToken:(NSString *)publickey fileURL:(NSString *)fileURL protectContentKey:(int)protect callBack:(void (^)(NSString * token ,NSString * signature))callBack{
    if (!publickey) {
        return;
    }
    NSMutableURLRequest * mrequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://cos.cloud.tencent.com/samples/hls/token"]];
    mrequest.HTTPMethod = @"POST";
    [mrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *data = [publickey dataUsingEncoding:NSUTF8StringEncoding];
    publickey = [data base64EncodedStringWithOptions:0];
    NSDictionary * body = @{
        @"src":fileURL,
        @"publicKey":publickey,
        @"protectContentKey":@(protect)
    };

    mrequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingFragmentsAllowed error:nil];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:mrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        callBack(result[@"token"],result[@"authorization"]);
    }]resume];
}
@end
