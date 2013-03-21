//
//  ronchigramAppDelegate.m
//  ronchigram
//
//  Created by James LeBeau on 5/21/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import "ronchigramAppDelegate.h"

@implementation ronchigramAppDelegate

@synthesize window;

- (id) init
{
	self = [super init];
	if (self != nil) {
		nc = [NSNotificationCenter defaultCenter];
		
		[nc addObserver:self selector:@selector(viewNeedsUpdate:) name:kRonchigramNeedsUpdate object:nil];
		
		colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);
        
        noteTranform = [[[SANotationTransformer alloc] init] autorelease];
        
        [NSValueTransformer setValueTransformer:noteTranform
                                        forName:@"NotationTransformation"];
		
	}
	return self;
}

/**
 *This sets up all of the initial values for the program. This makes the fftController and sets up the window.
 */
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	
	// Insert code here to initialize your application 
	
	//probe = [[SAProbe alloc] init];
	
	[window setContentAspectRatio:NSMakeSize(956, 673)];
	
    int size = 51;
    
	pixels = NSMakeSize(256,256);
	realSize = NSMakeSize(size, size);
	
	hrPixels = NSMakeSize(512, 512);
	hrRealSize = NSMakeSize(size*2, size*2);
	
	//isAmorphous = YES;
    isAmorphous = NO;
	isSliding = NO;
    
	
	[self prepareProbe];
	[self preparePotential];
	
	
	[viewSize setFloatValue:realSize.width];
	
	// Setup the potential and probe for calculating  
	prbPotPrd = [[SAComplexMatrix alloc] initWithRows:pixels.height Columns:pixels.width];
	ronchigram = [[SAComplexMatrix alloc] initWithRows:pixels.height Columns:pixels.width];
	fftController = [[SAFFTController alloc] initWithInput: prbPotPrd Output: ronchigram];
	
	textCellOpts = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
					NSAllowsEditingMultipleValuesSelectionBindingOption,
					[NSNumber numberWithBool:YES],
					NSCreatesSortDescriptorBindingOption,
					[NSNumber numberWithBool:YES],
					NSConditionallySetsEditableBindingOption,
					[NSNumber numberWithBool:YES],
					NSConditionallySetsEnabledBindingOption,
                    [NSNumber numberWithBool:YES],
                    NSContinuouslyUpdatesValueBindingOption,
					[NSNumber numberWithBool:YES],
					NSRaisesForNotApplicableKeysBindingOption,nil];
    
	[textCellOpts retain];
	
	NSTableColumn *columnA = [aberrationTable tableColumnWithIdentifier:@"aCoeff"];
	NSTableColumn *columnB = [aberrationTable tableColumnWithIdentifier:@"bCoeff"];
	
	[columnA bind:@"value" toObject:abController withKeyPath:@"arrangedObjects.Cnma" options:textCellOpts];
	[columnB bind:@"value" toObject:abController withKeyPath:@"arrangedObjects.Cnmb" options:textCellOpts];
	
	
	[self viewNeedsUpdate:nil];
	
}

/* TODO: Create two-resoltion calculations
 
 
 Calculate potential for high resolution and do bilinear/bicubic interpolation
 
 
 */

/**
 *This calculates the ronchigram. It takes the fourier transform of the wavefunction multiplied with the potential. 
 */
- (void) calculateRonchigram{
	
	SAComplexMatrix *wavefunction;
	SAComplexMatrix *specimen;
	
	wavefunction = [probe wavefunction];
	
	if (isSliding == YES) {
		
		specimen = [potential potential];
		
		[ronchigram resizeToI:[wavefunction numRows] byJ:[wavefunction numColumns]];
		[prbPotPrd resizeToI:[wavefunction numRows] byJ:[wavefunction numColumns]];
	}else{
		specimen = [hrPotential potential];
		[ronchigram resizeToI:[wavefunction numRows] byJ:[wavefunction numColumns]];
		//ronchi = ronchigram;
		
		[prbPotPrd resizeToI:[wavefunction numRows] byJ:[wavefunction numColumns]];
		//ronchi = hrRonchigram;
		//probePotPrd = hrPrbPotPrd;
		//prdController = hrFFTController;
		
	}
    
	[wavefunction retain];
	[specimen retain];
	
	[wavefunction elementMultiplyWith:specimen Result: prbPotPrd];
	
	[fftController forwardTransform];
	[fftController fftShift:ronchigram];
	
    //	[probePotPrd release];
	[wavefunction release];
	[specimen release];
    //	[prdController release];
	
}

