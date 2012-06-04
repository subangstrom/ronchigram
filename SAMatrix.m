//
//  SAMatrix.m
//  Orient
//
//  Created by James LeBeau on 11/27/08.
//  Copyright 2008 _Angstrom. All rights reserved.
//


#import "SAMatrix.h"




@implementation SAMatrix

- (id) init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		matrix = (double*) calloc(9, sizeof(double));
		numRows = 3;
		numColumns =3;
    }
    return self;
}


- (id) initWithRows: (int) rows Columns: (int) columns{
	self = [super init];
	
    if (self) {
		
		matrix = (double*) calloc(rows*columns, sizeof(double));
		numRows = rows;
		numColumns = columns;
		
		[self zeroMatrix];
		
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		
    }
    return self;
	
} 


+ (SAMatrix *) identityWithSize: (int) size{
	
	SAMatrix *identity = [[SAMatrix alloc] initWithRows:size Columns:size];
	
	int i;
	for(i=0; i<size; i++){
		[identity setMatrixValue: (double) 1.000 atI:i atJ:i];
	}
	
	[identity retain];
	
	return identity;
	
}

- (void) zeroMatrix{
    
	int i;
	
	for (i=0; i<numRows*numColumns; i++) {
		matrix[i] = 0.0;
	}
	
}


/* 
 
 Set the entire matrix with a 1 dimensional array.  This saves a lot of time in terms of hardcoding in things.
 This takes a pointer to the memory space of the array.
 
 */


- (void) setMatrixWithArray: (double*) array Rows: (int) rows Columns: (int) columns{
	
	int i,j;
	
	
	// TODO: Implement - if(sizeof(array) == rows*columns){
    
    for(i = 0; i< numRows; i++){
        for(j = 0; j < numColumns; j++){
            [self setMatrixValue:array[(i*numColumns)+j] atI:i atJ:j];
        }
    }
    
	
	//}
	
	
}

- (void) setArrayValue: (double) value AtIndex: (int) index{
	
	matrix[index] = value;
	
	
}

- (void) setMatrixValue: (double) value atI: (int) i atJ: (int) j{
	
	matrix[i*numColumns+j] = value;
}

- (double) matrixValueAtI: (int) i atJ:(int) j{
	
	return matrix[i*numColumns+j];
}

#pragma mark Operations

- (SAMatrix*) matrixMultiplyWith: (SAMatrix*) matmul{
	
	if(![self compatibleWith:matmul]){
		NSLog(@"Matrices are not compatible");
		return nil;
	} 
	
	SAMatrix* resultMatrix = [[SAMatrix alloc] initWithRows:numRows Columns:[matmul numColumns]];
	
	// setup the number of columns 
	
	int lda = numColumns;
	int ldb = [matmul numColumns];
	int ldc = [resultMatrix numColumns];
	
	double alpha = 1.0;
	double beta =1.0;
	
    
	cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, numRows, numColumns, [matmul numColumns], alpha, [self matrix], lda, [matmul matrix],ldb, beta, [resultMatrix matrix], ldc);
	
	return resultMatrix;
}

- (double) matrixSum{
	
	int i;
	double sum = 0;
	
	for (i = 0; i < [self arraySize]; i++) {
		sum += matrix[i];
	}
	
	return sum;
}

- (SAMatrix*) addMatrix:(SAMatrix *) matAdd{
	
	if(![self sameSizeAs:matAdd]){
		NSLog(@"Matrices cannot be added");
		return nil;
	} 
	
	int i,j;
	
	SAMatrix* resultMatrix = [[SAMatrix alloc] initWithRows:numRows Columns:numColumns];
	
	double newValue;
	// setup the number of columns 
	
	for(i = 0; i < numRows; i++){
		
		for(j = 0; j < numColumns; j++){
			
			newValue = [self matrixValueAtI:i atJ:j] + [matAdd matrixValueAtI:i atJ:j]; 
			[resultMatrix setMatrixValue: newValue atI:i atJ:j];
            
		}
	}
	
	return resultMatrix;
}

- (void) scaleByValue:(double) scale{
	
	int i;
	
	for(i = 0; i < numRows*numColumns; i++){
		matrix[i] = matrix[i]*scale;
	}
    
}
- (void) log{
    double newVal;
    for(int i=0; i<numRows; i++){
        for(int j=0; j<numColumns; j++){
            newVal=log([self matrixValueAtI:i atJ:j]);
            [self setMatrixValue:newVal atI:i atJ:j];
        }
    }
}



#pragma mark Comparisons

- (BOOL) isEqualToMatrix: (SAMatrix*) compMat{
	
	int i;
	bool areEqual = true;
	
	//Run the test loop only if they are the same size, otherwise this is automatically false
	if([self sameSizeAs:compMat]){
		
		double* matrixB = [compMat matrix];
		
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

- (BOOL) sameSizeAs: (SAMatrix *) compMat{
	
	bool sameSize = false;
	
	int numRowsB, numColumnsB;
	
	numRowsB = [compMat numRows];
	numColumnsB = [compMat numColumns];
	
	//Are the two matrices the same size;
	if(numRows == numRowsB && numColumns == numColumnsB)
		sameSize = true;
	
	return sameSize;
}

- (BOOL) compatibleWith: (SAMatrix*) compMat{
	
	bool compatible = false;
	
	if(numColumns == [compMat numRows])
		compatible = true;
	
	return compatible;
	
}

- (double) maxValue{
	
	int i;
	
	double maximum = matrix[0];
	
	for(i = 1; i < numRows*numColumns; i++){
		
		
		
		if (matrix[i] > maximum) {
			maximum = matrix[i];
		}
	}
    
	return maximum;
	
}

- (double) minValue{
	
	int i;
	
	double minimum = matrix[0];
	
	for(i = 1; i < numRows*numColumns; i++){
		
		
		
		if (matrix[i] < minimum) {
			minimum = matrix[i];
		}
	}
	
	return minimum;
	
}

#pragma mark Getters

- (int) arraySize{
	
	return numRows*numColumns;
	
}
- (double) valueAtArrayIndex:(int) arrayIndex{
	
	return matrix[arrayIndex];
	
}

- (int) numRows{
	return numRows;
}

- (int) numColumns{
	return numColumns;
}

- (double*) matrix{
	
	/* double newMatrix[numRows][numColumns];
     
     int i, j;
     
     for (i = 0; i< numRows; i++){
     for (j = 0; j < numColumns; j++)
     {
     newMatrix[i][j]= [self matrixValueAtI:i atJ:j];
     }
     }
	 */	
	return matrix;
}

- (void) printMatrix{
	
	int i, j;
	double aij;
	
	for (i = 0; i< numRows; i++){
		for (j = 0; j < numColumns; j++)
		{
			aij = [self matrixValueAtI:i atJ:j];
			printf("%f \t", aij);
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



- (void) dealloc{
	
	free(matrix);
	
	[super dealloc];
	
}

@end
