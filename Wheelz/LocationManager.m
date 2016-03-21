//
//  LocationManager.m
//  ParkAbility
//
//  Created by Benson Huynh & Dave Hurley on 2016-02-08.
//  Copyright © 2016 Benson Huynh & Dave Hurley. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>


@implementation LocationManager

+ (LocationManager *)locationManager {
    
    static LocationManager* _locationManager = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _locationManager = [[LocationManager alloc] init];
    });
    return _locationManager;
}

- (void) setupLocationManager {
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 10;
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)startLocationManager{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [self setupLocationManager];
        }else if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)){
            [self setupLocationManager];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Yo!"
                                                                                     message:@"Location services are disabled, Please go into Settings > Privacy > Location to enable"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                       }];
            [alertController addAction:ok];
        }
    }
}

-(void)stopLocationManager{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        if (self.locationManager) {
            [self.locationManager stopUpdatingLocation];
        }
    }
}

-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    
    CLLocation *loc = [locations objectAtIndex: [locations count]-1];
    NSTimeInterval locationAge = -[loc.timestamp timeIntervalSinceNow];
    
    if (locationAge > 10.0){
        return;
    }
    
    if (loc.horizontalAccuracy < 0){
        return;
    }
    
    if (self.currentLocation == nil || self.currentLocation.horizontalAccuracy >= loc.horizontalAccuracy) {
        self.currentLocation = loc;
        
        if (loc.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            [self stopLocationManager];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedLocation" object:nil];
    }
}

@end
