//
//  CHHarmonizeViewController.h
//  Colmonizor
//
//  Created by Johnny Bee on 13/1/14.
//  Copyright (c) 2013年 Johnny. All rights reserved.
//

#import <UIKit/UIKit.h>
//using namespace cv;

@interface CHHarmonizeViewController : UIViewController{
    CIContext *context;
    NSMutableArray *filters;
    CIImage *beginImage;
//    UIScrollView *filtersScrollView;
    UIView *selectedFilterView;
    UIImage *finalImage;
}

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *harmonizedImage;
@property (strong, nonatomic) IBOutlet UIScrollView *filtersScrollView;
//@property (strong, nonatomic) IBOutlet UIView *selectedFilerView;

- (IBAction)goBack:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)loadActionSheet:(id)sender;


/*  OPENCV  */
//
//- (Mat)cvMatGrayFromUIImage:(UIImage *)image;
//- (Mat)cvMatFromUIImage:(UIImage *)image;
//- (UIImage *)UIImageFromCVMat:(Mat)cvMat;

@end
