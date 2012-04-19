//
//  SAImageView.h
//  ronchigram
//
//  Created by James LeBeau on 6/18/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@interface SAImageView : NSView {

	CALayer *rootLayer;
	CALayer *imageLayer;
	
}

- (void) awakeFromNib;
- (void) setupLayers;

- (void) setImageWithCGImageRef: (CGImageRef) imageRef;

@end
