#import "KidoZen.h"

NSString *const KZOnKidoZenInitializationError = @"KZOnKidoZenInitializationError";
NSString *const KZShareFileError = @"KZShareFileError";
NSString *const KZPushNotificationError = @"KZPushNotificationError";
NSString *const KZSalesForceError = @"KZSalesForceError";
NSString *const KZStorageError = @"KZStorageError";
NSString *const KZEmailError = @"KZStorageError";

NSString *const KZ_PROVIDER_KEY = @"Kidozen";
NSString *const KZ_SALESFORCE_SERVICEID = @"salesforce";
NSString *const KZ_SHAREFILE_SERVICEID = @"sharefile";
NSString *const KZ_STORAGEID= @"FilesForLead";
NSString *const KZ_CHANNEL= @"FilesForLeadChannel";

NSString *const KZ_SALESFORCE_CREATE_METHODID = @"createObject";
NSString *const KZ_SALESFORCE_COMUNITY_ID = @"09ai00000006W9L";
NSString *const KZ_SALESFORCE_QUERY_METHODID = @"queryObjects";

NSString *const KZ_SHAREFILE_FILEGET_METHODID = @"FileGet";
NSString *const KZ_SHAREFILE_FILELINK_METHODID = @"file";
NSString *const KZ_SHAREFILE_FOLDERLIST_METHODID = @"folder";

NSString *const KZ_SHAREFILE_GETAUTHID_METHODID =@"getAuthID";

@interface KidoZen()
{
    NSString *shareFileAuthId;
}
@end

@implementation KidoZen

+ (KidoZen *)sharedApplication
{
    __strong static id _sharedObject = nil;
    @synchronized(self) {
        if (_sharedObject == nil)
        {
            _sharedObject = [[self alloc] init];
            [_sharedObject initApplicationAndAuthenticate];
        }
    }
    return _sharedObject;
}

-(void) initApplicationAndAuthenticate
{
    __block NSError * initializationError = nil;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        self.settings = [NSUserDefaults standardUserDefaults];
        self.kido = [[KZApplication alloc] initWithTennantMarketPlace:[_settings objectForKey:@"tenant_preference"]
                                                      applicationName:[_settings objectForKey:@"application_preference"]
                                                  bypassSSLValidation:[_settings integerForKey:@"bypasssl_preference"]
                                                          andCallback:^(KZResponse * kr) {
            if (kr.error) {
                initializationError = kr.error;
                dispatch_semaphore_signal(semaphore);
            }
            else
                [kr.application authenticateUser:[_settings objectForKey:@"kz_user_preference"]
                                withProvider:KZ_PROVIDER_KEY andPassword:[_settings objectForKey:@"kz_secret_preference"]
                                completion:^(id kr){
                    if ([kr  isKindOfClass:[NSError class]]) {
                        initializationError = kr;
                    }
                    dispatch_semaphore_signal(semaphore);
                }];
        }];

        while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    if (initializationError) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KZOnKidoZenInitializationError object:initializationError];
    }
    else {
        self.salesforce = [self.kido LOBServiceWithName:KZ_SALESFORCE_SERVICEID];
        self.sharefile = [self.kido LOBServiceWithName:KZ_SHAREFILE_SERVICEID];
        self.storage = [self.kido StorageWithName:KZ_STORAGEID];
    }
}

//salesforce
-(void) getLeadsFromSalesforce:(queryArrayOperationBlock) response {
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:@"SELECT Id, Name FROM Lead", @"query",nil];
    [self.salesforce invokeMethod:KZ_SALESFORCE_QUERY_METHODID withData:data completion:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZSalesForceError object:r.error];
        else {
            response([[r.response objectForKey:@"data"] objectForKey:@"records"]);
        }
    }];
}

-(void) createIdeaForFile:(NSString *)fileUrl andLead:(NSString *) lead   withBlock:(operationResponseBlock) response {
    NSString * title = [NSString stringWithFormat:@"Hey %@, take a look here!", lead];
    NSString * body = [NSString stringWithFormat:@"ShareFile url: %@", fileUrl];

    
    NSDictionary *feedData = [NSDictionary dictionaryWithObjectsAndKeys:body,@"Body",
                              title,@"Title",
                              KZ_SALESFORCE_COMUNITY_ID,@"CommunityId",
                              nil];
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:feedData, @"object",@"Idea",@"objectClass",nil];

    [self.salesforce invokeMethod:KZ_SALESFORCE_CREATE_METHODID withData:data completion:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZSalesForceError object:r.error];
        else
            response([[r.response objectForKey:@"data"] objectForKey:@"success"]);
    }];
}

