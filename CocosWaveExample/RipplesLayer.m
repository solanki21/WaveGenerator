//
//  Ripples.m
//  CocosShaderEffects
//
//  Created by Kalpesh Solanki on 1/10/13.
//
//

#import "RipplesLayer.h"
#import "CCSpriteWaveGenerator.h"
#import "CCTouchDispatcher.h"

@implementation RipplesLayer{
    CCSpriteWaveGenerator *swg;
}

- (id) init{
    self = [super init];
    if(self){
        CCSprite* sprite = [CCSprite spriteWithFile:@"Default.png"];
        
        //Create CCSpriteWaveGenerator for the sprite.
        swg = [[CCSpriteWaveGenerator alloc] initWithCCSprite:sprite];
        
        //Display
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //Get the rippled sprite from the wave generator//
        CCSprite *rippledSprite = swg.rippledSprite;
        
        rippledSprite.rotation = 90;
        rippledSprite.scale = 1.0;
        rippledSprite.scaleY = -1.0;
        rippledSprite.position = ccp(size.width/2+80,size.height/2-80);
        [self addChild:rippledSprite];
        

        [self scheduleUpdate];
         self.isTouchEnabled = YES;
    }
    
    return self;
}

- (void) update:(ccTime)dt{
    [swg update:dt];
}


-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint origin = [swg.rippledSprite convertTouchToNodeSpace:touch];
    
    [swg createWaveAt:CGPointMake(origin.x,origin.y)];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event { 
    CGPoint origin = [swg.rippledSprite convertTouchToNodeSpace:touch];
    NSLog(@"touch origin: %f , %f",origin.x,origin.y);
    
    [swg createWaveAt:CGPointMake(origin.x,origin.y)];
}


@end