/**
 *This prepares the probe itself. It sets up all of the abberations and names them. It also sets the max and min for each abberation.
 *
 *We need to set the min and max to different valuse that will be determined by the microscope itself.
 */
- (void) prepareProbe{
    
	
    // Zeroth order aberrations
    SAAberration *beamshift = [SAAberration aberrationWithN:0 M:1 Cnma:0 Cnmb:0];
    
    // First order aberrations
    SAAberration *defocus = [SAAberration aberrationWithN:1 M:0 Cnma:-.002 Cnmb:0];
    SAAberration *twoFold = [SAAberration aberrationWithN:1 M:2 Cnma:0 Cnmb:0];
    
	
    // Second order aberrations
    SAAberration *threeFold = [SAAberration aberrationWithN:2 M:3 Cnma:0 Cnmb:0];
    SAAberration *coma = [SAAberration aberrationWithN:2 M:1 Cnma:0 Cnmb:0];
    
    // Third order aberrations
    SAAberration *cs =  [SAAberration aberrationWithN:3 M:0 Cnma:6 Cnmb:0];
    SAAberration *thirdstar = [SAAberration aberrationWithN:3 M:2 Cnma:0 Cnmb:0];
    
    SAAberration *fourfold = [SAAberration aberrationWithN:3 M:4 Cnma:0 Cnmb:0];
    
    
    // fourth order aberrations
    SAAberration *fourthcoma = [SAAberration aberrationWithN:4 M:1 Cnma:0 Cnmb:0];
    SAAberration *fourththreelobe = [SAAberration aberrationWithN:4 M:3 Cnma:0 Cnmb:0];
    SAAberration *fivefold = [SAAberration aberrationWithN:4 M:5 Cnma:0 Cnmb:0];
    
    // Fifth order aberrations
    SAAberration *fifthspherical = [SAAberration aberrationWithN:5 M:0 Cnma:0 Cnmb:0];
    SAAberration *fifthstar = [SAAberration aberrationWithN:5 M:2 Cnma:0 Cnmb:0];
    SAAberration *fifthrosette = [SAAberration aberrationWithN:5 M:4 Cnma:0 Cnmb:0];
    SAAberration *sixfold = [SAAberration aberrationWithN:5 M:6 Cnma:0 Cnmb:0];
    
    // Sixth order aberrations
    SAAberration *sixthcoma = [SAAberration aberrationWithN:6 M:1 Cnma:0 Cnmb:0];
    SAAberration *sixththreelobe = [SAAberration aberrationWithN:6 M:3 Cnma:0 Cnmb:0];
    SAAberration *sixthpentacle = [SAAberration aberrationWithN:6 M:5 Cnma:0 Cnmb:0];
    SAAberration *sevenfold = [SAAberration aberrationWithN:6 M:7 Cnma:0 Cnmb:0];
    
    // Seventh order aberrations
    SAAberration *seventhspherical = [SAAberration aberrationWithN:7 M:0 Cnma:0 Cnmb:0];
    SAAberration *seventhstar = [SAAberration aberrationWithN:7 M:2 Cnma:0 Cnmb:0];
    SAAberration *seventhrosette = [SAAberration aberrationWithN:7 M:4 Cnma:0 Cnmb:0];
    SAAberration *seventhchaplet = [SAAberration aberrationWithN:7 M:6 Cnma:0 Cnmb:0];
    SAAberration *eightfold = [SAAberration aberrationWithN:7 M:8 Cnma:0 Cnmb:0];
    
    
    NSMutableDictionary *aberrationsDict = [[NSMutableDictionary alloc] init];
    [aberrationsDict setObject:beamshift forKey:@"A0"];
    [aberrationsDict setObject:defocus forKey:@"C1"];
    [aberrationsDict setObject:cs forKey:@"C3"];
    [aberrationsDict setObject:coma forKey:@"B2"];
    [aberrationsDict setObject:threeFold forKey:@"A2"];
    [aberrationsDict setObject:twoFold forKey:@"A1"];
    [aberrationsDict setObject:seventhchaplet forKey:@"G7"];
    [aberrationsDict setObject:eightfold forKey:@"A7"];
    [aberrationsDict setObject:fourfold forKey:@"A3"];
    [aberrationsDict setObject:fivefold forKey:@"A4"];
    [aberrationsDict setObject:sixfold forKey:@"A5"];
    [aberrationsDict setObject:sixthcoma forKey:@"B6"];
    [aberrationsDict setObject:sixththreelobe forKey:@"D6"];
    [aberrationsDict setObject:sixthpentacle forKey:@"F6"];
    [aberrationsDict setObject:sevenfold forKey:@"A6"];
    [aberrationsDict setObject:seventhrosette forKey:@"R7"];
    [aberrationsDict setObject:seventhstar forKey:@"S7"];
    [aberrationsDict setObject:seventhspherical forKey:@"C7"];
    [aberrationsDict setObject:thirdstar forKey:@"S3"];
    [aberrationsDict setObject:fourththreelobe forKey:@"D4"];
    [aberrationsDict setObject:fifthspherical forKey:@"C5"];
    [aberrationsDict setObject:fifthstar forKey:@"S5"];
    [aberrationsDict setObject:fifthrosette forKey:@"R5"];
    [aberrationsDict setObject:fourthcoma forKey:@"B4"];
    
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:10], NSFontAttributeName,[NSNumber numberWithInt:-1], NSSuperscriptAttributeName,[NSNumber numberWithFloat:3], NSBaselineOffsetAttributeName, nil];
    
	
	defocus.label = @"Defocus";
	
	[cs setMin:0 Max:3E7];
	cs.symRange = NO;
	cs.label = @"Third order spherical";
    
    NSRange labelRange;
    labelRange.length = 1;
    labelRange.location = 1;
    
    NSRange krivRange;
    krivRange.length = 3;
    krivRange.location = 1;
    
    
    
    float rangeScaling = 0.1;
    float maxMin;
    
    for (NSString *key in aberrationsDict) {
        
        SAAberration *ab = [aberrationsDict objectForKey:key];
        
        NSMutableAttributedString *haid = [[NSMutableAttributedString alloc] initWithString:key];
        NSMutableAttributedString *kriv = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"C%d,%d", ab.n, ab.m]];
        
        [haid setAttributes:stringAttributes range:labelRange];
        [kriv setAttributes:stringAttributes range:krivRange];
        
        maxMin = powf(10,ab.n)*rangeScaling;
        
        [ab setMin:-maxMin Max: maxMin];
        [ab setHaiderLabel:haid];
        [ab setKrivanekLabel:kriv];
    }
    
    [defocus setMin:-.05 Max:.05];
    
    
    //[thirdsphericalHaider setAttributes:stringAttributes range:labelRange];
    //[defocusHaider setAttributes:stringAttributes range:labelRange];
    
    
    //NSMutableAttributedString *c3Label = [sphericalLetter copy];
    
    //[c3Label appendAttributedString:order3];
    //[c3Label setAttributes:stringAttributes range:labelRange];
    
    //defocus.haiderLetter = [haiderLabels objectForKey:@"c1"];
    //cs.haiderLetter = thirdsphericalHaider;
    //twoFold.haiderLetter = twofoldHaider;
    
    
    
    
    // fifthspherical.letter = [spherical stringByAppendingString:[NSString stringWithFormat: @"%d", fifthspherical.n ]];
	
	//[twoFold setMin:-2000 Max:2000];
	twoFold.label = @"2 fold astigmatism";
	
	//[threeFold setMin:-5000 Max:5000];
    
	threeFold.label = @"3 fold astigmatism";
    
	//[coma setMin:-50 Max:50];
	beamshift.label = @"Beam Shift";
	coma.label = @"Second Order Coma";
    thirdstar.label = @"Third Order Star";
    fourfold.label = @"Fouth Fold Astigmatism";
    fourthcoma.label = @"Fourth Order Coma";
    fourththreelobe.label = @"Fourth Order Three Lobe";
    fivefold.label = @"Five Fold Astigmatism";
    fifthspherical.label = @"Fifth Order Spherical";
    fifthstar.label = @"Fifth Order Star";
    fifthrosette.label = @"Fifth Order Rosette";
    sixfold.label = @"Sixth Fold Astigmatism";
    sixthcoma.label = @"Sixth Coma";
    sixththreelobe.label = @"Sixth Order Three Lobe";
    sixthpentacle.label = @"Sixth Order Pentacle";
    sevenfold.label = @"Seventh Fold Astigmatism";
    seventhchaplet.label = @"Seventh Order Chaplet";
    seventhspherical.label = @"Seventh Order Spherical";
    seventhrosette.label = @"Seventh Order Rosette";
    eightfold.label = @"Eighth Fold Astigmatism";
    seventhstar.label = @"Seventh Order Star";
	
	[abController addObject:defocus];
	[abController addObject:beamshift];
    
    [abController addObject:twoFold];
    
    [abController addObject:threeFold];
    [abController addObject:coma];
    
	[abController addObject:cs];
    [abController addObject:thirdstar];
    [abController addObject:fourfold];
    
    [abController addObject:fourthcoma];
    [abController addObject:fourththreelobe];
    [abController addObject:fivefold];
    
    [abController addObject:fifthspherical];
    [abController addObject:fifthstar];
    [abController addObject:fifthrosette];
    [abController addObject:sixfold];
    
    [abController addObject:sixthcoma];
    [abController addObject:sixththreelobe];
    [abController addObject:sixthpentacle];
    [abController addObject:sevenfold];
    [abController addObject:seventhchaplet];
    [abController addObject:seventhspherical];
    [abController addObject:seventhrosette];
    [abController addObject:seventhstar];
	[abController addObject:eightfold];
	
	[defocus release];
	[cs release];
	[twoFold release];
	
	// Setup the probe with some initial general parameters for a standard microscope
	
	NSArray *abs = [abController arrangedObjects];
	
	
	[abs release];
	[beamEnergy setFloatValue:300];
	[apSize setFloatValue:25];	
    
    probe = [SAProbe probeWithAberrations:abs RealSize:realSize.width ApertureSize:[apSize floatValue] Lambda:.0197 Pixels: pixels];
    
	
}


