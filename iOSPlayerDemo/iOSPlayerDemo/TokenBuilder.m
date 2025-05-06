//
//  TokenBuilder.m
//  iOSPlayerDemo
//
//  Created by garenwang on 2023/11/22.
//

#import "TokenBuilder.h"
#import <AVFoundation/AVFoundation.h>
#import <Security/Security.h>

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

+ (void)getToken:(NSString *)publickey fileURL:(NSString *)fileURL protectContentKey:(int)protect callBack:(void (^)(NSString * url))callBack{
    if (!publickey) {
        return;
    }
    NSMutableURLRequest * mrequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://carsonxu.com/cos/samples/hls/getPlayUrl"]];
    mrequest.HTTPMethod = @"POST";
    [mrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *data = [publickey dataUsingEncoding:NSUTF8StringEncoding];
    publickey = [data base64EncodedStringWithOptions:0];
    NSString * objectKey = [NSURL URLWithString:fileURL].path;
    if ([objectKey hasPrefix:@"/"]) {
        objectKey = [objectKey substringFromIndex:1];
    }
    NSDictionary * body = @{
        @"objectKey":objectKey,
        @"publicKey":publickey,
        @"protectContentKey":@(protect)
    };

    mrequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingFragmentsAllowed error:nil];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:mrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            callBack(nil);
        }else{
            NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            callBack(result[@"playUrl"]);
        }
    }]resume];
}
@end
