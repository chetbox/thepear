//
//  QuoteMachineViewController.m
//  ThePear
//
//  Created by Tom Dixon on 24/11/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import "QuoteMachineViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QuoteMachineViewController ()

@property (weak, nonatomic) IBOutlet UIView *quoteLabelContainer;
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;

@property NSArray *quotes;
@property AVAudioPlayer *audioPlayer;

@end

@implementation QuoteMachineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Quote Machine";
    self.quotes = @[
  @{@"person": @"Peter", @"quote": @"Who do we always do?...Who do we always do?...Who do we always do?"},
  @{@"person": @"Tom", @"quote": @"We’re creating a mirror for you awful people"},
  @{@"person": @"Tom", @"quote": @"Piss off! That's how they print big shit?!"},
  @{@"person": @"Tom", @"quote": @"SwiftKey’s vision: do her"},
  @{@"person": @"Tom", @"quote": @"Ottoman Empire"},
  @{@"person": @"Tom", @"quote": @"Raspberry Pi powered toaster lamp"},
  @{@"person": @"Tom", @"quote": @"'That' to 'they'...that’s my favourite ongoing ticket"},
  @{@"person": @"Tom", @"quote": @"I’ll put you in the fridge"},
  @{@"person": @"Tom", @"quote": @"That’s like the bell end example"},
  @{@"person": @"Peter", @"quote": @"Yo yo whassup this yo boy PH comin in live from Compton (Peter's first push notification)"},
  @{@"person": @"Tom", @"quote": @"We don’t have any data for cheese"},
  @{@"person": @"Tom", @"quote": @"What are you trying to remember?"},
  @{@"person": @"Peter", @"quote": @"Do you ever get that feeling that you’re watching someone talking and they’re suddenly really small on the screen and then you feel like an insect. Makes me feel weird sometimes, I have to leave the room or turn a light on"},
  @{@"person": @"Peter", @"quote": @"I thought up a great bathroom"},
  @{@"person": @"Tom", @"quote": @"Speaking out of a small hole in the bark. (Honza’s imaginary presentation outfit made entirely from wood)"},
  @{@"person": @"Peter", @"quote": @"You’re approach is very flat, do me again"},
  @{@"person": @"Peter", @"quote": @"Do me, do me, Honza do me"},
  @{@"person": @"Tom", @"quote": @"You have to stand your ground with computers else they’ll take advantage of you"},
  @{@"person": @"Peter", @"quote": @"How can you judge someone's performance if you don’t even know how tall they are?"},
  @{@"person": @"Honza", @"quote": @"You can only type properly if you’re pointing north (Honza's new theme)"},
  @{@"person": @"Honza", @"quote": @"New five star review 'more themes please'... what they don’t realise is that they ARE getting MOR-phemes!!"},
  @{@"person": @"Anna", @"quote": @"I’m going to try to diversify my emoji usage"},
  @{@"person": @"Peter", @"quote": @"OMG this is a really great cookie, this cookie is AMAAAAZIINGG (signature emoji)"},
  @{@"person": @"Honza", @"quote": @"How’s your parrot doing is it back from the doctor yet?"},
  @{@"person": @"Honza", @"quote": @"Horse horse firework (trying to communicate in emoji)"},
  @{@"person": @"Honza", @"quote": @"The quality of duck tape here has been steadily going down"},
  @{@"person": @"Chet", @"quote": @"I'm just a strategic drinker"},
  @{@"person": @"Honza", @"quote": @"You were ready to laugh like a crazy person, yeah, we’ve met you Naomi"},
  @{@"person": @"Martin", @"quote": @"Satisfaction from work is eternal"},
  @{@"person": @"Peter", @"quote": @"I always put the cylinder on you"},
  @{@"person": @"Honza", @"quote": @"Medication, medication, medication, MEDITATION course (team building)"},
  @{@"person": @"Peter", @"quote": @"It’s inconsistent as shit yeah (emoji in Gmail)"},
  @{@"person": @"Marcin", @"quote": @"Maybe you should limit how much you speak"},
  @{@"person": @"Tom", @"quote": @"Initial sausage"},
  @{@"person": @"Chet", @"quote": @"My phone is in a mug over there so now everyone can watch live"},
  @{@"person": @"Honza", @"quote": @"This is the best looking presentation I've ever seen you make"},
  @{@"person": @"Marcin", @"quote": @"Naomi, maybe you should limit how much you speak", @"audio": @"marcin1.m4a"}
  ];
    
    // do a little bit of pretifying
    self.generateButton.layer.cornerRadius = 3.0;
    self.quoteLabelContainer.layer.cornerRadius = 4.0;
    
    // populate with random quote to start off..
    [self pickNewQuote];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickNewQuote {
    
    NSUInteger randomIndex = arc4random() % [self.quotes count];
    NSDictionary *randQuote = [self.quotes objectAtIndex:randomIndex];
    NSString *person = [randQuote objectForKey:@"person"];
    NSString *quote = [randQuote objectForKey:@"quote"];
    
    if (self.audioPlayer != nil) {
        [self.audioPlayer stop];
    }
    
    if ([randQuote objectForKey:@"audio"] != nil) {
        NSString *audioFileName = [randQuote objectForKey:@"audio"];
        NSURL *audioURL = [[NSBundle mainBundle]
         URLForResource: [[audioFileName lastPathComponent] stringByDeletingPathExtension] withExtension:audioFileName.pathExtension];
        
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc]
                                      initWithContentsOfURL:audioURL error:&error];
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
 
    }
    
    
    [self.quoteLabel setText:quote];
    [self.personImageView setImage:[self imageForPerson:person]];
    
}

- (UIImage *)imageForPerson:(NSString *)person {
    
    if ([person isEqualToString:@"Tom"]) {
        return [UIImage imageNamed:@"tom_emoji"];
    } else if ([person isEqualToString:@"Peter"]) {
        return [UIImage imageNamed:@"peter_emoji"];
    } else if ([person isEqualToString:@"Honza"]) {
        return [UIImage imageNamed:@"honza_emoji"];
    } else if ([person isEqualToString:@"Anna"]) {
        return [UIImage imageNamed:@"anna_emoji"];
    } else if ([person isEqualToString:@"Chet"]) {
        return [UIImage imageNamed:@"chet_emoji"];
    } else if ([person isEqualToString:@"Marcin"]) {
        return [UIImage imageNamed:@"marcin_emoji"];
    } else if ([person isEqualToString:@"Martin"]) {
        return [UIImage imageNamed:@"martin_emoji"];
    } else {
        return [[UIImage alloc] init];
    }
}

#pragma mark - IB Actions

- (IBAction)generateQuote:(UIButton *)sender {
    [self pickNewQuote];
}

@end
