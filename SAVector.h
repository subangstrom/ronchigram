//
//  SAVector.h
//  SACrystallography
//
//  Created by James LeBeau on 8/20/09.
//  Copyright 2009 _Angstrom. All rights reserved.
//  
//	A crystallographic vector object
//

#import <Cocoa/Cocoa.h>
//#import <gsl_blas.h>
//#import <vecLib/clapack.h>
//#import <vecLib/cblas.h>

@interface SAVector : NSObject <NSCopying>{
	//gsl_vector *vector;
	double *vector;
	int dimension;
}

@property (assign) int dimension;
@property (assign) double *vector;

/** Methods to 
 
 */

- (id) initWithDimension: (int) dim;

- (void) addConst:(double) A;

- (void) scale: (double) alpha;

- (void) setVectorWithVector: (SAVector*) setVec;

- (void) multiply: (SAVector*) multVector;

- (void) setVector: (double*) array;

- (double) dot: (SAVector*) dotVec;

- (void) divide: (SAVector*) divVector;

- (void) setValue:(double)value forIndex:(int)index;

- (double) valueforIndex: (int) index;


- (void) printVector;

// Adds a vector and returns a new one

- (SAVector *) addVec: (SAVector*) vec;

- (BOOL) isCompatibleWith: (SAVector*) vec;



@end
