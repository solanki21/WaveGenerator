//
//  CCSpriteWaveGenerator.m
//  CocosShaderEffects
//
//  Created by Kalpesh Solanki on 1/14/13.
//
//

#import "CCSpriteWaveGenerator.h"
#import "CCSpriteWaveGeneratorShaders.h"

#define MAX_HF_WIDTH 50

@implementation CCSpriteWaveGenerator{
    CCRenderTexture *rtPing,*rtPong;
    CCRenderTexture *resultTexture;
    CGSize resultTextureSize;
    CCSprite *sourceSprite;
    CCSprite *resultSprite;
    CGSize heightFieldSize;
    bool causeRippleFlag;
    CGPoint rippleOrigin;
    
    CCSprite *_hfsprite;
}

@synthesize sprite = resultSprite;
@synthesize hfsprite = _hfsprite;

- (id) initWithCCSprite:(CCSprite*)sprite{
    self = [super init];
    if(self){
        sourceSprite = sprite;
        float spriteRatio = sourceSprite.boundingBox.size.width/sourceSprite.boundingBox.size.height;
        
        int hfwidth = sourceSprite.boundingBox.size.width/2.0;
        int hfheight = 0;
        if(hfwidth > MAX_HF_WIDTH){
            hfwidth = MAX_HF_WIDTH;
        }
        hfheight = hfwidth*spriteRatio;
        
        heightFieldSize = CGSizeMake(hfwidth, hfheight);
        resultTextureSize = sourceSprite.boundingBox.size;
        
       // NSLog(@"HF size: %d x %d",hfwidth,hfheight);
        
        
        //Create Two Render Textures to render on each other's textures//
        rtPing = [CCRenderTexture renderTextureWithWidth:heightFieldSize.width height:heightFieldSize.height];
        [self setupRenderTexture:rtPing];
        
        rtPong = [CCRenderTexture renderTextureWithWidth:heightFieldSize.width height:heightFieldSize.height];
        [self setupRenderTexture:rtPong];
                
        resultTexture = [CCRenderTexture renderTextureWithWidth:resultTextureSize.width height:resultTextureSize.height];
        [self setupRippleSpriteShader:sourceSprite];
        
        resultSprite = [CCSprite spriteWithTexture:resultTexture.sprite.texture];

        
        causeRippleFlag = false;

        _hfsprite = rtPing.sprite;
        
    }
    
    return self;
}

- (void) update:(ccTime) dt
{
    [self calculateHeighField];
    [self applyRipplesToSprite:sourceSprite andStoreIn:resultTexture];
}

- (void) createWaveAt:(CGPoint) origin{
    causeRippleFlag = true;
    rippleOrigin = origin;
}

////////// Private Methods ////////////////

- (void) applyRipplesToSprite:(CCSprite*) sprite andStoreIn:(CCRenderTexture*)rt{
    [rt beginWithClear:0.0 g:0.0 b:0.0 a:1.0];
    
    CGSize texSize = resultTextureSize;
    sprite.position = ccp(texSize.width/2,texSize.height/2);
    
    [sprite.shaderProgram use];
    
    GLuint Program = sprite.shaderProgram->program_;
    
    GLuint HFLoc =  glGetUniformLocation(Program, "HeightField");
    GLuint scale =  glGetUniformLocation(Program, "Scale");
    
    glUniform1i(HFLoc,1);
    glUniform2f(scale, 1.0f/texSize.width, 1.0f/texSize.height);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D,rtPing.sprite.texture.name);
    glActiveTexture(GL_TEXTURE0);
    
    [sprite visit];
    [rt end];
}

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
    [rtPong end];
    
    
    [self swapRenderTextures];
}

- (void)setupRippleSpriteShader:(CCSprite*) sprite{
    sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                      fragmentShaderByteArray:_ripple_frag_shader];
    [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [sprite.shaderProgram link];
    [sprite.shaderProgram updateUniforms];
    
    [sprite.texture setAliasTexParameters];
}

- (void)setupRenderTexture:(CCRenderTexture*) rt{
    
    [rt beginWithClear:0.0 g:0.0 b:0.0 a:1.0];
    [rt end];
    
    rt.sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                         fragmentShaderByteArray:_heighfield_frag_shader];
    [rt.sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [rt.sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [rt.sprite.shaderProgram link];
    [rt.sprite.shaderProgram updateUniforms];
    
    [rt.sprite.texture setAliasTexParameters];
}

- (void) swapRenderTextures{
    CCRenderTexture* temp = rtPing;
    rtPing = rtPong;
    rtPong = temp;
}


@end