- (void) preparePotential{
	
	// Setup a potential to form the ronchigram - only needs updating in the case of 
	
	if (potential == nil || hrPotential == nil) {
		potential = [[SAPotential alloc] initWithPixels:pixels RealSize:realSize];
		hrPotential = [[SAPotential alloc] initWithPixels:hrPixels RealSize:hrRealSize];
	}
	
	[hrPotential setRealSize:hrRealSize];
	[potential setRealSize:realSize];
	
	if(isAmorphous){
		[hrPotential setRealSize:hrRealSize];
		[hrPotential randomPotentialWithDensity:5 withZ:6];
		//[potential randomPotentialWithDensity:5 withZ:6];
		[potential potentialWithAtoms:[hrPotential atoms]];
		
	}else{
		[potential orderedPotentialWithSpacingA:3 SpacingB:3 Z:6];
		[hrPotential orderedPotentialWithSpacingA:3 SpacingB:3 Z:6]; 
	}
	
}


#pragma mark Image view setup
#pragma mark -

- (CGImageRef) CGImageRefWithMatrix:(SAMatrix*) matrixToImage{
	
	[matrixToImage retain];

	
	int arraySize = [matrixToImage arraySize];
	
	double maxValue = [matrixToImage maxValue];
	double minValue = [matrixToImage minValue];
	
	int numRows = [matrixToImage numRows];
	int numColumns = [matrixToImage numColumns];
	
	int i;
	
	short *matrix = (short*) calloc(numRows*numColumns, sizeof(short));
    
	for(i = 0; i < arraySize; i++){
		matrix[i] = (short)(([matrixToImage valueAtArrayIndex:i] - minValue)/(maxValue - minValue)*65535.0);
	}
	
	size_t numBytes = sizeof(short)*arraySize;
	
	CGDataProviderRef theProvider = CGDataProviderCreateWithData(NULL,  matrix, numBytes, NULL);
	CGImageRef matrixImage = CGImageCreate([matrixToImage numColumns], 
                                           [matrixToImage numRows], 
                                           16, 
                                           16, 
                                           sizeof(short)*[matrixToImage numColumns], 
                                           colorSpace, 
                                           kCGBitmapByteOrder16Host,
                                           theProvider, 
                                           NULL,
                                           true, 
                                           kCGRenderingIntentDefault);
	
	[matrixToImage release];
	
	free(matrix);
	
	CGDataProviderRelease(theProvider);
	
	return matrixImage;
}

