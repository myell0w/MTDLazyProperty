MTDLazyProperty
===============

Think of it as Eiffel's **once** keyword for Objective-C. This is more of a coding exercise than something you should really use though.

There‘s a common pattern I encounter when implementing readonly properties: I want to lazily evaluate a probably costly function once and cache the computed value, s.t. further calls to the property getter just return the cached value. Typically that would probably look like this:

```objective-c
@interface MyClass : MyAwesomeSuperclass

@property (nonatomic, readonly) NSString *lazyEvaluatedProperty;

@end

@implementation MyClass { 
	_lazyEvaluatedProperty;
}

- (NSString *)lazyEvaluatedProperty {
	if (_lazyEvaluatedProperty == nil) {
		_lazyEvaluatedProperty = SomeCostlyFunction();
	}
	
	return _lazyEvaluatedProperty;
}

@end
```


Now enter MTDLazyProperty, where everything is (sarcasm:on) much easier and so much more concise (sarcasm:off). It has Unit Tests too.

```objective-c
@interface MyClass : MyAwesomeSuperclass

@property (nonatomic, readonly) NSString *lazyEvaluatedProperty;

@end

@implementation MyClass 

@dynamic lazyEvaluatedProperty;

@end

..

[MyClass mtd_implementProperty:@"lazyEvaluatedProperty" withBlock:id^(id _self){
	return SomeCostlyFunction();
}];
```


Isn't it awesome? I know. Hit me up on Twitter ([@myell0w](https://twitter.com/myell0w)) if you know how to extend the example for primitive values.