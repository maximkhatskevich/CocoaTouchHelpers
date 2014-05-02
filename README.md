MyHelpers
===

Helper classes and categories for iOS SDK.

How to install via CocoaPods
---

pod 'CocoaTouchHelpers', :git => 'https://github.com/maximkhatskevich/CocoaTouchHelpers.git'

ExtMutableArray class
---

`ExtMutableArray` is a subclass of `NSMutableArray`, so it works completely like `NSMutableArray` plus it allows to track `selectedObjects` list - this is helpful for some kind of user selection tracking.

Public class interface is pretty much self-descriptive, but there are couple of important notes:

- `selection` read-only property of `NSArray` class returns array of "selected" objects that are in the array at the moment;
- use special methods to add/replace/remove objects to/at/from `selection`;
- only an object from the array can be added to `selection`;
- if you remove an object from `selection`, this object will NOT be removed from the array, you have to do it explicitly;
- if you remove an object from the array, this object WILL be removed from `selection` automatically, you do not need to do it manually/explicitly;
- there is read-only property `selectedObject` of `id` type that returns first object from `selection` list, so it is the same as call `selection.firstObject`.


> NOTE:
> `selectedObjects` list maintains only `weak` references to its entries.
