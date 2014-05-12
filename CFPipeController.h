//
//  CFPipeController.h
//  spritedemo
//
//  Created by Bradley Johnson on 5/11/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PipeNode.h"

@interface CFPipeController : NSObject <PipeDelegate>
@property (weak,nonatomic) PipeNode *firstAvailable;
@property (strong,nonatomic) NSMutableArray *pipes;

-(id)initWithNumberOfPipes:(NSInteger)numOfPipes;

@end
