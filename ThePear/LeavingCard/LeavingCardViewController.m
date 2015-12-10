//
//  LeavingCardViewController.m
//  ThePear
//
//  Created by Marcin Kuptel on 06/12/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import "LeavingCardViewController.h"
#import "LeavingMessageTableViewCell.h"

@interface LeavingCardViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *messageImages;

@end

@implementation LeavingCardViewController

- (instancetype) init {
    self = [super initWithNibName: @"LeavingCardViewController" bundle: [NSBundle mainBundle]];
    if (self) {
        _messageImages = @[@"Marcin", @"Peter", @"Tom", @"Alex.jpeg", @"James.jpg"];
        _messageImages = [self shuffleArray:_messageImages];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName: @"LeavingMessageTableViewCell" bundle: [NSBundle mainBundle]];
    [self.tableView registerNib: nib forCellReuseIdentifier: [LeavingMessageTableViewCell identifier]];
}

- (NSArray *)shuffleArray:(NSArray *)array
{
    NSMutableArray *mutArray = [array mutableCopy];
    NSUInteger count = mutArray.count;
    
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [mutArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return [mutArray copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageImages count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeavingMessageTableViewCell *cell = (LeavingMessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier: [LeavingMessageTableViewCell identifier]];
    cell.messageImageView.image = [UIImage imageNamed: self.messageImages[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = [UIImage imageNamed: self.messageImages[indexPath.row]];
    return [self _heightForImage: image];
}

- (CGFloat) _heightForImage: (UIImage*) image {
    CGFloat imageRatio = image.size.height/image.size.width;
    return imageRatio * [UIScreen mainScreen].bounds.size.width;
}

@end
