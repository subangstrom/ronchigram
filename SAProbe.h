//
//  SAProbe.h
//  ronchigram
//
//  Created by James LeBeau on 5/24/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SAComplexMatrix.h"
#import "SAAberration.h"
#import "constants.h"
#import "SAFFTController.h"

@interface SAProbe : NSObject {
    
	SAComplexMatrix *wavefunction;
	SAComplexMatrix *aperture;
    
	SAFFTController *fftController;
	
	double realSize;
	float apertureSize;
	float lambda; 
	BOOL isDirectSpace;
    BOOL fastCalc;
    
	//NSArray filled with aberrations
	NSArray *aberrations;
}

@property (readwrite, assign) BOOL isDirectSpace;
@property (readwrite, assign) double realSize;
@property (readwrite, assign) float lambda;
@property (readwrite, assign) float apertureSize;
@property (assign) NSArray *aberrations; 

#pragma mark Initialization Statements
+ (SAProbe*) probeWithAberrations: (NSArray*) newAberrations 
						 RealSize: (float) rSize 
					 ApertureSize: (float) apSize 
						   Lambda: (float) wavelength 
						   Pixels: (NSSize) pixels;

- (NSArray *) aberrations;

- (void) calculateProbe;
- (double) integratedIntensity;

- (SAMatrix*) intensityDistribution;
- (SAComplexMatrix*) wavefunction;
- (SAComplexMatrix*) aperture;
- (void) resizeProbeTo:(NSSize) pixSize RealSize: (NSSize) realSize;
-(void) setScrollCalc: (BOOL) fast;

@end
