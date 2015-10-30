//
//  AppDelegate.swift
//  SFCredentialHacker
//
//  Created by Peter Park on 10/30/15.
//  Copyright © 2015 Rollio. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

let SFCredentialsReceivedNotification = "SFCredentialsReceivedNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let RemoteAccessConsumerKey = "3MVG9A2kN3Bn17huP7U2.vrcoDFZjUhnQBEoKVs_aHq678Hub3_j5H2OvlAM6NsbsIBwbf4qugv5T6d4Brua0"
    let OAuthRedirectURI        = "testsfdc:///mobilesdk/detect/oauth/done" //"https://oauth-callback.rollioapp.com/"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Salesforce setup
        SFLogger.setLogLevel(SFLogLevelDebug)
        
        SalesforceSDKManager.sharedManager().connectedAppId = RemoteAccessConsumerKey
        SalesforceSDKManager.sharedManager().connectedAppCallbackUri = OAuthRedirectURI
        SalesforceSDKManager.sharedManager().authScopes = ["api", "web"]
        
        // Define Salesforce account event handlers
        SalesforceSDKManager.sharedManager().postLaunchAction = postLaunchAction
        
        SFAuthenticationManager.sharedManager().logout()
        SalesforceSDKManager.sharedManager().launch()
        
//        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
        SFAuthenticationManager.sharedManager().logout()
    }
    
    // MARK: Salesforce Manager event handlers
    
    func postLaunchAction(launchActionList: SFSDKLaunchAction) {
        // If you wish to register for push notifications, uncomment the line below.  Note that,
        // if you want to receive push notifications from Salesforce, you will also need to
        // implement the application:didRegisterForRemoteNotificationsWithDeviceToken: method (below).
        //
        //[[SFPushNotificationManager sharedInstance] registerForRemoteNotifications];
        //
        self.log(SFLogLevelInfo, msg: "Post-launch: launch actions taken: \(SalesforceSDKManager.launchActionsStringRepresentation(launchActionList))")
        
        //collect credentials and copy to pasteboard
        let creds = SFUserAccountManager.sharedInstance().currentUser.credentials
        let credentials: Dictionary<String, String> = [
            "client_id" : RemoteAccessConsumerKey,
            "instance_url" : creds.instanceUrl.absoluteString,
            "identity_url": creds.identityUrl.absoluteString,
            "access_token" : creds.accessToken,
            "refresh_token" : creds.refreshToken,
            "user_id" : creds.userId]
        
        NSNotificationCenter.defaultCenter().postNotificationName(SFCredentialsReceivedNotification, object: credentials)
    }
}

