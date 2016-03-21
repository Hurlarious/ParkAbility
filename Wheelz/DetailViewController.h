//
//  DetailViewController.h
//  ParkAbility
//
//  Created by Benson Huynh & Dave Hurley on 2016-02-08.
//  Copyright © 2016 Benson Huynh & Dave Hurley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingSpot.h"

@class ParkSpotAnnotation;

@interface DetailViewController : UIViewController

@property (nonatomic) ParkSpotAnnotation *parkSpotAnnotation;


@end
