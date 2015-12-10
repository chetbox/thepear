//
//  EmojiFacesViewController.m
//  ThePear
//
//  Created by Alexander Primavesi on 07/12/2015.
//  Copyright © 2015 SwiftKey. All rights reserved.
//

#import "EmojiFacesViewController.h"

@interface EmojiDecoration ()

@end

@implementation EmojiDecoration
@end

@interface EmojiFacesViewController ()


@property (nonatomic, strong) UIImage *chosenImage;
@property (nonatomic, strong) NSMutableArray *emojiDecorations;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIImageView *emojiBeingPlacedView;
@property (nonatomic, strong) NSMutableArray *emojiImages;
@property (nonatomic) NSUInteger emojiImagePointer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *undoBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeFaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseImageBtn;

@end

@implementation EmojiFacesViewController

- (void)refreshControlPanel
{
    self.imageView.userInteractionEnabled = NO;
    [self hideAllButtons];
    if (!self.chosenImage) {
        self.chooseImageBtn.hidden = NO;
    } else if (!self.emojiBeingPlacedView) {
        self.undoBtn.hidden = NO;
        if (self.emojiDecorations.count == 0) {
            self.undoBtn.alpha = 0.5;
        }
        self.saveBtn.hidden = NO;
        self.imageView.userInteractionEnabled = YES;
    } else {
        self.doneBtn.hidden = NO;
        self.changeFaceBtn.hidden = NO;
        self.imageView.userInteractionEnabled = YES;
    }
}

- (void)hideAllButtons
{
    NSArray *allBtns = @[_undoBtn,_saveBtn,_doneBtn,_changeFaceBtn,_chooseImageBtn];
    for (UIButton *btn in allBtns) {
        btn.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshControlPanel];
    _emojiImages = [NSMutableArray array];
    for (int i = 1; i <= 12; i++) {
        [_emojiImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"em%d.png", i]]];
    }
    
    _emojiImagePointer = 0;
    _emojiDecorations = [NSMutableArray array];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.imageView addGestureRecognizer:tgr];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSArray *allBtns = @[_undoBtn,_saveBtn,_doneBtn,_changeFaceBtn,_chooseImageBtn];
    for (UIButton *btn in allBtns) {
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldShowImagePicker
{
    return !(self.chosenImage);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self refreshControlPanel];
}

- (void)saveImageInCurrentState
{
    //Draw imageview to uiimage
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Save to somewhere
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    //Reset to start state.
    self.chosenImage = nil;
    self.emojiBeingPlacedView = nil;
    self.emojiDecorations = [NSMutableArray array];
    for (UIView *v in self.imageView.subviews) {
        [v removeFromSuperview];
    }
    self.imageView.image = nil;
    [self refreshControlPanel];
}

- (void)showPicker
{
    if (self.picker) return;
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)hidePicker
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.picker = nil;
    }];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *edited = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!edited) {
        UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.chosenImage = original;
    } else {
        self.chosenImage = edited;
    }
    self.imageView.image = self.chosenImage;
    [self refreshControlPanel];
    [self hidePicker];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self refreshControlPanel];
    [self hidePicker];
}

#pragma mark Buttons
- (IBAction)changeFace:(id)sender {
    _emojiImagePointer++;
    _emojiImagePointer %= _emojiImages.count;
    UIImage *newImg = _emojiImages[_emojiImagePointer];
    if (self.emojiBeingPlacedView) {
        self.emojiBeingPlacedView.image = newImg;
    }
}
- (IBAction)undo:(id)sender {
    if (self.emojiDecorations.count > 0) {
        UIImageView *iv = [self.emojiDecorations lastObject];
        [iv removeFromSuperview];
        [self.emojiDecorations removeLastObject];
        [self refreshControlPanel];
        if (self.emojiDecorations.count == 0) {
            self.undoBtn.alpha = 0.5;
        }
    }
}
- (IBAction)chooseImage:(id)sender {
    [self showPicker];
}
- (IBAction)save:(id)sender {
    [self saveImageInCurrentState];
}
- (IBAction)done:(id)sender {
    for (UIGestureRecognizer *gr in self.emojiBeingPlacedView.gestureRecognizers) {
        [self.emojiBeingPlacedView removeGestureRecognizer:gr];
    }
    [self.emojiDecorations addObject:self.emojiBeingPlacedView];
    self.emojiBeingPlacedView = nil;
    [self refreshControlPanel];
}

#pragma mark Gestures

- (void)tap:(UITapGestureRecognizer *)tgr
{
    if (self.emojiBeingPlacedView) return;
    
    CGPoint pt = [tgr locationInView:self.imageView];
    CGRect startFrame = CGRectMake(pt.x - 60, pt.y - 60, 120, 120);
    //Create UIImageView with gesture recognisers
    self.emojiBeingPlacedView = [[UIImageView alloc] initWithFrame:startFrame];
    self.emojiBeingPlacedView.contentMode = UIViewContentModeScaleAspectFit;
    self.emojiBeingPlacedView.userInteractionEnabled = YES;
    [self.imageView addSubview:self.emojiBeingPlacedView];
    [self changeFace:nil];
    
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(drag:)];
    [self.emojiBeingPlacedView addGestureRecognizer:pgr];
    UIPinchGestureRecognizer *pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(pinch:)];
    [self.emojiBeingPlacedView addGestureRecognizer:pinchgr];
    UIRotationGestureRecognizer *rgr = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(rotate:)];
    [self.emojiBeingPlacedView addGestureRecognizer:rgr];
    
    self.undoBtn.alpha = 1;
    
    [self refreshControlPanel];
}

- (void)drag:(UIPanGestureRecognizer *)sender
{
    static CGPoint initialCenter;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        initialCenter = sender.view.center;
    }
    CGPoint translation = [sender translationInView:sender.view.superview];
    sender.view.center = CGPointMake(initialCenter.x + translation.x,
                                     initialCenter.y + translation.y);
}

- (void)pinch:(UIPinchGestureRecognizer *)sender
{
    static CGPoint center;
    static CGSize initialSize;
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        center = sender.view.center;
        initialSize = sender.view.frame.size;
    }
    
    // scale the image
    sender.view.frame = CGRectMake(0,
                                   0,
                                   initialSize.width * sender.scale,
                                   initialSize.height * sender.scale);
    // recenter it with the new dimensions
    sender.view.center = center;
}

- (void)rotate:(UIRotationGestureRecognizer *)sender
{
    static CGFloat initialRotation;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        initialRotation = atan2f(sender.view.transform.b, sender.view.transform.a);
    }
    CGFloat newRotation = initialRotation + sender.rotation;
    sender.view.transform = CGAffineTransformMakeRotation(newRotation);
}


@end
