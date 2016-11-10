//
//  LPGViewController.m
//  Phonagotchi
//
//  Created by Steven Masuch on 2014-07-26.
//  Copyright (c) 2014 Lighthouse Labs. All rights reserved.
//

#import "LPGViewController.h"
#import "Pet.h"

@interface LPGViewController ()
@property (nonatomic) UIImageView *petImageView;
@property (nonatomic) UIImageView *basketView;
@property (strong, nonatomic) UIPanGestureRecognizer * panGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer * panGestureRecognizerApple;
@property (strong, nonatomic) UIPinchGestureRecognizer * pinchGestureRecognizer;
@property (strong, nonatomic) Pet * petModel;
@property (nonatomic) UIImageView *apple;

@end

@implementation LPGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.petModel = [Pet new];
    
    self.view.backgroundColor = [UIColor colorWithRed:(252.0/255.0) green:(240.0/255.0) blue:(228.0/255.0) alpha:1.0];
    
    self.petImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.petImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.petImageView.image = [UIImage imageNamed:@"default"];
    
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
    
    //Basket and Apple
    UIImageView * basketView = [[UIImageView alloc] initWithFrame:CGRectZero];
    basketView.translatesAutoresizingMaskIntoConstraints = NO;
    basketView.image = [UIImage imageNamed:@"bucket.png"];
    [self.view addSubview: basketView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:basketView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:-30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:basketView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:basketView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:80]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:basketView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:80]];
    basketView.userInteractionEnabled = YES;
    self.basketView = basketView;
    
    
    UIImageView * appleView = [[UIImageView alloc] initWithFrame:CGRectZero];
    appleView.translatesAutoresizingMaskIntoConstraints = NO;
    appleView.image = [UIImage imageNamed:@"apple.png"];
    [self.view addSubview: appleView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:appleView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:-52]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:appleView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-65]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:appleView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:35]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:appleView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:35]];
    
    //Gestures List
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPet)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onApplePinch)];
    [self.basketView addGestureRecognizer:self.pinchGestureRecognizer];
    
    
    
}

-(void)onPet {
    CGPoint velocity = [self.panGestureRecognizer velocityInView:self.view];
    NSString * imageName = [self.petModel onPet:velocity];
    self.petImageView.image = [UIImage imageNamed:imageName];
    if (self.panGestureRecognizer.state == 3) {
        self.petImageView.image = [UIImage imageNamed:@"default.png"];
    }
}

-(void)onApplePinch {
    if (self.pinchGestureRecognizer.state == 3) {
        self.apple = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.apple.translatesAutoresizingMaskIntoConstraints = NO;
        self.apple.image = [UIImage imageNamed:@"apple.png"];
        [self.view addSubview: self.apple];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:-65]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:35]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:35]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.apple
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        self.apple.userInteractionEnabled = YES;
        self.panGestureRecognizerApple = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onAppleMove)];
        [self.apple addGestureRecognizer: self.panGestureRecognizerApple];

        
    }
}

-(void)onAppleMove{
    CGPoint touchLocation = [self.panGestureRecognizerApple locationInView:self.view];
    self.apple.center = touchLocation;
    //NSLog(@"%@", NSStringFromCGPoint(self.apple.center));
    if ( CGRectContainsPoint(self.petImageView.frame, self.apple.center) && (self.panGestureRecognizerApple.state == 3)) {
        [self.apple removeFromSuperview];
        NSLog(@"He ate it!");
    }else if ( CGRectContainsPoint(self.petImageView.frame, self.apple.center) == NO && (self.panGestureRecognizerApple.state == 3)) {
        [self.apple removeFromSuperview];
        NSLog(@"Ah. The apple fell.");
    }
    
}
@end
