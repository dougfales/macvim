//
//  MVPDirEntry.m
//  MacVim
//
//  Created by Doug Fales on 4/3/10.
//  MacVimProject (MVP) by Doug Fales, 2010
//

#import "MVPDirEntry.h"
#import "MVPProject.h"
#import "MacVim.h"
@implementation MVPDirEntry

@synthesize url, name, relativePath, rootDirectory, parentDirEntry, children, isDirectory, excludePredicate, currentSort;

- (id)initWithURL:(NSURL *)newUrl andParent:(MVPDirEntry *)aParent andProjectRoot:(NSString *)projectRoot andExcludePredicate:(NSPredicate *)excludePaths {
	if((self = [super init])) {
		self.url = newUrl;
        self.excludePredicate = excludePaths;
		NSNumber *dir = nil;
		[url getResourceValue:&dir forKey:NSURLIsDirectoryKey error:NULL];		
		isDirectory = [dir boolValue]; 
		self.rootDirectory = projectRoot;
        self.name = [url lastPathComponent];
        self.relativePath = [[url path] stringByReplacingOccurrencesOfString:projectRoot withString:@""];
		self.parentDirEntry = aParent;
        self.currentSort = [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES];
	}
	return self;
}

- (MVPDirEntry *)entryAtPath:(NSString *)path onlyDirectories:(BOOL)wantDir {
    MVPDirEntry *entry = self;
    NSString *projectRelativePath = [path stringByReplacingOccurrencesOfString:self.rootDirectory withString:@""];
    if([projectRelativePath isEqualToString:@"/"]){
        return entry;
    }
    NSArray *pathComponents = [projectRelativePath pathComponents];
    for (NSString *pathComponent in pathComponents) {
        for(MVPDirEntry *child in [entry children] ) {
            if([[child filename] isEqualToString:pathComponent]) {
                if(!wantDir || [child isDirectory]){
                    entry = child;
                    break;
                }
            }
        }
    }
    return entry;
}

- (MVPDirEntry *)refreshAtPath:(NSString *)pathToRefresh{
    MVPDirEntry *entryToRefresh = [self entryAtPath:pathToRefresh onlyDirectories:YES];
    [entryToRefresh refreshDirectory];
    return entryToRefresh;
}

- (MVPDirEntry *)entryAtPath:(NSString *)path {
    return [self entryAtPath:path onlyDirectories:NO];
}

- (NSArray *)directoryContents
{
    NSArray *keys = [NSArray arrayWithObjects:NSURLIsDirectoryKey, NSURLIsPackageKey, NSURLLocalizedNameKey, nil];
	NSError *error = nil;
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.url
													  includingPropertiesForKeys:keys
																		 options:(NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsHiddenFiles)
																		   error:&error];
    return contents;
}

// Refresh only one-level--do not recurse unless a new directory is found. Intended for use with the FSEvents listener.
- (void)refreshDirectory
{
    NSArray *contents = [self directoryContents];
    // First, add new objects.
    for(NSURL *file in contents) {
        NSString *name = [file lastPathComponent];
		if(self.excludePredicate == nil || [self.excludePredicate evaluateWithObject:name] == NO) {
            BOOL unchanged = NO;
            NSNumber *isDir = nil;
			[file getResourceValue:&isDir forKey:NSURLIsDirectoryKey error:NULL];
            for(MVPDirEntry *child in children) {
                if([[child filename] isEqualToString:name] && [child isDirectory] == [isDir boolValue]) {
                    unchanged = YES;
                    break;
                }
            }
            
            if(!unchanged) {
                MVPDirEntry *dirEntry = [[MVPDirEntry alloc] initWithURL:file
                                                               andParent:self
                                                          andProjectRoot:self.rootDirectory
                                                     andExcludePredicate:self.excludePredicate];
                [self addChild:dirEntry];
                if([isDir boolValue]) {
                    [dirEntry buildTree];
                }
            }
		}
	}
    // Locate and remove deleted ones.
    NSMutableArray *deletedFiles = [NSMutableArray array];
    for(MVPDirEntry *child in children) {
        BOOL found = NO;
        for(NSURL *file in contents) {
            if([[file lastPathComponent] isEqualToString:[child filename]]){
                found = YES;
                break;
            }
        }
        if(!found){
            [deletedFiles addObject:child];
        }
    }
    [children removeObjectsInArray:deletedFiles];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES];
    [children sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}

-(void)buildTree
{
    NSArray *contents = [self directoryContents];
    if([contents count] > 0){
        self.isDir = YES;
    }
    for(NSURL *file in contents) {
		if(self.excludePredicate == nil || [self.excludePredicate evaluateWithObject:[file lastPathComponent]] == NO) {
			MVPDirEntry *dirEntry = [[MVPDirEntry alloc] initWithURL:file
                                                           andParent:self
                                                      andProjectRoot:self.rootDirectory
                                                 andExcludePredicate:self.excludePredicate];
			[self addChild:dirEntry];
            NSNumber *isDirectory = nil;
            [file getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
            dirEntry.isDir = [isDirectory boolValue];
            if(dirEntry.isDir) {
                dirEntry.needsLoad = YES;
            }
		}
	}
    self.needsLoad = NO;
     [self.children sortUsingDescriptors:[NSArray arrayWithObject:self.currentSort]];
}

- (void)addChild:(MVPDirEntry *)childEntry
{
    // Skip .mvp project file.
    if([childEntry.filename hasSuffix:@".mvp"]) {
        return;
    }
    if(children == nil) {
		self.children = [NSMutableArray arrayWithCapacity:1];
	}
	[children addObject:childEntry];
}

-(id)copyWithZone:(NSZone *)zone {
	MVPDirEntry *copy = [[MVPDirEntry alloc] initWithURL:self.url andParent:self.parentDirEntry andProjectRoot:self.rootDirectory andExcludePredicate:self.excludePredicate];
	return copy;
}

- (void)dealloc {
	[url release]; url = nil;
	[parentDirEntry release]; parentDirEntry = nil;
	[super dealloc];
}

-(NSImage *)icon {
	return [[NSWorkspace sharedWorkspace] iconForFileType:[self.url pathExtension]];
}

- (NSString *)filename {
	return [url lastPathComponent];
}

- (NSString *)absolutePath {
    return [self.rootDirectory stringByAppendingPathComponent:relativePath];
}

- (BOOL)isLeaf {
    return !self.isDir;
	//return ((children == nil) || [children count] == 0);
}

- (NSInteger)childCount {
	if(children == nil) {
		return 0;
	} else {
		return [children count];
	}
}

- (MVPDirEntry *)childAtIndex:(NSInteger)index
{
    if(children == nil || [children count] <= index){
        return nil;
    } else {
        return [children objectAtIndex:index];
    }
}

@end
