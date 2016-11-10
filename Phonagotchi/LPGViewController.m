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
    //self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onApplePinch)];
    //[self.basketView addGestureRecognizer:self.pinchGestureRecognizer];
    
    
    
}

-(void) updateCatMood: (NSString *) newMood {
    self.moodLabel.text = newMood;
    
}

-(void)onPet {
    CGPoint velocity = [self.petGestureRecognizer velocityInView:self.view];
    float magnitude = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
    NSLog(@"%f", magnitude);
    NSString * petMood = [self.pet onPet:magnitude];
    
    switch (self.petGestureRecognizer.state) {
        case 2:
            if ([petMood isEqual: @"Grumpy"]) {
                self.petImageView.image = [UIImage imageNamed:@"grumpy.png"];
                self.moodLabel.text = petMood;
                break;
            case 3:
                self.petImageView.image = [UIImage imageNamed:@"default.png"];
                self.moodLabel.text = [self.pet onPet: 0];
                
                break;
            default:
                break;
            }
    }
}

//-(void)onApplePinch {
//    if (self.pinchGestureRecognizer.state == 3) {
//        self.apple = [[UIImageView alloc] initWithFrame:CGRectZero];
//        self.apple.translatesAutoresizingMaskIntoConstraints = NO;
//        self.apple.image = [UIImage imageNamed:@"apple.png"];
//        [self.view addSubview: self.apple];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
//                                                              attribute:NSLayoutAttributeBottom
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeBottom
//                                                             multiplier:1
//                                                               constant:0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
//                                                              attribute:NSLayoutAttributeRight
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeRight
//                                                             multiplier:1
//                                                               constant:-65]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
//                                                              attribute:NSLayoutAttributeWidth
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:nil
//                                                              attribute:NSLayoutAttributeNotAnAttribute
//                                                             multiplier:1
//                                                               constant:35]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
//                                                              attribute:NSLayoutAttributeHeight
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:nil
//                                                              attribute:NSLayoutAttributeNotAnAttribute
//                                                             multiplier:1
//                                                               constant:35]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
//                                                              attribute:NSLayoutAttributeBottom
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeBottom
//                                                             multiplier:1
//                                                               constant:0]];
//        self.apple.userInteractionEnabled = YES;
//        self.panGestureRecognizerApple = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onAppleMove)];
//        [self.apple addGestureRecognizer: self.panGestureRecognizerApple];
//
//
//    }
//}
//
//-(void)onAppleMove{
//    CGPoint touchLocation = [self.panGestureRecognizerApple locationInView:self.view];
//    self.apple.center = touchLocation;
//    //NSLog(@"%@", NSStringFromCGPoint(self.apple.center));
//    if ( CGRectContainsPoint(self.petImageView.frame, self.apple.center) && (self.panGestureRecognizerApple.state == 3)) {
//        [self.apple removeFromSuperview];
//        NSLog(@"He ate it!");
//    }else if ( CGRectContainsPoint(self.petImageView.frame, self.apple.center) == NO && (self.panGestureRecognizerApple.state == 3)) {
//        [self.apple removeFromSuperview];
//        NSLog(@"Ah. The apple fell.");
//    }
//
//}
@end
