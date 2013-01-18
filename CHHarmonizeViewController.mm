//
//  CHHarmonizeViewController.m
//  Colmonizor
//
//  Created by Johnny Bee on 13/1/14.
//  Copyright (c) 2013年 Johnny. All rights reserved.
//

#import "CHHarmonizeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Extensions.h"
#import "Filter.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
using namespace cv;

@interface CHHarmonizeViewController () <UINavigationControllerDelegate, UIActionSheetDelegate>{
    ACAccount *facebookAccount;
}

@end

@implementation CHHarmonizeViewController


- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

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
    
    [self.harmonizedImage setImage:self.image];
    [self initializeFilterContext];
    [self loadFiltersForImage: self.harmonizedImage.image];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Delete image without saving?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"Cancel", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)saveImage:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.harmonizedImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:@"Done"
                                           message:@"The photo is saved successfully."
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
}


-(void) initializeFilterContext
{
    context = [CIContext contextWithOptions:nil];
}

-(UIImage *)colorFilter:(NSString *)Name PreviewImage:(UIImage *) image
{
    
    Mat hsv =  [self cvMatFromUIImage: image];
    
    cvtColor(hsv, hsv, CV_BGR2HSV);
    
    //int hueColor = 180, sCol = 1;
    int hisSize[180] = {0};
    
    for (int i=0; i < hsv.rows ; i++)
    {
        for(int j=0; j <  hsv.cols; j++)
        {
            int hue = hsv.at<cv::Vec3b>(i,j)[0];
            int sat = hsv.at<cv::Vec3b>(i,j)[1];
            
            hisSize[hue] += sat;
        }
    }
    if([Name isEqualToString:@"original"])
    {
        cvtColor(hsv, hsv, CV_HSV2BGR);
    }
    if([Name isEqualToString:@"iTypeFilter"])
    {
        int ialpha = 0;
        int it = [self iType:hisSize alphaAngle:&ialpha];
        NSLog(@"iType: %d , %d" , it, ialpha);
        [self iTypeHarm:hsv alpha:ialpha];
        cvtColor(hsv, hsv, CV_HSV2BGR);
    }
    if([Name isEqualToString:@"VTypeFilter"])
    {
        int Valpha = 0;
        int Vt = [self VType:hisSize alphaAngle:&Valpha];
        NSLog(@"VType: %d , %d" , Vt, Valpha);
        [self VTypeHarm:hsv alpha:Valpha];
        cvtColor(hsv, hsv, CV_HSV2BGR);
    }
    if([Name isEqualToString:@"LTypeFilter"])
    {
        int Lalpha = 0;
        int Lt = [self VType:hisSize alphaAngle:&Lalpha];
        NSLog(@"LType: %d , %d" , Lt, Lalpha);
        [self LTypeHarm:hsv alpha:Lalpha];
        cvtColor(hsv, hsv, CV_HSV2BGR);
    }
    if([Name isEqualToString:@"ITypeFilter"])
    {
        int Ialpha = 0;
        int It = [self IType:hisSize alphaAngle:&Ialpha];
        NSLog(@"IType: %d , %d" , It, Ialpha);
        [self ITypeHarm:hsv alpha:Ialpha];
        cvtColor(hsv, hsv, CV_HSV2BGR);
    }
    if([Name isEqualToString:@"TTypeFilter"])
    {
        int Talpha = 0;
        int Tt = [self TType:hisSize alphaAngle:&Talpha];
        NSLog(@"TType: %d , %d" , Tt, Talpha);
        [self TTypeHarm:hsv alpha:Talpha];
        cvtColor(hsv, hsv, CV_HSV2BGR);
    }
    if([Name isEqualToString:@"YTypeFilter"])
    {
        int Yalpha = 0;
        int Yt = [self YType:hisSize alphaAngle:&Yalpha];
        NSLog(@"YType: %d , %d" , Yt, Yalpha);
        [self YTypeHarm:hsv alpha:Yalpha];
        cvtColor(hsv, hsv, CV_HSV2BGR);
    }
    if([Name isEqualToString:@"XTypeFilter"])
    {
        int Xalpha = 0;
        int Xt = [self XType:hisSize alphaAngle:&Xalpha];
        NSLog(@"XType: %d , %d" , Xt, Xalpha);
        [self XTypeHarm:hsv alpha:Xalpha];
        
    }
    
    UIImage *fImage = [self UIImageFromCVMat: hsv];
    
    return fImage;
}
-(void) loadFiltersForImage:(UIImage *) image
{
//    
    UIImage *Original = [self colorFilter:@"original" PreviewImage:image];
    UIImage *iTypeFilter = [self colorFilter:@"iTypeFilter" PreviewImage:image];
    UIImage *VTypeFilter = [self colorFilter:@"VTypeFilter" PreviewImage:image];
    UIImage *LTypeFilter = [self colorFilter:@"LTypeFilter" PreviewImage:image];
    UIImage *ITypeFilter = [self colorFilter:@"ITypeFilter" PreviewImage:image];
    UIImage *TTypeFilter = [self colorFilter:@"TTypeFilter" PreviewImage:image];
    UIImage *YTypeFilter = [self colorFilter:@"YTypeFilter" PreviewImage:image];
    UIImage *XTypeFilter = [self colorFilter:@"XTypeFilter" PreviewImage:image];
    
   filters = [[NSMutableArray alloc] init];
    
    
    [filters addObjectsFromArray:[NSArray arrayWithObjects: Original, iTypeFilter, VTypeFilter,LTypeFilter,ITypeFilter, TTypeFilter ,YTypeFilter, XTypeFilter, nil]];
    
    [self createPreviewViewsForFilters];
}

