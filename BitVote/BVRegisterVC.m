//
//  BVRegisterVC.m
//  BitVote
//
//  Created by Yair Szarf on 1/10/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import "BVRegisterVC.h"
#import <Parse/Parse.h>
#import "BVUser.h"
#import <SLScrollViewKeyboardSupport.h> 

@interface BVRegisterVC () <UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UITextField * textFieldFirstName;
@property (weak,nonatomic) IBOutlet UITextField * textFieldLastName;
@property (weak,nonatomic) IBOutlet UITextField * textFieldEmail;
@property (weak,nonatomic) IBOutlet UITextField * textFieldVoterID;
@property (weak,nonatomic) IBOutlet UITextField * textFieldPassword;
@property (strong,nonatomic) NSArray * textFieldOrder;

@property (weak,nonatomic) IBOutlet UIButton * submitButton;

@property (weak,nonatomic) IBOutlet UIScrollView * textScrollView;
@property (strong, nonatomic) SLScrollViewKeyboardSupport * keyboardSupport;


@end

@implementation BVRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textFieldOrder = @[self.textFieldFirstName,
                            self.textFieldLastName,
                            self.textFieldEmail,
                            self.textFieldVoterID,
                            self.textFieldPassword];
    self.keyboardSupport= [[SLScrollViewKeyboardSupport alloc] initWithScrollView:self.textScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initializeUser:(BVUser *) user
{
    BTCKey * key = [[BTCKey alloc] init];
    NSLog(@"%@, %@",key.privateKey, key.publicKey);
    user.publicKey = key.address.string;
    user.privateKey = key.privateKeyAddress.string;
    [user saveInBackground];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registrationSuccesful"
                                                        object:nil];
}


- (IBAction)tappedCancel:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedSignUp:(UIButton*)sender
{
    PFUser *user = [PFUser user];
    user.username = self.textFieldVoterID.text;
    user.password = self.textFieldPassword.text;
    user.email = self.textFieldEmail.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self initializeUser:[BVUser currentUser]];
        } else {
            if (error) {
                [self handleLoginError:error];
            }
        }
    }];
    
}

- (BOOL) isFormValid {
    BOOL firstNameFilled = (self.textFieldFirstName.text.length > 1);
    BOOL lastNameFilled = (self.textFieldLastName.text.length > 1);
    BOOL emailFilled = (self.textFieldEmail.text.length > 1);
    BOOL voterIDFilled = (self.textFieldVoterID.text.length > 1);
    BOOL passwordFilled = (self.textFieldPassword.text.length > 1);
    
    BOOL emailValid = [self validateEmail:self.textFieldEmail.text];
    
    if (firstNameFilled &&
        lastNameFilled &&
        emailValid &&
        emailFilled &&
        voterIDFilled &&
        passwordFilled) return YES;
    
    return NO;
}



- (void) handleLoginError:(NSError *) error
{
    NSLog(@"%@",error.localizedDescription);
    NSString * message = [NSString stringWithFormat:@"There was a problem, \n%@",error];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Fail!" message:message delegate:self cancelButtonTitle:@"Shucks!" otherButtonTitles:nil];
    [alertView show];
}

- (BOOL) validateEmail:(NSString*) email
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:email] == NO) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - UITextFieldDelegate


-(void) textFieldDidBeginEditing:(UITextField *)textField {
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    textField.layer.borderColor = [[UIColor whiteColor] CGColor];

}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [textField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (textField == self.textFieldEmail) {
        if (![self validateEmail:textField.text]) {
            self.textFieldEmail.layer.borderColor = [[UIColor redColor] CGColor];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger i = [self.textFieldOrder indexOfObject:textField];
    if (i < self.textFieldOrder.count-1) {
        [self.textFieldOrder[i+1] becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
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
    if ([self isFormValid]) self.submitButton.enabled = YES;

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
