//
//  QCloudJWTToken.m
//  QCloudHLSPlugin
//
//  Created by garenwang on 2024/1/3.
//

#import "QCloudJWTToken.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonHMAC.h>

static NSString *QCloudHLSErrorDomain = @"com.tencent.jwt";
@implementation QCloudJWTToken
+ (NSString *)encodePayload:(NSDictionary *)thePayload withSecret:(NSString *)theSecret withHeaders:(NSDictionary *)theHeaders{
    
    NSError *error = nil;
    NSString *encodedString = [self encodePayload:thePayload withSecret:theSecret withHeaders:theHeaders withError:&error];
    return encodedString;
}

+ (NSString *)encodePayload:(NSDictionary *)thePayload withSecret:(NSString *)theSecret withHeaders:(NSDictionary *)theHeaders withError:(NSError * __autoreleasing *)theError;
{
    
    NSDictionary *header = @{@"typ": @"JWT", @"alg":@"HS256"};
    NSMutableDictionary *allHeaders = [header mutableCopy];
    
    if (theHeaders.allKeys.count) {
        [allHeaders addEntriesFromDictionary:theHeaders];
    }
    
    NSString *headerSegment = [self encodeSegment:[allHeaders copy] withError:theError];
    
    if (!headerSegment) {
        // encode header segment error
        *theError = [self errorWithCode:QCloudHLSEncodingHeaderError];
        return nil;
    }
    
    NSString *payloadSegment = [self encodeSegment:thePayload withError:theError];
    
    if (!payloadSegment) {
        // encode payment segment error
        *theError = [self errorWithCode:QCloudHLSEncodingPayloadError];
        return nil;
    }
    
    NSString *signingInput = [@[headerSegment, payloadSegment] componentsJoinedByString:@"."];
    NSData *signedOutputData = [self encodePayload:signingInput withSecret:theSecret];
    NSString *signedOutput = [self base64UrlEncodedStringFromBase64String:[signedOutputData base64EncodedStringWithOptions:0]];
    return [@[headerSegment, payloadSegment, signedOutput] componentsJoinedByString:@"."];
}

+(NSString *)base64UrlEncodedStringFromBase64String:(NSString *)base64String
{
    NSString *s = base64String;
    s = [s stringByReplacingOccurrencesOfString:@"=" withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    s = [s stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return s;
}

+ (NSData *)encodePayload:(NSString *)theString withSecret:(NSString *)theSecret
{
    const char *cString = [theString cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cSecret = [theSecret cStringUsingEncoding:NSUTF8StringEncoding];
    
    size_t amount = 32;
    size_t fullSize = amount * sizeof(unsigned char);
    unsigned char* cHMAC = malloc(fullSize);
    CCHmacAlgorithm ccAlg = kCCHmacAlgSHA256;

    CCHmac(ccAlg, cSecret, strlen(cSecret), cString, strlen(cString), cHMAC);
    
    NSData *returnData = [[NSData alloc] initWithBytes:cHMAC length:fullSize];
    free(cHMAC);
    return returnData;
}

+ (NSString *)encodeSegment:(id)theSegment withError:(NSError **)error
{
    NSData *encodedSegmentData = nil;
    
    if (theSegment) {
         encodedSegmentData = [NSJSONSerialization dataWithJSONObject:theSegment options:0 error:error];
    }
    else {
        // error!
        NSError *generatedError = [self errorWithCode:QCloudHLSInvalidSegmentSerializationError];
        if (error) {
            *error = generatedError;
        }
        NSLog(@"%@ Could not encode segment: %@", self.class, generatedError.localizedDescription);
        return nil;
    }
    
    NSString *encodedSegment = nil;
    
    if (encodedSegmentData) {
        encodedSegment = [self base64UrlEncodedStringFromBase64String:[encodedSegmentData base64EncodedStringWithOptions:0]];
    }
    
    return encodedSegment;
}

+ (NSString *)encodeSegment:(id)theSegment;
{
    NSError *error;
    return [self encodeSegment:theSegment withError:&error];
}

+ (NSError *)errorWithCode:(QCloudHLSError)code {
    return [self errorWithCode:code withUserDescription:[self userDescriptionForErrorCode:code]];
}

+ (NSError *)errorWithCode:(NSInteger)code withUserDescription:(NSString *)string {
    return [NSError errorWithDomain:QCloudHLSErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: string}];
}

+ (NSString *)userDescriptionForErrorCode:(QCloudHLSError)code {
    NSString *resultString = [self errorDescriptionsAndCodes][@(code)];
    return resultString ?: @"Unexpected error";
}

+ (NSDictionary *)errorDescriptionsAndCodes {
    static NSDictionary *dictionary = nil;
    return dictionary ?: (dictionary = @{
        @(QCloudHLSInvalidFormatError): @"Invalid format! Try to check your encoding algorithm. Maybe you put too many dots as delimiters?",
        @(QCloudHLSUnsupportedAlgorithmError): @"Unsupported algorithm! You could implement it by yourself",
        @(QCloudHLSAlgorithmNameMismatchError) : @"Algorithm doesn't match name in header.",
        @(QCloudHLSInvalidSignatureError): @"Invalid signature! It seems that signed part of jwt mismatch generated part by algorithm provided in header.",
        @(QCloudHLSNoPayloadError): @"No payload! Hey, forget payload?",
        @(QCloudHLSNoHeaderError): @"No header! Hmm",
        @(QCloudHLSEncodingHeaderError): @"It seems that header encoding failed",
        @(QCloudHLSEncodingPayloadError): @"It seems that payload encoding failed",
        @(QCloudHLSEncodingSigningError): @"It seems that signing output corrupted. Make sure signing worked (e.g. we may have issues extracting the key from the PKCS12 bundle if passphrase is incorrect).",
        @(QCloudHLSClaimsSetVerificationFailed): @"It seems that claims verification failed",
        @(QCloudHLSInvalidSegmentSerializationError): @"It seems that json serialization failed for segment",
        @(QCloudHLSUnspecifiedAlgorithmError): @"Unspecified algorithm! You must explicitly choose an algorithm to decode with.",
        @(QCloudHLSBlacklistedAlgorithmError): @"Algorithm in blacklist? Try to check whitelist parameter",
        @(QCloudHLSDecodingHeaderError): @"Error decoding the JWT Header segment.",
        @(QCloudHLSDecodingPayloadError): @"Error decoding the JWT Payload segment."
    }, dictionary);
}

@end
