//
//  inspectorDelegate.m
//  ronchigram
//
//  Created by James LeBeau on 7/19/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import "SAInspectorDelegate.h"


@implementation SAInspectorDelegate


- (void) awakeFromNib 
{
			
	float newHeight,delta;
	
	newHeight =200.0;

	NSRect newFrame = [inspectorPanel frame];
	NSSize newSize = newFrame.size;
	NSPoint newOrigin = newFrame.origin;
	
	
	delta = newSize.height - newHeight;
	newSize.height = newHeight;
	newOrigin.y += delta;
	
	newFrame.size = newSize;
	newFrame.origin = newOrigin;
	
	NSArray *elementsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"elementData" ofType:@"plist"]];

	
	for (NSDictionary *elementDict in elementsArray) {
		[elementsCombo addItemWithObjectValue:[elementDict objectForKey:@"SAElementName"]]; 
	}
	
	[selector selectSegmentWithTag:0];
	[tabView selectTabViewItemAtIndex:0];
	[inspectorPanel setFrame:newFrame display:NO];

}


- (IBAction) changeInspectorSelection:(NSSegmentedControl*) sender{
	
	NSInteger selected, current;
	
	float newHeight,delta;
	
	selected = [sender selectedSegment];
	current = [tabView indexOfTabViewItem:[tabView selectedTabViewItem]];

	if([sender isKindOfClass:[NSSegmentedControl class]] && current!=selected){
		
		
		[tabView selectTabViewItemAtIndex:selected];

		NSRect newFrame = [inspectorPanel frame];
		NSSize newSize = newFrame.size;
		NSPoint newOrigin = newFrame.origin;
		
		switch (selected) {
			case 0:
				newHeight = 200.0;	
				break;
			case 1:
				newHeight = 300.0;
				break;
			case 2:
				newHeight = 350.0;
		}
		
		delta = newSize.height - newHeight;
		newSize.height = newHeight;
		newOrigin.y += delta;
		
		newFrame.size = newSize;
		newFrame.origin = newOrigin;
		
		
		[inspectorPanel setFrame:newFrame display:YES animate:YES];		
		 
		
	}
	
}

@end
