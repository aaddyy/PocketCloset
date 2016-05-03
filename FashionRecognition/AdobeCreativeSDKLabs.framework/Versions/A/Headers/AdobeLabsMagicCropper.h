/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2015 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 *
 **************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/** AdobeLabsMagicCropResult represents a crop result.
 */
@interface AdobeLabsMagicCropResult : NSObject

/** The crop rectangle.
 */
@property CGRect    cropRect;

/** The crop composition score.  0.0 - 1.0, 1.0 is best.
 */
@property NSNumber  *cropCompositionScore;

/** The crop preservation score.  0.0 - 1.0, 1.0 is best.
 */
@property NSNumber  *cropContentPreservationScore;

/** The crop simplicity score.  0.0 - 1.0, 1.0 is best.
 */
@property NSNumber  *cropBoundarySimplicityScore;

@end
//struct AdobeLabsMagicCropResult 
//{ 
//    CGRect cropRect;
//    float cropCompositionScore; 
//    float cropContentPreservationScore; 
//    float cropBoundarySimplicityScore; 
//};


@interface AdobeLabsMagicCropper : NSObject

/** @name Properties */

/** Input image to be cropped
 */
@property (nonatomic, readwrite)    UIImage *       image;

/** Controls whether or not the iOS face detector should be used (YES - default) or not (NO)
 */
@property (nonatomic, readwrite)    BOOL            useFaceDetector;


/** Generates a set of crops with default aspect ratio settings.
 * The default aspect ratios are 64.0/27.0, 16.0/9.0, 3.0/2.0, 4.0/3.0, 3.0/4.0, and 2.0/3.0.
 */
- (void)generateCrops;

/** Generates crops with specific aspect ratios.
 @param aspectRatios an NSArray of numbers, e.g. @[@(64.0/27.0), @(16.0/9.0), @(3.0/2.0), @(4.0/3.0), @0.75, @(2.0/3.0)] or  @[@1.0]
 */
- (void)generateCrops: (NSArray *)aspectRatios;

/** Generates crops with specific aspect ratios and sizes.
 @param aspectRatios an NSArray of numbers, e.g. @[@(64.0/27.0), @(16.0/9.0), @(3.0/2.0), @(4.0/3.0), @0.75, @(2.0/3.0)] or  @[@1.0]
 @param cropSizes an NSArray of crop sizes, e.g. @[@0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1.0]
 */
- (void)generateCrops: (NSArray *)aspectRatios cropSizes: (NSArray *)cropSizes;

/** Returns and array of used aspect ratios in generated crops 
    This is useful for querying the default aspect ratios if none are given in generateCrops.
*/
- (NSArray *)getAspectRatios;

/** Returns and array of used crop sizes 
    This is useful for querying the default crop sizes if none are given in generateCrops.
*/
- (NSArray *)getCropSizes;

/** Returns an array of AdobeLabsMagicCropResult.
    numResults specifies how many results the method should return.
 @note The user must be logged into the creative cloud or this function will return nil
 */
- (NSArray *)getTopCropResults: (NSUInteger)numResults;

@end





