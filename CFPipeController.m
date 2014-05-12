//
//  CFPipeController.m
//  spritedemo
//
//  Created by Bradley Johnson on 5/11/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import "CFPipeController.h"

@implementation CFPipeController

-(id)initWithNumberOfPipes:(NSInteger)numOfPipes
{
    self = [super init];
    if (self)
    {
        self.pipes = [NSMutableArray new];
        for (int i = 0; i < numOfPipes; i++)
        {
            PipeNode *pipe = [PipeNode spriteNodeWithImageNamed:@"pipe.png"];
            [self.pipes addObject:pipe];
            pipe.delegate = self;
            pipe.hidden = YES;
            if (i > 0)
            {
                PipeNode *previousPipe = self.pipes[i - 1];
                previousPipe.next = pipe;
            }
        }
        self.firstAvailable = self.pipes[0];
    }
    
    
    return self;
}

-(PipeNode*)firstAvailable
{
    PipeNode *first = _firstAvailable;
    _firstAvailable = first.next;
    first.hidden = NO;
    return first;
}

-(void)doneWithPipe:(PipeNode *)pipe
{
    pipe.hidden = YES;
    pipe.next = _firstAvailable;
    self.firstAvailable = pipe;
}

@end
