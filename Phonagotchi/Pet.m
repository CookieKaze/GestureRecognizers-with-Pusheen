//
//  Pet.m
//  Phonagotchi
//
//  Created by Erin Luu on 2016-11-10.
//  Copyright © 2016 Lighthouse Labs. All rights reserved.
//

#import "Pet.h"

@implementation Pet

-(NSString *) onPet: (CGPoint) velocity {
    NSString * imageName;
    if ((velocity.x > 300 || velocity.x < -300) || (velocity.y > 300 || velocity.y < -300)) {
        imageName = @"grumpy.png";
        //NSLog(@"FAST: %f.2", velocity.x);
    }else{
        imageName = @"default.png";
        //NSLog(@"SLOW: %f.2", velocity.x);
    }
    return imageName;
}

@end
