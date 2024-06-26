//
//  QCloudJWTToken.h
//  QCloudHLSPlugin
//
//  Created by garenwang on 2024/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QCloudHLSError) {
    QCloudHLSInvalidFormatError = -100,
    QCloudHLSUnsupportedAlgorithmError,
    QCloudHLSAlgorithmNameMismatchError,
    QCloudHLSInvalidSignatureError,
    QCloudHLSNoPayloadError,
    QCloudHLSNoHeaderError,
    QCloudHLSEncodingHeaderError,
    QCloudHLSEncodingPayloadError,
    QCloudHLSEncodingSigningError,
    QCloudHLSClaimsSetVerificationFailed,
    QCloudHLSInvalidSegmentSerializationError,
    QCloudHLSUnspecifiedAlgorithmError,
    QCloudHLSBlacklistedAlgorithmError,
    QCloudHLSDecodingHeaderError,
    QCloudHLSDecodingPayloadError,
};

@interface QCloudJWTToken : NSObject
+ (NSString *)encodePayload:(NSDictionary *)thePayload withSecret:(NSString *)theSecret withHeaders:(NSDictionary *)theHeaders;

+ (NSString *)encodePayload:(NSDictionary *)thePayload withSecret:(NSString *)theSecret withHeaders:(NSDictionary *)theHeaders withError:(NSError * __autoreleasing *)theError;
@end

NS_ASSUME_NONNULL_END
