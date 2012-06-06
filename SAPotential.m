//
//  SAPotential.m
//  ronchigram
//
//  Created by James LeBeau on 5/24/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import "SAPotential.h"


@implementation SAPotential

@synthesize atoms;
@synthesize potential;
@synthesize subpotential;

- (id) init
{
	self = [super init];
	if (self != nil) {
		potential = [[SAComplexMatrix alloc] initWithRows:512 Columns:512];
        subpotential = [[SAComplexMatrix alloc] initWithRows:11 Columns:11];
		atoms = [[NSMutableArray alloc] init];
        
	}
	return self;
}

/**
 *This initializes the potential and subpotential arrays.
 */
- (id) initWithPixels: (NSSize) size RealSize: (NSSize) rSize {
	
	if (self != nil) {
		potential = [[SAComplexMatrix alloc] initWithRows:size.height Columns:size.width];
        subpotential = [[SAComplexMatrix alloc] initWithRows:11 Columns:11];
		realSize = rSize;
		atoms = [[NSMutableArray alloc] init];
        
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(calculatePotential) name:kSAMatrixDidChangeNotification object:potential];
        
	}
	return self;
}

/**
 *This just returns the potential matrix. 
 */
- (SAComplexMatrix*) potential{
	return potential;
}

/**
 *This method is called to recalculate the potential. It stores a copy of the atoms coordinates for continued use.
 */
- (void) potentialWithAtoms: (NSArray*) inputAtoms{
	
	[inputAtoms retain];
	
	atoms = [inputAtoms copy];
	
	[inputAtoms release];
	
	//[self calculatePotential];
    [self calculateSubPotential];
	
}

/*
 *This is now unused code.
 *This method calculated the potential matrix. it was cumbersome becasue it recalculted for each atom which was unnecessary. 
 */
- (void) calculatePotential{
	
	int numPots = [atoms count];
	
	[potential zeroMatrixComplex];
	
	int numPixX = [potential numColumns];
	int numPixY = [potential numRows]; 
	double oldValue, newValue;
	
	// Center float points
	
	NSPoint potCenter;
	NSPoint potCalcPoint;
	
	// Float off center
	
	int centerI, centerJ;
	
	// Pixels size and range to cover
	
	float pixSizeX = numPixX/realSize.width;
	float pixSizeY = numPixY/realSize.height;
	
	float pixCalcRangeX = ceilf(2.0*pixSizeX);
	float pixCalcRangeY = ceilf(2.0*pixSizeY);
	
	int pixI, pixJ;
	
	// generic counters
	int i,j,k;
	
	NSDictionary *atom;
	int atomicNumber;
    
	
	for (k = 0; k < numPots; k++) {
		
		atom = [atoms objectAtIndex:k];
		atomicNumber = [[atom objectForKey:kSAAtomicNumber] intValue];
		
		potCenter.x = [[atom objectForKey:kSAPotCenterX] floatValue];
		potCenter.y = [[atom objectForKey:kSAPotCenterY] floatValue];
        
		
		centerJ = floor(potCenter.x*pixSizeX);
		centerI = floor(potCenter.y*pixSizeY);
		
		for (i = 0; i < pixCalcRangeY; i++){
			
			pixI = centerI+i-round(pixCalcRangeY/2);
			
			if(pixI > numPixY-1 || i < 0)
				continue;
			
			for (j = 0; j < pixCalcRangeX; j++){
				
				pixJ = centerJ+j-round(pixCalcRangeX/2);
				
				if(pixJ > numPixX-1 || j < 0)
					continue;
				
				potCalcPoint.x = ((float) (j - pixCalcRangeX/2)) / pixSizeX; 
				potCalcPoint.y = ((float) (i - pixCalcRangeY/2)) / pixSizeY; 
				
				oldValue = 	[potential maxtrixRealValueAtI: pixI  atJ: pixJ];
				newValue = [self projectedPotentialForZ:atomicNumber atPoint: potCalcPoint];
				
				[potential setMatrixRealValue: (oldValue + newValue) atI: pixI  atJ:pixJ];
				
			}
		}
	}
}

