/*
 * Copyright (c) 2013 Kalpesh Solanki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "CCSpriteWaveGenerator.h"
#import "CCSpriteWaveGeneratorShaders.h"

//Increase this value if you want to increase the "resolution" of the ripples//
//Note that, higher the value slower the simulation
#define MAX_HEIGHTFIELD_WIDTH 32

@implementation CCSpriteWaveGenerator{
    CCRenderTexture *rtPing,*rtPong,*rtHFOffset;
    CCRenderTexture *resultTexture;

    CCSprite *sourceSprite;
    CCSprite *resultSprite;
    CCSprite *heightFieldSpriteForRenderingToHFOffsetRenderTexture;
    
    CGSize resultTextureSize;
    CGSize heightFieldSize;
    float spriteToHeightFieldSizeRatio;
    
    bool causeRippleFlag;
    CGPoint rippleOrigin;
}

@synthesize rippledSprite = resultSprite;

- (id) initWithCCSprite:(CCSprite*)sprite{
    self = [super init];
    if(self){
        sourceSprite = [sprite retain];
        float spriteWidthToHeightRatio = sourceSprite.boundingBox.size.width/sourceSprite.boundingBox.size.height;
        
        int hfwidth = sourceSprite.boundingBox.size.width/2.0;
        int hfheight = 0;
        if(hfwidth > MAX_HEIGHTFIELD_WIDTH){
            hfwidth = MAX_HEIGHTFIELD_WIDTH;
        }
        hfheight = hfwidth/spriteWidthToHeightRatio;
        heightFieldSize = CGSizeMake(hfwidth, hfheight);
        spriteToHeightFieldSizeRatio = sourceSprite.boundingBox.size.width/hfwidth;
        
        resultTextureSize = sourceSprite.boundingBox.size;
        
       // NSLog(@"HF size: %d x %d",hfwidth,hfheight);
        
        
        //Create Two Render Textures to render on each other's textures//
        rtPing = [[CCRenderTexture renderTextureWithWidth:heightFieldSize.width height:heightFieldSize.height] retain];
        [self setupRenderTexture:rtPing];
        
        rtPong = [[CCRenderTexture renderTextureWithWidth:heightFieldSize.width height:heightFieldSize.height] retain];
        [self setupRenderTexture:rtPong];

        //rtHFOffset = [[CCRenderTexture renderTextureWithWidth:heightFieldSize.width height:heightFieldSize.height] retain];
        //[self setupHFOffsetRenderTexture:rtHFOffset];
        
        resultTexture = [[CCRenderTexture renderTextureWithWidth:resultTextureSize.width height:resultTextureSize.height] retain];
        [self setupRippleSpriteShader:sourceSprite];
        
        resultSprite = [[CCSprite spriteWithTexture:resultTexture.sprite.texture] retain];

        
        causeRippleFlag = false;
    }
    
    return self;
}

- (void) update:(ccTime) dt
{
    [self calculateHeighField];
    //[self calculateHeighFieldOffsets];
    [self applyRipplesToSprite:sourceSprite andStoreIn:resultTexture];
    
    causeRippleFlag = false;
}

- (void) createWaveAt:(CGPoint) origin{
    causeRippleFlag = true;
    rippleOrigin = CGPointMake(origin.x/spriteToHeightFieldSizeRatio,origin.y/spriteToHeightFieldSizeRatio);
  //  NSLog(@"hf size: %f x %f, ripple Origin: %f , %f",heightFieldSize.width,heightFieldSize.height, rippleOrigin.x,rippleOrigin.y);
}

- (void) dealloc{
    [super dealloc];
    [rtPing release];
    [rtPong release];
    [resultSprite release];
    [resultTexture release];
    [sourceSprite release];
}

////////// Private Methods ////////////////

- (void) calculateHeighField{
    //Use shader to render rtPing Texture to rtPong Texture
    //and swap them for the next iteration
    
    [rtPong begin];
    rtPing.sprite.position = ccp(heightFieldSize.width/2,heightFieldSize.height/2);
    [rtPing.sprite.shaderProgram use];
    
    GLuint Program = rtPing.sprite.shaderProgram->program_;
    
    GLuint HFBLoc =        glGetUniformLocation(Program, "HeightFieldB");
    GLuint causeRippleFlagLoc =  glGetUniformLocation(Program, "CauseRippleFlag");
    GLuint rippleOriginLoc =  glGetUniformLocation(Program, "RippleOrigin");
    GLuint scale =         glGetUniformLocation(Program, "Scale");
    
    glUniform1i(HFBLoc,1);
    glUniform1f(causeRippleFlagLoc,causeRippleFlag);
    glUniform2f(rippleOriginLoc,rippleOrigin.x,rippleOrigin.y);
    glUniform2f(scale, 1.0f/heightFieldSize.width, 1.0f/heightFieldSize.height);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D,rtPong.sprite.texture.name);
    glActiveTexture(GL_TEXTURE0);
    
    [rtPing.sprite visit];
//    if(causeRippleFlag){
//        //ccDrawPoint(rippleOrigin);
//        ccDrawCircle(rippleOrigin, 5.0, 360, 10, false);
//    }
    
    [rtPong end];
    
    
    [self swapRenderTextures];
}

- (void) calculateHeighFieldOffsets{
    //Use shader to render rtPing Texture to rtPong Texture
    //and swap them for the next iteration
        
    [rtHFOffset begin];
    heightFieldSpriteForRenderingToHFOffsetRenderTexture.position = ccp(heightFieldSize.width/2,heightFieldSize.height/2);
    [heightFieldSpriteForRenderingToHFOffsetRenderTexture.shaderProgram use];
    
    GLuint Program = heightFieldSpriteForRenderingToHFOffsetRenderTexture.shaderProgram->program_;
    GLuint scale =         glGetUniformLocation(Program, "Scale");
    

    glUniform2f(scale, 1.0f/(heightFieldSize.width), 1.0f/(heightFieldSize.height));
    
    glActiveTexture(GL_TEXTURE0);
    
    [heightFieldSpriteForRenderingToHFOffsetRenderTexture visit];
    [rtHFOffset end];
}

- (void) applyRipplesToSprite:(CCSprite*) sprite andStoreIn:(CCRenderTexture*)rt{
    [rt beginWithClear:0.0 g:0.0 b:0.0 a:1.0];
    
    CGSize texSize = resultTextureSize;
    sprite.position = ccp(texSize.width/2,texSize.height/2);
    
    [sprite.shaderProgram use];
    
    GLuint Program = sprite.shaderProgram->program_;
    
   // GLuint HFLoc =  glGetUniformLocation(Program, "HFOffset");
    GLuint HFLoc =  glGetUniformLocation(Program, "HeightField");
    GLuint scale =  glGetUniformLocation(Program, "Scale");
    
    glUniform1i(HFLoc,1);
    glUniform2f(scale, 1.0f/texSize.width, 1.0f/texSize.height);
    
    glActiveTexture(GL_TEXTURE1);
  //  glBindTexture(GL_TEXTURE_2D,rtHFOffset.sprite.texture.name);
    glBindTexture(GL_TEXTURE_2D,rtPing.sprite.texture.name);
    glActiveTexture(GL_TEXTURE0);
    
    [sprite visit];
    
    
    [rt end];
}

////


- (void)setupRippleSpriteShader:(CCSprite*) sprite{
   // sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
   //                                                   fragmentShaderByteArray:_ripple_frag_shader];

    sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderFilename:@"ripple_vert_shader.vsh" fragmentShaderFilename:@"ripple_frag_shader.fsh"];
    
    [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [sprite.shaderProgram link];
    [sprite.shaderProgram updateUniforms];
    
    [sprite.texture setAliasTexParameters];
}

- (void)setupRenderTexture:(CCRenderTexture*) rt{
    
    [rt beginWithClear:0.0 g:0.0 b:0.0 a:1.0];
    [rt end];
    
   // rt.sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
     //                                                    fragmentShaderByteArray:_heighfield_frag_shader];
    rt.sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderFilename:@"heightfield_vert_shader.vsh" fragmentShaderFilename:@"heightfield_frag_shader.fsh"];
    
    [rt.sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [rt.sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [rt.sprite.shaderProgram link];
    [rt.sprite.shaderProgram updateUniforms];

    [rt.sprite.texture setAntiAliasTexParameters];
}

- (void)setupHFOffsetRenderTexture:(CCRenderTexture*) rt{
    
//    [rt beginWithClear:0.0 g:0.0 b:0.0 a:1.0];
//    [rt end];
//    
//    heightFieldSpriteForRenderingToHFOffsetRenderTexture = [[CCSprite spriteWithTexture:rtPing.sprite.texture] retain];
//    
//    CCSprite *sprite = heightFieldSpriteForRenderingToHFOffsetRenderTexture;
//    sprite.scaleY = -1.0;
//    
//    sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderFilename:@"hfoet_vert_shader.vsh" fragmentShaderFilename:@"hfoffsetg_shader.fsh"];
//    
//    [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
//    [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
//    [sprite.shaderProgram link];
//    [sprite.shaderProgram updateUniforms];
//    [sprite.texture setAntiAliasTexParameters];
}

- (void) swapRenderTextures{
    CCRenderTexture* temp = rtPing;
    rtPing = rtPong;
    rtPong = temp;
}


@end
