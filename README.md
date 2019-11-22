# Pale

[![Version](https://img.shields.io/cocoapods/v/pale.svg?style=flat)](https://cocoapods.org/pods/pale)
[![License](https://img.shields.io/cocoapods/l/pale.svg?style=flat)](https://cocoapods.org/pods/pale)
[![Platform](https://img.shields.io/cocoapods/p/pale.svg?style=flat)](https://cocoapods.org/pods/pale)

Pale is a small addition to Moya to be able to use addressable providers.

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Pale](#pale)
	- [Why Pale?](#why-pale)
		- [Ok, but I meant why 'Pale'?](#ok-but-i-meant-why-pale)
	- [Using Pale](#using-pale)
		- [Installation](#installation)
		- [Using addressable providers](#using-addressable-providers)
		- [Reactive extensions](#reactive-extensions)
	- [Developing Pale](#developing-pale)
		- [Bootstraping your environment](#bootstraping-your-environment)
		- [Updating your environment](#updating-your-environment)
		- [Installing dependencies](#installing-dependencies)
	- [Author](#author)
	- [License](#license)

<!-- /TOC -->

## Why Pale?

If you use development environments to test your iOS apps you will have probably come across
the need of dynamically pointing the app to other environments on demand, so your QA
department does not need you to provide different apps pointing to different environments.
If that's the case, and you are using [Moya](https://github.com/Moya/Moya) to implement
your network layer, this small addition is for you.

`Pale` introduces the concept of `AddressableMoyaProvider`, which inherits from `MoyaProvider`.
An `AddressableMoyaProvider` provides a writable `baseURL` property which you can modify
on runtime to point to different environments, so the requests made using your provider will
be routed to the proper environment.

### Ok, but I meant why 'Pale'?

An `AddressableMoyaProvider` can't point you in the right direction unless you provide it
with a proper `baseURL`, the same way the Pale Man can't properly act unless he is guided by
his palm embedded eyeballs.

![The Pale Man.](readme-files/paleman.gif)

So if you are using `Pale`,

> You're going to a very dangerous place, so be careful. The thing that slumbers there, it is not human.

You've been warned. 😜

## Using Pale

### Installation

`Pale` is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your `Podfile`:

```ruby
pod 'Pale'
```

### Using addressable providers

From now on we assume you are familiar with [Moya](https://github.com/Moya/Moya), at least regarding
its [basic usage](https://github.com/Moya/Moya/blob/master/docs/Examples/Basic.md). Let's implement
a subset of the service used in the `Moya` example using an addressable provider.

First of all, we create the usual enum with the targets of our API:

```swift
enum MyService {
	case zen
	case showUser(id: Int)
}
```

Then, instead of conforming to the `TargetType` protocol, we conform to our newly introduced
`RelativeTargetType` protocol. This protocol is basically the same as the Moya's `TargetType`
protocol except for the `baseURL` property:

```swift
extension MyService: RelativeTargetType {
    var path: String {
        switch self {
        case .zen:
            return "/zen"
        case .showUser(let id), .updateUser(let id, _, _):
            return "/users/\(id)"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        return .requestPlain
    }
    var sampleData: Data {
        switch self {
        case .zen:
            return "Half measures are as bad as nothing at all.".data(using: .utf8)!
        case .showUser(let id):
            return "{\"id\": \(id), \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".data(using: .utf8)!
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
```

Now, instead of creating a `MoyaProvider`, we create an `AddressableMoyaProvider` providing a base `URL`
which we will use for all the targets requested with this provider:

```swift
let provider = AddressableMoyaProvider<MyService>(baseURL: URL(string: "http://www.example.org")!)
provider.request(.zen) { result in
	// do something with the result
}

// Request will go to http://www.example.org/zen

provider.request(.showUser(id: 123))  { result in
	// do something with the result
}

// Request will go to http://www.example.org/users/123
```

If you now want to dynamically change the server you are connecting to, you just have to change the
`AddressableMoyaProvider`'s `baseURL` property:

```swift
provider.baseURL = URL(string: "http://test-server.example.org")!
provider.request(.zen) { result in
	// do something with the result
}

// Request will go to http://test-server.example.org/zen
```

### Reactive extensions

`Pale` also provides reactive extensions if you prefer to use [RxSwift](https://github.com/ReactiveX/RxSwift)
`Obseravble`s. In that case, make sure you include the following in your `Podfile`:

```ruby
pod 'Pale/RxSwift'
```

And then, you just invoke the reactive methods using `RelativeTarget`s instead of `Target`s:

```swift
provider.rx.request(.zen).subscribe(onNext: { response in
	// do something with the result
}, onError: { error in
	// do something with the error
})
```

## Developing Pale

Pale tries to create a reproducible development environment so we don't suffer from
the _compiles-in-my-machine_ syndrome. In order to achieve that this project uses the following tools
to ensure every developer works with the same setup (we assume you are working on a MacOS based machine):

* [Homebrew](https://brew.sh/) - Used to install some of the tools involved in this setup
* [rbenv](https://github.com/rbenv/rbenv) - Used to set the Ruby version used by the building tools
* [Bundler](http://bundler.io/) - Used to specify the version of the gems used to build the project

In addition to these tools, that are used to bootstrap the environment, we use the following tools
to manage the life cycle of the project:

* [Cocoapods](https://cocoapods.org/) - Dependency management
* [fastlane](https://fastlane.tools/) - Automation for CI/CD
* [slather](https://github.com/SlatherOrg/slather) - Generate code coverage reports
* [Jazzy](https://github.com/realm/jazzy) - Soulful docs for Swift & Objective-C

### Bootstraping your environment

In order to properly build and run the project you should follow the following steps to setup
the development environment (if you haven't done so for other projects).

* Make sure you have Xcode installed, and install the command line tools using the following command:

        $ xcode-select --install

* Install `Homebrew` executing the following command:

        $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

* Install and configure `rbenv`:

    * Execute the following commands to install `rbenv`:

            $ brew update
            $ brew install rbenv
            $ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

    * Restart your terminal, or run `source ~/.bash_profile` in order to activate `rbenv`

* Install `Ruby` using the following command:

        $ rbenv install 2.6.2

* Clone the project and `cd` to the directory where you have cloned it. __The following steps
must be run in the project directory so the gems are installed for the proper Ruby version__
* Install `Bundler`:

        $ gem install bundler

* Install the rest of the development tools:

        $ bundle install --path vendor/bundle --binstubs

And that's it! Now you have a standard and reproducible development environment and you can start
to work on Pale without your blood being drunk!

### Updating your environment

Any time we upgrade any tool in our toolchain you should re-run the previous commands, starting
with the suitable step:

* If we update our `Ruby` version, start from the `Ruby` environment installation
* If we update any version of the tools used to build the project (`Gemfile` changes), re-run
just the installation of the development tools.

In any case, `Bundler` won't let you go ahead if the `Ruby` version used to run the command
differs from the version configured in the project's `Gemfile`.


### Installing dependencies

The next step to start developing is to install the dependencies and generate
the Xcode workspace. Just run the following command:

    $ bin/fastlane pods

Make sure you open the generated `Example/Pale.xcworkspace`, not the project in
`Example/Pale.xcodeproj`.

## Author

José González, jose.gonzalez@openinput.com

## License

`Pale` is available under the MIT license. See the LICENSE file for more info.