-(void) createPreviewViewsForFilters
{
    int offsetX = 0;
    
    for(int index = 0; index < [filters count]; index++)
    {
        UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(10+offsetX, 10, 60, 60)];
        
        // create a label to display the name
        UILabel *filterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, filterView.bounds.size.width, 12)];
        
        filterNameLabel.center = CGPointMake(filterView.bounds.size.width/2, filterView.bounds.size.height + filterNameLabel.bounds.size.height);
        
        Filter *filter = (Filter *) [filters objectAtIndex:index];
        
        filterNameLabel.text =  filters[index];
        filterNameLabel.backgroundColor = [UIColor clearColor];
        filterNameLabel.textColor = [UIColor whiteColor];
        filterNameLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:11];
        filterNameLabel.shadowColor = [UIColor blackColor];
        filterNameLabel.layer.shadowRadius = 4.0f;
        filterNameLabel.layer.shadowOpacity = 0.8f;
        filterNameLabel.layer.shadowOffset = CGSizeZero;
        filterNameLabel.textAlignment = NSTextAlignmentCenter;
        
        CIImage *outputImage = [filter.filter outputImage];
        
        CGImageRef cgimg =
        [context createCGImage:outputImage fromRect:[outputImage extent]];
        
        UIImage *smallImage =  [UIImage imageWithCGImage:cgimg];
        
        if(smallImage.imageOrientation == UIImageOrientationUp)
        {
            smallImage = [smallImage imageRotatedByDegrees:90];
        }

        
        // create filter preview image views
        UIImageView *filterPreviewImageView = [[UIImageView alloc] initWithImage:smallImage];
        
        [filterView setUserInteractionEnabled:YES];
        
        filterPreviewImageView.layer.cornerRadius = 10;
        filterPreviewImageView.opaque = NO;
        filterPreviewImageView.backgroundColor = [UIColor clearColor];
        filterPreviewImageView.layer.masksToBounds = YES;
        filterPreviewImageView.frame = CGRectMake(0, 0, 60, 60);

        
        filterView.tag = index;
        
        [self applyGesturesToFilterPreviewImageView:filterView];
        
        [filterView addSubview:filterPreviewImageView];
        [filterView addSubview:filterNameLabel];
        
        [self.filtersScrollView addSubview:filterView];
        
        offsetX += filterView.bounds.size.width + 10;
        
    }
    
    [self.filtersScrollView setContentSize:CGSizeMake(400, 60)];
}

