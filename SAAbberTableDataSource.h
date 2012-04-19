//
//  SAAbberTableDataSource.h
//  ronchigram
//
//  Created by James LeBeau on 5/28/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SAProbe.h"
#import "constants.h"


@interface SAAbberTableDataSource : NSObject <NSTableViewDataSource> {
	
	NSMutableArray *aberrationArray;
	NSNotificationCenter *nc;
	
}

- (void) setAberrationArrayWithProbe:(SAProbe*) probe;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(NSInteger)rowIndex;

@end
