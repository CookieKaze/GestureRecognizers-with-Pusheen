//
//  LPGViewController.m
//  Phonagotchi
//
//  Created by Steven Masuch on 2014-07-26.
//  Copyright (c) 2014 Lighthouse Labs. All rights reserved.
//

#import "LPGViewController.h"
#import "Pet.h"

@interface LPGViewController () <catViewRules>
@property (nonatomic) UIImageView *petImageView;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;
@property (strong, nonatomic) UIPanGestureRecognizer * petGestureRecognizer;

@property (weak, nonatomic) IBOutlet UIImageView *appleView;
@property (nonatomic) UIImageView *appleViewNew;
@property (strong, nonatomic) UIPanGestureRecognizer * panAppleGestureRecognizer;


@property (strong, nonatomic) UIPanGestureRecognizer * panGestureRecognizerApple;
@property (strong, nonatomic) UIPinchGestureRecognizer * pinchGestureRecognizer;
@property (strong, nonatomic) Pet * pet;

@end

@implementation LPGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Setup Pet View
    self.view.backgroundColor = [UIColor colorWithRed:(252.0/255.0) green:(240.0/255.0) blue:(228.0/255.0) alpha:1.0];
    self.petImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.petImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.petImageView.image = [UIImage imageNamed:@"sleeping.png"];
    [self.view addSubview:self.petImageView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.petImageView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.petImageView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    self.petImageView.userInteractionEnabled = YES;
    
    //Setup Pet
    self.pet = [Pet new];
    self.pet.catViewDelegate = self;
    self.moodLabel.text = [self.pet getMood];
    
    //Setup Pet Gesture
    self.petGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPet)];
    [self.petImageView addGestureRecognizer:self.petGestureRecognizer];
}

-(void) updateCatMood: (NSString *) newMood {
    self.moodLabel.text = newMood;
}

-(void) onPet {
    CGPoint velocity = [self.petGestureRecognizer velocityInView:self.view];
    float magnitude = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
    [self.pet onPet:magnitude];
    switch (self.petGestureRecognizer.state) {
        case 2:
            if (self.pet.catMood == 1) {
                self.petImageView.image = [UIImage imageNamed:@"grumpy.png"];
                break;
            case 3:
                self.petImageView.image = [UIImage imageNamed:@"default.png"];
                [self.pet onStopPet];
                break;
            default:
                break;
            }
    }
}

- (IBAction)onAppleDrag:(UIPanGestureRecognizer *)sender {
    self.panAppleGestureRecognizer = sender;
    //Create Apple
    if (!self.appleViewNew) {
        CGRect appleSize = self.appleView.frame;
        self.appleViewNew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple.png"]];
        self.appleViewNew.frame = appleSize;
        [self.view addSubview: self.appleViewNew];
    }
    //Move Apple
    CGPoint touchLocation = [self.panAppleGestureRecognizer locationInView:self.view];
    self.appleViewNew.center = touchLocation;
    if ( CGRectContainsPoint(self.petImageView.frame, self.appleViewNew.center) && (self.panAppleGestureRecognizer.state == 3)) {
        [self.appleViewNew removeFromSuperview];
        [self.pet onFeed];
        self.petImageView.image = [UIImage imageNamed:@"sleeping.png"];
        self.appleViewNew = nil;
    }else if ( CGRectContainsPoint(self.petImageView.frame, self.appleViewNew.center) == NO && (self.panAppleGestureRecognizer.state == 3)) {
        
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.appleViewNew.frame = CGRectMake(self.appleViewNew.frame.origin.x, self.view.frame.size.height, self.appleViewNew.frame.size.width, self.appleViewNew.frame.size.height);
            
        } completion:^(BOOL finished){
            [self.appleViewNew removeFromSuperview];
            self.appleViewNew = nil;
        }];
    
    }
}

@end
