//
//  ImageViewController.m
//  FriendSnap
//
//  Created by cristian cirjan on 1/3/16.
//  Copyright © 2016 cristian cirjan. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // first download the file from Parse, then upload the image to the imageview
    // the pffile class has a url property that contains the url to get the image from parse.com. we can use the url to load a NSdata object, and we can use one of the conveneince methods for downloading. We can then set the imageview from the nsdata variable.
    
    PFFile *imageFile =[self.message objectForKey:@"file"];
    NSURL *imageFileUrl= [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];

    self.imageView.image =[UIImage imageWithData:imageData];
    
    NSString *senderName =[self.message objectForKey:@"senderName"];
    NSString *title =[NSString stringWithFormat:@"Sent from %@", senderName];
    self.navigationItem.title=title;
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
