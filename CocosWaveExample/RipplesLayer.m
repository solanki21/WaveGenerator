//
//  Ripples.m
//  CocosShaderEffects
//
//  Created by Kalpesh Solanki on 1/10/13.
//
//

#import "Ripples.h"
#import "CCSpriteWaveGenerator.h"

@implementation Ripples{
    CCSpriteWaveGenerator *swg;
}

- (id) init{
    self = [super init];
    if(self){
        CCSprite* sprite = [CCSprite spriteWithFile:@"Default.png"];
        swg = [[CCSpriteWaveGenerator alloc] initWithCCSprite:sprite];
        
        
        //Display
        CGSize size = [[CCDirector sharedDirector] winSize];
        swg.sprite.position = ccp(size.width/2,size.height/2);
        swg.sprite.scale = 0.5;
        swg.sprite.rotation = 180;
        swg.sprite.scaleX = -0.5;
        [self addChild:swg.sprite];
        
        [self scheduleUpdate];

    }
    
    return self;
}

- (void) update:(ccTime)dt{
    [swg update:dt];

    ///cause random ripples
    static ccTime tickCounter  = 0.0;
    tickCounter += dt;
    
    if(tickCounter > 0.5){
        NSLog(@"Causing Ripple");
        [self causeRandomRipples];
        tickCounter = 0.0;
    }
}


- (void) causeRandomRipples{
    CGPoint origin = CGPointMake(rand()%50, rand()%50);
    if(origin.x != 0 && origin.y != 0){
        [swg createWaveAt:origin];
    }
}


@end
