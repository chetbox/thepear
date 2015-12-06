//
//  LeavingCardViewController.m
//  ThePear
//
//  Created by Marcin Kuptel on 06/12/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import "LeavingCardViewController.h"
#import "LeavingMessageTableViewCell.h"

@interface LeavingCardViewController()<UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation LeavingCardViewController

- (instancetype) init {
    self = [super initWithNibName: @"LeavingCardViewController" bundle: [NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName: @"LeavingMessageTableViewCell" bundle: [NSBundle mainBundle]];
    [self.tableView registerNib: nib forCellReuseIdentifier: [LeavingMessageTableViewCell identifier]];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeavingMessageTableViewCell *cell = (LeavingMessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier: [LeavingMessageTableViewCell identifier]];
    return cell;
}


@end
