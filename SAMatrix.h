//
//  SAMatrix.h
//  Orient
//
//  Created by James LeBeau on 11/27/08.
//  Copyright 2008 _Angstrom. All rights reserved.
//

/*
 
 TODO: Switch to vecLib for more efficient calculations and more portable - get rid of GSL!
 
 */


#import <Cocoa/Cocoa.h>
//#import <vecLib/clapack.h>
//#import <vecLib/cblas.h>
#import <Accelerate/Accelerate.h>

@interface SAMatrix : NSObject {
	double *matrix;
	int numRows;
	int numColumns;
	
}


/*
 
 By default [SAMatrix* init] creates a identity 3x3 matrix;
 
 */

+ (SAMatrix*) identityWithSize:(int) size;
- (id) initWithRows: (int) rows Columns: (int) columns;

- (double) matrixSum;

#pragma mark setters

- (void) zeroMatrix;
- (void) setMatrixValue: (double) value atI: (int) i atJ: (int) j;
- (void) setMatrixWithArray: (double*) array Rows: (int) rows Columns: (int) columns;
- (void) setArrayValue: (double) value AtIndex: (int) index;

#pragma mark getter
//- (double) matrixArrayx;

- (int) arraySize;
- (double) valueAtArrayIndex:(int) arrayIndex;
- (void) printMatrix;
- (int) numRows;
- (int) numColumns;
- (NSSize) size;




#pragma mark comparitors

/*
 Comparitor methods for a 
 
 equalTo:
 This method is setup to compare two matrices (self and compMat).  If the two are equal,
 method returnes TRUE, false otherwise
 
 sameSizeAs:
 Is the matrix the same as the comp matrix
 
 */

- (double) minValue;
- (double) maxValue;
- (BOOL) isEqualToMatrix: (SAMatrix*) compMat;
- (BOOL) sameSizeAs: (SAMatrix *) compMat;
- (BOOL) compatibleWith: (SAMatrix*) compMat;
- (double*) matrix;


- (double) matrixValueAtI: (int) i atJ:(int) j;

/*
 Calculation operations
 */

- (SAMatrix*) matrixMultiplyWith: (SAMatrix*) matmul;
- (SAMatrix*) addMatrix:(SAMatrix *) matAdd;
- (void) scaleByValue:(double) scale;
- (void) log;



@end
