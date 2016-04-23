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

/** The `AdobeLabsMagicPath` class provides an intuitive way to generate and progressively manipulate a path. The first path sets the MagicPath and each path created after the first one manipulates the MagicPath either by extending it from the end points or by modifying an internal part of the MagicPath, both of which are done auto-magically based on the input path.
    CurrentPath is the path that is intended to edit the magic path once it is ended. 
    MagicPath is build by succesively beginning, moving (hence populating), and ending current paths.
 **/
@interface AdobeLabsMagicPath: NSObject

/** Initialize the magic path.
 */
- (id)init;

/** Begins a new path that will be used to manipulate the underlying magic path.
 *
 * @param point the position of the start of the path
 * @returns true if successful, returns false if not
 * @note This function will return false if a current path is already in progress
 *
 */
- (BOOL)beginCurrentPath: (CGPoint)point;

/** Adds a new point to the current path that will be used to manipulate the underlying magic path
 *
 * @param point the position of the point where the new path point is
 * @returns true if successful, returns false if not
 * @note This function will return false if a current path is not already in progress
 * @note The user must be logged into the creative cloud for this function to succeed.
 */
- (BOOL)moveCurrentPath: (CGPoint)point;

/** Ends the current path and manipulates the underlying magic path with the current path.
 *
 * @param point the position of the point where the current path ends
 * @returns true if successful, returns false if not
 * @note This function will return false if a current path is not already in progress
 *
 */
- (BOOL)endCurrentPath: (CGPoint)point;

/** Rollsback the state of the magic path to the previous state by undoing the manipulation effects of the last path.
 *
 * @returns true if successful, returns false if not (NOTE: MagicPath keeps only one previous state!)
 * @note If you call undoLastPath with a currentPath in progress, it won't undo anything and return false.
 * The current path must be ended first.
 *
 */
- (BOOL)undoLastPath;

/** Returns the number of points in the current path.
 *
 * @returns the number of points in the current path
 *
 */
- (NSUInteger)numCurrentPathPoints;

/** Returns the position of a the point at index of current path.
 *
 * @param index the index of the point that belongs to current path
 * @returns the position of the current path point at index
 * @note CGPoint(0, 0) will be returned if index is invalid.
 *
 */
- (CGPoint)currentPathPointAt: (NSUInteger)index;

/** Returns the number of points in the magic path.
 *
 * @returns the number of points in the magic path
 *
 */
- (NSUInteger)numMagicPathPoints;

/** Returns the position of a the point at index of the magic path.
 *
 * @param index the index of the point that belongs to magic path
 * @returns the position of the magic path point at index
 *
 */
- (CGPoint)magicPathPointAt: (NSUInteger)index;

@end