/**
 *This calculates the subPotential array. This array is based on the potential of a single atom. It calculates the electrostatic potential for a single atom.
 *This calls the fillPotentialMatrix method.
 */
- (void) calculateSubPotential{
   	
    
	[subpotential zeroMatrixComplex];
    [potential zeroMatrixComplex];
	
	float numPixX = [potential numColumns];
	float numPixY = [potential numRows]; 
	double oldValue, newValue;
    
	// Center float points
	
	NSPoint potCalcPoint;
	
	// Pixels size and range to cover
	
	float pixSizeX = numPixX/realSize.width;
	float pixSizeY = numPixY/realSize.height;
	
	float pixCalcRangeX = [subpotential numRows];
	float pixCalcRangeY = [subpotential numColumns];
	
	// generic counters
	int i,j;
	
	int atomicNumber;
    
    atomicNumber = 6;
    
    for (i = 0; i < [subpotential numColumns]; i++){
        
        
        for (j = 0; j < [subpotential numRows]; j++){
            
            
            potCalcPoint.x = ((float) (j - pixCalcRangeX/2)) / pixSizeX; 
            potCalcPoint.y = ((float) (i - pixCalcRangeY/2)) / pixSizeY; 
            
            oldValue = 	[subpotential maxtrixRealValueAtI: i  atJ: j];
            newValue = [self projectedPotentialForZ:atomicNumber atPoint: potCalcPoint];
            
            [subpotential setMatrixRealValue: (oldValue+newValue) atI: i  atJ:j];
        }
    }
    [self fillPotentialMatrix];			
}

/**
 *This is used when looking at amorphous samples. It generates random centers for the atoms in the potential array.
 */
- (void) randomPotentialWithDensity: (float) density withZ: (int) atomicNumber{
	
	int numPots = roundf(density*realSize.width*realSize.height);
	
	[potential zeroMatrixComplex];
    
	// Center float points
    
	NSPoint potCenter;
    
	// Float off center
	
	int k;
	
	NSDictionary *newAtom;
	
	NSMutableArray *newAtoms = [[NSMutableArray alloc] init]; 
	
	for (k =0; k < numPots; k++){
		
		potCenter.x = ((float) (arc4random() % 10000)) / 10000.0 * realSize.width;
		potCenter.y = ((float) (arc4random() % 10000)) / 10000.0 * realSize.height;
		
		newAtom = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithFloat: potCenter.x], kSAPotCenterX, 
                   [NSNumber numberWithFloat: potCenter.y],kSAPotCenterY,
                   [NSNumber numberWithInt:6], kSAAtomicNumber, nil]; 
		
		[newAtoms addObject:newAtom]; 
		
		[newAtom release];
        
	}
	
	[self potentialWithAtoms: newAtoms];
    
}
/**
 *This method lowers the quality of the display to speed up the program.
 *THis is an unused method.
 */
- (SAPotential *) downScaledVersionBy: (float) scaleFactor{
	
	
	int nRows = roundf(scaleFactor * (float) [potential numRows]);
	int nColumns = roundf(scaleFactor * (float) [potential numColumns]);
	
	NSSize nPixSize = NSMakeSize(nColumns, nRows);
	
	SAPotential *scaledPot = [[SAPotential alloc] initWithPixels:nPixSize RealSize:realSize];
	
	return scaledPot;
	
}
/**
 *This initializes creates a mutable array of atoms and gives each one an x and y point.
 */
