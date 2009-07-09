/*
 CHDataStructures.framework -- CHSortedDictionary.m
 
 Copyright (c) 2009, Quinn Taylor <http://homepage.mac.com/quinntaylor>
 
 Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.
 
 The software is  provided "as is", without warranty of any kind, including all implied warranties of merchantability and fitness. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software.
 */

#import "CHSortedDictionary.h"
#import "CHAVLTree.h"

@implementation CHSortedDictionary

- (void) dealloc {
	[sortedKeys release];
	[super dealloc];
}

- (id) initWithCapacity:(NSUInteger)numItems {
	if ((self = [super initWithCapacity:numItems]) == nil) return nil;
	sortedKeys = [[CHAVLTree alloc] init];
	return self;
}

- (id) initWithCoder:(NSCoder*)decoder {
	if ((self = [super initWithCoder:decoder]) == nil) return nil;
	[sortedKeys addObjectsFromArray:[(NSDictionary*)dictionary allKeys]];
	return self;
}

// The -encodeWithCoder: inherited from CHLockableDictionary works fine here.

#pragma mark Adding Objects

- (void) setObject:(id)anObject forKey:(id)aKey {
	if (!CFDictionaryContainsKey(dictionary, aKey)) {
		id clonedKey = [[aKey copy] autorelease];
		[sortedKeys addObject:clonedKey];
		CFDictionarySetValue(dictionary, clonedKey, anObject);
	}
}

#pragma mark Querying Contents

/**
 Returns an array containing the receiver's keys in sorted order.
 
 @return An array containing the receiver's keys in sorted order. The array is empty if the receiver has no entries.
 
 @see allValues
 @see count
 @see keyEnumerator
 @see countByEnumeratingWithState:objects:count:
 */
- (NSArray*) allKeys {
	return [super allKeys];
}

- (id) firstKey {
	return [sortedKeys firstObject];
}

- (id) lastKey {
	return [sortedKeys lastObject];
}

- (NSEnumerator*) keyEnumerator {
	return [sortedKeys objectEnumerator];
}

- (NSEnumerator*) reverseKeyEnumerator {
	return [sortedKeys reverseObjectEnumerator];
}

- (NSMutableDictionary*) subsetFromKey:(id)start
                                 toKey:(id)end
                               options:(CHSubsetConstructionOptions)options
{
	id<CHSortedSet> keySubset = [sortedKeys subsetFromObject:start toObject:end options:options];
	NSMutableDictionary* subset = [[[[self class] alloc] init] autorelease];
	for (id aKey in keySubset) {
		[subset setObject:[self objectForKey:aKey] forKey:aKey];
	}
	return subset;
}

#pragma mark Removing Objects

- (void) removeAllObjects {
	[sortedKeys removeAllObjects];
	[super removeAllObjects];
}

- (void) removeObjectForKey:(id)aKey {
	if (CFDictionaryContainsKey(dictionary, aKey)) {
		[sortedKeys removeObject:aKey];
		CFDictionaryRemoveValue(dictionary, aKey);
	}
}

@end
