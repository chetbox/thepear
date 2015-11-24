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

// INCREMENT HERE WHEN ADDING A PAGE
#define NUMBER_OF_PAGES 1

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
    
    cell.label.text = [NSString stringWithFormat:@"Page %li", indexPath.item + 1];
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
            
        default:
            break;
    }
}

@end
