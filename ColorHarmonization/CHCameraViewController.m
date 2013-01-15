//
//  CHCameraViewController.m
//  ColorHarmonization
//
//  Created by Johnny Bee on 13/1/13.
//  Copyright (c) 2013年 Johnny. All rights reserved.
//

#import "CHCameraViewController.h"
#import "CHHarmonizeViewController.h"

@interface CHCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@end

@implementation CHCameraViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self UIReset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIReset{
    [self.myImage setImage:nil];
    [self.pickAPhoto setHidden:NO];
    [self.btnHarmonize setHidden:YES];
}

- (IBAction)takePicture:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (IBAction)loadAlbum:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];

}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.myImage setImage:newImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.pickAPhoto setHidden:YES];
    [self.btnHarmonize setHidden:NO];
    // Save image
//    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)loadActionSheet:(id)sender
{
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"Take a Photo From"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"My Albums", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self performSelector:@selector(takePicture:) withObject:self];
    } else if (buttonIndex == 1) {
        [self performSelector:@selector(loadAlbum:) withObject:self];
    }
}

- (IBAction)harmonize:(id)sender{
    [self performSegueWithIdentifier:@"harmonize" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UIImage *image = self.myImage.image;
    
    if([segue.identifier isEqualToString:@"harmonize"]){
        CHHarmonizeViewController *detailPage = segue.destinationViewController;
        detailPage.image = image;
    }
}

@end
