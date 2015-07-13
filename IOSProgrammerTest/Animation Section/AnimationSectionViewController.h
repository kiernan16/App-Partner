//
//  AnimationSectionViewController.h
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Additions by Matt Kiernan 5/1/14
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationSectionViewController : UIViewController
{
    
    IBOutlet UIButton *spin;
    IBOutlet UIImageView *icon;
    IBOutlet UIImageView *water;
    
    NSTimer *waterTimer;
    NSTimer *iconTimer;
}

-(IBAction)spinAction:(id)sender;


-(NSUInteger)supportedInterfaceOrientations;

@end
