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
@property (nonatomic, strong) UILabel *best;

@property (nonatomic, strong) NSDate *gameStartTime;
@property (nonatomic, strong) UIImageView *mbLeft;
@property (nonatomic, strong) UIImageView *mbRight;
@property (nonatomic, strong) PearKingView *pearKing;
@property (nonatomic, assign) BOOL mbLookingLeft;
@property (nonatomic, assign) GameState gameState;

@property (nonatomic, strong) UIImageView *successView;
@property (nonatomic, strong) UIImageView *failureView;
@property (nonatomic, strong) UIButton *restartGame;

@end

@implementation ChompViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *reset = [[UIBarButtonItem alloc] initWithTitle:@"Reset Scores"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(resetScores)];
    
    self.navigationItem.rightBarButtonItem = reset;
    
    NSTimeInterval bestTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"best-time"];
    if (bestTime == 0) {
        [[NSUserDefaults standardUserDefaults] setDouble:INT_MAX forKey:@"best-time"];
    }
    
    
    self.gameStartTime = [NSDate date];
    self.gameState = GameStateEating;
    
    [self setupViews];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.restartGame = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.restartGame setTitle:@"Play Again" forState:UIControlStateNormal];
    [self.restartGame addTarget:self action:@selector(restartTheGame) forControlEvents:UIControlEventTouchUpInside];
    self.restartGame.titleLabel.font = [UIFont systemFontOfSize:28.0f];
    self.restartGame.frame = CGRectMake(85.0f, 180.0f, 200.0f, 60.0f);
    self.restartGame.layer.borderColor = [UIColor grayColor].CGColor;
    self.restartGame.layer.cornerRadius = 4.0f;
    self.restartGame.layer.borderWidth = 2.0f;
    self.restartGame.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.restartGame.hidden = YES;
    
    self.best = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 74.0f, 300.0f, 40.0f)];
    self.best.font = [UIFont systemFontOfSize:18.0f];
    self.best.backgroundColor = [UIColor clearColor];
    
    self.score = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 104.0f, 300.0f, 40.0f)];
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
    
    UIImage *success = [UIImage imageNamed:@"success"];
    self.successView = [[UIImageView alloc] initWithImage:success];
    CGSize successSize = success.size;
    self.successView.frame = CGRectMake((375.0f / 2) - (successSize.width / 2), 420.0f, successSize.width, successSize.height);
    self.successView.hidden = YES;

    UIImage *failure = [UIImage imageNamed:@"regicide"];
    self.failureView = [[UIImageView alloc] initWithImage:failure];
    CGSize failureSize = failure.size;
    self.failureView.frame = CGRectMake((375.0f / 2) - (failureSize.width / 2), 420.0f, failureSize.width, failureSize.height);
    self.failureView.hidden = YES;
    
    [self.view addSubview:self.best];
    [self.view addSubview:self.score];
    [self.view addSubview:self.mbLeft];
    [self.view addSubview:self.mbRight];
    [self.view addSubview:self.pearKing];
    [self.view addSubview:self.successView];
    [self.view addSubview:self.failureView];
    [self.view addSubview:self.restartGame];
    
    self.mbLeft.hidden = YES;
    
    [self updateScoreTo:0.0f];
    [self resetMartinTimer];
    [self updateBest];
}

- (void)restartTheGame {
    self.restartGame.hidden = YES;
    self.score.hidden = NO;
    self.mbLeft.hidden = YES;
    self.mbRight.hidden = NO;
    self.mbLookingLeft = NO;
    self.successView.hidden = YES;
    self.failureView.hidden = YES;
    
    self.gameState = GameStateEating;
    [self.pearKing reset];
    
    [self updateBest];
    [self updateScoreTo:0.0f];
    
    [self resetMartinTimer];
}

- (void)resetScores {
    [[NSUserDefaults standardUserDefaults] setDouble:INT_MAX forKey:@"best-time"];
    [[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"best-score"];
    
    [self updateBest];
}

- (void)updateBest {
    CGFloat bestScore = [[NSUserDefaults standardUserDefaults] floatForKey:@"best-score"];
    
    if (fabs(bestScore - 1.0f) < FLT_EPSILON) {
        NSTimeInterval bestTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"best-time"];
        
        self.best.text = [NSString stringWithFormat:@"Best Time: %.02f seconds", bestTime];
    } else {
        self.best.text = [NSString stringWithFormat:@"Best Score: %d%%", (int)(bestScore * 100)];
    }
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
    
    CGFloat currentBest = [[NSUserDefaults standardUserDefaults] floatForKey:@"best-score"];
    if (percentage > currentBest) {
        [[NSUserDefaults standardUserDefaults] setFloat:percentage forKey:@"best-score"];
        [self updateBest];
    }
}

- (void)pearChomped
{
    if (self.mbLookingLeft) {
        self.pearKing.chompsAllowed = NO;
        self.score.hidden = YES;
        self.gameState = GameStateFailed;
        
        self.failureView.hidden = NO;
        self.restartGame.hidden = NO;
    } else {
        CGFloat percent = self.pearKing.offsetEatenPercentage;
        
        [self updateScoreTo:percent];
        
        if (fabs(percent - 1.0f) < FLT_EPSILON) {
            self.gameState = GameStateSucceeded;
            self.restartGame.hidden = NO;
            self.successView.hidden = NO;
            
            NSTimeInterval time = -[self.gameStartTime timeIntervalSinceNow];
            
            NSTimeInterval bestTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"best-time"];
            if (time < bestTime) {
                [[NSUserDefaults standardUserDefaults] setDouble:time forKey:@"best-time"];
                [self updateBest];
            }
        }
    }
}

@end
