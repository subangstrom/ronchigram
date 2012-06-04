//
//  SAPotential.h
//  ronchigram
//
//  Created by James LeBeau on 5/24/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SAComplexMatrix.h"
#import "constants.h"

// Functions are currently from Earl J. Kirkland's code 

double calculateK0(double x);
double bessi0( double x );
double bessk0( double x );

@interface SAPotential : NSObject {
    
	SAComplexMatrix *potential;
    SAComplexMatrix *subpotential;
	NSSize realSize;
	NSArray *atoms;
	
}

@property (assign) NSArray *atoms;
@property (assign) SAComplexMatrix *potential;
@property (assign) SAComplexMatrix *subpotential;


//	Method used to create a random potential with a uniform distribution
//	density is given in number/angstrom^2

- (id) initWithPixels: (NSSize) size RealSize: (NSSize) rSize;

- (void) calculatePotential;
- (void) calculateSubPotential;
- (void) fillPotentialMatrix;

- (void) randomPotentialWithDensity: (float) density withZ: (int) atomicNumber;

// Atoms is a dictionary of position and Z

- (void) potentialWithAtoms: (NSArray*) atoms;
- (void) orderedPotentialWithSpacingA:(float) a SpacingB: (float) b Z: (int) z;

- (double) projectedPotentialForZ: (int) atomicNumber atPoint: (NSPoint) point;
- (SAComplexMatrix*) potential;
- (void) setRealSize:(NSSize) size;

/*Test*/


@end