- (void) reloadViewWithMatrix: (SAMatrix*) matrixToView{
	
	[CATransaction begin];
	//[CATransaction setDisableActions:YES];
	
	CGImageRef matrixImage  = [self CGImageRefWithMatrix:matrixToView];
	
	
	[saView setImageWithCGImageRef:matrixImage];
    
	[CATransaction commit];	
	
	CGImageRelease(matrixImage);
	
}


- (void) viewNeedsUpdate:(id) sender{
	
	NSInteger selected = [viewSelectSeg selectedSegment];
    
	SAMatrix *newViewMatrix;
	
	SAComplexMatrix *wave;
	SAComplexMatrix *ap;
    SAComplexMatrix *conjMatrix;
	SAComplexMatrix *newComplexMatrix;
	
	if(isSliding == YES){
		[probe resizeProbeTo:pixels RealSize:realSize];
        [probe setScrollCalc:TRUE];
	}
	else {
		[probe resizeProbeTo:hrPixels RealSize:hrRealSize];
        [probe setScrollCalc:FALSE];
	}
	
	
	switch (selected) {
		case 0:
            
			[probe calculateProbe];
			[self calculateRonchigram];
            
			conjMatrix = [[SAComplexMatrix alloc] initWithSameSizeAs:ronchigram];
			newComplexMatrix = [[SAComplexMatrix alloc] initWithSameSizeAs:ronchigram];
			
			// Determine conjugate
			[ronchigram conjugateToResult:conjMatrix];
			// Intensity distribution 
			[conjMatrix elementMultiplyWith:ronchigram Result:newComplexMatrix];
			newViewMatrix = [newComplexMatrix realPart];
			
			break;
            
		case 1:
			
			if(isSliding == YES){
				[probe resizeProbeTo:pixels RealSize:realSize];
			}
			else {
				[probe resizeProbeTo:hrPixels RealSize:realSize];
			}
			
			[probe calculateProbe];
			
			wave = [probe wavefunction];
			
			
			[fftController fftShift:wave];
			
			conjMatrix = [[SAComplexMatrix alloc] initWithSameSizeAs:wave];
			newComplexMatrix = [[SAComplexMatrix alloc] initWithSameSizeAs:wave];
			
			[wave conjugateToResult:conjMatrix];
			[conjMatrix elementMultiplyWith:wave Result:newComplexMatrix];
			
			[fftController fftShift:wave];
			
			newViewMatrix = [newComplexMatrix realPart];
			
			break;
		case 2:
			
			if(isSliding == YES){
				[probe resizeProbeTo:pixels RealSize:realSize];
			}
			else {
				[probe resizeProbeTo:hrPixels RealSize:hrRealSize];
			}
			
			[probe calculateProbe];
            
			ap = [probe aperture];	
            
			conjMatrix = [[SAComplexMatrix alloc] initWithSameSizeAs:ap];
			newComplexMatrix = [[SAComplexMatrix alloc] initWithSameSizeAs:ap];
			
			[fftController fftShift:ap];
			
			newViewMatrix = [ap realPart];
			
			[fftController fftShift:ap];
            
			break;
			
        case 3:
            isSliding = YES;
            [probe resizeProbeTo:pixels RealSize:realSize];
            [probe calculateProbe];
			[self calculateRonchigram];
            [probe setScrollCalc:FALSE];
//            if(isSliding == YES){
//				[probe resizeProbeTo:pixels RealSize:realSize];
//                [probe setScrollCalc:FALSE];
//			} else {
//				[probe resizeProbeTo:hrPixels RealSize:hrRealSize];
//			}
            
			conjMatrix = [[SAComplexMatrix alloc] initWithSameSizeAs:[probe wavefunction]];
			newComplexMatrix = [[SAComplexMatrix alloc] initWithSameSizeAs:[probe wavefunction]];
            SAComplexMatrix *convolutionImageMatrix = [[SAComplexMatrix alloc] initWithSameSizeAs:[probe wavefunction]];
            SAFFTController *fftPotController;
            fftPotController = [[SAFFTController alloc] initWithInput: [potential potential] Output: newComplexMatrix];
//            if(isSliding == YES){
//                fftPotController = [[SAFFTController alloc] initWithInput: [potential potential] Output: newComplexMatrix];
//                
//			} else {
//                fftPotController = [[SAFFTController alloc] initWithInput: [hrPotential potential] Output: newComplexMatrix];
//                
//			}
            
            SAFFTController *fftPotPrbController = [[SAFFTController alloc] initWithInput: conjMatrix Output: convolutionImageMatrix];
			
            [fftPotController forwardTransform];
            [newComplexMatrix elementMultiplyWith:[probe aperture] Result: conjMatrix];
            [fftPotPrbController reverseTransform];
            
            newViewMatrix = [convolutionImageMatrix abs];
            isSliding = NO;
            break;
            
		default:
			break;
            
	}
	
	[self reloadViewWithMatrix:newViewMatrix];
    
	[newComplexMatrix release];
	[conjMatrix release];
	[newViewMatrix release];
	
}

