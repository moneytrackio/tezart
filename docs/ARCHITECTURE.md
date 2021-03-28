## Technical Architecture of the project

### Tezart is a Dart package

One of the most important choices made while creating this project , was to provide **tezart** as **dart** [library package](https://dart.dev/tools/pub/glossary#library-package). That means **Tezart** is a pakcage that other packages or applications can depend on. 
To clarify the purpose, you need to use **tezart** in a Flutter application or dart application which are an entrypoint ( usually with a `.dart` file that contains `main()` )

### Implementation choices 

The project follows the convention to have all the implementation code placed under `lib/src`. 

We have create an organization under `lib/src` according to the features provided by this package :  

    ├── lib
    │   ├── src
    │   │   ├── common
    │   │   ├── feature-1
    │   │   ├── feature-2
    │   │   ├── ...
    │   │   ├── feature-n


The code under `lib/src` is considered **private**; To make any APIs provided under `lib/src` **public**, you must export them from the `tezart.dart` file that's directly under `lib/` 


### Tezart as mini librairies

One of the best practices while building a dart package is to break the package into small and individual librairies. Therefore, **Tezart** will be easy to maintain, extend and test. 

So, according to our organization under `lib/src` , each feature is in its own mini library. **This one is very important for the project architecture ! We are trying to avoid tighly coupled between features**

    ├── lib
    │   ├── src
    │   │   ├── common
    │   │   ├── feature-1 ( one mini-library )
    │   │   ├── feature-2 ( another mini-library )
    │   │   ├── ...
    │   │   ├── feature-n ( yet another mini-library )

To make any feature or API public, the `tezart.dart` file directly under `lib/` must export it : 

```dart
export 'src/file_feature_1.dart'
export 'src/file_feature_2.dart'
...
export 'src/file_feature_n.dart'
```
