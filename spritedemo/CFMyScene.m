//
//  CFMyScene.m
//  spritedemo
//
//  Created by Brad on 2/17/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import "CFMyScene.h"
#import "CFPipeController.h"


@interface CFMyScene ()

{
    int _nextFlappy;
    double _nextFlappySpawn;
    double _previousTime;
    double _deltaTime;
    double _timeSinceLastPipes;
    double _nextPipeTime;
    
}

@property (strong,nonatomic) SKSpriteNode *mainCharacter;
//@property (strong,nonatomic) NSMutableArray *flappyArray;
@property (strong,nonatomic) NSMutableArray *pipes;
@property (strong,nonatomic) NSMutableArray *downPipes;
@property (weak,nonatomic) PipeNode *firstAvailablePipe;
@property (weak,nonatomic) PipeNode *firstAvailableDownPipe;


#define kNumFlappys 10
#define kNumOfPipes 16

@end
@implementation CFMyScene

static const uint32_t eagleCategory =  0x1 << 0;
static const uint32_t flappyCategory =  0x1 << 1;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        [self setupScrollingBackground];
        [self setupPlayer];
        [self setupPipes];
        
        _nextPipeTime = 1.5;
        
    }
    return self;
}

-(void)setupScrollingBackground
{
    for (int i = 0; i <2; i++)
    {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(i * bg.size.width,0);
        bg.name = @"background";
        [self addChild:bg];
    }
    
}

-(void)setupPlayer
{
    self.mainCharacter = [SKSpriteNode spriteNodeWithImageNamed:@"flappy"];
    self.mainCharacter.position = CGPointMake(50, 150);
    [self addChild:self.mainCharacter];
    
    self.mainCharacter.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.mainCharacter.size];
    self.mainCharacter.physicsBody.dynamic = YES;
    self.mainCharacter.physicsBody.affectedByGravity =YES;
    self.mainCharacter.physicsBody.allowsRotation = NO;
    self.mainCharacter.physicsBody.mass = 0.02;
    self.mainCharacter.physicsBody.categoryBitMask = eagleCategory;
    self.mainCharacter.physicsBody.contactTestBitMask = flappyCategory;
}
-(void)setupPipes
{
    self.pipes = [NSMutableArray new];
    for (int i = 0; i < kNumOfPipes; i++)
    {
        PipeNode *pipe = [PipeNode spriteNodeWithImageNamed:@"pipe.png"];
        [self.pipes insertObject:pipe atIndex:0];
        //pipe.delegate = self;
        pipe.hidden = YES;
        [self addChild:pipe];
        if (self.pipes.count > 1)
        {
            pipe.next = self.pipes[1];
        }
    }
    self.firstAvailablePipe = self.pipes[0];
    
    self.downPipes = [NSMutableArray new];
    for (int i = 0; i < kNumOfPipes; i++)
    {
        PipeNode *pipe = [PipeNode spriteNodeWithImageNamed:@"downpipe.png"];
        [self.downPipes insertObject:pipe atIndex:0];
        //pipe.delegate = self;
        pipe.hidden = YES;
        [self addChild:pipe];
        if (self.downPipes.count > 1)
        {
            pipe.next = self.downPipes[1];
        }
    }
    self.firstAvailableDownPipe = self.downPipes[0];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.mainCharacter.physicsBody setVelocity:CGVectorMake(0, 0)];
    [self.mainCharacter.physicsBody applyImpulse:CGVectorMake(0, 7)];
}

-(float)randomValueBetween:(float)low andValue:(float)high
{
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

-(void)update:(CFTimeInterval)currentTime {
    
    //NSLog(@" %f",self.view.frame.size.height);
    _deltaTime = currentTime - _previousTime;
    _previousTime = currentTime;
    //NSLog(@" %f",_deltaTime);
    
    _timeSinceLastPipes += _deltaTime;
    
    if (_timeSinceLastPipes > _nextPipeTime)
    {
        //NSLog(@"time for a pipe");
        PipeNode *pipe = self.firstAvailablePipe;
        float randomY = [self randomValueBetween:-100 andValue:100];
        NSLog(@" %f",pipe.size.height);
        pipe.position = CGPointMake(600, randomY);
        //[self addChild:pipe];
        CGPoint location = CGPointMake(-30, randomY);
        
        SKAction *moveAction = [SKAction moveTo:location duration:3];
        SKAction *endAction = [SKAction runBlock:^{
            [self doneWithPipe:pipe];
        }];
        
        SKAction *sequence = [SKAction sequence:@[moveAction,endAction]];
        
        [pipe runAction:sequence];
        
        PipeNode *downPipe = self.firstAvailableDownPipe;
        float downY = randomY + 350;
        downPipe.position = CGPointMake(600, downY);
        //[self addChild:downPipe];
        CGPoint newLocation = CGPointMake(-30, downY);
        SKAction *downMoveAction = [SKAction moveTo:newLocation duration:3];
        SKAction *downEndAction = [SKAction runBlock:^{
            [self doneWithDownPipe:downPipe];
        }];
        SKAction *downSequence = [SKAction sequence:@[downMoveAction,downEndAction]];
        [downPipe runAction:downSequence];
        
        _timeSinceLastPipes = 0;
    }
    
    [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *bg = (SKSpriteNode *)node;
        bg.position = CGPointMake(bg.position.x - 5, bg.position.y);
        
        if (bg.position.x <= -bg.size.width)
        {
            bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y);
        }
    
    }];
    
}

-(PipeNode*)firstAvailablePipe
{
    PipeNode *first = _firstAvailablePipe;
    _firstAvailablePipe = first.next;
    first.hidden = NO;
    return first;
}

-(PipeNode*)firstAvailableDownPipe
{
    PipeNode *first = _firstAvailableDownPipe;
    _firstAvailableDownPipe = first.next;
    first.hidden = NO;
    return first;
}

-(void)doneWithPipe:(PipeNode*)pipe
{
    NSLog(@"done with child");
    pipe.hidden = YES;
    pipe.next = _firstAvailablePipe;
    self.firstAvailablePipe = pipe;
}

-(void)doneWithDownPipe:(PipeNode*)downPipe
{
     NSLog(@"done with child");
    downPipe.hidden = YES;
    downPipe.next = _firstAvailableDownPipe;
    self.firstAvailableDownPipe = downPipe;
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    
    NSLog(@"contact");
}

@end
