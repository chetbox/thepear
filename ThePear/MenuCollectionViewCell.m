//
//  MenuCollectionViewCell.m
//  ThePear
//
//  Created by Tom Dixon on 24/11/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@implementation MenuCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor colorWithRed:(101.0f/255.0f)
                                               green:(195.0f/255.0f)
                                                blue:(211.0f/255.0f)
                                               alpha:0.9f];
    }
    
    return self;
}

@end
