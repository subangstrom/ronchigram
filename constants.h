/*
 *  constants.h
 *  ronchigram
 *
 *  Created by James LeBeau on 5/27/10.
 *  Copyright 2010 subangstrom. All rights reserved.
 *
 */

// Probe constants
#define kSAApertureSize @"SAApertureSize"
#define kSARealSize @"SARealSize"

// Aberration Constants
#define kSAn @"SAn"
#define kSAm @"SAm"
#define kSACnma @"SACnma"
#define kSACnmb @"SACnmb"

#define kProbeNeedsUpdate @"probeNeedsUpdate"
#define kRonchigramNeedsUpdate @"ronchigramNeedsUpdate"

#define kSAPotCenterX @"potCenterX"
#define kSAPotCenterY @"potCenterY"
#define kSAAtomicNumber @"atomicNumber"

#define kSAMatrixDidChangeNotification @"matrixDidChange"



typedef struct _SARange {
	NSUInteger minimum;
	NSUInteger maximum;
} SARange;
