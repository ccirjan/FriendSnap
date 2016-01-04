//
//  ChatViewController.h
//  FriendSnap
//
//  Created by cristian cirjan on 12/30/15.
//  Copyright © 2015 cristian cirjan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;


- (IBAction)logout:(id)sender;

@end