-(void) applyGesturesToFilterPreviewImageView:(UIView *) view
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyFilter:)];
    
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    
    [view addGestureRecognizer:singleTapGestureRecognizer];
}

-(void) applyFilter:(id) sender
{
    selectedFilterView.layer.shadowRadius = 0.0f;
    selectedFilterView.layer.shadowOpacity = 0.0f;
    
    selectedFilterView = [(UITapGestureRecognizer *) sender view];
    
    selectedFilterView.layer.shadowColor = [UIColor whiteColor].CGColor;
    selectedFilterView.layer.shadowRadius = 4.0f;
    selectedFilterView.layer.shadowOpacity = 0.9f;
    selectedFilterView.layer.shadowOffset = CGSizeZero;
    selectedFilterView.layer.masksToBounds = NO;
    
    int filterIndex = [(UITapGestureRecognizer *) sender view].tag;
    Filter *filter = [filters objectAtIndex:filterIndex];
    
    CIImage *outputImage = [filter.filter outputImage];
    
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    finalImage = [UIImage imageWithCGImage:cgimg];
    
    if(finalImage.imageOrientation == UIImageOrientationUp)
    {
        finalImage = [finalImage imageRotatedByDegrees:90];
    }
    
    [self.harmonizedImage setImage:finalImage];
    
    CGImageRelease(cgimg);
}

- (IBAction)loadActionSheet:(id)sender
{
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"Choose an action"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save to Album", @"Share via Facebook", @"Share via Twitter", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
    targetSheet.tag = 2;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *serviceType = @"";
//    NSLog(@"%d", buttonIndex);
    if(actionSheet.tag ==2){
        if (buttonIndex == 0) {
            //Save photo to local album
            [self performSelector:@selector(saveImage:) withObject:self];
        } else if (buttonIndex == 3){
            //Cancel button; do nothing
        } else {
                        
            if (buttonIndex == 1){
                //Share via Facebook
                serviceType = SLServiceTypeFacebook;
            }else if (buttonIndex == 2){
                //Share via Twitter
                serviceType = SLServiceTypeTwitter;
            }
        
            SLComposeViewController *composer = [SLComposeViewController    composeViewControllerForServiceType:serviceType];
            [composer addImage:self.harmonizedImage.image];
        
            composer.completionHandler = ^(SLComposeViewControllerResult result) {
                NSString *title = nil;
                if (result==SLComposeViewControllerResultCancelled) title = @"Post canceled";
                else if (result==SLComposeViewControllerResultDone) title = @"Post sent";
                else title = @"Unknown";
            
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            };
            [self presentViewController:composer animated:YES completion:nil];
        }
    }
}

- (void)accessFacebookAccountWithPermission:(NSArray *)permissions Handler:(void (^)(void))handler; {
    if (!facebookAccount) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        
        NSDictionary *facebookRequestOptions = @{
    ACFacebookAppIdKey: @"393041694118834",
    ACFacebookPermissionsKey: permissions,
    ACFacebookAudienceKey: ACFacebookAudienceEveryone,
        };
        [accountStore requestAccessToAccountsWithType:facebookAccountType
                                              options:facebookRequestOptions
                                           completion:^(BOOL granted, NSError *error) {
                                               if (granted) {
                                                   NSArray *accounts = [accountStore
                                                                        accountsWithAccountType:facebookAccountType];
                                                   facebookAccount = [accounts lastObject];
                                                   handler();
                                               } else {
                                                   NSLog(@"Auth Error: %@", [error localizedDescription]);
                                               }
                                           }];
    } else {
        handler();
    }
}



/* Color Harmonization Code*/
#pragma COLOR HARMONIZATION CODE........

-(int)iType:(int *)hisSize alphaAngle:(int *)m
{
    int iTAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            if((alpha+9)%180 < hue && hue <=(alpha+94)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+9) + 180)% 180);
            else if((alpha+94)%180 < hue && hue <=(alpha+179)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+179)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(iTAlpha > sum)
        {
            iTAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return iTAlpha ;
}

