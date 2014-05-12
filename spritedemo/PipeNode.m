//
//  PipeNode.m
//  spritedemo
//
//  Created by Bradley Johnson on 5/11/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import "PipeNode.h"

@implementation PipeNode

-(void)update:(CFTimeInterval)currentTime
{
    if (!self.hidden)
    {
        self.position = CGPointMake(self.position.x + 1, self.position.y);
        
        if (self.position.x < 0)
        {
            self.hidden = YES;
            
        }
    }
}

@end