- (void) orderedPotentialWithSpacingA:(float) a SpacingB: (float) b Z: (int) z{
	
	[potential zeroMatrixComplex];
    
	int numA = round(realSize.width/a);
	int numB = round(realSize.height/b);
	
	int i,j;
    
	NSPoint potCenter;
	
	
	NSDictionary *newAtom;
	
	NSMutableArray *newAtoms = [[NSMutableArray alloc] init]; 
	
	for (i = 0; i <= numB; i++) {
        
		for (j = 0; j <= numA; j++) {
			
			potCenter.x = a*j;
			potCenter.y = b*i;
			
			newAtom = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithFloat: potCenter.x], kSAPotCenterX, 
					   [NSNumber numberWithFloat: potCenter.y],kSAPotCenterY,
					   [NSNumber numberWithInt:6], kSAAtomicNumber, nil]; 
			
			[newAtoms addObject:newAtom]; 
			
			[newAtom release];
			
		}
	}
	
	[self potentialWithAtoms: newAtoms];
    
}
/**
 *This method takes the subPotential matrix and fills the potential matrix with an instance of the sub matrix at each position.
 */
- (void) fillPotentialMatrix{
    
    int numPixX = [subpotential numColumns];
	int numPixY = [subpotential numRows];
    int k;
    int numPots = [atoms count];
    
    
    NSPoint potCenter = potCenter, potCorner;
    
    for (k=0; k<numPots; k++) {
        NSDictionary *atom;
        atom = [atoms objectAtIndex:k];
        
        potCenter.x = [[atom objectForKey:kSAPotCenterX] floatValue];
		potCenter.y = [[atom objectForKey:kSAPotCenterY] floatValue];
        
        float pixSizeX = [potential numColumns]/realSize.width;
        float pixSizeY = [potential numRows]/realSize.height;
        
        potCenter.x=floorf(potCenter.x * pixSizeX)-1;
        potCenter.y=floorf(potCenter.y * pixSizeY)-1;
        
        potCorner.x=round(potCenter.x-(numPixX/2));
        potCorner.y=round(potCenter.y-(numPixY/2));
        
        int maxXValue=[subpotential numColumns], maxYValue=[subpotential numRows];
        
        for (int i=0; i<maxXValue; i++) {
            
            for (int j=0; j<maxYValue; j++) {
                
                if (potCorner.x+i > ([potential numColumns]-1) || potCorner.x+i< 0)
                    continue;
                if(potCorner.y+j > ([potential numRows]-1) || potCorner.y+j< 0)
                    continue;
                
                double oldValue=[potential maxtrixRealValueAtI: (potCorner.x+i)  atJ: (potCorner.y+j)];
                [potential setMatrixRealValue:(oldValue+[subpotential maxtrixRealValueAtI: (i) atJ: (j)]) atI:(potCorner.x+i) atJ:(potCorner.y+j)];
            }
        }
    }
}
/**
 * Not sure what this calculation is specifically for but it is used to calculate the electrostatic potential of the atoms. 
 */
- (double) projectedPotentialForZ: (int) atomicNumber atPoint: (NSPoint) point{
	
	
	
	// a0 in angstroms
	double bohrRadius = 0.529177;
	double pot = 0;
	
	double potTerm1;
	double potTerm2;
	
	double f[12];
	
	// f as per Kirkland
	
	f[0] =  2.12080767e-001 ;
    f[1] =  2.08605417e-001 ;
    f[2] =  1.99811865e-001 ;
    f[3] =  2.08610186e-001 ;
    f[4] =  1.68254385e-001 ;
    f[5] =  5.57870773e+000 ;
    f[6] =  1.42048360e-001 ;
    f[7] =  1.33311887e+000 ;
    f[8] =  3.63830672e-001 ;
    f[9] =  3.80800263e+000 ;
    f[10] =  8.35012044e-004 ;
    f[11] =  4.03982620e-002 ;
	
	double r = sqrt(point.x*point.x+point.y*point.y);
	
	
	double prefact1 = 4*pi*pi*bohrRadius*1.6e-19;
	double prefact2 = 2*pi*pi*bohrRadius*1.6e-19;
	
	int i;
	
	for(i = 0; i < 3; i++){
		
		potTerm1 = prefact1*f[i*2]*bessk0(2*pi*r*sqrt(f[i*2+1]));
		potTerm2 = prefact2*f[i*2+6]/f[i*2+7]*exp(-pi*pi*r*r/f[i*2+7]);
		
		pot =  potTerm1 + potTerm2 + pot;
		
	} 
	
	return pot;
	
}


