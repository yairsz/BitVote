//
//  BVUser.h
//  BitVote
//
//  Created by Yair Szarf on 1/10/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreBitcoin/CoreBitcoin.h>

@interface BVUser : PFUser

@property (strong,nonatomic) NSString * publicKey;
@property (strong,nonatomic) NSString * privateKey;
@property (strong,nonatomic) NSString * firstName, *lastName;
@property (strong,nonatomic) NSString * voterID;
@property (strong,nonatomic) PFFile * thumbPrint;

@end
