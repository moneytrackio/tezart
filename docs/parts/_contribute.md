## Contribute
There are many ways to contribute to this project.
You can : 
- add some example into the `example folder`,
- contribute to the source code, 
- submit bug reports or feature requests,
- ask questions about it on [r/Tezos](http://reddit.com/r/tezos/) or the [Tezos StackExchange](https://tezos.stackexchange.com/). 

[Pull Requests are welcome as well !](#feature-requests-and-bugs)  

### Project versionning

The versioning scheme we use is [SemVer](http://semver.org/). Given a version number MAJOR.MINOR.PATCH, increment the:

- **MAJOR** version when you make incompatible API changes,
- **MINOR** version when you add functionality in a backwards compatible manner, and
- **PATCH** version when you make backwards compatible bug fixes. 

Read [dart package versioning](https://dart.dev/tools/pub/versioning) to learn more.

### Setup your development environment

> *The following setup only works for Mac and Linux*

To ensure that you can contribute to this project, you will need to setup your environment :

#### A. Install prerequisites
You can follow the instructions in the prerequisites [section](#prerequisites)

#### B. Setup Lefthook

To install lefthook, just follow [this](https://github.com/Arkweid/lefthook/blob/master/docs/full_guide.md#installation) guide, then run :

```bash
lefthook install
```

#### C. Verify your setup 

To ensure that your environment is ready for contribution, please run the following command at the root of the project: 

```bash
./tezart doctor
```

You can add an alias like this `alias tezart='./tezart'` to avoid  calling the command line with `./`
 
Following is a sample of a correct setup :

<img src="img/a-sample-correct-setup.png?raw=true"></img>


### Edit this documentation

The following documentation is provided in `tezart/docs/` directory and you call the following command to serve it 
locally : 

```bash
./tezart docs
```

<img src="img/a-sample-tezart-docs.png?raw=true"></img>

### Utility functions

We provide some utility functions through `tezart` to help you in your development process. 

Following is the output usage : 

<img src="img/a-current-usage.png?raw=true"></img>

### Tests policy

- Integration tests for exposed classes: `TezartClient` `RpcInterface` `Keystore` `Signature`.
- Unit tests for private classes.
- Ensure code coverage is higher than 85%.

### Pull Request advice

- Ensure to have a correct output for `tezart doctor` in your development environment. 
- Update the `docs/README.md` if necessary with details of changes that you've made. This includes new API,
   useful command-line option, etc...
- You may merge the Pull Request in once you have the sign-off of two other developers, or if you 
   do not have permission to do that, you may request the second reviewer to merge it for you.
