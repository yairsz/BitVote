//
//  BVLoginVC.m
//  BitVote
//
//  Created by Yair Szarf on 1/10/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import "BVLoginVC.h"
#import <SLScrollViewKeyboardSupport.h>
#import <CoreBitcoin/BTCKey.h>
#import <Parse/Parse.h>

@interface BVLoginVC () <UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UIScrollView * textScrollView;
@property (strong, nonatomic) SLScrollViewKeyboardSupport * keyboardSupport;
@property (weak,nonatomic) IBOutlet UITextField * textFieldVoterID;
@property (weak,nonatomic) IBOutlet UITextField * textFieldPassword;

@end

@implementation BVLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.keyboardSupport= [[SLScrollViewKeyboardSupport alloc] initWithScrollView:self.textScrollView];
    [self registerForNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrationSuccesful) name:@"registrationSuccesful"
                                               object:nil];
}

- (void) registrationSuccesful
{
    [self.navigationController popViewControllerAnimated:YES];
    NSString * message = @"Registration was succesful. \nPlease sign in";
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];

}

- (IBAction)tappedLogin:(UIButton *)sender
{
    [PFUser logInWithUsernameInBackground:self.textFieldVoterID.text
                                 password:self.textFieldPassword.text
                                    block:^(PFUser *user, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSString * message = [NSString stringWithFormat:@"There was an error signing in: %@", error.localizedDescription];
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"authenticate"];
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
        });
    }];
}

#pragma mark - UITextFieldDelegate


-(void) textFieldDidBeginEditing:(UITextField *)textField {
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [textField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(void) textFieldDidChange: (UITextField *) sender {
    // use this method for behaviors that happen as the user types
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //This is a gist by @johnnyclem https://gist.github.com/johnnyclem/8215415 well done!
    for (UIControl *control in self.view.subviews) {
        if ([control isKindOfClass:[UITextField class]]) {
            [control endEditing:YES];
        }
    }
}

@end
