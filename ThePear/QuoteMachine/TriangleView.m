//
//  TriangleView.m
//  ThePear
//
//  Created by Adam Cudworth on 07/12/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // top right
    CGContextAddLineToPoint(ctx, CGRectGetMidX(rect) - 13, CGRectGetMaxY(rect));  // bottom slightly left of mid
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 0.4325, 0.4431, 0.4314, 1);
    CGContextFillPath(ctx);
    
}


@end
