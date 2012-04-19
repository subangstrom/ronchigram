//
//  SAFFTController.h
//  ronchigram
//
//  Created by James LeBeau on 6/2/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SAComplexMatrix.h"
#import <complex.h>
#import "constants.h"
#import "fftw3.h"
#import <omp.h>


@interface SAFFTController : NSObject {	

	SAComplexMatrix *input;
	SAComplexMatrix *output;

	fftw_plan backwardPlan;
	fftw_plan forwardPlan;
}


// Automatically sets the controller to update when the matrix size changes
- (id) initWithInput: (SAComplexMatrix*) inputMatrix Output: (SAComplexMatrix*) outputMatrix;

- (void) setInput: (SAComplexMatrix*) inputMatrix Output: (SAComplexMatrix*) outputMatrix;
- (void) setInput: (SAComplexMatrix*) inputMatrix; 
- (void) setOutput: (SAComplexMatrix*) outputMatrix;

- (void) updateInOut;

- (void) forwardTransform;
- (void) reverseTransform;

- (void) fftShift: (SAComplexMatrix *) shiftMatrix;



@end
