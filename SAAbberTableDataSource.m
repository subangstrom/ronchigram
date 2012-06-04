//
//  SAAbberTableDataSource.m
//  ronchigram
//
//  Created by James LeBeau on 5/28/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import "SAAbberTableDataSource.h"


@implementation SAAbberTableDataSource

- (id) init
{
	self = [super init];
	if (self != nil) {
		nc = [NSNotificationCenter defaultCenter];
	}
	return self;
}


- (void) setAberrationArrayWithProbe: (SAProbe*) probe{
	
	aberrationArray = [probe aberrations];
	
}
/**
 * This dectermines the number of rows in the table by returning the number of abberations.
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
	
	return (NSInteger) [aberrationArray count]; 
	
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
	

	SAAberration *aberration = [aberrationArray objectAtIndex:rowIndex];
	
	return [aberration aberrationForKey:[aTableColumn identifier]];
	
}

- (void)tableView:(NSTableView *)aTableView 

   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(NSInteger)rowIndex{
	
	SAAberration *aberration = [aberrationArray objectAtIndex:rowIndex];
	
	[aberration setAberration:anObject ForKey:[aTableColumn identifier]];
	
	
	[nc postNotification:[NSNotification notificationWithName:kProbeNeedsUpdate object: nil]];
	
	
}

@end
