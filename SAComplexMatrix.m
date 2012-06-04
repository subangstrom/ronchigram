//
//  SAComplexMatrix.m
//  ronchigram
//
//  Created by James LeBeau on 5/25/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

// TODO: Post a notification that matrix size has changed

#import "SAComplexMatrix.h"


@implementation SAComplexMatrix

@synthesize numRows;
@synthesize numColumns;

#pragma mark Initialization Methods
#pragma mark -

+ (SAComplexMatrix *) identityWithSize: (int) size{
	
	SAComplexMatrix *identity = [[SAComplexMatrix alloc] initWithRows:size Columns:size];
	
	int i;
	for(i=0; i<size; i++){
		[identity setMatrixComplexValue: 1.000 + I*1.00 atI:i atJ:i];
	}
	
	[identity retain];
	
	return identity;
	
}


- (id) init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		matrix = (complex double*) malloc(9* sizeof(complex double));
		[self zeroMatrixComplex];
		
		numRows = 3;
		numColumns =3;
    }
    return self;
}

- (id) initWithRows: (int) rows Columns: (int) columns{
	self = [super init];
	if (self != nil) {
		
		matrix = (complex double*) malloc(sizeof(complex double)*rows*columns);
		[self zeroMatrixComplex];
		
		numRows = rows;
		numColumns = columns;
        
	}
	return self;
	
	
}

- (id) initWithSameSizeAs: (SAComplexMatrix*) copySize{
	
	self = [super init];
    if (self) {
        
		int rows = [copySize numRows];
		int columns = [copySize numColumns];
		matrix = (complex double*) malloc(sizeof(complex double)*rows*columns);
		[self zeroMatrixComplex];
		
		numRows = rows;
		numColumns = columns;
	}
    return self;
	
}

#pragma mark Setters
#pragma mark -
/* 
 
 Set the entire matrix with a 1 dimensional array.  This saves a lot of time in terms of hardcoding in things.
 This takes a pointer to the memory space of the array.
 
 */


- (void) setComplexMatrixWithArray: (complex double*) array Rows: (int) rows Columns: (int) columns{
	
	int i,j;
	
	
	// TODO: Implement - if(sizeof(array) == rows*columns){
	
	for(i = 0; i< numRows; i++){
		for(j = 0; j < numColumns; j++){
			[self setMatrixComplexValue: array[(i*numColumns)+j] atI:i atJ:j];
		}
	}
	
	
	//}
	
	
}

- (void) setMatrixComplexValue: (complex double) complexNum atI: (int) i atJ: (int) j{
	
	matrix[i*numColumns+j] = complexNum;
    
}
- (void) setMatrixRealValue: (double) value atI: (int) i atJ: (int) j{
	
	matrix[i*numColumns+j] = value + I*0.00;
}


- (void) setMatrixImaglValue: (double) value atI: (int) i atJ: (int) j{
	
	matrix[i*numColumns+j] = 0.00 + I*value;
}

- (void) setComplexValue: (complex double) complexNum atIndex: (int) index{
	
	matrix[index] = complexNum;
	
}

// Convience methods to clear out different parts of the complex matrix, code is fairly transparent

- (void) zeroMatrixComplex{
	
	int i;
	
	for (i=0; i<numRows*numColumns; i++) {
		
		matrix[i] = 0.00 + I*0.00;
	}
}

- (void) zeroMatrixReal{
	
	int i;
	
	for (i=0; i<numRows*numColumns; i++) {
		matrix[i] = 0.00 + I*cimag(matrix[i]);
	}
}
- (void) zeroMatrixImag{
	
	int i;
	
	for (i=0; i<numRows*numColumns; i++) {
		matrix[i] = creal(matrix[i])+ I*0.00;
	}
}



#pragma mark Getters
#pragma mark -

- (complex double*) matrix{
	
	
	return matrix;
}


- (int) numRows{
	return numRows;
}

- (int) numColumns{
	return numColumns;
}

/** returns the real part of the matrix*/
- (SAMatrix*) realPart{
	
	SAMatrix *realMatrix = [[SAMatrix alloc] initWithRows:numRows Columns:numColumns];
	double realValue;
	int i;
	
	for (i = 0; i < numRows*numColumns; i++){
		realValue = creal(matrix[i]);
		[realMatrix setArrayValue:realValue AtIndex:i];
        
	}
	
	return realMatrix;
}

- (SAMatrix*) imagPart{
	
	SAMatrix *imagMatrix = [[SAMatrix alloc] initWithRows:numRows Columns:numColumns];
    
	double imagValue;
	int i;
	for (i = 0; i < numRows*numColumns; i++){
		imagValue = creal(matrix[i]);
		[imagMatrix setArrayValue:imagValue AtIndex:i];
		
	}
	
	return imagMatrix;
}



- (complex double) complexValueAtIndex: (int) index{
	
	return matrix[index];
	
}


- (complex double) matrixComplexValueAtI: (int) i atJ:(int) j{
	
	return matrix[i*numColumns+j];
}

- (double) maxtrixRealValueAtI:(int) i atJ: (int) j{
	
	return creal([self matrixComplexValueAtI: i atJ: j]);
    
	
}

- (double) maxtrixImagValueAtI:(int) i atJ: (int) j{
	
	return cimag([self matrixComplexValueAtI: i atJ: j]);
	
}




#pragma mark Operations
#pragma mark -

