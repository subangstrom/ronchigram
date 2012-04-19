//
//  SAAberrations.m
//  ronchigram
//
//  Created by James LeBeau on 5/26/10.
//  Copyright 2010 subangstrom. All rights reserved.
//
//	Aberration values should all be in angstroms!

#import "SAAberration.h"


@implementation SAAberration

@synthesize n;
@synthesize m;
@synthesize label;
@synthesize Cnma;
@synthesize Cnmb;
@synthesize max;
@synthesize min;
@synthesize symRange;
@synthesize haiderLabel;
@synthesize krivanekLabel;

@synthesize angle;
@synthesize mag;

- (id) init
{
	self = [super init];
	if (self != nil) {
		
		n = 0;
		m = 0;
		self.Cnma = 0;
		self.Cnmb = 0;
		max = 10000;
		min = -10000;
		label = @"Unspecified";
		symRange = YES;
				 
			 
		aberrDict = [[NSMutableDictionary alloc] init];
	}
	return self;
}


+ (SAAberration*) aberrationWithN: (int) nVal 
								M: (int) mVal 
							 Cnma: (float) cnmaVal 
							 Cnmb: (float) cnmbVal;
{
	SAAberration* newAberration = [[SAAberration alloc] init];
	
	newAberration.n = nVal;
	newAberration.m = mVal;
	newAberration.Cnma = [NSNumber numberWithFloat:cnmaVal];
	newAberration.Cnmb = [NSNumber numberWithFloat:cnmbVal];
	
	 
	return newAberration;
}

/*- (NSNumber *) angle{
        
    float fcnma, fcnmb;
    float angle;
    
    fcnma = [Cnma floatValue];
    fcnmb = [Cnmb floatValue];
    
    if (fcnma == 0){
        angle = 0;
    }
    else
        angle = atanf(fcnmb/fcnma);
    
    return [NSNumber numberWithFloat:angle*180/pi];
    
}*/

- (void) setCnma:(NSNumber *)nCnma{
    
    Cnma = nCnma;
    [Cnma retain];
    
    float fcnma, fcnmb;

    
    fcnma = [Cnma floatValue];
    fcnmb = [Cnmb floatValue];
    
    mag = [NSNumber numberWithFloat:sqrtf(fcnma*fcnma+fcnmb*fcnmb)];
    [mag retain];
    
    if (fcnma == 0){
        angle = [NSNumber numberWithFloat:0];
    }
    else
        angle = [NSNumber numberWithFloat:atanf(fcnmb/fcnma)*180/pi];
    
    [angle retain]; 

}

- (void) setCnmb:(NSNumber *)nCnmb{
    
    float fcnma, fcnmb;
    
    
    fcnma = [Cnma floatValue];
    fcnmb = [nCnmb floatValue];
    
    mag = [NSNumber numberWithFloat:sqrtf(fcnma*fcnma+fcnmb*fcnmb)];
    [mag retain];
    
    if (fcnma == 0){
        angle = [NSNumber numberWithFloat:0];
    }
    else
        angle = [NSNumber numberWithFloat:atanf(fcnmb/fcnma)*180/pi];
    
    [angle retain]; 

    
    Cnmb = nCnmb;
    [Cnmb retain];
    


}

/*- (NSNumber *) magnitude{
    
    float fcnma, fcnmb;
    
    fcnma = [Cnma floatValue];
    fcnmb = [Cnmb floatValue];
    
    return [NSNumber numberWithFloat:sqrtf(fcnma*fcnma+fcnmb*fcnmb)];
}

- (void) setAngle:(NSNumber *) angle{
    
    float fcnma, fcnmb, magnitude;
    
    
    fcnma = [Cnma floatValue];
    fcnmb = [Cnmb floatValue];
    
    magnitude = sqrtf(fcnma*fcnma+fcnmb*fcnmb);

        
    Cnma = [NSNumber numberWithFloat: cosf([angle floatValue])*magnitude]; 
    Cnmb = [NSNumber numberWithFloat: sinf([angle floatValue])*magnitude]; 
    
    
}


- (void) setMagnitude:(NSNumber *) magnitude{
    
    
    float fcnma, fcnmb, angle;
    
    fcnma = [Cnma floatValue];
    fcnmb = [Cnmb floatValue];
    
    if (fcnma == 0){
        angle = 0;
    }
    else
    angle = atanf(fcnmb/fcnma);

    [Cnma release];
    [Cnmb release];
    
    Cnma = [NSNumber numberWithFloat: cosf(angle)*[magnitude floatValue]]; 
    Cnmb = [NSNumber numberWithFloat: sinf(angle)*[magnitude floatValue]]; 
    
}
 
 */


- (void) setMin: (float) newMin Max: (float) newMax{
	
	min = newMin;
	max = newMax;
	
}

- (NSMutableDictionary*) coefficients{
	return aberrDict;
}

- (id) aberrationForKey: (id) key{
	return [aberrDict objectForKey:key];
	
}



- (void) setAberration: (NSNumber *)  coeff ForKey: (id) key{
	
	[aberrDict setObject:coeff forKey:key];
	
}




- (void) dealloc
{
	[label release];
	[super dealloc];
}



@end