#pragma mark -
#pragma mark Change Parameters

- (IBAction) resetAberration:(id) sender{
	
	NSArray *selected = [abController selectedObjects];
	
	
	NSUInteger i, count = [selected count];
	
	for (i = 0; i < count; i++) {
		SAAberration * ab = [selected objectAtIndex:i];
		ab.Cnma=0;
		ab.Cnmb=0;
	}
    
	[probe setAberrations:[abController arrangedObjects]];
    
	[self viewNeedsUpdate:nil];
	
}
/*
 *also recalculates the potential.
 *called by the max Sampeling pixels drop box.
 *
 */
- (IBAction) changeResolution: (id) sender{
	
	NSInteger selected = [[sender selectedItem] tag];
	
	int newSqSize;
	
	switch (selected) {
            
		case 0:
			newSqSize = 256;			
			break;
            
		case 1:
			newSqSize= 512;
			break;
			
		case 2:
			newSqSize=1024;
			break;
            
		default:
			break;
	}
	
	// Realspace image size for when the sliders stop when viewing the ronchigram and phase plate
	hrRealSize.width = (float) newSqSize/hrPixels.width * (float) hrRealSize.width;
	hrRealSize.height = (float) newSqSize/hrPixels.height * (float) hrRealSize.height;
	
	// New number of pixels
	hrPixels = NSMakeSize(newSqSize, newSqSize);
	
	// Update the potential pixels
	SAComplexMatrix *potMatrix = [hrPotential potential];
	[potMatrix resizeToI:hrPixels.height byJ:hrPixels.width];
	
    
	[hrPotential setRealSize:hrRealSize];
	
	if(isAmorphous){
		[hrPotential randomPotentialWithDensity:5 withZ:6];		
	}else{
		[hrPotential orderedPotentialWithSpacingA:3 SpacingB:3 Z:6]; 
	}
    
	[self viewNeedsUpdate:nil];
	
	
}

