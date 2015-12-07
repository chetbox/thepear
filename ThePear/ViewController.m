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

// INCREMENT HERE WHEN ADDING A PAGE
#define NUMBER_OF_PAGES 3

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"The Pear";
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
            cell.label.text = [NSString stringWithFormat:@"Sorry you're leaving"];
            break;
        }
        case 2: {
            cell.label.text = [NSString stringWithFormat:@"Emoji faces"];
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
            
        default:
            break;
    }
}

@end
