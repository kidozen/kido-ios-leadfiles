//
//  FunctionRename.h
//
//  Copyright (c) 2012 Citrix Systems Inc. All rights reserved.
//

/* This file needs to be included in the .pch file of the app for Replacing Function*/

#define  SCNetworkReachabilityCreateWithAddress             SCNetworkReachabilityCreateWithAddrHK
#define  SCNetworkReachabilityCreateWithAddressPair         SCNetworkReachabilityCreateWithAddressPHK 
#define  SCNetworkReachabilityCreateWithName                SCNetworkReachabilityCreateWithNHK 
#define  SCNetworkReachabilityGetFlags                      SCNetworkReachabilityGetFlHK 
#define  SCNetworkReachabilityScheduleWithRunLoop           SCNetworkReachabilityScheduleWithRunLHK 
#define  SCNetworkReachabilityUnscheduleWithRunLoop         SCNetworkReachabilityUnscheduleFromRunLHK
#define  SCNetworkReachabilitySetCallback                   SCNetworkReachabilitySetCallbHK

#define  connect            connHK
#define  bind               bHK 
#define  gethostbyname      gethostbynHK 
#define  sendto             senHK 
#define  recvfrom           recvfHK 
#define  res_query          res_quHK 
#define  gethostbyaddr      gethostbyaHK 

#define  CFHostCreateWithAddress             CFHostCreateWithAddrHK 
#define  CFHostCreateWithName                CFHostCreateWithNHK  
#define  CFHostStartInfoResolution           CFHostStartInfoResolutHK   
#define  CFHostScheduleWithRunLoop           CFHostScheduleWithRunLHK   

#define  CFHostSetClient                     CFHostSetCliHK 
#define  CFHostGetAddressing                 CFHostGetAddressHK    
#define  CFHostUnscheduleFromRunLoop         CFHostUnscheduleFromRunLHK
#define  CFHostCancelInfoResolution          CFHostCancelInfoResolutHK 

#define  CFStreamCreatePairWithSocket               CFStreamCreatePairWithSocHK    
#define  CFStreamCreatePairWithSocketToHost         CFStreamCreatePairWithSocketToHHK  
#define  CFStreamCreatePairWithSocketToCFHost       CFStreamCreatePairWithSocketToCFHHK
#define  CFStreamCreatePairWithPeerSocketSignature  CFStreamCreatePairWithPeerSocketSignatHK


#define  CFReadStreamSetProperty                    CFReadStreamSetPropeHK  
#define  CFWriteStreamSetProperty                   CFWriteStreamSetPropeHK  
#define  CFReadStreamCreateForHTTPRequest           CFReadStreamCreateForHTTPRequHK  
#define  CFReadStreamCreateForStreamedHTTPRequest   CFReadStreamCreateForStreamedHTTPRequHK  

#define CFWriteStreamGetError  CFWriteStreamGetErHK
#define CFWriteStreamCopyError CFWriteStreamCopyErHK

#define CFReadStreamGetError    CFReadStreamGetErHK
#define CFReadStreamCopyError   CFReadStreamCopyErHK

#define  CFNetworkCopySystemProxySettings    CFNetworkCopySystemProxySettiHK 
#define  CFWriteStreamOpen                   CFWriteStreamOHK 
#define  CFReadStreamOpen                    CFReadStreamOHK 
#define  CFSocketCreate                      CFSocketCreHK    
#define  CFSocketConnectToAddress            CFSocketConnectToAddrHK    
#define  CFSocketSendData                    CFSocketSendDHK    //used for UDP interception only
#define  CFSocketCreateRunLoopSource         CFSocketCreateRunLoopSouHK    
#define  CFSocketInvalidate                  CFSocketInvalidHK   

#define CFReadStreamCreateWithFTPURL    CFReadStreamCreateWithFTPHK
#define CFWriteStreamCreateWithFTPURL   CFWriteStreamCreateWithFTPHK

    // Contentment
#define AudioUnitSetProperty            AudioUnitSetPropeHK
#define AudioUnitRender                 AudioUnitRenHK

