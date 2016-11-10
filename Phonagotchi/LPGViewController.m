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
@property (strong, nonatomic) UIPanGestureRecognizer * panGestureRecognizer;
@property (strong, nonatomic) Pet * petModel;
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
                                                           constant:30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:basketView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:30]];
    
    [self.view addConstraint:[NSLayoutConstraint ]];
    //Gestures List
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPet)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    self.petImageView.image = [UIImage imageNamed:@"default"];
    
    
}

-(void)onPet {
    CGPoint velocity = [self.panGestureRecognizer velocityInView:self.view];
//    NSLog(@"%@", [NSString stringWithFormat:@"Horizontal Velocity: %.2f points/sec", velocity.x]);
//    NSLog(@"%@", [NSString stringWithFormat:@"Vertical Velocity: %.2f points/sec", velocity.y]);
    NSString * imageName = [self.petModel onPet:velocity];
    self.petImageView.image = [UIImage imageNamed:imageName];
}

@end
