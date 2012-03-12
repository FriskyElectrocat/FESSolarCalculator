//
//  ViewController.m
//  SolarCalculatorExample
//
//  Created by Dan Weeks on 2012-02-11.
//  Copyright © 2012 Daniel Weeks.
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ViewController.h"

@implementation ViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];

    _solarCalculator = [[FESSolarCalculator alloc] initWithDate:[NSDate date] location:newLocation];

    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    
    // set the labels
    self.locationLabel.text = [NSString stringWithFormat:@"Lat: %f  Long: %f", self.solarCalculator.location.coordinate.latitude, self.solarCalculator.location.coordinate.longitude];
    self.startDateLabel.text = [df stringFromDate:self.solarCalculator.startDate];
    self.sunriseLabel.text = [df stringFromDate:self.solarCalculator.sunrise];
    self.sunsetLabel.text = [df stringFromDate:self.solarCalculator.sunset];
    self.solarNoonLabel.text = [df stringFromDate:self.solarCalculator.solarNoon];

    self.civilDawnLabel.text = [df stringFromDate:self.solarCalculator.civilDawn];
    self.civilDuskLabel.text = [df stringFromDate:self.solarCalculator.civilDusk];

    self.nauticalDawnLabel.text = [df stringFromDate:self.solarCalculator.nauticalDawn];
    self.nauticalDuskLabel.text = [df stringFromDate:self.solarCalculator.nauticalDusk];

    self.astronomicalDawnLabel.text = [df stringFromDate:self.solarCalculator.astronomicalDawn];
    self.astronomicalDuskLabel.text = [df stringFromDate:self.solarCalculator.astronomicalDusk];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"ERROR : %@", error);
}
@end
