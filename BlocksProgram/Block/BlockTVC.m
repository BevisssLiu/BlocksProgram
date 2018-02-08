//
//  BlockTVC.m
//  BlocksProgram
//
//  Created by bevis on 09/01/2018.
//  Copyright © 2018 bevis. All rights reserved.
//

#import "BlockTVC.h"
#define LOG_SEE_ANNOTATION_WITHIN_CODES NSLog(@"Please see the codes in function: %s",__FUNCTION__)

typedef float (^MyBlockType)(float, float);

@interface BlockTVC ()
@property (nonatomic, copy) NSString * string1;

@end

@implementation BlockTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.string1 = @"string one";
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:
                           @"1. find the matched method with same cell title\n2. read annotation and codes\n3. press the cell and see the result on console"
                                                    delegate:nil cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)Declaring_and_Using_a_Block{
    /**
     You use the ^ operator to declare a block variable and to indicate the beginning of a block literal. The body of the block itself is contained within {}, as shown in this example (as usual with C, ; indicates the end of the statement):
     */
    int multiplier = 7;
    int (^myBlock)(int) = ^(int num) {
        return num * multiplier;
    };
    //If you declare a block as a variable, you can then use it just as you would a function:
    printf("%d\n", myBlock(3));
    // prints "21"
}
- (void)Using_a_Block_Directly{
    /**
     In many cases, you don’t need to declare block variables; instead you simply write a block literal inline where it’s required as an argument. The following example uses the qsort_b function. qsort_b is similar to the standard qsort_r function, but takes a block as its final argument.
     */
    
    char *myCharacters[3] = { "TomJohn", "George", "Charles Condomine" };
    qsort_b(myCharacters, 3, sizeof(char *), ^(const void *l, const void *r) {
        char *left = *(char **)l;
        char *right = *(char **)r;
        return strncmp(left, right, 1);
    });
    
    printf("%s %s %s", myCharacters[0],myCharacters[1],myCharacters[2]);
    // myCharacters is now { "Charles Condomine", "George", "TomJohn" }
}

- (void)Blocks_with_Cocoa{
    
    /**
     Several methods in the Cocoa frameworks take a block as an argument, typically either to perform an operation on a collection of objects, or to use as a callback after an operation has finished. The following example shows how to use a block with the NSArray method sortedArrayUsingComparator:. The method takes a single argument—the block. For illustration, in this case the block is defined as an NSComparator local variable:
     */
    NSArray *stringsArray = @[ @"string 1",
                               @"String 21",
                               @"string 12",
                               @"String 11",
                               @"String 02" ];
    
    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch |
    NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    NSLocale *currentLocale = [NSLocale currentLocale];
    
    NSComparator finderSortBlock = ^(id string1, id string2) {
        
        NSRange string1Range = NSMakeRange(0, [string1 length]);
        return [string1 compare:string2 options:comparisonOptions range:string1Range locale:currentLocale];
    };
    
    NSArray *finderSortArray = [stringsArray sortedArrayUsingComparator:finderSortBlock];
    NSLog(@"finderSortArray: %@", finderSortArray);
    
    /*
     Output:
     finderSortArray: (
     "string 1",
     "String 02",
     "String 11",
     "string 12",
     "String 21"
     )
     */
    
    //use as a callback after an operation, like this:
    [UIView animateWithDuration:10 animations:^{
        //your animations
    } completion:^(BOOL finished) {
        //you can do sth after animations
    }];
}

- (void)__block_Variables{
    /**
     A powerful feature of blocks is that they can modify variables in the same lexical scope. You signal that a block can modify a variable using the __block storage type modifier. Adapting the example shown in Blocks with Cocoa, you could use a block variable to count how many strings are compared as equal as shown in the following example. For illustration, in this case the block is used directly and uses currentLocale as a read-only variable within the block:
     */
    NSArray *stringsArray = @[ @"string 1",
                               @"String 21", // <-
                               @"string 12",
                               @"String 11",
                               @"Strîng 21", // <-
                               @"Striñg 21", // <-
                               @"String 02" ];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    __block NSUInteger orderedSameCount = 0;
    
    NSArray *diacriticInsensitiveSortArray = [stringsArray sortedArrayUsingComparator:^(id string1, id string2) {
        
        NSRange string1Range = NSMakeRange(0, [string1 length]);
        NSComparisonResult comparisonResult = [string1 compare:string2 options:NSDiacriticInsensitiveSearch range:string1Range locale:currentLocale];
        
        if (comparisonResult == NSOrderedSame) {
            orderedSameCount++;
        }
        return comparisonResult;
    }];
    
    NSLog(@"diacriticInsensitiveSortArray: %@", diacriticInsensitiveSortArray);
    NSLog(@"orderedSameCount: %lu", (unsigned long)orderedSameCount);
    
    /*
     Output:
     
     diacriticInsensitiveSortArray: (
     "String 02",
     "string 1",
     "String 11",
     "string 12",
     "String 21",
     "Str\U00eeng 21",
     "Stri\U00f1g 21"
     )
     orderedSameCount: 2
     */
}

