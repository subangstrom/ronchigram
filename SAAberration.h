//
//  SAAberrations.h
//  ronchigram
//
//  Created by James LeBeau on 5/26/10.
//  Copyright 2010 subangstrom. All rights reserved.
//
//	Aberration values should all be in angstroms!

#import <Cocoa/Cocoa.h>
#import "constants.h"


@interface SAAberration : NSObject {

	NSMutableDictionary *aberrDict;
	
	int n;
	int m;
    
	NSNumber *Cnma;
    NSNumber *Cnmb;
	NSString *label;
    
    NSNumber *angle;
    NSNumber *mag;
    
	float min;
	float max;
	BOOL symRange;
    
    NSAttributedString *haiderLabel;
    NSAttributedString *krivanekLabel;

}

@property int n;
@property int m;
@property (copy, setter=setCnma:, nonatomic) NSNumber *Cnma;
@property (copy, setter=setCnmb:, nonatomic) NSNumber *Cnmb;
@property (copy) NSString *label;
@property (copy) NSNumber *mag;
@property (copy) NSNumber *angle;
@property float min;
@property float max;
@property BOOL symRange;
@property (copy) NSAttributedString *haiderLabel;
@property (copy) NSAttributedString *krivanekLabel;

+ (SAAberration*) aberrationWithN: (int) nVal M: (int) mVal Cnma: (float) cnmaVal Cnmb: (float) cnmbVal;
- (NSMutableDictionary*) coefficients;

- (void) setMin: (float) newMin Max: (float) newMax;

- (id) aberrationForKey: (id) key;
- (void) setAberration: (NSNumber *)  coeff ForKey: (id) key;
- (NSNumber *) angle;
- (NSNumber *) magnitude;


@end
