//
//  AnimationSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Additions by Matt Kiernan 5/1/14
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "AnimationSectionViewController.h"
#import "MainMenuViewController.h"

@interface AnimationSectionViewController ()

@end

@implementation AnimationSectionViewController

int SPINCOEFFICIENT = 2;

int x = 0;
int y = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    water.center = CGPointMake(water.center.x, 450);
    y=0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
    [self.navigationController pushViewController:mainMenuViewController animated:YES];
    x=0;
    y=0;
}

#pragma mark - Drag Icon

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [iconTimer invalidate];
    UITouch *aTouch = [touches anyObject];
    CGPoint loc = [aTouch locationInView:icon];
    CGPoint prevloc = [aTouch previousLocationInView:icon];
    
    CGRect myFrame = icon.frame;
    float deltaX = loc.x - prevloc.x;
    float deltaY = loc.y - prevloc.y;
    myFrame.origin.x += deltaX;
    myFrame.origin.y += deltaY;
    [icon setFrame:myFrame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
     [self checkIconWater];

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

}

#pragma mark - Spin/Rotation


//spin icon/logo
- (IBAction)spinAction:(id)sender
{
    x++;
    if(x==3){
        [self waterTimer];
    }
    
    spin.enabled = NO;
    CABasicAnimation * spinRotation = [CABasicAnimation animationWithKeyPath: @"transform.rotation"];
    spinRotation.fromValue = [NSNumber numberWithFloat:0];
    spinRotation.toValue = [NSNumber numberWithFloat:(SPINCOEFFICIENT*(M_PI))];
    spinRotation.duration = 1.25;
    spinRotation.repeatCount = 0;
    
    
    // disable spin button until full rotation is over
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.35 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        spin.enabled = YES;
    });
    
[icon.layer addAnimation:spinRotation forKey:@"360"];

    //To reverse spin rotation of icon
    SPINCOEFFICIENT *= -1;
    
    
    
}

#pragma mark - Icon Rise

//See if icon is in water
-(void) checkIconWater{
 
    if(CGRectIntersectsRect(icon.frame, water.frame)){
        [self iconTimer];
        y++;

    }
}

//Float the icon
-(void) iconRise{
    
   // y++;
    int bubble = arc4random()%10-5;
    
    if (icon.center.y > 70) {
        icon.center = CGPointMake(icon.center.x+bubble, icon.center.y-8);
        
    }
    
    else{
        [iconTimer invalidate];
    }
}

-(void) iconTimer{
    iconTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(iconRise)
                                                userInfo: nil
                                                 repeats:YES];
}

#pragma mark - Water Rise

//Make water rise
-(void) waterRise{
    //-200
    
    if (water.center.y > -50) {
        water.center = CGPointMake(water.center.x, water.center.y-10);
        if (CGRectIntersectsRect(icon.frame, water.frame) && y==0){
            y++;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.35 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self iconTimer];
            });
        }
    }
    
    else{
        [waterTimer invalidate];
    }
}

-(void) waterTimer{
    
    waterTimer = [NSTimer scheduledTimerWithTimeInterval:0.075
                                                 target:self
                                               selector:@selector(waterRise)
                                               userInfo: nil
                                                repeats:YES];
}

-(NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
