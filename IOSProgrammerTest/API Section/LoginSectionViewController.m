//
//  APISectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Additions by Matt Kiernan 5/1/14
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "LoginSectionViewController.h"
#import "MainMenuViewController.h"

@interface LoginSectionViewController ()

@end

@implementation LoginSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    passwordField.delegate = self;
    usernameField.delegate = self;
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
}

- (IBAction)Login:(id)sender {
    [self request];
}

#pragma mark Request/Response function
-(void) request{
    float pretime = CACurrentMediaTime();

    NSString *username = usernameField.text;
    NSString *password = passwordField.text;

//    // only working:
//    //  username=SuperBoise
//    //  password=qwerty
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://dev.apppartner.com/AppPartnerProgrammerTest/scripts/login.php"]];
    
    // create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    NSString *userUpdate =[NSString stringWithFormat:@"username=%@&password=%@",username,password,nil];
    NSLog(@"Data Details: %@", userUpdate);
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [request setHTTPBody:data];
    
    NSError *err;
    NSURLResponse *response;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    //This is for Response
    NSLog(@"got response==%@", resSrt);
  
// RESPONSE ACTION
    if(resSrt)
    {
        float apiTime = (CACurrentMediaTime() - pretime)*1000;
        
        // parsing 'code' & 'message'
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * JSONmessage=[[NSArray alloc]init];
        NSString * JSONcode=[[NSString alloc]init];
        JSONmessage=[json valueForKeyPath:@"message"];
        JSONcode=[json valueForKeyPath:@"code"];
        
        NSString *errorCompare = @"Error";

        //if getting response
        if(JSONcode && JSONmessage){
            NSLog(@"CODE: %@",JSONcode);
            NSLog(@"MESSAGE: %@",JSONmessage);
        
            
            NSLog(@"JSONcode: %@",JSONcode);
           
            //if response is error
            if (JSONcode.length == errorCompare.length) {

                NSString *alertMessage = [NSString stringWithFormat:@"Code: %@\nMessage: %@\nAPI Time: %0.3f(mils)",JSONcode,JSONmessage, apiTime];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Login Fail"
                                                               message: alertMessage
                                                              delegate: self
                                                     cancelButtonTitle:nil//@"Cancel"
                                                     otherButtonTitles:@"OK",nil];
                
                [alert show];
            }
            
            //if response is success
            else{

                NSString *alertMessage = [NSString stringWithFormat:@"Code: %@\nMessage: %@\nAPI Time: %0.3f(mils)",JSONcode,JSONmessage, apiTime];
        
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Login Success"
                                                       message: alertMessage
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        
                [alert show];
            }
                               
        
        }
        
        else{
            NSLog(@"ERROR WITH CODE & MESSAGE");
        }
    }
    else
    {
        NSLog(@"failed to connect");
    }
  
}

//for going back to main menu (on success)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
        [self.navigationController pushViewController:mainMenuViewController animated:YES];
    }}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

        //NSLog(@"GOOD GOOD GOOD");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"ERROR ERROR ERROR");
}

#pragma mark Text Field Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

    
-(NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
