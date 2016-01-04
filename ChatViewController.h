//
//  ChatViewController.h
//  FriendSnap
//
//  Created by cristian cirjan on 12/30/15.
//  Copyright © 2015 cristian cirjan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface ChatViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PFObject *selectedMessage;

- (IBAction)logout:(id)sender;

@end