-(int)VType:(int *)hisSize alphaAngle:(int *)m
{
    int VTAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+47)%180 < hue && hue <=(alpha+114)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+47) + 180)% 180);
            else if((alpha+114)%180 < hue && hue <=(alpha+179)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+179)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(VTAlpha > sum)
        {
            VTAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return VTAlpha ;
}

-(int)TType:(int *)hisSize alphaAngle:(int *)m
{
    int TTAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+90)%180 < hue && hue <=(alpha+135)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+90) + 180)% 180);
            else if((alpha+135)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(TTAlpha > sum)
        {
            TTAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return TTAlpha ;
}

-(int)IType:(int *)hisSize alphaAngle:(int *)m
{
    int IAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+9)%180 < hue && hue <=(alpha+50)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+9) + 180)% 180);
            else if((alpha+50)%180 < hue && hue <=(alpha+90)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+90)- hue + 180)% 180);
            else if((alpha+99)%180 < hue && hue <=(alpha+140)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+99) + 180)% 180);
            else if((alpha+140)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(IAlpha > sum)
        {
            IAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return IAlpha ;
}

-(int)YType:(int *)hisSize alphaAngle:(int *)m
{
    int YAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+47)%180 < hue && hue <=(alpha+78)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+47) + 180)% 180);
            else if((alpha+78)%180 < hue && hue <=(alpha+109)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+109)- hue + 180)% 180);
            else if((alpha+118)%180 < hue && hue <=(alpha+149)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+118) + 180)% 180);
            else if((alpha+149)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(YAlpha > sum)
        {
            YAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return YAlpha ;
}



-(int)XType:(int *)hisSize alphaAngle:(int *)m
{
    int XAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+47)%180 < hue && hue <=(alpha+69)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+47) + 180)% 180);
            else if((alpha+69)%180 < hue && hue <=(alpha+90)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+90)- hue + 180)% 180);
            else if((alpha+137)%180 < hue && hue <=(alpha+159)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+137) + 180)% 180);
            else if((alpha+159)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(XAlpha > sum)
        {
            XAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return XAlpha ;
}

-(int)LType:(int *)hisSize alphaAngle:(int *)m
{
    int LAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+40)%180 < hue && hue <=(alpha+50)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+40) + 180)% 180);
            else if((alpha+50)%180 < hue && hue <=(alpha+60)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+60)- hue + 180)% 180);
            else if((alpha+69)%180 < hue && hue <=(alpha+124)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+69) + 180)% 180);
            else if((alpha+124)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(LAlpha > sum)
        {
            LAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return LAlpha ;
}


-(void)iTypeHarm:(Mat)image alpha:(int)ialpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((ialpha+4)%180 < hue && hue <=(ialpha+94)%180)
                image.at<cv::Vec3b>(i,j)[0] = (ialpha + 4 + (image.at<cv::Vec3b>(i,j)[0] - (ialpha+4)+180)%180/90*4)%180;
            else //if((ialpha+94)%180 < hue && hue <=(ialpha+184)%180)
                image.at<cv::Vec3b>(i,j)[0] = (ialpha + 4 - ((ialpha+184)-image.at<cv::Vec3b>(i,j)[0]+180)%180/90*4+180)%180;
        }
    }
    
}

-(void)VTypeHarm:(Mat)image alpha:(int)Valpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Valpha+24)%180 < hue && hue <=(Valpha+114)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Valpha + 24 + (image.at<cv::Vec3b>(i,j)[0] - (Valpha+24)+180)%180/90*24)%180;
            else //if((Valpha+114)%180 < hue && hue <=(Valpha+204)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Valpha + 24 - ((Valpha+204)-image.at<cv::Vec3b>(i,j)[0]+180)%180/90*24+180)%180;
        }
    }
    
}

