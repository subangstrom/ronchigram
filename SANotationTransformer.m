//
//  SANotationTransformer.m
//  ronchigram
//
//  Created by James Lebeau on 3/12/12.
//  Copyright 2012 North Carolina State University. All rights reserved.
//

#import "SANotationTransformer.h"

@implementation SANotationTransformer

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES
    ;
}

/**
 *This changes the units from krivanek to haider and vice versa. 
 */
- (id)transformedValue:(id)value
{
    float krivanekInput;
    float haiderOutput;
    
    if (value == nil) return nil;
    
    // Attempt to get a reasonable value from the
    // value object.
    krivanekInput = sqrtf(powf([[value Cnma] floatValue],2)+powf([[value Cnmb] floatValue],2));
    
/*
    if ([value respondsToSelector: @selector(floatValue)]) {
        // handles NSString and NSNumber
        krivanekInput = [[value Cnma] floatValue];
    } else {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -floatValue.",
         [value class]];
    }
  */  
    // calculate Celsius value
    haiderOutput = krivanekInput;
    
    return [NSNumber numberWithFloat: haiderOutput];
}

- (id) reverseTransformedValue:(id)value{
    
    
    
    return value;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
