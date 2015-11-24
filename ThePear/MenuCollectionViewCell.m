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
        self.backgroundColor = [UIColor colorWithRed:(230.0f/255.0f) green:(230.0f/255.0f) blue:(230.0f/255.0f) alpha:1.0f];
    }
    
    return self;
}

@end
