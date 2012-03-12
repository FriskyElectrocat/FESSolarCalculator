//
//  AppDelegate.m
//  MacOS_Example
//
//  Created by Dan Weeks on 2012-03-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize locationLabel;
@synthesize startDateLabel;
@synthesize sunriseLabel;
@synthesize sunsetLabel;
@synthesize solarNoonLabel;
@synthesize civilDawnLabel;
@synthesize civilDuskLabel;
@synthesize nauticalDawnLabel;
@synthesize nauticalDuskLabel;
@synthesize astronomicalDawnLabel;
@synthesize astronomicalDuskLabel;
@synthesize solarCalculator=_solarCalculator;
@synthesize locationManager=_locationManager;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    
    _solarCalculator = [[FESSolarCalculator alloc] initWithDate:[NSDate date] location:newLocation];
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    
    // set the labels
    self.locationLabel.stringValue = [NSString stringWithFormat:@"Lat: %f  Long: %f", self.solarCalculator.location.coordinate.latitude, self.solarCalculator.location.coordinate.longitude];
    self.startDateLabel.stringValue = [df stringFromDate:self.solarCalculator.startDate];
    self.sunriseLabel.stringValue = [df stringFromDate:self.solarCalculator.sunrise];
    self.sunsetLabel.stringValue = [df stringFromDate:self.solarCalculator.sunset];
    self.solarNoonLabel.stringValue = [df stringFromDate:self.solarCalculator.solarNoon];
    
    self.civilDawnLabel.stringValue = [df stringFromDate:self.solarCalculator.civilDawn];
    self.civilDuskLabel.stringValue = [df stringFromDate:self.solarCalculator.civilDusk];
    
    self.nauticalDawnLabel.stringValue = [df stringFromDate:self.solarCalculator.nauticalDawn];
    self.nauticalDuskLabel.stringValue = [df stringFromDate:self.solarCalculator.nauticalDusk];
    
    self.astronomicalDawnLabel.stringValue = [df stringFromDate:self.solarCalculator.astronomicalDawn];
    self.astronomicalDuskLabel.stringValue = [df stringFromDate:self.solarCalculator.astronomicalDusk];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"ERROR : %@", error);
}

@end
