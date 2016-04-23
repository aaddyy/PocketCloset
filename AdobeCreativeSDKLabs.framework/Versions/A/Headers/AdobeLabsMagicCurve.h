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

/** <fakeout>AdobeLabsMagicCurveIndex</fakeout> contains a constant that defines the value of a null control point index.
 
 <fakeout>AdobeLabsMagicCurve</fakeout> functions that return an NSUInteger index for a control point can return
 the value <i><fakeout>AdobeLabsMagicCurveNullIndex</fakeout></i> to represent a null index.
 
 */
typedef NS_ENUM(NSUInteger, AdobeLabsMagicCurveIndex)
{
    /** Returned when no control points are present or when no valid control point is found. */
    AdobeLabsMagicCurveNullIndex = 0xFFFFFFFF
};

/** The `AdobeLabsMagicCurve` class provides an intuitive easy way to generate curves and shapes by adding control points that, unlike traditional Bezier curves, sit on the curve directly.  When the control points are adjusted, the curve magically transforms according to human perceptual expectation.    `AdobeLabsMagicCurve` provides an intuitive API for the construction of curves and shapes based on the specification of control points in any arbitrary, user-defined coordinate system, including UIView coordinates for direct integration into iOS apps.  Magic Curves can be manipulated under direct programmatic control, or driven by UI actions that call public API functions.
 
 Magic Curves can be scaled and translated and converted into Apple's UIBezierPath class for easy rendering.
 
 The following code illustrates how to programatically create a Magic Curve that is a square:
    
    AdobeLabsMagicCurve * square = [[AdobeLabsMagicCurve alloc] init];
    [square addControlPoint: CGPointMake(  0,   0) isCorner: YES];
    [square addControlPoint: CGPointMake(100,   0) isCorner: YES];
    [square addControlPoint: CGPointMake(100, 100) isCorner: YES];
    [square addControlPoint: CGPointMake(  0, 100) isCorner: YES];
    square.isClosed = YES;
 
 A circle may be created using the same coordinates, but without using corners:
 
    AdobeLabsMagicCurve * circle = [[AdobeLabsMagicCurve alloc] init];
    [circle addControlPoint: CGPointMake(  0,   0) isCorner: NO];
    [circle addControlPoint: CGPointMake(100,   0) isCorner: NO];
    [circle addControlPoint: CGPointMake(100, 100) isCorner: NO];
    [circle addControlPoint: CGPointMake(  0, 100) isCorner: NO];
    circle.isClosed = YES;
 
 Note that the circle will be slightly larger than the square since the control points describe the same corners as the square and the arcs of the curve pass through the control points.
 
 By adjusting the control point positions to the apex of the arcs, the circle can be bounded by the same size as the square:
 
    AdobeLabsMagicCurve * circle = [[AdobeLabsMagicCurve alloc] init];
    [circle addControlPoint: CGPointMake( 50,   0) isCorner: NO];
    [circle addControlPoint: CGPointMake(100,  50) isCorner: NO];
    [circle addControlPoint: CGPointMake( 50, 100) isCorner: NO];
    [circle addControlPoint: CGPointMake(  0,  50) isCorner: NO];
    circle.isClosed = YES;
 
 Not only can shapes be created with `AdobeLabsMagicCurve` but open paths may also be created:
 
    AdobeLabsMagicCurve * path = [[AdobeLabsMagicCurve alloc] init];
    [path addControlPoint: CGPointMake(  50,  0) isCorner: NO];
    [path addControlPoint: CGPointMake(100,  50) isCorner: NO];
    [path addControlPoint: CGPointMake( 50, 100) isCorner: NO];
    path.isOpen = YES;
 
 Note the use of the isOpen and isClosed properties to specify whether the MagicCurve is an open path or a closed shape.
 
 Rendering the magic curve is easy.  Here is an example of how to do this in your UIView's drawRect method:
 
    - (void) drawRect:(CGRect)rect {
 
        // 1.  set fill and stroke colors
        [[UIColor redColor] setFill];
        [[UIColor blackColor] setStroke];
 
        // 2.  generate a UIBezierPath from the Magic Curve
        UIBezierPath * path = [_magicCurve generateUIBezierPath];
 
        // 3.  if the MagicCurve is closed, draw the path fill
        if (_magicCurve.isClosed) [path fill];
 
        // 4. draw the path stroke
        [path stroke];
    }

 It is also easy to render the control points, if desired:
 
         // 5. draw the control points
         NSUInteger numControlPoints = _magicCurve.numControlPoints;
         CGContextRef context = UIGraphicsGetCurrentContext();
     
         CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
         for (NSUInteger i = 0; i < numControlPoints; i++)
         {
             CGPoint controlPoint = [_magicCurve controlPointAt: i];
             CGContextFillEllipseInRect(context, CGRectMake(controlPoint.x-5, controlPoint.y-5, 10, 10));
         }

  Magic Curves are also easy to manipulate from UI code; here's a simple example using touchesBegan, touchesMoved, and touchesEnded:
 
     - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
     {
         UITouch * touch = [touches anyObject];
         CGPoint location = [touch locationInView: self];
         CGFloat radius = MAX(10, touch.majorRadius); // 10 is our control point size that we rendered
         NSUInteger index = 0;
 
         _currentControlPointIndex = AdobeLabsMagicCurveNullIndex;
         
         if ([_magicCurve findClosestControlPoint: location withRadius: radius andControlPointIndexToSet: &index])
         {
            _currentControlPointIndex = index;
            [_magicCurve setControlPoint: _currentControlPointIndex withPoint: location];
            [self setNeedsDisplay];
         }
     }
 
     - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
     {
         if (_currentControlPointIndex != AdobeLabsMagicCurveNullIndex)
         {
             [_magicCurve setControlPoint: _currentControlPointIndex withPoint: [[touches anyObject] locationInView: self]];
             [self setNeedsDisplay];
         }
     }
     
     -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
     {
         if (_currentControlPointIndex != AdobeLabsMagicCurveNullIndex)
         {
             [_magicCurve setControlPoint: _currentControlPointIndex withPoint: [[touches anyObject] locationInView: self]];
             _currentControlPointIndex = AdobeLabsMagicCurveNullIndex;
             [self setNeedsDisplay];
         }
     }
 
 That's how easy it is!  You can also split curves, insert new control points along the curve, and convert UIBezierPaths into Magic Curves.  For further details see below.
 
 */
