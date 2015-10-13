//
//  GMKeyChain.h
//  GameMaster
//
//  Created by Derek.Ray on 15/8/16.
//  Copyright (c) 2015年 Subao Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @interface GMKeyChain
 *
 * Wrapper of keychain, save/load credential infos for app
 */
@interface GMKeyChain : NSObject

/**
 * @method putVpnCredentialToKeychainWithKey:password
 *
 * Save VPN credential info to keychain
 *
 * @param key      Key of password
 * @param password Value for key
 */
+ (void)putVpnCredentialToKeychainWithKey:(NSString *)key password:(NSString *)password;

/**
 * @method getVpnCredentialFromKeychainWithKey
 *
 * Load vpn credential data from keychain
 *
 * @param key Key request value
 *
 * @return Persistent reference for request data, if error occured, nil will be returned
 */
+ (NSData *)getVpnCredentialFromKeychainWithKey:(NSString *)key;

@end
