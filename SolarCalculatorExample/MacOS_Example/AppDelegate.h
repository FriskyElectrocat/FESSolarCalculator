//
//  AppDelegate.h
//  MacOS_Example
//
//  Created by Dan Weeks on 2012-03-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>
#import "FESSolarCalculator.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, CLLocationManagerDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (strong, nonatomic) IBOutlet NSTextField *locationLabel;
@property (strong, nonatomic) IBOutlet NSTextField *startDateLabel;
@property (strong, nonatomic) IBOutlet NSTextField *sunriseLabel;
@property (strong, nonatomic) IBOutlet NSTextField *sunsetLabel;
@property (strong, nonatomic) IBOutlet NSTextField *solarNoonLabel;
@property (strong, nonatomic) IBOutlet NSTextField *civilDawnLabel;
@property (strong, nonatomic) IBOutlet NSTextField *civilDuskLabel;
@property (strong, nonatomic) IBOutlet NSTextField *nauticalDawnLabel;
@property (strong, nonatomic) IBOutlet NSTextField *nauticalDuskLabel;
@property (strong, nonatomic) IBOutlet NSTextField *astronomicalDawnLabel;
@property (strong, nonatomic) IBOutlet NSTextField *astronomicalDuskLabel;

@property (strong, nonatomic) FESSolarCalculator *solarCalculator;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
