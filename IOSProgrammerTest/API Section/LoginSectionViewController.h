//
//  APISectionViewController.h
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Additions by Matt Kiernan 5/1/14
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginSectionViewController : UIViewController<NSURLConnectionDelegate, UITextFieldDelegate>{

    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;

}

- (IBAction)Login:(id)sender;


@end
