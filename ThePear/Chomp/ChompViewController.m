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

typedef NS_ENUM(NSUInteger, GameState) {
    GameStateEating,
    GameStateFailed,
    GameStateSucceeded
};

#define ARC4RANDOM_MAX      0x100000000
#define MB_TURN_DELAY_MIN   0.5
#define MB_TURN_DELAY_MAX   5.0
#define MB_LOOK_DURATION_MIN   0.5
#define MB_LOOK_DURATION_MAX   3.0


@interface ChompViewController () <PearKingViewDelegate>

@property (nonatomic, strong) UILabel *score;
@property (nonatomic, strong) UIImageView *mbLeft;
@property (nonatomic, strong) UIImageView *mbRight;
@property (nonatomic, strong) PearKingView *pearKing;
@property (nonatomic, assign) BOOL mbLookingLeft;
@property (nonatomic, assign) GameState gameState;

@end

@implementation ChompViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
}

- (void)setupViews {
    
    self.gameState = GameStateEating;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.score = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 74.0f, 200.0f, 40.0f)];
    self.score.font = [UIFont systemFontOfSize:18.0f];
    self.score.backgroundColor = [UIColor clearColor];
    
    UIImage *mbLeft = [UIImage imageNamed:@"mb-left"];
    UIImage *mbRight = [UIImage imageNamed:@"mb-right"];
    
    self.mbLeft = [[UIImageView alloc] initWithImage:mbLeft];
    self.mbRight = [[UIImageView alloc] initWithImage:mbRight];
    self.pearKing = [[PearKingView alloc] initWithFrame:CGRectMake(3.5f, 289.0f, 158.5f, 232.0f)];
    self.pearKing.delegate = self;
    
    self.mbLeft.frame = CGRectMake(126.5f, 346.0f, 248.5f, 346.0f);
    self.mbRight.frame = CGRectMake(126.5f, 346.0f, 248.5f, 346.0f);
    
    [self.view addSubview:self.score];
    [self.view addSubview:self.mbLeft];
    [self.view addSubview:self.mbRight];
    [self.view addSubview:self.pearKing];
    
    self.mbLeft.hidden = YES;
    
    [self updateScoreTo:0.0f];
    [self resetMartinTimer];
}

- (void)resetMartinTimer {

    double nextLook = (((double)arc4random() / ARC4RANDOM_MAX) * (MB_TURN_DELAY_MAX - MB_TURN_DELAY_MIN)) + MB_TURN_DELAY_MIN;
    
    [NSTimer scheduledTimerWithTimeInterval:nextLook
                                     target:self
                                   selector:@selector(mbLook:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)mbLook:(NSTimer *)timer {
    if (self.gameState == GameStateEating) {
        self.mbLookingLeft = YES;
        self.mbLeft.hidden = NO;
        self.mbRight.hidden = YES;
        
        double lookFor = (((double)arc4random() / ARC4RANDOM_MAX) * (MB_LOOK_DURATION_MAX - MB_LOOK_DURATION_MIN)) + MB_LOOK_DURATION_MIN;
        
        [NSTimer scheduledTimerWithTimeInterval:lookFor
                                         target:self
                                       selector:@selector(mbTurnBack:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)mbTurnBack:(NSTimer *)timer {
    if (self.gameState == GameStateEating) {
        self.mbLookingLeft = NO;
        self.mbLeft.hidden = YES;
        self.mbRight.hidden = NO;
        
        [self resetMartinTimer];
    }
}

- (void)updateScoreTo:(CGFloat)percentage {
    int scorePercentage = (int)(percentage * 100);
    self.score.text = [NSString stringWithFormat:@"Pear consumed: %d%%", scorePercentage];
}

- (void)pearChomped
{
    if (self.mbLookingLeft) {
        self.pearKing.chompsAllowed = NO;
        self.score.hidden = YES;
        self.gameState = GameStateFailed;
    } else {
        CGFloat percent = self.pearKing.offsetEatenPercentage;
        
        if (fabs(self.pearKing.offsetEatenPercentage - 1.0f) < FLT_EPSILON) {
            self.gameState = GameStateSucceeded;
        }
        [self updateScoreTo:self.pearKing.offsetEatenPercentage];
    }
}

@end
