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
#import <AVFoundation/AVFoundation.h>

/** <fakeout>AdobeLabsMagicAudioErrorCode</fakeout> defines the constant error codes for <fakeout>AdobeLabsMagicAudioErrorDomain</fakeout>.
 *
 * <fakeout>AdobeLabsMagicAudioSpeechMatcher</fakeout> completion blocks pass an NSError.  If the NSError is non-nil and the NSError domain is <fakeout>AdobeLabsMagicAudioErrorDomain</fakeout> then the error code will be set with one of these enumeration values.
 *
 * @see AdobeLabsMagicAudioErrorDomain
 *
 */
typedef NS_ENUM(NSInteger, AdobeLabsMagicAudioErrorCode) {
    /** Writing an asset failed  */
    AdobeLabsMagicAudioErrorWriteAssetFailed  = -10,
    /** Reading an asset failed  */
    AdobeLabsMagicAudioErrorLoadAssetFailed   = -11,
    /** No match targets were added */
    AdobeLabsMagicAudioErrorEmptyMatcher      = -12,
    /** An unknown error occurred  */
    AdobeLabsMagicAudioErrorUnknown           = -13,
    /** User is not authenticated with Creative Cloud */
    AdobeLabsMagicAudioErrorNotAuthenticated  = -14
};

/** <fakeout>AdobeLabsMagicAudioErrorDomain</fakeout> defines the error domain for NSErrors sent to completion blocks of AdobeLabsMagicAudio functions.
 *
 * @see AdobeLabsMagicAudioErrorCode
 *
 */
extern NSString * const AdobeLabsMagicAudioErrorDomain;

/** The `AdobeLabsMagicAudioSpeechMatcher` class magically transforms speech audio files so that they match the acoustic properties of one or more other speech audio files.  `AdobeLabsMagicAudioSpeechMatcher` is useful for transforming speech files so that they all sound like they were recorded in the same session, independent of location or microphone position.  The best way to use this class is to create one or more <i>target</i> speech recordings that you would like all subsequent recordings to match.  Parameterize this class with target recordings as follows:
 
    AdobeLabsMagicAudioSpeechMatcher * matcher = [AdobeLabsMagicAudioSpeechMatcher alloc] init];
    [matcher addTarget: [AVAsset assetFromURL: [NSURL fileURLWithPath: @"myTargetSpeech.mp3"]];
 
 Adding a single recording will make that recording the target. Adding additional recordings will make the average of the included recordings the target. Then to match a new speech recording to the target sound, call the matchSpeechOf function:
 
     [matcher matchSpeechOf: [AVAsset assetFromURL: [NSURL fileURLWithPath: @"mySourceRecordingToMatch.mp3"]]
            completionBlock: ^(AVAsset * asset, NSError *error)
                {
                    // completionBlock is called on the main thread
                    if (nil == error)
                        {
                            // success! the new asset was created and is in the local variable 'asset'
                        }
                }];
 
 <b>Note:</b> If there is an error in matching, the error parameter of the completion block will be set.<br>Errors specific to `AdobeLabsMagicAudioSpeechMatcher` will have error.domain set to:<br>`extern NSString * const AdobeLabsMagicAudioErrorDomain`<br> and will have error code set to one of the enumeration values in AdobeLabsMagicAudioErrorCode.
 
 Using <fakeout>AdobeLabsMagicAudioSpeechMatcher</fakeout> is easy!  There is a function that allows for specification of the desired noise factor during matching: matchSpeechOf:andNoiseFactor:completionBlock:
 
 */
@interface AdobeLabsMagicAudioSpeechMatcher : NSObject

/** @name Instance Methods */

/** add an audio AVAsset to the list of match targets to match against
 *
 * In the case of multiple added target AVAssets, the AdobeLabsMagicAudioSpeechMatcher will match to the average of the target AVAssets.
 *
 * @param matchTarget the AVAsset to add to the list of match targets to match against. This asset must reside on the device (i.e. only file URL's are accepted)
 * @see removeMatchTarget
 *
 */
- (void)addMatchTarget:(AVAsset *)matchTarget;

/** remove a previously added AVAsset from the list of match targets to match against
 *
 * @param matchTarget the AVAsset to remove from the list of match targets to match against
 * @see addMatchTarget
 *
 */
- (void)removeMatchTarget:(AVAsset *)matchTarget;

/** match the acoustic properties of an AVAsset to the target AVAssets
 *
 * @param sourceAudio the source AVAsset match to the previously added targets.
 * @note This asset must reside on the device (i.e. only AVAssets created from file URL's are accepted)
 * @param completionBlock the completion block to call with error status and the new AVAsset upon completion
 * @note The NSError passed in to the completion block will be nil on success and non-nil on error.<br>The AVAsset passed in to the completion block will be non-nil on success and nil on error.<br>The completion block will be called on the main thread.  The error `AdobeLabsMagicAudioErrorNotAuthenticated` will be returned if the user is on  the network but not logged into Creative Cloud.  It is the responsibility of the caller to ensure the user is logged into Creative Cloud prior to calling this function.
 * @see addMatchTarget
 * @see AdobeLabsMagicAudioDomain
 * @see AdobeLabsMagicAudioErrorCode
 *
 */
- (void)matchSpeechOf:(AVAsset *)sourceAudio completionBlock:(void(^)(AVAsset *, NSError *))completionBlock;

/** match the acoustic properties of an AVAsset to the target AVAssets with control of the noise factor
 *
 * @param sourceAudio the source AVAsset match to the previously added targets.
 * @note This asset must reside on the device (i.e. only AVAssets created from file URL's are accepted)
 * @param noiseFactor the noise factor between 0.0 and 1.0 specifying the amount of noise factor from the targets to include in the match
 * @param completionBlock the completion block to call with error status and the new AVAsset upon completion
 * @note The NSError passed in to the completion block will be nil on success and non-nil on error.<br>The AVAsset passed in to the completion block will be non-nil on success and nil on error.<br>The completion block will be called on the main thread.  The error `AdobeLabsMagicAudioErrorNotAuthenticated` will be returned if the user is on the network but not logged into Creative Cloud.  It is the responsibility of the caller to ensure the user is logged into Creative Cloud prior to calling this function.
 * @see addMatchTarget
 * @see AdobeLabsMagicAudioDomain
 * @see AdobeLabsMagicAudioErrorCode
 *
 */
- (void)matchSpeechOf:(AVAsset *)sourceAudio andNoiseFactor:(float)noiseFactor completionBlock:(void(^)(AVAsset *, NSError *))completionBlock;

@end


