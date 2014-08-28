/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#import <UIKit/UIKit.h>

@class SampleAppLeftMenuViewController;

@interface SampleAppSlidingMenuController : UIViewController <UIGestureRecognizerDelegate>{

    CGFloat kSlidingMenuWidth;
    BOOL ignoreDoubleTap;
    
    // true when the left menu is displayed
    BOOL showingLeftMenu;
}

// we keep track of the gestu recognizer in order to be able to enable/disable them
@property (strong, nonatomic) UITapGestureRecognizer * tapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer * panGestureRecognizer;

- (id)initWithRootViewController:(UIViewController*)controller;

- (void) shouldIgnoreDoubleTap;
- (void) showRootController:(BOOL)animated;
- (void) showLeftMenu:(BOOL)animated;

- (void) dismiss;

@end

