//
//  ChompViewController.m
//  ThePear
//
//  Created by Tom Dixon on 29/11/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import "ChompViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PearKingView.h"

@interface ChompViewController ()

@property (nonatomic, strong) UILabel *score;
@property (nonatomic, strong) UIImageView *mbLeft;
@property (nonatomic, strong) UIImageView *mbRight;
@property (nonatomic, strong) PearKingView *pearKing;

@end

@implementation ChompViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.score = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 74.0f, 200.0f, 40.0f)];
    self.score.font = [UIFont systemFontOfSize:18.0f];
    self.score.backgroundColor = [UIColor clearColor];
    
    UIImage *mbLeft = [UIImage imageNamed:@"mb-left"];
    UIImage *mbRight = [UIImage imageNamed:@"mb-right"];
    
    self.mbLeft = [[UIImageView alloc] initWithImage:mbLeft];
    self.mbRight = [[UIImageView alloc] initWithImage:mbRight];
    self.pearKing = [[PearKingView alloc] initWithFrame:CGRectMake(3.5f, 289.0f, 158.5f, 232.0f)];

    self.mbLeft.frame = CGRectMake(126.5f, 346.0f, 248.5f, 346.0f);
    self.mbRight.frame = CGRectMake(126.5f, 346.0f, 248.5f, 346.0f);
    
    [self.view addSubview:self.score];
    [self.view addSubview:self.mbLeft];
    [self.view addSubview:self.mbRight];
    [self.view addSubview:self.pearKing];
    
    self.mbLeft.hidden = YES;
}

- (void)updateScore {
    CGFloat surfaceEaten = [self surfaceEaten];
    int scorePercentage = (int)(surfaceEaten * 100);
    self.score.text = [NSString stringWithFormat:@"Score: %d%%", scorePercentage];
}

- (CGFloat)surfaceEaten {
    UIView *hitTest;
    
    CGFloat total = 0;
    CGFloat eaten = 0;
    
    for (int i = 0; i < self.pearKing.frame.size.height; i++) {
        for (int j = 0; j < self.pearKing.frame.size.width; j++) {
            hitTest = [self.pearKing hitTest:CGPointMake(i, j) withEvent:nil];
            
            if (![hitTest isKindOfClass:[UIImageView class]]) {
                eaten++;
            }
            
            total++;
        }
    }
    
    return eaten / total;
}

@end
