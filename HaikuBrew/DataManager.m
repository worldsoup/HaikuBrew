    //
//  DataManager.m
//
//  Created by Haiku Brew on 7/23/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import "DataManager.h"
#import "GetHaikuBrewsForUserId.h"
#import "CreateHaikuRequest.h"
#import "UpdateHaikuLineThree.h"
#import "UpdateLineTwo.h"
#import "SyllablesCount.h"
#import "HideHaikuRequest.h"
#import "FacebookUser.h"
#import "SendPushTokenToServer.h"


static DataManager *dataManager = nil;

@implementation DataManager

@synthesize  lastCommunicationError;
#pragma mark Singleton Methods
+ (id) getDataManager {
    @synchronized(self) {
        if(dataManager == nil)
            dataManager = [[super allocWithZone:NULL] init];
    }
    return dataManager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (NSMutableArray *) getHaikuBrewsForUserId:(NSString *) _userId
{    
    GetHaikuBrewsForUserId * request = [[GetHaikuBrewsForUserId alloc] init];
    
    NSMutableArray *success = [request execute:_userId];    
    return success;
}

- (Haiku *) createHaiku:(Haiku *) haiku
{    
    CreateHaikuRequest * request = [[CreateHaikuRequest alloc] init];
    
    Haiku *success = [request execute:haiku];    
    return success;
}


- (Haiku *) updateHaikuLine2:(Haiku *) haiku
{    
    UpdateLineTwo * request = [[UpdateLineTwo alloc] init];
    
    Haiku *success = [request execute:haiku];    
    return success;
}

- (Haiku *) updateHaikuLine3:(Haiku *) haiku
{    
    UpdateHaikuLineThree * request = [[UpdateHaikuLineThree alloc] init];
    
    Haiku *success = [request execute:haiku];    
    return success;
}

- (NSNumber *) syllableCountCheck:(NSString *) _string
{    
    SyllablesCount * request = [[SyllablesCount alloc] init];
    
    NSNumber *success = [request execute:_string];    
    return success;
}

- (BOOL) hideHaiku:(Haiku *) pHaiku
{    
    HideHaikuRequest * request = [[HideHaikuRequest alloc] init];
    return [request execute:pHaiku];    
}


- (BOOL) registerDevice:(FacebookUser *) user
{    
    SendPushTokenToServer * request = [[SendPushTokenToServer alloc] init];
    return [request executeWithFacebookUser:user];    
}


- (NSNumber *) countSyl:(NSString *) phrase
{
  
    
    
    __block int syllables = 0;
    NSArray *listItems = [phrase componentsSeparatedByString:@" "];
    for(int i = 0; i < listItems.count; i++)
    {
        NSString *word = [[[listItems objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
        if(![word isEqualToString:@""])
        {
            NSNumber *wordSylCount = [self countSyllablesForWord:word];
            syllables = syllables + wordSylCount.intValue;
        }
    }
    
    return [NSNumber numberWithInt: syllables];
    
}

- (NSNumber *) countSyllablesForWord:(NSString *) wordForCalc
{
    __block int syllables = 0;
    NSArray *subtractSyllables = [[NSArray alloc] initWithObjects:  [NSRegularExpression regularExpressionWithPattern:@"cial" options:0 error:nil], [NSRegularExpression regularExpressionWithPattern:@"tia" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"cius" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"cious" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"uiet" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"gious" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"geous" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"priest" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"giu" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"dge" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ion" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"iou" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"sia$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".che$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ched$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".abe$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ace$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ade$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".age$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".aged$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ake$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ale$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".aled$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ales$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ane$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ame$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ape$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".are$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ase$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ashed$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".asque$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ate$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@".ave$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"azed$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"awe$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"aze$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"aped$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"athe$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"athes$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ece$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ese$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"esque$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"esques$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"eze$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"gue$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ibe$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ice$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ide$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ife$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ike$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ile$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ime$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ine$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ipe$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"iped$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ire$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ise$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ished$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ite$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ive$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ize$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"obe$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ode$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"oke$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ole$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ome$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"one$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ope$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"oque$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ore$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ose$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"osque$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"osques$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ote$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ove$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"pped$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"sse$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ssed$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ste$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ube$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"uce$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ude$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"uge$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"uke$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ule$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ules$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"uled$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ume$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"une$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"upe$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ure$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"use$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ushed$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ute$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ved$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"we$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"wes$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"wed$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"yse$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"yze$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"rse$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"red$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"rce$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"rde$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ily$" options:0 error:nil],
                                  //[NSRegularExpression regularExpressionWithPattern:@"ne$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ely$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"des$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"gged$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"kes$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ced$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ked$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"med$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"mes$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ned$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"sed$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"nce$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"rles$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"nes$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"pes$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"tes$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"res$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ves$" options:0 error:nil],
                                  [NSRegularExpression regularExpressionWithPattern:@"ere$" options:0 error:nil],
                                  nil];
    
    
    NSArray *addSyllables = [[NSArray alloc] initWithObjects: [NSRegularExpression regularExpressionWithPattern:@"ia" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"riet" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"dien" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"ien" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"iet" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"iu" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"iest" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"io" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"ii" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"ily" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"oala$" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"iara$" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"ying$" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"earest" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"aress" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"eate$" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"eation$" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"[aeiouym]bl$" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"[aeiou]{3}" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"^mc" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"ism" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"^mc" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"asm" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"([^aeiouy])\1l$" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"[^l]lien" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"^coa[dglx]." options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"[^gq]ua[^auieo]" options:0 error:nil],
                             [NSRegularExpression regularExpressionWithPattern:@"dnt$" options:0 error:nil],
                             nil];
    
    NSArray *uberExceptions = [[NSArray alloc] initWithObjects:  @"abe",
                               @"ace",
                               @"ade",
                               @"age",
                               @"ale",
                               @"are",
                               @"use",
                               @"ate" ,nil];
    
    NSRegularExpression *test = [NSRegularExpression regularExpressionWithPattern:@"[^aeiouy]+" options:0 error:nil];
    [test enumerateMatchesInString:wordForCalc options:0 range:NSMakeRange(0, [wordForCalc length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        // your code to handle matches here
        
        NSRange matchRange = [match range];
        matchRange.length = matchRange.length+1;
        NSLog(@"matchRange.location: %d",matchRange.location);
        NSLog(@"matchRange.length: %d",matchRange.length);
        
        if(matchRange.location + matchRange.length <= wordForCalc.length)
        {
            NSString *brokenUp = [wordForCalc substringWithRange:NSMakeRange(matchRange.location, matchRange.length)]; 
            NSLog(@"%@", brokenUp);
            syllables = syllables + 1;
        }
        
    }];
    
    //[test matchesInString:word options:0 range:NSMakeRange(0, [word length])];
    
    for(int k = 0; k < subtractSyllables.count; k ++)
    {
        NSRegularExpression *expression = [subtractSyllables objectAtIndex:k];
        syllables = syllables - [expression numberOfMatchesInString:wordForCalc options:0 range:NSMakeRange(0, [wordForCalc length])];
    }
    
    for(int k = 0; k < addSyllables.count; k ++)
    {
        NSRegularExpression *expression = [addSyllables objectAtIndex:k];
        syllables = syllables + [expression numberOfMatchesInString:wordForCalc options:0 range:NSMakeRange(0, [wordForCalc length])];
    }
    
    for(int k = 0; k < uberExceptions.count; k ++)
    {
        NSString *uber = [uberExceptions objectAtIndex:k];
        if([uber isEqualToString:wordForCalc])
            syllables = syllables - 1;
    }
    
    
    if(syllables == 0)
        return [NSNumber numberWithInt: 1];
    else {
        return [NSNumber numberWithInt:syllables];;
    }

}

/*
 public function count($sentence){
 $total = 0;
 $words = explode(" ", $sentence);
 
 foreach($words as $word){
 if(count(trim($word)) > 0){
 $total += $this->countWord($word);
 }
 }
 return $total;
 }
 
 protected function countWord($word) {
 
 $subsyl = array(
 // ORIGINALLY ONLY 'are' appeared below 
 //'abe',
 //'ace',
 //'ade',
 //'age',
 //'ale',
 //'ate',
 //'are'
 );
 
 $addsyl = array(
  );
 
 // UBER EXCEPTIONS - WHOLE WORDS THAT SLIP THROUGH THE NET OR SOMEHOW THROW A WOBBLY
 $exceptions_one = array(
 @"abe",
 @"ace",
 @"ade",
 @"age",
 @"ale",
 @"are",
 @"use",
 @"ate"
 );
 
 // Based on Greg Fast's Perl module Lingua::EN::Syllables
 $word = preg_replace('/[^a-z]/is', '', strtolower($word));
 $word_parts = preg_split('/[^aeiouy]+/', $word);
 foreach ($word_parts as $key => $value) {
 if ($value <> '') {
 $valid_word_parts[] = $value;
 }
 }
 
 $syllables = 0;
 // Thanks to Joe Kovar for correcting a bug in the following lines
 foreach ($subsyl as $syl) {
 $syllables -= preg_match('~'.$syl.'~', $word);
 }
 foreach ($addsyl as $syl) {
 $syllables += preg_match('~'.$syl.'~', $word);
 }
 if(strlen($word) == 1) {
 //$syllables++;
 }
 // UBER EXCEPTIONS - WORDS THAT SLIP THROUGH THE NET
 if (in_array($word,$exceptions_one,true)){
 $syllables -= 1;
 }
 
 $syllables += count($valid_word_parts);
 $syllables = ($syllables == 0) ? 1 : $syllables;
 
 return $syllables;
 }*/



@end
