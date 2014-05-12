//
//  PipeNode.h
//  spritedemo
//
//  Created by Bradley Johnson on 5/11/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class PipeNode;

@protocol PipeDelegate <NSObject>

-(void)doneWithPipe:(PipeNode *)pipe;

@end


@interface PipeNode : SKSpriteNode

@property (weak,nonatomic) PipeNode *next;
@property (unsafe_unretained) id<PipeDelegate> delegate;

@end
