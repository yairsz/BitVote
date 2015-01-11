//
//  BVCandidate.h
//  BitVote
//
//  Created by Yair Szarf on 1/11/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import <Parse/Parse.h>

@interface BVCandidate : PFObject <PFSubclassing>

@property (strong,nonatomic) NSString * fullName;
@property (strong,nonatomic) NSString * publicAddress;
@property (strong,nonatomic) NSString * electionID;

@end