-(void) getLeadFromSalesforce:(NSString *) lead withBlock:(queryDictionaryOperationBlock) response {
    
    NSString * q = [NSString stringWithFormat:@"SELECT Id, Name, Title, Company, Email FROM Lead WHERE Name = '%@'", lead];
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:q, @"query",nil];

    [self.salesforce invokeMethod:KZ_SALESFORCE_QUERY_METHODID withData:data completion:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZSalesForceError object:r.error];
        else
            response([[[r.response objectForKey:@"data"] objectForKey:@"records"] objectAtIndex:0]);
    }];
}

// sharefile
-(void)setAuthId
{
    if (shareFileAuthId) {
        return;
    }
    dispatch_semaphore_t s = dispatch_semaphore_create(0);
    
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:
                           [_settings objectForKey:@"sharefile_user"], @"username",
                           [_settings objectForKey:@"sharefile_password"], @"password",nil];
    
    
    [self.sharefile invokeMethod:KZ_SHAREFILE_GETAUTHID_METHODID withData:data completion:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZShareFileError object:r.error];
        else
            shareFileAuthId = [[r.response objectForKey:@"data"] objectForKey:@"authid"];

        dispatch_semaphore_signal(s);
    }];
    while (dispatch_semaphore_wait(s, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
}

-(id) checkShareFileResponse:(KZResponse *) r
{
    if ([r.response isKindOfClass:[NSDictionary class]]) {
        if ([r.response objectForKey:@"error"]) {
            NSObject * err = [r.response objectForKey:@"error"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KZShareFileError object:err];
            return nil;
        }
        else {
            NSDictionary * data = [r.response objectForKey:@"data"];
            return data;
        }
    }
    else
        return r.response;
}

-(void) getDetails:(NSString *) file withBlock:(queryDictionaryOperationBlock) response {
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:shareFileAuthId, @"authid", @"get", @"op", file, @"id",  nil];
    
    [self.sharefile invokeMethod:KZ_SHAREFILE_FILEGET_METHODID withData:data completion:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZShareFileError object:r.error];
        else
            response([self checkShareFileResponse:r]);
    }];
}

-(void) getFilesFromShareFilePath:(NSString *) path withBlock:(queryArrayOperationBlock) response {
    [self setAuthId];
    if (!shareFileAuthId) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KZSalesForceError object:nil];
        return;
    }
    
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:shareFileAuthId, @"authid", path, @"path",nil];
    [self.sharefile invokeMethod:KZ_SHAREFILE_FOLDERLIST_METHODID withData:data completion:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZShareFileError object:r.error];
        else
            response([self checkShareFileResponse:r]);
    }];
}

-(void) getFileLinkUsingFileId:(NSString *) file andPath:(NSString *) path withBlock:(operationResponseBlock) response {
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:shareFileAuthId, @"authid", @"download", @"op", file, @"id",  nil];
    
    [self.sharefile invokeMethod:KZ_SHAREFILE_FILELINK_METHODID withData:data completion:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZShareFileError object:r.error];
        else
        {
            NSString *kidoresponse = [r.response objectForKey:@"data"];
            NSString *escaped = [kidoresponse stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            response(escaped);
        }
    }];
}


//storage
-(void) assignFile:(NSString *)file toLead:(NSString *)lead withBlock:(operationResponseBlock) block {

    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:file, @"file",
                           lead, @"lead",nil];

    [self.storage create:data completion:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZStorageError object:r.error];
        else
            block (r);
    }];
}

-(void) getFilesForLead:(NSString *)lead withBlock:(queryArrayOperationBlock ) response {

    NSString *q = [NSString stringWithFormat:@"{\"lead\": \"%@\"}", lead];
    [self.storage query:q withBlock:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZStorageError object:r.error];
        else
            response( r.response );
    }];
}

-(void) getFileOwners:(NSString *)file withBlock:(queryArrayOperationBlock ) response {
    
    NSString *q = [NSString stringWithFormat:@"{\"file\": \"%@\"}", file];
    [self.storage query:q withBlock:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZStorageError object:r.error];
        else
            response( r.response );
    }];
}

//email
-(void) sendToEmail:(NSString *)mail fileUrl:(NSString *)file withBlock:(operationResponseBlock) response
{
    [self.kido sendMailTo:mail from:@"support@kidozen.com" withSubject:@"ShareFile link" andHtmlBody:@"" andTextBody:file completion:^(KZResponse * r) {
        if (r.error)
            [[NSNotificationCenter defaultCenter] postNotificationName:KZEmailError object:r.error];
        else
            response( r.response );
    }];
}

@end