- (void) setRealSize:(NSSize) size{
	realSize = size;
}

- (void) dealloc
{
	[potential release];
    [subpotential release];
	[super dealloc];
}


@end

// K0 Bessel function calcuation following Abramowitz and Stegun, page 378-379

double calculateK0(double x){
	
	double K0,I0;
	double t = x/3.75;
	double v = x/2;
	
	
	I0 = 1.0+3.5156229*pow(t,2)+3.0899424*pow(t,4.0)+1.2067492*pow(t,6)+0.2659732*pow(t,8)+0.0360768*pow(t,10)+0.0045813*pow(t,12.0);
	
	K0 = -log(x/2)*I0-.57721566+0.42278420*pow(v,2)+0.23069756*pow(v,4)+0.03488590*pow(v,6)+0.00262698*pow(v, 8)+0.0010750*pow(v,10)+.00000740*pow(v,12);
	
	return K0;
	
	
}

/*-------------------- bessi0() ---------------*/
/*
 modified Bessel function I0(x)
 see Abramowitz and Stegun page 379
 
 x = (double) real arguments
 
 12-feb-1997 E. Kirkland
 */
double bessi0( double x ) {
    int i;
    double ax, sum, t;
    
    double i0a[] = { 1.0, 3.5156229, 3.0899424, 1.2067492,
        0.2659732, 0.0360768, 0.0045813 };
	
    double i0b[] = { 0.39894228, 0.01328592, 0.00225319,
        -0.00157565, 0.00916281, -0.02057706, 0.02635537,
        -0.01647633, 0.00392377};
	
    ax = fabs( x );
    if( ax <= 3.75 ) {
        t = x / 3.75;
        t = t * t;
        sum = i0a[6];
        for( i=5; i>=0; i--) sum = sum*t + i0a[i]; 
    } else {
        t = 3.75 / ax;
        sum = i0b[8];
        for( i=7; i>=0; i--) sum = sum*t + i0b[i];
        sum = exp( ax ) * sum / sqrt( ax );
    }
    return( sum );
	
}  /* end bessi0() */

/*-------------------- bessk0() ---------------*/
/*
 modified Bessel function K0(x)
 see Abramowitz and Stegun page 380
 
 Note: K0(0) is not define and this function
 returns 1E20
 
 x = (double) real arguments
 
 this routine calls bessi0() = Bessel function I0(x)
 
 12-feb-1997 E. Kirkland
 */
double bessk0( double x ){
    double bessi0(double);
	
    int i;
    double ax, x2, sum;
    double k0a[] = { -0.57721566, 0.42278420, 0.23069756,
		0.03488590, 0.00262698, 0.00010750, 0.00000740};
	
    double k0b[] = { 1.25331414, -0.07832358, 0.02189568,
		-0.01062446, 0.00587872, -0.00251540, 0.00053208};
	
    ax = fabs( x );
    if( (ax > 0.0)  && ( ax <=  2.0 ) ){
        x2 = ax/2.0;
        x2 = x2 * x2;
        sum = k0a[6];
        for( i=5; i>=0; i--) sum = sum*x2 + k0a[i];
        sum = -log(ax/2.0) * bessi0(x) + sum;
    } else if( ax > 2.0 ) {
        x2 = 2.0/ax;
        sum = k0b[6];
        for( i=5; i>=0; i--) sum = sum*x2 + k0b[i];
        sum = exp( -ax ) * sum / sqrt( ax );
    } else sum = 1.0e20;
    return ( sum );
	
}  /* end bessk0() */


