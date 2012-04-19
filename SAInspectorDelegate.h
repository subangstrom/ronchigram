//
//  inspectorDelegate.h
//  ronchigram
//
//  Created by James LeBeau on 7/19/10.
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

@interface SAInspectorDelegate : NSObject {
	
	IBOutlet NSPanel *inspectorPanel;
	IBOutlet NSTabView *tabView;
	IBOutlet NSComboBox *elementsCombo;
	IBOutlet NSSegmentedControl *selector;
}

- (IBAction) changeInspectorSelection:(NSSegmentedControl*) sender;


@end
