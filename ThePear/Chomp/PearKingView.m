//
//  PearKingView.m
//  ThePear
//
//  Created by Tom Dixon on 07/12/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import "PearKingView.h"
#import <QuartzCore/QuartzCore.h>

@interface PearKingView ()

@property (nonatomic, strong) NSMutableArray *chomps;
@property (nonatomic, strong) UIImage *pearImage;
@property (nonatomic, strong) UIImage *pearMaskImage;
@property (nonatomic, assign) NSUInteger startingEatenPixels;
@property (nonatomic, assign) NSUInteger currentEatenPixels;
@property (nonatomic, assign) NSUInteger totalPixels;

@end

@implementation PearKingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.pearImage = [UIImage imageNamed:@"pear-king"];
        self.pearMaskImage = [UIImage imageNamed:@"pear-king-mask"];
        self.chomps = [NSMutableArray new];
        self.chompsAllowed = YES;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *pearTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pearTapped:)];
        pearTap.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:pearTap];
        
        [self calculateInitialPercentages];
    }
    
    return self;
}

- (void)calculateInitialPercentages {
    
//    CGImageRef imageRef = self.pearMaskImage.CGImage;
//    NSUInteger imageWidth = CGImageGetWidth(imageRef);
//    NSUInteger imageHeight = CGImageGetHeight(imageRef);
    
//    self.totalPixels = imageWidth * imageHeight;
    self.startingEatenPixels = [self currentEatenPixels];
    self.currentEatenPixels = self.startingEatenPixels;
}

- (CGFloat)offsetEatenPercentage {
    return (CGFloat)(self.currentEatenPixels - self.startingEatenPixels) / (CGFloat)(self.totalPixels - self.startingEatenPixels);
}

- (void)chompAddedAt:(CGRect)chompRect {
    
    // Before - count eaten pixels
    NSUInteger before = [self currentEatenPixels];
    
    // Draw chomp circle onto image
    UIGraphicsBeginImageContextWithOptions(self.pearMaskImage.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    UIImage *image = self.pearMaskImage;
    CGRect imageRect = CGRectMake(0,0, self.pearMaskImage.size.width, self.pearMaskImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -imageRect.size.height);
    CGContextDrawImage(context, imageRect, image.CGImage);
    CGContextRestoreGState(context);
    
    CGContextAddEllipseInRect(context, chompRect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    self.pearMaskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // After - count eaten pixels
    NSUInteger after = [self currentEatenPixels];
    
    self.currentEatenPixels += (after - before);
}

- (NSUInteger)currentEatenPixels
{
    // Count eaten pixels
    NSUInteger whitePixels = 0;
    NSUInteger totalPixels = 0;
    
    CGImageRef imageRef = self.pearMaskImage.CGImage;
    NSUInteger imageWidth = CGImageGetWidth(imageRef);
    NSUInteger imageHeight = CGImageGetHeight(imageRef);
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    for (NSUInteger x = 0; x < imageWidth; x++) {
        for (NSUInteger y = 0; y < imageHeight; y++) {
            NSUInteger pixelInfo = ((imageWidth * y) + x) * 4; // The image is png
            
            UInt8 red = data[pixelInfo];
            UInt8 alpha = data[pixelInfo+3];
            
            // White pixel
            if (alpha > 0) {
                totalPixels++;
                
                if (red > 0) {
                    whitePixels++;
                }
            }
        }
    }
    
    CFRelease(pixelData);
    
    self.totalPixels = totalPixels;
    
    return whitePixels;
}

- (void)pearTapped:(UITapGestureRecognizer *)recog {
    
    if (self.chompsAllowed) {
        CGPoint chompLocation = [recog locationInView:self];
        CGFloat chompDiam = arc4random_uniform(15) + 30;
        
        CGRect chompRect = CGRectMake(chompLocation.x - (chompDiam / 2), chompLocation.y - (chompDiam / 2), chompDiam, chompDiam);
        [self.chomps addObject:[NSValue valueWithCGRect:chompRect]];
        
        [self chompAddedAt:chompRect];
        [self.delegate pearChomped];
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [self.pearImage drawInRect:rect];
    
    for (NSValue *chomp in self.chomps) {
        CGRect chompRect = chomp.CGRectValue;
        
        CGContextAddEllipseInRect(ctx, chompRect);
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillPath(ctx);
    }
}

@end
