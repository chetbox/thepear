//
//  LeavingMessageTableViewCell.h
//  ThePear
//
//  Created by Marcin Kuptel on 06/12/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeavingMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;


+ (NSString*) identifier;

@end
