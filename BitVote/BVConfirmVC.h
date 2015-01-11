//
//  BVConfirmVC.h
//  BitVote
//
//  Created by Yair Szarf on 1/11/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVCandidate.h"

@interface BVConfirmVC : UIViewController
@property (strong, nonatomic) BVCandidate * selectedCandidate;
@end