@interface AdobeLabsMagicCurve : NSObject

/** @name Properties */

/** controls whether or not the path represents a closed shape (YES) or an open curve (NO)
 */
@property (nonatomic, readwrite)    BOOL            isClosed;

/** controls whether or not the path represents an open curve (YES) or a closed shape (NO)
 */
@property (nonatomic, readwrite)    BOOL            isOpen;

/** gives the number of control points
 */
@property (nonatomic, readonly)     NSUInteger      numControlPoints;

/** @name Instance Methods */

/** Add a control point to the curve given a position.
 *
 * @param position the position of the control point as a CGPoint.
 * @returns the index of the control point that was added
 *
 */
- (NSUInteger)addControlPoint: (CGPoint)position isCorner: (BOOL)isCorner;

/** determines whether or not a control point can be inserted on the curve near a position
 *
 * This function provides a way to test whether or not insertControlPoint would succeed without inserting a control point.
 *
 * @param position the position near which to find insert a control point on the curve
 * @param radius the radius around the input position that the curve must intersect
 * @return YES if a position on the curve was found within the radius around the input position and a control point can be inserted there, NO otherwise
 * @see insertControlPoint
 *
 */
- (BOOL)canInsertControlPoint: (CGPoint)position withRadius: (CGFloat)radius;

/** Clear all of the control points from the magic curve.
 */
- (void)clear;

/** Returns the position of a control point.
 *
 * @param nControlPointIndex the index of the control point
 * @returns the position of the control point or (0, 0) for an invalid controlPointIndex
 *
 */
- (CGPoint)controlPointAt: (NSUInteger)nControlPointIndex;

/** find the closest control point near a position
 *
 * @param position the position to find the control point near
 * @param radius the radius around the position that the control point must intersect
 * @param pControlPointIndexToSet a pointer to the NSUInteger variable to receive the found control point index
 * @return YES if a control point was found within the radius around the position, NO if a control point was not found
 *
 */
- (BOOL)findClosestControlPoint: (CGPoint)position withRadius: (CGFloat)radius andControlPointIndexToSet: (NSUInteger *)pControlPointIndexToSet;