int GlobalInt = 999999;
int (^getGlobalInt)(void) = ^{ return GlobalInt; };

- (void)Declaring_and_Creating_a_Block_Reference{
    //The following are all valid block variable declarations:
    void (^blockReturningVoidWithVoidArgument)(void);
    int (^blockReturningIntWithIntAndCharArguments)(int, char);
    void (^arrayOfTenBlocksReturningVoidWithIntArgument[10])(int);
    
    MyBlockType myFirstBlock = ^(float a, float b){
        //deal with your things
        return a+b; //return float type
    };
    MyBlockType mySecondBlock = ^(float a, float b ){
        // your things
        return (float)0.0001;
    };
    
    //At a file level, you can use a block as a global literal:
    printf("%d\n",getGlobalInt());
    
    
    // an array of ten blocks
    for (int i = 0 ; i<10; i++) {
        arrayOfTenBlocksReturningVoidWithIntArgument[i] = ^(int x){
            NSLog(@"defined block[%d]",x);
        };
    }
    arrayOfTenBlocksReturningVoidWithIntArgument[9](1); //use the last block
}



/**
 __block variables live in storage that is shared between the lexical scope of the variable and all blocks and block copies declared or created within the variable’s lexical scope. Thus, the storage will survive the destruction of the stack frame if any copies of the blocks declared within the frame survive beyond the end of the frame (for example, by being enqueued somewhere for later execution). Multiple blocks in a given lexical scope can simultaneously use a shared variable.
 
 As an optimization, block storage starts out on the stack—just like blocks themselves do. If the block is copied using Block_copy (or in Objective-C when the block is sent a copy), variables are copied to the heap. Thus, the address of a __block variable can change over time.
 */
- (void)a__block_variable{
    
    //
    __block int x = 123; //  x lives in block storage
    printf("1. x address %p\n",(void*)&x); //0x7fff5eef4e38
    
    void (^printXAndY)(int) = ^(int y) {
        
        printf("2. x address %p\n",&x); //0x608000220498 address changed
        x = x + y;
        printf("%d %d\n", x, y);
        printf("3. x address %p\n",&x); //0x608000220498
        
    };
    printXAndY(456); // prints: 579 456
    printf("4. x address %p\n",(void*)&x); //0x608000220498 same as which in block
    printf("%d",x);
    // x is now 579
    
    
}

extern NSInteger CounterGlobal = 5;
static NSInteger CounterStatic = 55;

- (void)interact_with_several_types_of_variables{
    NSInteger localCounter = 42;
    __block char localCharacter = 'c';
    
    printf("1. localCounter %ld address %p      localCharacter  %c address %p \n",localCounter,&localCounter,localCharacter,&localCharacter);
    void (^aBlock)(void) = ^(void) {
        printf("4. localCounter %ld address %p      localCharacter  %c address %p \n",localCounter,&localCounter,localCharacter,&localCharacter);
        ++CounterGlobal;
        ++CounterStatic;
        CounterGlobal = localCounter; // localCounter fixed at block creation 42
        localCharacter = 'a'; // sets localCharacter in enclosing scope
        printf("5. localCounter %ld address %p      localCharacter  %c address %p \n",localCounter,&localCounter,localCharacter,&localCharacter);
    };
    
    printf("2. localCounter %ld address %p      localCharacter  %c address %p \n",localCounter,&localCounter,localCharacter,&localCharacter);
    ++localCounter; // unseen by the block  43
    localCharacter = 'b';
    printf("3. localCounter %ld address %p      localCharacter  %c address %p \n",localCounter,&localCounter,localCharacter,&localCharacter);
    aBlock(); // execute the block
    printf("6. localCounter %ld address %p      localCharacter  %c address %p \n",localCounter,&localCounter,localCharacter,&localCharacter); // localCharacter now 'a'
    
    
    
    
    
    //With Objects
    NSString * string = @"one";
    __block NSNumber * number = @10;
    
    NSLog(@"1. string: %@ %p     number: %@ %p",string,&string,number,&number);
    void (^bBlock)(void) = ^(void){
        NSLog(@"4. string: %@ %p     number: %@ %p",string,&string,number,&number);
//        string = @"two";
        number = @30;
        NSLog(@"5. string: %@ %p     number: %@ %p",string,&string,number,&number);
    };
    NSLog(@"2. string: %@ %p     number: %@ %p",string,&string,number,&number);
    string = @"two";
    number = @20; //unseen by the bBlock
    NSLog(@"3. string: %@ %p     number: %@ %p",string,&string,number,&number);
    bBlock();
    NSLog(@"6. string: %@ %p     number: %@ %p",string,&string,number,&number); //string: two      number: 30
}

- (void)Object_and_Block_Variables{
    /**
     When a block is copied, it creates strong references to object variables used within the block. If you use a block within the implementation of a method:
     If you access an instance variable by reference, a strong reference is made to self;
     If you access an instance variable by value, a strong reference is made to the variable.
     */
    dispatch_queue_t  queue = dispatch_queue_create("blocks_test", 0);
    dispatch_async(queue, ^{
        // instanceVariable is used by reference, a strong reference is made to self
//        doSomethingWithObject(instanceVariable);
    });
    
    
    id localVariable = _string1;
    dispatch_async(queue, ^{
        /*
         localVariable is used by value, a strong reference is made to localVariable
         (and not to self).
         */
//        doSomethingWithObject(localVariable);
    });
    LOG_SEE_ANNOTATION_WITHIN_CODES;
    
}

