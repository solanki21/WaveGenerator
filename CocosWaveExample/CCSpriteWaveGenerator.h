//
//  CCSpriteWaveGenerator.h
//  CocosShaderEffects
//
//  Created by Kalpesh Solanki on 1/14/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCSpriteWaveGenerator : NSObject

@property (readonly,nonatomic) CCSprite *sprite;
@property (readonly,nonatomic) CCSprite *hfsprite;

- (id) initWithCCSprite:(CCSprite*)sprite;
- (void) update:(ccTime) dt;
- (void) createWaveAt:(CGPoint) origin;

@end