/** find the closest control position on a curve near a position
 *
 * @param position the position near which to find a position on the curve
 * @param radius the radius around the input position that the curve must intersect
 * @param pPositionToSet a pointer to the CGPoint variable to receive the found position on the curve
 * @return YES if a position on the curve was found within the radius around the input position, NO if a position was not found
 *
 */
- (BOOL)findClosestPositionOnCurve: (CGPoint)position withRadius: (CGFloat)radius andClosestPositionToSet: (CGPoint *)pPositionToSet;

/** generates a UIBezierPath from the Magic Curve
 *
 * @return the UIBezierPath for the curve or nil if a UIBezierPath could not be generated
 * @note If the user is on the network and not logged into Creative Cloud, generateUIBezierPath will return nil.
 * It is the responsibility of the caller to ensure, if the user is on the network, that the user is authenticated
 * with Creative Cloud prior to calling this function.
 *
 */
- (UIBezierPath *)generateUIBezierPath;

/** Initialize the magic curve.
 */
- (id)init;

/** Initialize the magic curve by copying an existing magicCurve.
 */
- (id)initWithMagicCurve: (AdobeLabsMagicCurve *)magicCurve;

/** Initialize the magic curve with a UIBezierPath
*
 */
- (id)initWithUIBezierPath: (UIBezierPath *)path;

/** inserts a control point on the curve near a position
 *
 * @param position the position near which to insert a control point on the curve
 * @param radius the radius around the input position that the curve must intersect
 * @param pControlPointIndexToSet a pointer to the NSUInteger variable to receive the inserted control point index
 * @return YES if a control point was inserted, NO otherwise
 *
 */
- (BOOL)insertControlPoint: (CGPoint)position withRadius: (CGFloat)radius andControlPointIndexToSet: (NSUInteger *)pControlPointIndexToSet;

/** Returns whether or not a control point is a corner
 *
 * @param nControlPointIndex the index of the control point
 * @returns YES if the control point is a corner, no if it isn't or if controlPointIndex is invalid
 *
 */
- (BOOL)isCorner: (NSUInteger)nControlPointIndex;

/** Remove a control point from a curve.
 *
 * @param controlPointIndex the index of the control point to return
 * @returns AdobeLabsMagicCurveNullIndex if no more control points exist after the removal, controlPointIndex-1 if the last control point was removed, otherwise controlPointIndex
 *
 */
- (NSUInteger)removeControlPoint: (NSUInteger)nControlPointIndex;

/** scales the size of the Magic Curve by a factor
 *
 * @param scaleFactor the scale factor
 *
 */
- (void)scale:(CGFloat)scaleFactor;

/** sets whether or not a control point is a corner
 *
 * @param nControlPointIndex the index of the control point
 * @param isCorner whether or not the control point is a corner
 *
 */
- (void)setControlPoint: (NSUInteger)nControlPointIndex isCorner: (BOOL)isCorner;

/** sets a control point's position
 *
 * @param nControlPointIndex the index of the control point
 * @param position the new position of the control point
 *
 */
- (void)setControlPoint: (NSUInteger)nControlPointIndex withPosition: (CGPoint)position;

/** sets a control point's position and whether or not it is a corner
 *
 * @param nControlPointIndex the index of the control point
 * @param position the new position of the control point
 * @param andIsCorner whether or not the control point is a corner
 *
 */
- (void)setControlPoint: (NSUInteger)nControlPointIndex withPosition: (CGPoint)position andIsCorner: (BOOL)isCorner;

/** splits a closed curve to an open curve at a control point
 *
 * @param nControlPointIndex the index of the control point where to split the curve
 * @note This function only operates on closed curves and will assert if the curve is not closed.
 *
 */
- (void)splitClosedCurve: (NSUInteger)nControlPointIndex;

/** splits an open curve into two open curves at a control point
 *
 * @param nControlPointIndex the index of the control point where to split the curve
 * @return the new curve generated from the split at the control point or nil if invalid parameters are passed in
 * @note This function only operates on open curves and will assert if the curve is not open.
 *
 */
- (AdobeLabsMagicCurve *)splitOpenCurve: (NSUInteger)nControlPointIndex;

/** toggles whether or not a control point is a corner
 *
 * @param nControlPointIndex the index of the control point
 *
 */
- (void)toggleCorner: (NSUInteger)nControlPointIndex;

/** scales the size of the Magic Curve by a factor
 *
 * @param scaleFactor the scale factor
 *
 */
- (void)translate:(CGPoint)translation;

@end



