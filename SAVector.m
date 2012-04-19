//
//  SAVector.m
//  SACrystallography
//
//  Created by James LeBeau on 8/20/09.
//  Copyright 2009 _Angstrom. All rights reserved.
//

#import "SAVector.h"


@implementation SAVector

@synthesize dimension;
@synthesize vector;

- (id) init
{
	self = [super init];
	if (self != nil) {
		
		vector = (double*) calloc(3, sizeof(double));
		//vector = gsl_vector_calloc(3);
		dimension = 3;
		
	}
	return self;
}
 

- (id) initWithDimension: (int) dim
{
    self = [super init];
    if (self) {
		
		vector = (double*) calloc(dim, sizeof(double));
		//vector = gsl_vector_calloc(dim);
		dimension = dim;
		
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone{
	
	
	SAVector *copy = [[SAVector alloc] initWithDimension: dimension];
	[copy setVectorWithVector:self];
	[copy retain];
	
	return copy;
	
}

- (void) setVectorWithVector: (SAVector*) setVec{
	
	int i;
	
	
	if([self isCompatibleWith:setVec]){

		for(i = 0; i < dimension; i++){
		
			[self setValue:[setVec valueforIndex:i] forIndex:i];
		
		}
	}	
}


- (void) setVector: (double*) array  {
	
	int i;
	
	for (i = 0; i < dimension; i++) {
		[self setValue:array[i] forIndex:i];
	}
}

- (void) addConst:(double) A{
	
	const double scaleFactor = 1;
	double xVector[dimension];
	int incX =1;
	int incY = 1;
	int i;
	
	for(i =0; i< dimension;i++){
		xVector[i] = A;
	}
	
	cblas_daxpy(dimension, scaleFactor, xVector, incX, vector, incY);
} 

- (void) scale: (double) alpha{

	double yVector[dimension];
	int incX =1;
	int incY = 1;
	int i;
	
	for(i =0; i<dimension;i++){
		yVector[i] = 0;
	}
	
	cblas_daxpy(dimension, alpha, vector, incX, yVector, incY);
} 

- (void) multiply: (SAVector *) multVector{
	
	
	// Algorithm for v1*v2 -- component wise
	
	
	if ([self isCompatibleWith:multVector]) {
	
		
	}
	

	
//	gsl_vector_mul(vector, multVector);
}

- (void) divide: (SAVector*) divVector{
	
	int incX =1;
	int incY = 1;
	
//	gsl_vector_div(vector, divVector);
}

- (double) dot: (SAVector*) dotVec{
	
	int incX =1;
	int incY = 1;
	
//	gsl_blas_ddot(vector, dotVec, &dotProd);
	if([self isCompatibleWith:dotVec]){
		return cblas_ddot(dimension, vector, incX, [dotVec vector], incY);
	}
	else {
		return 0;
	}

}

- (void) setValue: (double) value forIndex: (int) index{
	
	//the vector, the index, new value
	//gsl_vector_set(vector, ind, element);
	
	vector[index] = value;
	
}  
		
- (double) valueforIndex: (int) index{
	
	
	return vector[index];
}
									  
							

- (BOOL) isCompatibleWith:(SAVector *)testVec{
	
	if(dimension ==[testVec dimension]){
		return YES;
	}else{
		return NO;
	}
	
}

- (SAVector *) addVec: (SAVector*) vec{
	
	int incX =1;
	int incY = 1;
	double  scaleFactor = 1;
	
	SAVector *newVec = [self copy];
	
	cblas_daxpy(dimension, scaleFactor, [vec vector], incX, [newVec vector], incY);
	
	return newVec;
	
}


- (void) printVector{
	int i;
	
	double ai;
	
	for (i=0; i<dimension; i++) {
		//ai = gsl_vector_get(vector, i);
		ai = vector[i];
		
		printf("%g\n", ai);
	}
}

- (void) dealloc
{
	//gsl_vector_free(vector);
	free(vector);
	
	[super dealloc];
}


@end
