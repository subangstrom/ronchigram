//
//  SAProbe.m
//  ronchigram
//
//  Created by James LeBeau on 5/24/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import "SAProbe.h"


@implementation SAProbe

@synthesize isDirectSpace;
@synthesize realSize;
@synthesize apertureSize;
@synthesize lambda;
@synthesize aberrations;

#pragma mark -
#pragma mark Intitialization

- (id) init
{
	self = [super init];
	if (self != nil) {
		
		// Setup a default probe so that people do not do stupid shit

		int waveSize = 256;
				
		realSize = 74.0;
		lambda = 0.0197;
		apertureSize = 10.0;
		

		wavefunction = [[SAComplexMatrix alloc] initWithRows: waveSize Columns:waveSize];
		aperture = [[SAComplexMatrix alloc] initWithRows:waveSize Columns:waveSize];
		
		fftController = [[SAFFTController alloc] initWithInput:aperture Output:wavefunction];  

	}
	return self;
}

/**
 *This is the constructor of the wavefunction and the aperture. 
 *@param rows-int representing the number of rows present.
 *@param columns-int representing the number of colunmns present.
 *@return self
 */
- (id) initWithRows: (int) rows Columns: (int) columns; 
{
	self = [super init];
	if (self != nil) {
		
		wavefunction = [[SAComplexMatrix alloc] initWithRows: rows Columns:columns];
		aperture = [[SAComplexMatrix alloc] initWithRows:rows Columns:columns];
		
		fftController = [[SAFFTController alloc] initWithInput:aperture Output:wavefunction];  
		
				
	}
	return self;
}

/**
 * This is the constructor of the probe itself.
 */
+ (SAProbe*) probeWithAberrations: (NSArray*) newAberrations 
						 RealSize: (float) rSize 
					 ApertureSize: (float) apSize 
						   Lambda: (float) wavelength 
						   Pixels: (NSSize) pixels{
	
	SAProbe *newProbe = [[SAProbe alloc] initWithRows: pixels.height Columns:pixels.width];
	
	[newProbe setRealSize: rSize];
	[newProbe setApertureSize: apSize];
	[newProbe setLambda: wavelength];

							   
	[newProbe setAberrations:newAberrations];
	 
	return newProbe;
	
}



#pragma mark Probe Calculation

- (void) calculateProbe{
	
	
	// generic counters
	
	int i, j;
	
	float k[2];
	float kMag;
	
	double chi1, chi2, chi;
	double phi;
	double complex chiExp;
	
	[aperture zeroMatrixComplex];
	
	float maxK = apertureSize*1E-3/lambda;
    float maxK2 = powf(maxK, 2);
	
	int numRows = [wavefunction numRows];
	int numColumns = [wavefunction numColumns];
	int iMid,jMid;
    
    float n, m, Cnma, Cnmb;
	
//	NSMutableDictionary *aberration = [[SAAberration alloc] init];

	iMid = ceil((double) numRows / (double) 2.00);
	jMid = ceil((double) numColumns / (double) 2.00);


	int numXpix = (int) (round(maxK/(1/realSize)));
	int numYpix = (int) (round(maxK/(1/realSize)));
	

	
	for(i = iMid-numYpix; i < iMid + numYpix; i++){
		for(j = jMid-numXpix; j < jMid + numXpix; j++){
			
			// Need to calculate the aperture as centered, then shift back later  as required for the FFT!
	
			k[1] = (1.0f / realSize) * ((double) iMid-i);
			k[0] = (1.0f / realSize) * ((double) j-jMid);
				
			kMag = (k[0])*(k[0])+(k[1])*(k[1]);
		
			if(kMag <= maxK2){
				
				//phi = sin(k[1]*k[0]);
				chi1 = 0;
				chi2 = 0;
				
				//k[0] -= 0.005/lambda;
				
				chi = 0;
				
				// For each aberration, calculate the contributions to chi(k)
				
				for (SAAberration *aberration in aberrations) {
					 n = (float) [aberration n];
					 m = (float) [aberration m];
					 Cnma = (float) [[aberration Cnma] floatValue] * 10000;
					 Cnmb = (float)[[aberration Cnmb] floatValue] * 10000;
					
					// Sum up terms and calculate the complex value

					chi = creal( Cnma * cpow(lambda*k[0]-I*lambda*k[1], m)+I*Cnmb*cpow(k[0]*lambda-I*k[1]*lambda, m))*powf(k[0]*k[0]*lambda*lambda+k[1]*k[1]*lambda*lambda, (n-m+1.0) /2.0) / (n + 1.0) + chi;
				}
								
				
				
				// Need to avoid cexp issues with cexp(0)!
				if(k[0] == 0 && k[1] ==0)
					chi = 0;

				// Calculate aberration function
				chiExp  = cexp(I * (2 * pi / lambda) * chi);   
				[aperture setMatrixComplexValue:chiExp atI:i atJ:j];
				
			
			}
		}
	
	}
					
	[fftController fftShift:aperture];
	[fftController reverseTransform];
	
	double scaleFactor = 1.0/sqrt([self integratedIntensity]);
	[wavefunction scaleByValue:scaleFactor];
	
	
	
}

- (NSSize) probePixels{
	
	NSSize pixels;
	
	pixels.height = [wavefunction numRows];
	pixels.width = [wavefunction numColumns];
	
	return pixels;
	
}

- (double) integratedIntensity{
	
	SAMatrix *intensityDist = [self intensityDistribution];
	
	double integratedSum = [intensityDist matrixSum];

	[intensityDist release];
	
	
	return  integratedSum;
}

- (SAMatrix*) intensityDistribution{
	
	
	SAComplexMatrix *conj = [[SAComplexMatrix alloc] initWithSameSizeAs:wavefunction];
	SAComplexMatrix *multiplyResult = [[SAComplexMatrix alloc] initWithSameSizeAs:wavefunction];
	
	[wavefunction conjugateToResult:conj];
	[conj elementMultiplyWith: wavefunction Result:multiplyResult];
	
	SAMatrix *intensity = [multiplyResult realPart];
	
	[multiplyResult release];
	[conj release];
	
	return intensity;
	
}

#pragma mark Getters
- (SAComplexMatrix*) wavefunction{
	return wavefunction;
}
- (SAComplexMatrix*) aperture{
	return aperture;
}

- (void) resizeProbeTo:(NSSize) pixSize RealSize: (NSSize) newRealSize{
	
	[wavefunction resizeToI:pixSize.height byJ:pixSize.width];
	[aperture resizeToI:pixSize.height byJ:pixSize.width];
	
	realSize = newRealSize.width;
	
	//[fftController updateInOut];
	
}

			

			

@end
