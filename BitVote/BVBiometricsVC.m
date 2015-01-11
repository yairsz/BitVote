//
//  BVBiometricsVC.m
//  BitVote
//
//  Created by Yair Szarf on 1/10/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import "BVBiometricsVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "BVUser.h"

@interface BVBiometricsVC ()

@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureStillImageOutput * imageOutput;
@property (weak, nonatomic) IBOutlet UIView * previewView;
@property (weak, nonatomic) IBOutlet UIImageView * imageCheckView;
@property (weak,nonatomic) IBOutlet UIButton * retakeButton, *proceedButton;
@property (strong, nonatomic) AVCaptureDevice * inputDevice;
@property (strong, nonatomic) NSData * imageData;

@end

@implementation BVBiometricsVC
{
    AVCaptureVideoPreviewLayer *  videoLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setupVideoPreview];
    
}



- (void) setupVideoPreview
{
    self.retakeButton.hidden = YES;
    if (!self.session) {
        self.session = [[AVCaptureSession alloc] init];
        [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    AVCaptureDevice * inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError * error;
    AVCaptureDeviceInput * deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    
    videoLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [videoLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    videoLayer.frame = self.previewView.bounds;
    videoLayer.cornerRadius = 10.0;
    //    self.view.layer.masksToBounds = YES;
    [self.previewView.layer addSublayer:videoLayer];
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    self.imageOutput.outputSettings = outputSettings;
    [self.session addOutput:self.imageOutput];
    [self.session startRunning];
    
}

- (void) startPreview
{
    NSError * error;
    [self.session startRunning];
    [self.inputDevice lockForConfiguration:&error];
    self.inputDevice.torchMode = AVCaptureTorchModeOn;
    self.imageCheckView.hidden = YES;
    self.proceedButton.enabled = NO;

}

- (IBAction)takePicture:(UIButton *) sender
{
    self.retakeButton.hidden = NO;
    self.proceedButton.enabled = YES;
    AVCaptureConnection * captureConnection = nil;
    for (AVCaptureConnection * connection in self.imageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if (([port.mediaType isEqual:AVMediaTypeVideo])) {
                captureConnection = connection;
                break;
            }
        }
        if (captureConnection) {
            break;
        }
    }
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            self.imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage * image = [UIImage imageWithData:self.imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageCheckView.image = image;
                self.imageCheckView.hidden = NO;
//                [videoLayer removeFromSuperlayer];
                [self.session stopRunning];
            });
        }
    }];
    
}

- (IBAction)tappedRetake:(UIButton *)sender
{
    self.proceedButton.enabled = YES;
    [self startPreview];
}

- (IBAction)tappedProceed:(UIButton *)sender
{
    BVUser * user = [BVUser currentUser];
    PFFile * thumbFile = [PFFile fileWithData:self.imageData];
    [thumbFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        user.thumbPrint = thumbFile;
        [user saveInBackground];
    }];
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vote"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
