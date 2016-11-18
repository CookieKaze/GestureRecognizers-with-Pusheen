//
//  Pet.h
//  Phonagotchi
//
//  Created by Erin Luu on 2016-11-10.
//  Copyright © 2016 Lighthouse Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum catMood {
    Bored,
    Grumpy,
    Sleepy,
    Happy
} catMood;

@protocol catViewRules <NSObject>
-(void) updateCatMood: (NSString *) newMood;
@end

@interface Pet : NSObject

@property catMood catMood;
@property int restfulness;
@property id <catViewRules> catViewDelegate;

-(void) onPet: (float) magnitude;
-(void) onStopPet;
-(void) onFeed;
-(void) onSleep;
-(void) updateMood;

-(NSString *) getMood;
@end
