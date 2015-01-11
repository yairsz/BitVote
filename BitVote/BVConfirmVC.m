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
    NSURL *URL = [NSURL URLWithString:@"https://api.coinprism.com/v1/sendasset?format=json"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString * body = @"{";
    body = [body stringByAppendingString:@"\"fees\": 1000,"];
    body = [body stringByAppendingString:@"\"from\": \"1zLkEoZF7Zdoso57h9si5fKxrKopnGSDn\","];
    body = [body stringByAppendingString:@"\"to\": ["];
    body = [body stringByAppendingString:@"{"];
    body = [body stringByAppendingString:@"\"address\": \"akSjSW57xhGp86K6JFXXroACfRCw7SPv637\","];
    body = [body stringByAppendingString:@"\"amount\": \"10\","];
    body = [body stringByAppendingString:@"\"asset_id\": \"AHthB6AQHaSS9VffkfMqTKTxVV43Dgst36\""];
    body = [body stringByAppendingString:@"}"];
    body = [body stringByAppendingString:@"]"];
    body = [body stringByAppendingString:@"}"];

    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

     
     NSURLSession *session = [NSURLSession sharedSession];
     NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                             completionHandler:
       ^(NSData *data, NSURLResponse *response, NSError *error) {
           
           if (error) {
               // Handle error...
               return;
           }
           
           if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
               NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
               NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
           }
           
           NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           NSLog(@"Response Body:\n%@\n", body);
       }];
     [task resume];
}
@end
