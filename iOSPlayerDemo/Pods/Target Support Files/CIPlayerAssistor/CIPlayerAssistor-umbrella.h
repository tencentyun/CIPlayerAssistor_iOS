#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CIMediaConfig.h"
#import "CIMediaInfo.h"
#import "CIOpenSSL.h"
#import "CIPlayerAssistor.h"

FOUNDATION_EXPORT double CIPlayerAssistorVersionNumber;
FOUNDATION_EXPORT const unsigned char CIPlayerAssistorVersionString[];

