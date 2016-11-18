//
//  Pet.m
//  Phonagotchi
//
//  Created by Erin Luu on 2016-11-10.
//  Copyright © 2016 Lighthouse Labs. All rights reserved.
//

#import "Pet.h"

@interface Pet ()
@property NSTimer * restTimer;
@end

@implementation Pet

- (instancetype)init
{
    self = [super init];
    if (self) {
        _catMood = Sleepy;
        _restfulness = 100;
    }
    return self;
}

-(NSString *) getMood {
    NSString * newMood = @"Sleepy";
    switch (self.catMood) {
        case 0:
            newMood = @"Bored";
            break;
        case 1:
            newMood = @"Grumpy";
            break;
        case 2:
            newMood = @"Sleepy";
            break;
        case 3:
            newMood = @"Happy";
            break;

        default:
            break;
    }
    return newMood;
}

-(void) onPet: (float) magnitude {
    if (magnitude > 500) {
        self.catMood = Grumpy;
    }else if (magnitude == 0) {
        self.catMood = Bored;
    }
    [self updateMood];
    [self.restTimer invalidate];
    self.restTimer =  [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(changeRestfulness:) userInfo:@"decrease" repeats:YES];
}

-(void) onStopPet {
    self.catMood = Bored;
    [self updateMood];
}

-(void) onSleep {
    self.catMood = Sleepy;
    [self updateMood];
    [self.restTimer invalidate];
    self.restTimer =  [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(changeRestfulness:) userInfo:@"increase" repeats:YES];
}

-(void) changeRestfulness: (NSTimer *) timer {
    if ([timer.userInfo isEqualToString:@"increase"]) {
        if (self.restfulness < 100) self.restfulness += 1;
    }else if  ([timer.userInfo isEqualToString:@"decrease"]) {
        if (self.restfulness > 0) self.restfulness -= 1;
    }
}

-(void) onFeed {
    self.catMood = Happy;
    [self updateMood];
    [self.restTimer invalidate];
    self.restTimer =  [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(changeRestfulness:) userInfo:@"decrease" repeats:YES];
}

-(void) updateMood {
    [self.catViewDelegate updateCatMood:[self getMood]];
}

@end
