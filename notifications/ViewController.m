//
//  ViewController.m
//  notifications
//
//  Created by xpression on 10/9/16.
//  Copyright (c) 2016 SZH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString* shownText;
@end

@implementation ViewController

- (void)setTextViewValue:(NSString*)str
{
    self.shownText = str;
    if (self.textView) {
        self.textView.text = self.shownText;
        self.shownText = @"";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTextViewValue:self.shownText];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendLocalNotificationWithAction:(UIButton *)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    static int count = 0;
    ++count;
    notification.alertBody = [NSString stringWithFormat:@"hello %d", count];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    notification.category = @"Test_Category";
    notification.alertTitle = @"this is title";
   // notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"scheduled %@", notification.alertBody);

}

- (IBAction)sendLocalNotificationWithoutAction:(UIButton *)sender {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    static int count = 0;
    ++count;
    notification.alertBody = [NSString stringWithFormat:@"hello %d", count];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
   // notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"scheduled %@", notification.alertBody);
}

@end
