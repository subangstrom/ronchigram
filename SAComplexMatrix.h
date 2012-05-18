//
//  SAComplexMatrix.h
//  ronchigram
//
//  Created by James LeBeau on 5/25/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "constants.h"
#import "SAMatrix.h"
#import "complex.h"
#import <vecLib/clapack.h>
#import <vecLib/cblas.h>

@interface SAComplexMatrix : NSObject {
	
	int numRows;
	int numColumns;
	
	complex double *matrix;
}

@property (readonly, assign) int numRows;
@property (readonly, assign) int numColumns;

+ (SAComplexMatrix *) identityWithSize: (int) size;
- (id) initWithRows: (int) rows Columns: (int) columns;
- (id) initWithSameSizeAs: (SAComplexMatrix*) copySize;


#pragma mark -
#pragma mark Matrix Getters


// Get a matrix value at a particular i and j
- (complex double) matrixComplexValueAtI: (int) i atJ:(int) j;
- (double) maxtrixRealValueAtI:(int) i atJ: (int) j;



// Report back the real or imag part of the matrix as a new real matrix

- (SAMatrix *) realPart;
- (SAMatrix *) imagPart;

// Return the pointer to the matrix 1D array

- (complex double*) matrix;


// Convience method for reporting numRows*numColumns

- (int) arraySize;


#pragma mark -
#pragma mark Matrix Setters

// 

- (void) setMatrixComplexValue: (complex double) complexNum atI: (int) i atJ: (int) j;
- (void) setMatrixRealValue: (double) value atI: (int) i atJ: (int) j;
- (void) setMatrixImaglValue: (double) value atI: (int) i atJ: (int) j;

// Convience method for directly setting a complex matrix value at a particular index
// *note index = i*numColumns+j in matrix notation, i.e. row major format

- (void) setComplexValue: (complex double) complexNum atIndex: (int) index;



#pragma mark -
#pragma mark Operations

- (void) addComplexMatrix:(SAComplexMatrix*) cMatAdd;
- (void) addRealMatrix: (SAMatrix*) realMatrix;
- (void) addImagMatrix: (SAMatrix*) imagMatrix;

- (void) scaleByValue:(double) scale;


// TODO: Make this actually do something
- (void) resizeToI:(int) rows byJ: (int) columns;



/* Multiply each element of the current matrix with the input matrix elemul
 
 Returns an allocated and initialized result matrix
 
 */

- (SAComplexMatrix*) elementMultiplyWith: (SAComplexMatrix*) elemul;
- (void) elementMultiplyWith: (SAComplexMatrix*) elemul Result:(SAComplexMatrix*) result;


// Return a complex conjugate of the matrix 
- (SAComplexMatrix*) conjugate;
- (void) conjugateToResult: (SAComplexMatrix*) conjMatrix;


/* Methods to zero different elements of the complex matrix
 
 z = a + i*b
 
 zeroMatrixComplex - set both a and b
 zeroMatrixReal - set  a = 0
 zeroMatrixImag - set b = 0
 
 */

- (void) zeroMatrixComplex;
- (void) zeroMatrixReal;
- (void) zeroMatrixImag;


// returns the size total size of the array in terms of elements, not bytes


#pragma mark -
#pragma mark Comparison Operations

- (BOOL) sameSizeAs: (SAComplexMatrix *) compMat;
- (BOOL) compatibleWith: (SAComplexMatrix*) compMat;


@end