- (SAComplexMatrix*) elementMultiplyWith: (SAComplexMatrix*) elemul{
	
	
	SAComplexMatrix *result = [[SAComplexMatrix alloc] initWithRows:numRows Columns:numColumns];
	
	[self elementMultiplyWith:elemul Result:result];
    
	return result;
	
}

- (void) resizeToI:(int) rows byJ: (int) columns{
	
	matrix = realloc(matrix, rows*columns*sizeof(complex double));
	
	numRows = rows;
	numColumns = columns;
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSNotification *note = [NSNotification notificationWithName:kSAMatrixDidChangeNotification object:self];
	
	[nc postNotification:note];
    
}

- (void) elementMultiplyWith: (SAComplexMatrix*) elemul Result:(SAComplexMatrix*) result{
	
	[result retain];
	if(![self sameSizeAs:elemul]){
		NSLog(@"Matrices cannot be element multiplied");
	} 
	
	complex double *elemulMatrix = [elemul matrix];
	complex double *resultMatrix = [result matrix];
	
	int i;
	for (i =0 ; i< numRows*numColumns; i++) {
		
		resultMatrix[i] = matrix[i] * elemulMatrix[i];
	}
	[result release];
	
}



- (SAComplexMatrix*) matrixMultiplyWith: (SAComplexMatrix*) matmul{
	
	if(![self compatibleWith:matmul]){
		NSLog(@"Matrices are not compatible");
		return nil;
	} 
	
	SAComplexMatrix* resultMatrix = [[SAComplexMatrix alloc] initWithRows:numRows Columns:[matmul numColumns]];
	
	// setup the number of columns 
	
	int lda = numColumns;
	int ldb = [matmul numColumns];
	int ldc = [resultMatrix numColumns];
	
	complex double *alpha = (complex double*) malloc(sizeof(complex double));
	*alpha = 1.0 + I*1.0;
	complex double *beta = (complex double*) malloc(sizeof(complex double));
	*beta = 1.0 + I*1.0;
	
	cblas_zgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, numRows, numColumns, [matmul numColumns], alpha, [self matrix], lda, [matmul matrix],ldb, beta, [resultMatrix matrix], ldc);
	
	return resultMatrix;
}

- (void) addComplexMatrix:(SAComplexMatrix *)cMatAdd{
	
	if(![self sameSizeAs:cMatAdd]){
		NSLog(@"Matrices cannot be added");
	} 
	
	int i,j;
	
	complex double newValue;
	// setup the number of columns 
	
	for(i = 0; i < numRows; i++){
		
		for(j = 0; j < numColumns; j++){
			
			newValue = [self matrixComplexValueAtI:i atJ:j] + [cMatAdd matrixComplexValueAtI:i atJ:j]; 
			[self setMatrixComplexValue:newValue atI:i atJ:j];
			
		}
	}
}

- (void) scaleByValue:(double) scale{
	
	int i;
	
	for(i = 0; i < numRows*numColumns; i++){
		matrix[i] = matrix[i]*scale;
	}
	
}

- (SAComplexMatrix*) conjugate{
	
	SAComplexMatrix *conjMatrix = [[SAComplexMatrix alloc] initWithRows:numRows Columns:numColumns];
	
	int i;
	
	for(i = 0; i < numRows*numColumns; i++){
		[conjMatrix setComplexValue:conj(matrix[i]) atIndex:i];
	}
    
	return conjMatrix;
	
}

- (void) conjugateToResult: (SAComplexMatrix*) conjMatrix{
	
	
	int i;
	
	for(i = 0; i < numRows*numColumns; i++){
		[conjMatrix setComplexValue:conj(matrix[i]) atIndex:i];
	}
    
}


#pragma mark Comparisons
#pragma mark -


- (BOOL) isEqualToMatrix: (SAComplexMatrix*) compMat{
	
	int i;
	bool areEqual = true;
	
	//Run the test loop only if they are the same size, otherwise this is automatically false
	if([self sameSizeAs:compMat]){
		
		complex double* matrixB = [compMat matrix];
		
		double aij, bij;
		
		//test each element of the matrix, then ouput the result
		
		for (i = 0; i< numRows*numColumns; i++){
			aij = matrix[i];
			bij = matrixB[i];
			if (aij != bij){
				areEqual = false;
				return areEqual;
			};
		}
		
	}else{
		areEqual = false;
	}
	
	
	return areEqual;	
}

- (BOOL) sameSizeAs: (SAComplexMatrix *) compMat{
	
	bool sameSize = false;
	
	int numRowsB, numColumnsB;
	
	numRowsB = [compMat numRows];
	numColumnsB = [compMat numColumns];
	
	//Are the two matrices the same size;
	if(numRows == numRowsB && numColumns == numColumnsB)
		sameSize = true;
	
	return sameSize;
}

- (BOOL) compatibleWith: (SAComplexMatrix*) compMat{
	
	bool compatible = false;
	
	if(numColumns == [compMat numRows])
		compatible = true;
	
	return compatible;
	
}



- (void) printMatrix{
	
	int i, j;
	complex double aij;
	
	for (i = 0; i< numRows; i++){
		for (j = 0; j < numColumns; j++)
		{
			aij = [self matrixComplexValueAtI:i atJ:j];
			printf("%f+i%f\t", creal(aij), cimag(aij));
		}
		printf("\n");
	}
	
}

- (NSSize) size{
	
	NSSize matrixSize;
	
	matrixSize.width = numColumns;
	matrixSize.height = numRows;
	return matrixSize;
	
}

- (int) arraySize{
	return numRows*numColumns;
}

- (void) dealloc{
	
	free(matrix);
	
	[super dealloc];
	
}


@end
