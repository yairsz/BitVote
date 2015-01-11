//
//  BVConfirmVC.m
//  BitVote
//
//  Created by Yair Szarf on 1/11/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import "BVConfirmVC.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BVConfirmVC () <MBProgressHUDDelegate>

@property (weak,nonatomic) IBOutlet UIButton * voteButton;
@property (weak,nonatomic) IBOutlet UIButton * backButton;
@property (weak,nonatomic) IBOutlet UILabel * candidateLabel;
@property (weak,nonatomic) IBOutlet UILabel * addressLabel;

@end

@implementation BVConfirmVC
{
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.candidateLabel.text = self.selectedCandidate.fullName;
    self.addressLabel.text = self.selectedCandidate.publicAddress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showHUD:(NSString *) message
{
    if (!HUD) {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
        
    }
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.color = [UIColor colorWithWhite:0.000 alpha:0.800];
    HUD.delegate = self;
    HUD.labelText = message;
    [HUD setAnimationType:MBProgressHUDAnimationZoomIn];
    
    [HUD show:YES];
}

-(IBAction)tappedVote:(id)sender
{
    [self performVote];
}

- (IBAction)tappedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) performVote
{
    [self showHUD:@"Performing Vote"];
}
@end
