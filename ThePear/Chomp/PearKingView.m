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
@property (nonatomic, assign) CGFloat percentageOffset;
@property (nonatomic, assign) CGFloat currentEatenPercentage;

@end

@implementation PearKingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.pearImage = [UIImage imageNamed:@"pear-king"];
        self.pearMaskImage = [UIImage imageNamed:@"pear-king-mask"];
        self.chomps = [NSMutableArray new];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *pearTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pearTapped:)];
        pearTap.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:pearTap];
    }
    
    return self;
}

- (void)calculateInitialPercentages {
    
}

- (void)pearTapped:(UITapGestureRecognizer *)recog {
    
    CGPoint chompLocation = [recog locationInView:self];
    CGFloat chompDiam = arc4random_uniform(8) + 20;
//    UIView *chompView = [[UIView alloc] initWithFrame:CGRectMake(chompLocation.x - (chompDiam / 2), chompLocation.y - (chompDiam / 2), chompDiam, chompDiam)];
//    chompView.layer.cornerRadius = (chompDiam / 2);
//    chompView.backgroundColor = [UIColor whiteColor];
    
//    [self.pearKing addSubview:chompView];
    
    CGRect chompRect = CGRectMake(chompLocation.x - (chompDiam / 2), chompLocation.y - (chompDiam / 2), chompDiam, chompDiam);
    [self.chomps addObject:[NSValue valueWithCGRect:chompRect]];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [self.pearImage drawInRect:rect];
    
    for (NSValue *chomp in self.chomps) {
        CGRect chompRect = chomp.CGRectValue;
        
//        if (CGRectIntersectsRect(rect, chompRect)) {
            CGContextAddEllipseInRect(ctx, chompRect);
            CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGContextFillPath(ctx);
//        }
    }
}

@end