- (void)Invoking_a_Block{
    //If you declare a block as a variable, you can use it as you would a function, as shown in these two examples:
    int (^oneFrom)(int) = ^(int anInt) {
        return anInt - 1;
    };
    
    printf("1 from 10 is %d", oneFrom(10));
    // Prints "1 from 10 is 9"
    
    float (^distanceTraveled)(float, float, float) =
    ^(float startingSpeed, float acceleration, float time) {
        
        float distance = (startingSpeed * time) + (0.5 * acceleration * time * time);
        return distance;
    };
    
    float howFar = distanceTraveled(0.0, 9.8, 1.0);
    // howFar = 4.9
    
    NSLog(@"Acutally, we've already done this many times, I guess this example wouldn't attract you!");
}
- (void)Using_a_Block_as_a_Function_Argument{
    char *myCharacters[3] = { "TomJohn", "George", "Charles Condomine" };
    
    qsort_b(myCharacters, 3, sizeof(char *), ^(const void *l, const void *r) {
        char *left = *(char **)l;
        char *right = *(char **)r;
        return strncmp(left, right, 1);
    });
    // Block implementation ends at "}"
    // myCharacters is now { "Charles Condomine", "George", "TomJohn" }
    
    
    size_t count = 100;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(count, queue, ^(size_t i) {
        sleep(random()%4);
        printf("%zu\n", i);
    });
}
- (void)Using_a_Block_as_a_Method_Argument{
    NSArray *array = @[@"A", @"B", @"Z", @"A",@"A", @"B", @"Z", @"A",@"G", @"are", @"Q"];
    NSSet *filterSet = [NSSet setWithObjects: @"A", @"Z", @"Q", nil];
    BOOL (^test)(id obj, NSUInteger idx, BOOL *stop);
    
    test = ^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (idx < 5) {
            if ([filterSet containsObject: obj]) {
                return YES;
            }
        }
        return NO;
    };
    
    NSIndexSet *indexes = [array indexesOfObjectsPassingTest:test];
    NSLog(@"indexes: %@", indexes);
    
}
- (void)Copying_Blocks{
    
    /**
     Typically, you shouldn’t need to copy (or retain) a block. You only need to make a copy when you expect the block to be used after destruction of the scope within which it was declared. Copying moves a block to the heap.
     
     You can copy and release blocks using C functions:
     
     Block_copy();
     Block_release();
     To avoid a memory leak, you must always balance a Block_copy() with Block_release().
     
     */
    LOG_SEE_ANNOTATION_WITHIN_CODES;
}


void dontDoThis() {
    void (^blockArray[3])(void);  // an array of 3 block references
    
    for (int i = 0; i < 3; ++i) {
        blockArray[i] = ^{ printf("hello, %d\n", i); };
        // WRONG: The block literal scope is the "for" loop.
    }
}
void dontDoThisEither() {
    void (^block)(void);
    
    int i = random();
    if (i > 1000) {
        block = ^{ printf("got i at: %d\n", i); };
        // WRONG: The block literal scope is the "then" clause.
    }
    // ...
}

- (void)Patterns_to_Avoid{
    /**
     A block literal (that is, ^{ ... }) is the address of a stack-local data structure that represents the block. The scope of the stack-local data structure is therefore the enclosing compound statement, so you should avoid the patterns shown in the following examples:
     */
    dontDoThis();
    dontDoThisEither();
    LOG_SEE_ANNOTATION_WITHIN_CODES;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{ //Getting Started with Blocks
            switch (indexPath.row) {
                case 0:[self Declaring_and_Using_a_Block];break;
                case 1:[self Using_a_Block_Directly];break;
                case 2:[self Blocks_with_Cocoa];break;
                case 3:[self __block_Variables];break;
            }
        }break;
        case 1:{ //Declaring and Creating Blocks
            switch (indexPath.row) {
                case 0:[self Declaring_and_Creating_a_Block_Reference];break;
            }
        }break;
        case 2:{ //Blocks and Variables
            switch (indexPath.row) {
                case 0:[self a__block_variable];break;
                case 1:[self interact_with_several_types_of_variables];break;
                case 2:[self Object_and_Block_Variables];break;
            }
        }break;
        case 3:{ //Using Blocks
            switch (indexPath.row) {
                case 0:[self Invoking_a_Block];break;
                case 1:[self Using_a_Block_as_a_Function_Argument];break;
                case 2:[self Using_a_Block_as_a_Method_Argument];break;
                case 3:[self Copying_Blocks];break;
                case 4:[self Patterns_to_Avoid];break;
            }
        }break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor darkGrayColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.textLabel.font = [UIFont italicSystemFontOfSize:21];
    
}

@end
