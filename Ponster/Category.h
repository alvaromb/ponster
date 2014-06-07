//
//  Category.h
//  Ponster
//
//  Created by Álvaro on 07/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AbstractPoster;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *posters;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addPostersObject:(AbstractPoster *)value;
- (void)removePostersObject:(AbstractPoster *)value;
- (void)addPosters:(NSSet *)values;
- (void)removePosters:(NSSet *)values;

@end
