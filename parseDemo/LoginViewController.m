//
//  LoginViewController.m
//  parseDemo
//
//  Created by Abhijeet Vaidya on 7/15/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/PFUser.h>
#import "DemoViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSignIn:(UIButton *)sender {
    
    [PFUser logInWithUsernameInBackground:self.userNameField.text password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"successful user login: ");
                                            DemoViewController *dvc = [[DemoViewController alloc] init];
                                            [self.navigationController pushViewController:dvc animated:NO];
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }];
    
}
- (IBAction)onSignUp:(UIButton *)sender {
    
    PFUser *user = [PFUser user];
    user.username = self.userNameField.text;
    user.password = self.passwordField.text;
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"successfully created the user: ");
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"got error: %@", errorString);
        }
    }];

}

@end
