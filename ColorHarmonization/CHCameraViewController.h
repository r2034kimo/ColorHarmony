//
//  CHCameraViewController.h
//  ColorHarmonization
//
//  Created by Johnny Bee on 13/1/13.
//  Copyright (c) 2013年 Johnny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHCameraViewController : UIViewController
- (IBAction)takePicture:(id)sender;
- (IBAction)loadAlbum:(id)sender;
- (IBAction)loadActionSheet:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *pickAPhoto;
- (IBAction)harmonize:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *myImage;
@property (strong, nonatomic) IBOutlet UIButton *btnHarmonize;

@end
