//
//  MDXSDK.h
//
//  Dated: 02/04/2013
//  Copyright (c) 2013 Citrix Systems Inc. All rights reserved.
//


typedef enum {
    MDX_APPMODE_MDXSpecific = 0,
    MDX_APPMODE_GeneralAppStore
} MDX_APPMODE;


@interface MDXSDK : NSObject

///// Set App Mode from one of the modes mentioned in the MDX_APPMODE enum
+(BOOL) CTXMDX_SetAppMode:(MDX_APPMODE)appMode;


///// Get policies values provided by the MDX framework. If MDX framework is not active and app is running with demo policies, return demo policy values
+(NSString*) CTXMDX_GetValueOfPolicy:(NSString*)policyName DefaultValue:(NSString*)defaultValue;


////// Check if MDX-Manager(Receiver or AccessManager) is installed //////
+(BOOL) CTXMDX_IsMDXAccessManagerInstalled;

@end
