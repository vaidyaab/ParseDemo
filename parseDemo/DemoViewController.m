//
//  DemoViewController.m
//  parseDemo
//
//  Created by Abhijeet Vaidya on 7/15/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "DemoViewController.h"
#import <Parse/PFObject.h>
#import <Parse/PFUser.h>
#import <Parse/PFQuery.h>

@interface DemoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UITableView *sampleTable;
@property (strong,nonatomic) NSArray *messages;
@end

@implementation DemoViewController

- (IBAction)onGoButton:(id)sender {
    
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message[@"user"] = [PFUser currentUser];
    message[@"text"] = self.textField.text;
    [message saveInBackground];

    
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
    // Do any additional setup after loading the view from its nib.
    self.sampleTable.delegate = self;
    self.sampleTable.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void) onTimer {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    //[query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query includeKey:@"user"];
    
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d messages.", objects.count);
            // Do something with the found objects
            
            self.messages = objects;
            
            [self.sampleTable reloadData ];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.messages objectAtIndex:indexPath.row][@"text"];

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
