//
//  Biometrics.h
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-13.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Biometrics_h
#define Biometrics_h

NS_ASSUME_NONNULL_BEGIN

@interface Biometrics : NSObject

+ (void)enrolled;
+ (void)unenrolled;
+ (void)successfulAuthentication;
+ (void)unsuccessfulAuthentication;

@end

NS_ASSUME_NONNULL_END

#endif /* Biometrics_h */
