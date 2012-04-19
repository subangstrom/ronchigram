//
//  SAFFTController.m
//  ronchigram
//
//  Created by James LeBeau on 6/2/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import "SAFFTController.h"


@implementation SAFFTController

- (id) initWithInput: (SAComplexMatrix*) inputMatrix Output: (SAComplexMatrix*) outputMatrix
{
	self = [super init];
	if (self != nil) {
		
		if(![inputMatrix sameSizeAs:outputMatrix]){
			NSLog(@"Output matrix and input matrix not the same size for FFT");
		}
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

		
		input = inputMatrix;
		output = outputMatrix;
		
//		[inputMatrix retain];
//		[outputMatrix retain];
		
		complex double *in = [inputMatrix matrix];
		complex double *out = [outputMatrix matrix];
		
		//int threadError = fftw_init_threads();
		
		//fftw_plan_with_nthreads(omp_get_max_threads());
		
		backwardPlan = fftw_plan_dft_2d([input numRows],[input numColumns], in, out, FFTW_BACKWARD, FFTW_MEASURE);
		forwardPlan = fftw_plan_dft_2d([input numRows],[input numColumns], in, out, FFTW_FORWARD, FFTW_MEASURE);
		
		
		[nc addObserver:self selector:@selector(updateInOut) name:kSAMatrixDidChangeNotification object:input];
		[nc addObserver:self selector:@selector(updateInOut) name:kSAMatrixDidChangeNotification object:output];

	}
	
	return self;
}



- (void) setInput: (SAComplexMatrix*) inputMatrix Output: (SAComplexMatrix*) outputMatrix{
	
	if(![inputMatrix sameSizeAs:outputMatrix]){
		NSLog(@"Output matrix and input matrix not the same size for FFT");
	}
	
	if (input != nil) {
		[input release];
	}
	if (output != nil) {
		[output release];
	}
	
	input = inputMatrix;
	output = outputMatrix;
	
	[inputMatrix retain];
	[outputMatrix retain];
	
	complex double *in = [inputMatrix matrix];
	complex double *out = [outputMatrix matrix];
	
	//int threadError = fftw_init_threads();
	
	//fftw_plan_with_nthreads(omp_get_max_threads());
	
	backwardPlan = fftw_plan_dft_2d([input numRows],[input numColumns], in, out, FFTW_BACKWARD, FFTW_MEASURE);
	forwardPlan = fftw_plan_dft_2d([input numRows],[input numColumns], in, out, FFTW_FORWARD, FFTW_MEASURE);
	
	
	
}
- (void) setInput: (SAComplexMatrix*) inputMatrix{
	
}

- (void) setOutput: (SAComplexMatrix*) outputMatrix{
	
}

- (void) forwardTransform{
	
	fftw_execute(forwardPlan);

}

- (void) reverseTransform{

	fftw_execute(backwardPlan);
}



- (void) fftShift: (SAComplexMatrix *) shiftMatrix {
	
	
	int numRows = [shiftMatrix numRows];
	int numColumns = [shiftMatrix numColumns];
	
	int i,j;
	 
	int iMid = numRows/2;
	int jMid = numColumns/2;
	
	int swapI, swapJ;
	
	complex double temp1, temp2;
	
	for(i = 0; i < numRows; i++){
		for(j = 0; j < jMid; j++){
			
			if(i<iMid){
				swapI = iMid +i;
				swapJ = jMid +j;
			}else{
				swapI = i-iMid;
				swapJ = jMid +j;
			}
			
			temp1 = [shiftMatrix matrixComplexValueAtI:i atJ:j];
			temp2 = [shiftMatrix matrixComplexValueAtI:swapI atJ:swapJ];
			
			[shiftMatrix setMatrixComplexValue:temp1 atI:swapI atJ:swapJ];
			[shiftMatrix setMatrixComplexValue:temp2 atI:i atJ:j];
		}
	}
	
}

- (void) updateInOut{
		
	fftw_destroy_plan(backwardPlan);
	fftw_destroy_plan(forwardPlan);
	
	complex double *in = [input matrix];
	complex double *out = [output matrix];
	
	//int threadError = fftw_init_threads();
	
	//fftw_plan_with_nthreads(omp_get_max_threads());
	
	backwardPlan = fftw_plan_dft_2d([input numRows],[input numColumns], in, out, FFTW_BACKWARD, FFTW_MEASURE);
	forwardPlan = fftw_plan_dft_2d([input numRows],[input numColumns], in, out, FFTW_FORWARD, FFTW_MEASURE);
	
}

- (void) dealloc
{
	//fftw_cleanup_threads();
	[input release];
	[output release];
	fftw_destroy_plan(backwardPlan);
	fftw_destroy_plan(forwardPlan);
	
	[super dealloc];
}



@end