-(void)TTypeHarm:(Mat)image alpha:(int)Talpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Talpha+45)%180 < hue && hue <=(Talpha+135)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Talpha + 45 + (image.at<cv::Vec3b>(i,j)[0] - (Talpha+45)+180)%180/90*90)%180;
            else //if((Talpha+135)%180 < hue && hue <=(Talpha+225)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Talpha + 45 - ((Talpha+225)-image.at<cv::Vec3b>(i,j)[0]+180)%180/90*90+180)%180;
        }
    }
    
}
-(void)XTypeHarm:(Mat)image alpha:(int)Xalpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Xalpha+24)%180 < hue && hue <=(Xalpha+69)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Xalpha + 24 + (image.at<cv::Vec3b>(i,j)[0] - (Xalpha+24)+180)%180/45*24)%180;
            else if((Xalpha+69)%180 < hue && hue <=(Xalpha+114)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Xalpha + 114 - ((Xalpha+114)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*24+180)%180;
            else if((Xalpha+114)%180 < hue && hue <=(Xalpha+159)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Xalpha + 114 + (image.at<cv::Vec3b>(i,j)[0] - (Xalpha+114)+180)%180/45*24)%180;
            else //if((Xalpha+159)%180 < hue && hue <=(Xalpha+204)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Xalpha + 204 - ((Xalpha+204)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*24+180)%180;
        }
    }
    
}


-(void)ITypeHarm:(Mat)image alpha:(int)Ialpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Ialpha+4)%180 < hue && hue <=(Ialpha+50)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Ialpha + 4 + (image.at<cv::Vec3b>(i,j)[0] - (Ialpha+4)+180)%180/45*4)%180;
            else if((Ialpha+50)%180 < hue && hue <=(Ialpha+94)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Ialpha + 94 - ((Ialpha+94)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*4+180)%180;
            else if((Ialpha+94)%180 < hue && hue <=(Ialpha+147)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Ialpha + 94 + (image.at<cv::Vec3b>(i,j)[0] - (Ialpha+94)+180)%180/45*4)%180;
            else //if((Xalpha+140)%180 < hue && hue <=(Xalpha+184)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Ialpha + 184 - ((Ialpha+184)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*4+180)%180;
        }
    }
    
}

-(void)YTypeHarm:(Mat)image alpha:(int)Yalpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Yalpha+24)%180 < hue && hue <=(Yalpha+78)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Yalpha + 24 + (image.at<cv::Vec3b>(i,j)[0] - (Yalpha+24)+180)%180/54*23)%180;
            else if((Yalpha+78)%180 < hue && hue <=(Yalpha+114)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Yalpha + 114 - ((Yalpha+114)-image.at<cv::Vec3b>(i,j)[0]+180)%180/36*5+180)%180;
            else if((Yalpha+114)%180 < hue && hue <=(Yalpha+149)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Yalpha + 114 + (image.at<cv::Vec3b>(i,j)[0] - (Yalpha+114)+180)%180/35*4)%180;
            else //if((Yalpha+149)%180 < hue && hue <=(Yalpha+204)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Yalpha + 204 - ((Yalpha+204)-image.at<cv::Vec3b>(i,j)[0]+180)%180/55*24+180)%180;
        }
    }
    
}

-(void)LTypeHarm:(Mat)image alpha:(int)Lalpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Lalpha+20)%180 < hue && hue <=(Lalpha+50)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Lalpha + 20 + (image.at<cv::Vec3b>(i,j)[0] - (Lalpha+20)+180)%180/30*20)%180;
            else if((Lalpha+50)%180 < hue && hue <=(Lalpha+65)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Lalpha + 65 - ((Lalpha+65)-image.at<cv::Vec3b>(i,j)[0]+180)%180/15*5+180)%180;
            else if((Lalpha+65)%180 < hue && hue <=(Lalpha+124)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Lalpha + 65 + (image.at<cv::Vec3b>(i,j)[0] - (Lalpha+65)+180)%180/45*4)%180;
            else //if((Xalpha+140)%180 < hue && hue <=(Xalpha+184)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Lalpha + 200 - ((Lalpha+200)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*4+180)%180;
        }
    }
    
}









@end
