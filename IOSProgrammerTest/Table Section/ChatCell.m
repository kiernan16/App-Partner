//
//  TableSectionTableViewCell.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Additions by Matt Kiernan 5/1/14
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ChatCell ()
@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UITextView *messageTextView;
@end

@implementation ChatCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)loadWithData:(ChatData *)chatData
{
    self.usernameLabel.text = chatData.username;
    self.messageTextView.text = chatData.message;

    
    //Download image from URL in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:chatData.avatar_url];
        NSData *data = [NSData dataWithContentsOfURL : url];
        UIImage *image = [UIImage imageWithData: data];
        
        //Create round image
        UIImageView *roundImage = [[UIImageView alloc] initWithImage:image];
        roundImage.image = image;

        CALayer *imageLayer = roundImage.layer;
        [imageLayer setCornerRadius:roundImage.frame.size.width/2];
        [imageLayer setBorderWidth:1];
        [imageLayer setMasksToBounds:YES];
        
        UIGraphicsBeginImageContext([imageLayer frame].size);
        
        [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.avatarImage.image = outputImage;
        });
        
    });
    
}

@end