- (IBAction) changeAbLabel: (id) sender{
	
	NSArray *selected = [abController selectedObjects];
	
	
	NSUInteger i, count = [selected count];
	
	for (i = 0; i < count; i++) {
		SAAberration * ab = [selected objectAtIndex:i];
		ab.label= [sender stringValue];
	}
    
	//[probe setAberrations:[abController arrangedObjects]];	
}


- (IBAction) changeAberration:(id) sender{
	
	NSInteger selected;
    
	if([sender isKindOfClass:[NSSegmentedControl class]]){
		
		selected = [sender selectedSegment];
		
		switch (selected) {
			case 0:
				[abController add:nil];
				[nc postNotification:[NSNotification notificationWithName:kRonchigramNeedsUpdate object: nil]];
				break;
                
			case 1:
				[abController remove:nil];
				[nc postNotification:[NSNotification notificationWithName:kRonchigramNeedsUpdate object: nil]];
				break;
                
		}
		
	}
	
	isSliding = YES;
    
	[self viewNeedsUpdate:nil];
	
	SEL sel = @selector( sliderDone: );
	[NSObject cancelPreviousPerformRequestsWithTarget: self selector:
	 sel object: sender];
	[self performSelector: sel withObject: sender afterDelay: 0.0];
    
    [aberrationTable reloadData];
	
}

// Annoying but necessary to get the textfields to update the view after changing values

- (BOOL) control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
	
	[self changeAberration:nil];
	return YES;
	
}

- (IBAction) changeAberrationRange: (id) sender{
	
	SAAberration *selectedAb = [[abController selectedObjects] objectAtIndex:0];
	
	if([selectedAb symRange] == YES){
		
		if ([sender tag] ==0) {
			selectedAb.max= [sender floatValue] * (-1);
            
		}else{
			selectedAb.min = [sender floatValue]* (-1);
            
		}
		
	}
}

