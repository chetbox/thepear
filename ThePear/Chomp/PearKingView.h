//
//  PearKingView.h
//  ThePear
//
//  Created by Tom Dixon on 07/12/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PearKingViewDelegate <NSObject>

- (void)pearChomped;

@end

@interface PearKingView : UIView

@property (readonly) CGFloat offsetEatenPercentage;
@property (nonatomic, assign) BOOL chompsAllowed;
@property (nonatomic, weak) id<PearKingViewDelegate> delegate;

- (void)reset;

@end
