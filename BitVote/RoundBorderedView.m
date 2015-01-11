//
//  RoundBorderedView.m
//  BitVote
//
//  Created by Yair Szarf on 1/10/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import "RoundBorderedView.h"

@implementation RoundBorderedView


- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self.layer setCornerRadius:10.0f];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.layer setBorderWidth:1.0];
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
