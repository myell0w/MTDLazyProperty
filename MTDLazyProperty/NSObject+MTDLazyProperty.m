#import "NSObject+MTDLazyProperty.h"
#import <objc/runtime.h>


@implementation NSObject (MTDLazyProperty)

// TODO: support primitives
+ (void)mtd_implementProperty:(NSString *)property withBlock:(mtd_property_block)block {
    const char *propertyUTF8 = [property UTF8String];
    objc_property_t propertyDescription = class_getProperty(self, propertyUTF8);
    const char *attributeDescriptionUTF8 = property_getAttributes(propertyDescription);
    NSString *attributeDescription = [NSString stringWithUTF8String:attributeDescriptionUTF8];
    // specific attributes of property to implement
    NSArray *attributes = [attributeDescription componentsSeparatedByString:@","];
    //const char *encoding = [[attributes[0] substringFromIndex:1] UTF8String];
    BOOL nonatomic = [attributes containsObject:@"N"];

    // block that lazily evaluates the value and stores the computed value as associated object
    const char *propertyKey = [[@"__MTD__" stringByAppendingString:property] UTF8String];
    id(^lazyBlock)(id) = ^(id _self) {
        // check if value is already computed
        id value = objc_getAssociatedObject(_self, propertyKey);

        // if not, compute it by calling the implementation block
        if (value == nil) {
            value = block(_self);

            // store computed value
            objc_AssociationPolicy policy = nonatomic ? OBJC_ASSOCIATION_RETAIN_NONATOMIC : OBJC_ASSOCIATION_RETAIN;
            objc_setAssociatedObject(_self, propertyKey, value, policy);
        }

        return value;
    };

    // implement lazy evaluating property getter
    IMP propertyImplementation = imp_implementationWithBlock(lazyBlock);
    NSAssert(class_addMethod(self, NSSelectorFromString(property), propertyImplementation, "@@:"),
             @"Could not implement property '%@' of class '%@' with the given block.", property, NSStringFromClass(self));
}

@end
