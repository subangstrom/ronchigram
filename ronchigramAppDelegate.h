//
//  ronchigramAppDelegate.h
//  ronchigram
//
//  Created by James LeBeau on 5/21/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "SAMatrix.h"
#import "SAProbe.h"
#import "SAComplexMatrix.h"
#import "SAAbberTableDataSource.h"
#import "SAPotential.h"
#import "SAFFTController.h"
#import <complex.h>
#import "fftw3.h"
#import "SANotationTransformer.h"
#import "SAImageView.h"

@interface ronchigramAppDelegate : NSObject <NSApplicationDelegate> {
    
	NSWindow *window;
	NSNotificationCenter *nc;
	
	NSSize pixels, realSize, hrPixels, hrRealSize;
	
	NSDictionary *textCellOpts;
	NSDictionary *sliderCellOpts;
	
	float apertureSize;
	float lambda;
    bool image;
	
	CGColorSpaceRef colorSpace;
	
	SAPotential *potential;
	SAPotential *hrPotential;
    
	SAProbe *probe;
    
	
	SAComplexMatrix *ronchigram;
	SAComplexMatrix *prbPotPrd;
	
	SAFFTController *fftController;
    
    SANotationTransformer *noteTranform;
	
	bool isAmorphous;
	bool isSliding;
	
	IBOutlet NSTextField *viewSize;
	IBOutlet NSTextField *apSize;
	IBOutlet NSTextField *wavelength;
	IBOutlet NSTextField *beamEnergy;
	IBOutlet NSSegmentedControl *viewSelectSeg;
	IBOutlet NSArrayController *abController;
	IBOutlet SAImageView *saView;
	IBOutlet NSTableView *aberrationTable;
    
    
}

@property (assign) IBOutlet NSWindow *window;

- (void) prepareProbe;
- (void) preparePotential;

- (IBAction) changeAberrationRange: (id) sender;
- (IBAction) changeAberration:(id) sender;
- (IBAction) changeApertureSize:(id) sender;
- (IBAction) changeRealViewSize: (id) sender;
- (IBAction) changeWavelength:(id) sender;
- (IBAction) changeAbLabel: (id) sender;
- (IBAction) changeResolution: (id) sender;
- (IBAction) changePotentialType: (id) sender;

- (IBAction) changeSpecimenType: (id) sender;

- (IBAction) viewNeedsUpdate: (id) sender;

- (IBAction) resetAberration:(id) sender;

- (IBAction) switchNotation:(id)sender;

- (void) reloadViewWithMatrix: (SAMatrix*) matrixToView;
- (CGImageRef) CGImageRefWithMatrix:(SAMatrix*) matrixToImage;


@end
