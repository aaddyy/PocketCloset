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

//
//  AdobeLabsMagicMusicRetargeting.h"
//  CreativeSDKLabs
//
//  Created by Juan-Pablo Caceres.
//  Copyright (c) 2015 Adobe Systems Incorporated. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, AdobeLabsMagicMusicRetargetingErrorCode) {
    /** Song Analysis failed  */
    AdobeLabsMagicMusicRetargetingErrorSongAnalysisFailed  = -10,
    /** Trying to retargt without running song analayis first  */
    AdobeLabsMagicMusicRetargetingErrorRetargetingWithoutSongAnalysis  = -11,
    /** Writing an asset failed  */
    AdobeLabsMagicMusicRetargetingErrorWriteAssetFailed  = -12,
    /** Reading an asset failed  */
    AdobeLabsMagicMusicRetargetingErrorLoadAssetFailed   = -13,
    /** An unknown error occurred  */
    AdobeLabsMagicMusicRetargetingErrorUnknown           = -14,
    /** User is not authenticated with Creative Cloud */
    AdobeLabsMagicMusicRetargetingErrorNotAuthenticated  = -15
};


/** <fakeout>AdobeLabsMagicMusicRetargetingErrorDomain</fakeout> defines the error domain for NSErrors sent to completion blocks of AdobeLabsMagicMusicRetargeting functions.
 *
 * @see AdobeLabsMagicMusicRetargetingErrorCode
 *
 */
extern NSString * const AdobeLabsMagicMusicRetargetingErrorDomain;


/** <fakeout>MagicMusicRetargetingStatus</fakeout> defines instance states.
 *
 * @see AdobeLabsMagicMusicRetargetingErrorCode
 *
 */
typedef NS_ENUM(NSInteger, AdobeLabsMagicMusicRetargetingStatus) {
    AdobeLabsMagicMusicRetargetingStatusSongAnalysisInitialized,
    AdobeLabsMagicMusicRetargetingStatusSongAnalysisSuccess,
    AdobeLabsMagicMusicRetargetingStatusSongAnalysisFailed,
    AdobeLabsMagicMusicRetargetingStatusRetargetingInitialized,
    AdobeLabsMagicMusicRetargetingStatusRetargetingSucess,
    AdobeLabsMagicMusicRetargetingStatusRetargetingFailed
};


/** The `AdobeLabsMagicMusicRetargeting` class magically transforms any song at the click of a button to the duration you want. 
 Using beat detection, content analysis, and source separation, `AdobeLabsMagicMusicRetargeting` can recompose your clips
 to create amazing remixes in seconds.
 
 To use this class, inizialize it with an AVAsset:
 AdobeLabsMagicMusicRetargeting* retarget = [[AdobeLabsMagicMusicRetargeting alloc] initWithAsset:inAsset];
 
 Before remixing your track, you need to analyse the song. This needs to be done only once for each track:
 [retarget analyseSongAssetCompletionBlock:(void(^)(NSError *error))completionBlock
 {
 // completionBlock is called on the main thread
 if (nil == error)
 {
 // success! the was analyzed!
 }
 }];
 
 Then you can remix your song to any length calling the retargetToLength function:
 
 [retarget retargetToLength:inLength toURL:inURL completionBlock:^(AVAsset *result, NSError *error)
 {
 // completionBlock is called on the main thread
 if (nil == error)
 {
 // success! the new asset was created and is in the local variable 'asset'
 }
 }];
 
 <b>Note:</b> If there is an error, the error parameter of the completion block will be set.<br>Errors specific to `AdobeLabsMagicMusicRetargeting` will have error.domain set to:<br>`extern NSString * const AdobeLabsMagicMusicRetargetingErrorDomain`<br> and will have error code set to one of the enumeration values in AdobeLabsMagicMusicRetargetingErrorCode.
 
 Using <fakeout>AdobeLabsMagicMusicRetargeting</fakeout> is easy!  There is a function that allows for specification of desired change points in the remix too:
 retargetToLength:(NSTimeInterval)inLength  toURL:(NSURL *) inURL withChangePoints:(NSMutableArray *) inTargetChangePoints
 */
@interface AdobeLabsMagicMusicRetargeting : NSObject

/** @name Instance Methods */

/** initialize AdobeLabsMagicMusicRetargeting  with an audio AVAsset
 *
 * In the case of multiple added target AVAssets, the AdobeLabsMagicAudioSpeechMatcher will match to the average of the target AVAssets.
 *
 * @param inAsset       the AVAsset to to inizialize the class with. This asset must reside on the device (i.e. only file URL's are accepted)
 *
 */
- (id)initWithAsset:(AVAsset *) inAsset;

/** analyse the AVAsset of the class instance (@see initWithAsset). This methods has to be called before calling <fakeout>analyseSongAssetCompletionBlock</fakeout>.
 *
 * @param completionBlock   the completion block to call with error status and the new AVAsset upon completion
 * @note                    The NSError passed in to the completion block will be nil on success and non-nil on error.<br>The AVAsset passed in
 to the completion block will be non-nil on success and nil on error.<br>The completion block will be called on the main thread.
 The error `AdobeLabsMagicAudioErrorNotAuthenticated` will be returned if the user is on  the network but not logged into Creative Cloud.
 It is the responsibility of the caller to ensure the user is logged into Creative Cloud prior to calling this function.
 *
 */

- (void)analyseSongAssetCompletionBlock:(void(^)(NSError *error))completionBlock;

/** retarget the AVAsset of the class instance (@see initWithAsset) with a new duration. @note analyseSongAssetCompletionBlock
 *  must be called before calling this method.
 *
 * @param sourceAudio       target length in seconds.
 * @param inURL             location to save the wav file of the retargeted audio file.
 * @param completionBlock   the completion block to call with error status and the new AVAsset upon completion
 * @note                    The NSError passed in to the completion block will be nil on success and non-nil on error.<br>The AVAsset passed in
 to the completion block will be non-nil on success and nil on error.<br>The completion block will be called on the main thread.
 The error `AdobeLabsMagicAudioErrorNotAuthenticated` will be returned if the user is on  the network but not logged into Creative Cloud.
 It is the responsibility of the caller to ensure the user is logged into Creative Cloud prior to calling this function.
 *
 */
- (void)retargetToLength:(NSTimeInterval)inLength toURL:(NSURL *) inURL completionBlock:(void(^)(AVAsset *result, NSError *error))completionBlock;

/** retarget the AVAsset of the class instance (@see initWithAsset) with a new duration with changes at novelty points. @note analyseSongAssetCompletionBlock
 *  must be called before calling this method.
 *
 * @param sourceAudio                target length in seconds.
 * @param inURL                      location to save the wav file of the retargeted audio file.
 * @param inTargetChangePoints       points in seconds where novelty (emotional change) must happen in the target song.
 * @param completionBlock            the completion block to call with error status and the new AVAsset upon completion
 * @note                             The NSError passed in to the completion block will be nil on success and non-nil on error.<br>The AVAsset passed in
 to the completion block will be non-nil on success and nil on error.<br>The completion block will be called on the main thread.
 The error `AdobeLabsMagicAudioErrorNotAuthenticated` will be returned if the user is on  the network but not logged into Creative Cloud.
 It is the responsibility of the caller to ensure the user is logged into Creative Cloud prior to calling this function.
 *  @see retargetToLength
 *
 */
- (void)retargetToLength:(NSTimeInterval)inLength  toURL:(NSURL *) inURL withChangePoints:(NSMutableArray *) inTargetChangePoints
         completionBlock:(void(^)(AVAsset *result, NSError *error))completionBlock;


@end

