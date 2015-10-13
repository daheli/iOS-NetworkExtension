//
//  GMKeyChain.m
//  GameMaster
//
//  Created by Derek.Ray on 15/8/16.
//  Copyright (c) 2015年 Subao Technology. All rights reserved.
//

#import "GMKeyChain.h"

@implementation GMKeyChain

+ (void)putVpnCredentialToKeychainWithKey:(NSString *)key password:(NSString *)password {
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSData *encodedIdentifier = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrDescription] = @"GameMaster authentitation keychain";
    keychainItem[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    keychainItem[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    keychainItem[(__bridge id)kSecAttrService] = [[NSBundle mainBundle] bundleIdentifier];
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    
    //Set our password
    keychainItem[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, nil);
    
    if (status != errSecSuccess && status != errSecDuplicateItem) {
        NSLog(@"Save %@ to keychain fail! error code = %d",key ,(int)status);
    }
}

+ (NSData *)getVpnCredentialFromKeychainWithKey:(NSString *)key {
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSData *encodedIdentifier = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrDescription] = @"GameMaster authentitation keychain";
    keychainItem[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    keychainItem[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    keychainItem[(__bridge id)kSecAttrService] = [[NSBundle mainBundle] bundleIdentifier];
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    keychainItem[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    keychainItem[(__bridge id)kSecReturnPersistentRef] = (__bridge id)kCFBooleanTrue;
    
    CFTypeRef typeResult = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, &typeResult);
    
    if(sts == errSecSuccess) {
        NSData *theReference = (__bridge NSData *)typeResult;
        return theReference;
        
    }
    
    NSLog(@"Error Code: %d", (int)sts);
    
    return nil;
}

@end
