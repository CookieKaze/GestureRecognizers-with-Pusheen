//
//  Pet.m
//  Phonagotchi
//
//  Created by Erin Luu on 2016-11-10.
//  Copyright © 2016 Lighthouse Labs. All rights reserved.
//

#import "Pet.h"

@implementation Pet




- (instancetype)init
{
    self = [super init];
    if (self) {
        _catMood = Sleepy;
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
        default:
            break;
    }
    return newMood;
}

-(NSString *) onPet: (float) magnitude {
    if (magnitude > 500) {
        self.catMood = Grumpy;
        [self.catViewDelegate updateCatMood:[self getMood]];
    }else if (magnitude == 0) {
        self.catMood = Bored;
        [self.catViewDelegate updateCatMood:[self getMood]];
    }
    return [self getMood];
}

@end
