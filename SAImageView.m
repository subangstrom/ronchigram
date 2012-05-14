//
//  SAImageView.m
//  ronchigram
//
//  Created by James LeBeau on 6/18/10.
//  Copyright 2010 subangstrom. All rights reserved.
//

#import "SAImageView.h"


@implementation SAImageView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void) awakeFromNib{
	
	[self setupLayers];
	[self setAutoresizesSubviews:YES];
	
}
- (void) setupLayers{
		
	CGColorRef blackColor=CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f);
	
	rootLayer = [CALayer layer];
	
	rootLayer.backgroundColor = blackColor;
	rootLayer.autoresizingMask = (kCALayerWidthSizable + kCALayerHeightSizable);
	rootLayer.contentsGravity = kCAGravityResizeAspect;
	
	CGColorRelease(blackColor);
	
	imageLayer = [CALayer layer];
	
	[rootLayer addSublayer:imageLayer];
	
	[imageLayer setAutoresizingMask: (kCALayerHeightSizable + kCALayerWidthSizable) ];
	imageLayer.contentsGravity = kCAGravityResizeAspect;
	
	[self setLayer:rootLayer];
	[self setWantsLayer:YES];
	


}

- (void) setImageWithCGImageRef: (CGImageRef) imageRef{
	
	/*CGRect newFrame = rootLayer.frame;	
	CGSize newSize = newFrame.size;
	
	newFrame.size.width = 256;
	newFrame.size.height = 256;*/
	
	imageLayer.contents = imageRef;
	imageLayer.frame = rootLayer.frame;
	
}


- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}


@end