- (void) sliderDone: (id) sender{
    
        isSliding = NO;
	
	//[probe calculateProbe];
	[nc postNotification:[NSNotification notificationWithName:kRonchigramNeedsUpdate object: nil]];
}

- (IBAction) changeWavelength:(id) sender{
	
	double energy;
	double length;
	
	energy = [sender doubleValue]*1000;
	
	length = 12.2639 / sqrt(energy + 0.97845e-6*energy*energy);;
	
	
	[probe setLambda: length];
	//[hrProbe setLambda:length];
	[probe calculateProbe];
	//[hrProbe calculateProbe];
	[self viewNeedsUpdate:nil];
	
}


- (IBAction) changeApertureSize: (id) sender{
	
	[probe setApertureSize:[sender floatValue]];
	
	[nc postNotification:[NSNotification notificationWithName:kRonchigramNeedsUpdate object: nil]];
    
	
}
//Changes the sample area.
- (IBAction) changeRealViewSize: (id) sender{
	
	if(realSize.width != [sender floatValue]){
        
		realSize = NSMakeSize([sender floatValue], [sender floatValue]);
		hrRealSize = NSMakeSize([sender floatValue]*2.0, [sender floatValue]*2.0);	
		
		[self preparePotential];
        
		[nc postNotification:[NSNotification notificationWithName:kRonchigramNeedsUpdate object: nil]];
        
	}
    
}
/**
 * This changes the style from amorphous to crystaline based on user input. 
 */
- (IBAction) changePotentialType: (id) sender{
	
	if([sender class] == [NSPopUpButton class]){
		
		if([sender indexOfSelectedItem]==0 && isAmorphous == NO){
			isAmorphous = YES;
			[self preparePotential];
            
		}else if([sender indexOfSelectedItem] ==1 && isAmorphous == YES) {
			isAmorphous = NO;
			[self preparePotential];
            
		}
		
		[nc postNotification:[NSNotification notificationWithName:kRonchigramNeedsUpdate object: nil]];
	}
	
}


- (void)windowWillClose:(NSNotification *)aNotification {
	[NSApp terminate:self];
}

- (IBAction) switchNotation:(id)sender{
    
    
    NSTableColumn *notationColumn = [aberrationTable tableColumnWithIdentifier:@"notation"];
    NSTableColumn *aCoeffColumn = [aberrationTable tableColumnWithIdentifier:@"aCoeff"];
    NSTableColumn *bCoeffColumn = [aberrationTable tableColumnWithIdentifier:@"bCoeff"];
    NSDictionary *currentBindings = [notationColumn infoForBinding:@"value"];
    
    
    
    NSString *current = [currentBindings objectForKey:NSObservedKeyPathKey];
    
    if ([current isEqualToString:@"arrangedObjects.krivanekLabel"]) {
        [notationColumn bind:@"value" toObject:abController withKeyPath:@"arrangedObjects.haiderLabel" options:nil];
        [aCoeffColumn bind:@"value" toObject:abController withKeyPath:@"arrangedObjects.mag" options:textCellOpts];
        [bCoeffColumn bind:@"value" toObject:abController withKeyPath:@"arrangedObjects.angle" options:textCellOpts];
        [[notationColumn headerCell] setStringValue:@"Haider"];
        [[aCoeffColumn headerCell] setStringValue:@"C (µm)"];
        [[bCoeffColumn headerCell] setStringValue:@"θ (º)"];
        
        
    }else{
        [notationColumn bind:@"value" toObject:abController withKeyPath:@"arrangedObjects.krivanekLabel" options:nil];
        [aCoeffColumn bind:@"value" toObject:abController withKeyPath:@"arrangedObjects.Cnma" options:textCellOpts];
        [bCoeffColumn bind:@"value" toObject:abController withKeyPath:@"arrangedObjects.Cnmb" options:textCellOpts];
        [[notationColumn headerCell] setStringValue:@"Krivanek"];
        [[aCoeffColumn headerCell] setStringValue:@"Ca (µm)"];
        [[bCoeffColumn headerCell] setStringValue:@"Cb (µm)"];
        
    }
    
    [aberrationTable reloadData];
    
}


@end
