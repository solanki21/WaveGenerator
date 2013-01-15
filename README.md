WaveGenerator
=============

Cocos-2D Class (and Example project) for generating water-like waves in the CCSprite objects.

How to use it?
--------------
CCSpriteWaveGenerator class has all the logic to create and update ripple simulation on the CCSprite object you provide.

Step 1: 
```
      //Create CCSprite that you want the ripples applied
      
      CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
      
      //Create and initialized CCSpriteWaveGenerator object
      CCSpriteWaveGenerator* swg = [[CCSpriteWaveGenerator alloc] initWithCCSprite:sprite];
```

Step 2: 

```
     //You have to keep updating the state of the simulation in your CCLayer's update method

     - (void) update:(ccTime)dt{
          [swg update:dt];
      }          
```

Step 3:

```
    //Access the CCSprite with ripple simulation applied to it using property "rippledSprite"
    CCSprite *rippledSprite = swg.rippledSprite;
```

Step 4: 

```
   //Create waves for some fun!

   CGPoint rippleOrigin = CGPointMake(..,..);
   [swg createWaveAt:rippleOrigin];
```
   
   Touch Example:

```
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint origin = [swg.rippledSprite convertTouchToNodeSpace:touch];
    [swg createWaveAt:CGPointMake(origin.x,origin.y)];
}   
```


