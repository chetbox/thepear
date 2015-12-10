//
//  ViewController.m
//  ThePear
//
//  Created by Tom Dixon on 24/11/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import "ViewController.h"
#import "MenuCollectionViewCell.h"
#import "QuoteMachineViewController.h"
#import "LeavingCardViewController.h"
#import "EmojiFacesViewController.h"
#import "ChompViewController.h"

// INCREMENT HERE WHEN ADDING A PAGE
#define NUMBER_OF_PAGES 4

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"🍐";
    
    UIImage *bgImage = [UIImage imageNamed:@"bg"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, 375, 667);
    [self.view insertSubview:bgImageView atIndex:0];
}

#pragma mark - UICollectionViewDataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return NUMBER_OF_PAGES;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                           forIndexPath:indexPath];
    
    switch (indexPath.item) {
            // ADD A CASE FOR YOUR VC HERE
        case 0: {
            cell.label.text = [NSString stringWithFormat:@"Quote Machine"];
            break;
        }
        case 1: {
            cell.label.text = [NSString stringWithFormat:@"Sorry You're Leaving"];
            break;
        }
        case 2: {
            cell.label.text = [NSString stringWithFormat:@"Emoji Stamper"];
            break;
        }
        case 3: {
            cell.label.text = [NSString stringWithFormat:@"Regicide de Poire"];
            break;
        }
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item) {
        // ADD A CASE FOR YOUR VC HERE
        case 0: {
            QuoteMachineViewController *newVc = [[NSBundle mainBundle] loadNibNamed:@"QuoteMachineViewController" owner:self options:nil][0];
            [self.navigationController pushViewController:newVc animated:YES];
            break;
        }
        case 1: {
            LeavingCardViewController *cardController = [[LeavingCardViewController alloc] init];
            cardController.title = @"Sorry you're leaving";
            [self.navigationController pushViewController: cardController animated: YES];
            break;
        }
        case 2: {
            EmojiFacesViewController *efVc = [[UIStoryboard storyboardWithName:@"EmojiFaces" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            [self.navigationController pushViewController:efVc animated:YES];
            break;
        }
        case 3: {
            ChompViewController *newVc = [[ChompViewController alloc] init];
            [self.navigationController pushViewController:newVc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

@end
