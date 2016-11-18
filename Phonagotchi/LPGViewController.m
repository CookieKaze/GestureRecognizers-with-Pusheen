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
@property (weak, nonatomic) IBOutlet UIView *restfulnessBar;
@property (nonatomic) CGFloat restBarWidth;
@property (nonatomic) UIImageView *petImageView;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;
@property (strong, nonatomic) UIPanGestureRecognizer * petGestureRecognizer;

@property (weak, nonatomic) IBOutlet UIImageView *appleView;
@property (nonatomic) UIImageView *appleViewNew;
@property (strong, nonatomic) UIPanGestureRecognizer * panAppleGestureRecognizer;


@property (strong, nonatomic) UIPanGestureRecognizer * panGestureRecognizerApple;
@property (strong, nonatomic) UIPinchGestureRecognizer * pinchGestureRecognizer;
@property (strong, nonatomic) Pet * pet;

@property (nonatomic) NSTimer* sleepTimer;
@property (nonatomic) NSTimer* boredTimer;
@property (nonatomic) NSTimer* restTimer;
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
    self.sleepTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(sleep:) userInfo:nil repeats:YES];
    [self.pet addObserver:self forKeyPath:@"restfulness" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    self.restBarWidth = self.view.frame.size.width;
    CGRect restBar = CGRectMake(self.restfulnessBar.frame.origin.x, self.restfulnessBar.frame.origin.y, self.restBarWidth, self.restfulnessBar.frame.size.height);
    self.restfulnessBar.frame = restBar;
}

#pragma mark - Pet Interaction
-(void) onPet {
    //Get velocity of the pan
    CGPoint velocity = [self.petGestureRecognizer velocityInView:self.view];
    //Calculate magnitude of the pan
    float magnitude = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
    
    //Pet mood change depending on the pan speed
    [self.pet onPet:magnitude];
    switch (self.petGestureRecognizer.state) {
        //If pan too fast
        case 2:
            if (self.pet.catMood == 1) {
                self.petImageView.image = [UIImage imageNamed:@"grumpy.png"];
            }
            break;
        //If user lets go of pan
        case 3:
            self.petImageView.image = [UIImage imageNamed:@"default.png"];
            [self.pet onStopPet];
            [self.sleepTimer invalidate];
            self.sleepTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(sleep:) userInfo:nil repeats:YES];
            break;
        default:
            break;
    }
}

- (IBAction)onAppleDrag:(UIPanGestureRecognizer *)sender {
    self.panAppleGestureRecognizer = sender;
    //Create new apple and add it to the view in the same location and with the same size
    if (!self.appleViewNew) {
        CGRect appleSize = self.appleView.frame;
        self.appleViewNew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple.png"]];
        self.appleViewNew.frame = appleSize;
        [self.view addSubview: self.appleViewNew];
    }
    //If the user pans it will move the apple
    CGPoint touchLocation = [self.panAppleGestureRecognizer locationInView:self.view];
    self.appleViewNew.center = touchLocation;
   
    //If the user let go ontop of the pet
    if ( CGRectContainsPoint(self.petImageView.frame, self.appleViewNew.center) && (self.panAppleGestureRecognizer.state == 3)) {
        [self.appleViewNew removeFromSuperview];
        //Change pet mood
        [self.pet onFeed];
        self.petImageView.image = [UIImage imageNamed:@"happy.png"];
        self.appleViewNew = nil;
        //Reset bored timer
        self.boredTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(bored) userInfo:nil repeats:YES];
    //If the user let go anywhere else
    }else if ( CGRectContainsPoint(self.petImageView.frame, self.appleViewNew.center) == NO && (self.panAppleGestureRecognizer.state == 3)) {
        //Do animation on apple
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.appleViewNew.frame = CGRectMake(self.appleViewNew.frame.origin.x, self.view.frame.size.height, self.appleViewNew.frame.size.width, self.appleViewNew.frame.size.height);
        //Kill apple once it leaves the screen
        } completion:^(BOOL finished){
            [self.appleViewNew removeFromSuperview];
            self.appleViewNew = nil;
        }];
        
    }
    //Stop and reset the sleep timer
    [self.sleepTimer invalidate];
    self.sleepTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(sleep:) userInfo:nil repeats:YES];
}

#pragma mark - Pet Mood Change

-(void) updateCatMood: (NSString *) newMood {
    self.moodLabel.text = newMood;
}

- (void) sleep:(NSTimer *)timer
{
    [self.pet onSleep];
    self.petImageView.image = [UIImage imageNamed:@"sleeping.png"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"restfulness"]) {
        [self updateRestfulnessBar];
    }
}

-(void) bored {
    [self.boredTimer invalidate];
    self.petImageView.image = [UIImage imageNamed:@"default.png"];
    [self.pet onStopPet];
}

-(void) updateRestfulnessBar {
    CGFloat screenSize = self.view.frame.size.width;
    self.restBarWidth = screenSize * (float)self.pet.restfulness/100;
    CGRect restBar = CGRectMake(self.restfulnessBar.frame.origin.x, self.restfulnessBar.frame.origin.y, self.restBarWidth, self.restfulnessBar.frame.size.height);
    self.restfulnessBar.frame = restBar;
}

@end
