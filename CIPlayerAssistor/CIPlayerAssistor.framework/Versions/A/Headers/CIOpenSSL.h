//
//  CIOpenSSL.h
//  CIPlugin
//
//  Created by garenwang on 2024/1/3.
//

#import <Foundation/Foundation.h>
#import <openssl/rsa.h>
#import <openssl/pem.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIOpenSSLRSA : NSObject

@property (nonatomic,strong)NSString * privateKey;

@property (nonatomic,strong)NSString * publicKey;

@end

@interface CIOpenSSL : NSObject

+(CIOpenSSLRSA *)generateRsa;

+ (NSData *)openssl_decryptWithPrivateStr:(NSString *)privateStr cipherData:(NSData *)cipherData padding:(int)padding;
@end

NS_ASSUME_NONNULL_END
