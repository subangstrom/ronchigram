//
//  SANegative.m
//  ronchigram
//
//  Created by James LeBeau on 7/2/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import "SANegative.h"


@implementation SANegative
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)value {
    return (value == nil) ? nil : NSStringFromClass([value class]);
}
@end


