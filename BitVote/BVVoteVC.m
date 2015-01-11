//
//  BVVoteVC.m
//  BitVote
//
//  Created by Yair Szarf on 1/11/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import "BVVoteVC.h"
#import <Parse/Parse.h>
#import "BVCandidate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "BVConfirmVC.h"



@interface BVVoteVC () <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (weak,nonatomic) IBOutlet UITableView * tableView;
@property (strong,nonatomic) NSArray * candidates;

@end

@implementation BVVoteVC
{
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    // Do any additional setup after loading the view.
    PFQuery * query = [PFQuery queryWithClassName:@"BVCandidate"];
    [query whereKey:@"electionID" equalTo:@"Hackathon"];
    [query orderByAscending:@"fullName"];
    [self showHUD:@"Fetching Candidates"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.candidates = objects;
        [self.tableView reloadData];
        [HUD hide:YES];
    }];
    
}

- (void)showHUD:(NSString *) message
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.color = [UIColor colorWithWhite:0.000 alpha:0.600];
    HUD.delegate = self;
    HUD.labelText = message;
    [HUD setAnimationType:MBProgressHUDAnimationZoomIn];
    
    [HUD show:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.candidates.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BVCandidate * candidate = self.candidates[indexPath.row];
    cell.textLabel.text = candidate.fullName;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BVCandidate * selectedCandidate = self.candidates[indexPath.row];
    [self confirmVoteForCandidate:selectedCandidate];
}

- (void) confirmVoteForCandidate:(BVCandidate *) candidate
{
    BVConfirmVC * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"confirm"];
    vc.selectedCandidate = candidate;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


@end
