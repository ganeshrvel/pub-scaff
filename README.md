# pub-scaff

- Author: [Ganesh Rathinavel](https://www.linkedin.com/in/ganeshrvel "Ganesh Rathinavel")
- License: [MIT](https://github.com/ganeshrvel/openmtp/blob/master/LICENSE "MIT")
- Package URL: [https://pub.dev/packages/scaff](https://pub.dev/packages/scaff "https://pub.dev/packages/scaff")
- Repo URL: [https://github.com/ganeshrvel/pub-scaff](https://github.com/ganeshrvel/pub-scaff/ "https://github.com/ganeshrvel/pub-scaff")
- Contacts: ganeshrvel@outlook.com


### Introduction

##### Scaffold Generator for Dart and Flutter.

**scaff** is a simple command-line utility for generating Dart and Flutter components from template files.
It is a very tedious job to keep replicating the boilerplate codes every time you try to add a new component in your app. Using scaff, you can generate dart or flutter components from the custom-defined templates. You can even add template schemes to the component directories and files for easy and flexible scaffolding.

**scaff** uses 'Mustache templating library' for defining and processing the template files.


## Installation

```shell
$ pub global activate scaff
```

## Usage Example
Let us create a simple component. First of all, we need to create a working directory and it should contain a scaff.setup.json file. The scaff.setup.json file should contain all the template variables used in that working directory.
Add the other subdirectories and template files into the working directory. 

All template files should have a .tpl extension. The files and directories name may contain template variables as well.

Template variable examples: {{var1}}, {{className}}Base, {{fileName}}_store

The example template directory structure:
```
component_templates
│   └── general_store_architecture
│       ├── scaff.setup.json
│       └── {{componentName}}
│           ├── {{componentName}}.tpl
│           └── {{componentName}}_store.tpl
```

1) Create a new directory in the project root

```shell
$ mkdir -p component_templates
$ cd component_templates/general_store_architecture
```

2) Create the component directory

```shell
$ mkdir {{componentName}}
$ cd {{componentName}}
```

3) Create the component template file

```shell
$ touch {{componentName}}.tpl
```

4) Add the code to {{componentName}}.tpl file

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mobx/{{componentName}}_store.dart';

class {{className}}Screen extends StatelessWidget {
  {{className}}Screen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final {{componentName}} = Provider.of<{{className}}Store>(context);

    return Scaffold(
      body: Center(
        child: Column(),
      ),
    );
  }
}
```

5) Create the store template file

```shell
$ touch {{componentName}}_store.tpl
```

6) Add the code to {{componentName}}_store.tpl file

```dart
import 'package:mobx/mobx.dart';

abstract class {{className}}StoreBase with Store {
  @observable
  bool dummyValue = false;
}
```

7) Create the *scaff.setup.json* file

```shell
$ cd ..
$ touch scaff.setup.json
```

8) Add all the template variables used in the working directory to scaff.setup.json file as

```json
{
	"variables": ["componentName", "className"]
}
```

9) cd into general_store_architecture folder.

```shell
$ pwd # it should be pointing to =>  /path/component_templates/general_store_architecture
```

10) Run scaff globally

```shell
$ pub global run scaff
```

11) You will be prompted to:
```shell
- Enter source directory (/path/component_templates/general_store_architecture) »
- Enter destination directory (/path/component_templates/general_store_architecture/__component__) »
- Enter 'componentName' variable value » login
- Enter 'className' variable value » Login
```

12) Navigate to the destination directory will have the newly generated component.

## Building from Source

Requirements: [Dart](https://dart.dev/get-dart "Install Dart") and [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git "Install Git")

### Clone
```shell
$ git clone --depth 1 --single-branch --branch master https://github.com/ganeshrvel/pub-scaff.git

$ cd pub-scaff
```

### Contribute
- Fork the repo and create your branch from master.
- Ensure that the changes pass linting.
- Update the documentation if needed.
- Make sure your code lints.
- Issue a pull request!

When you submit code changes, your submissions are understood to be under the same [MIT License](https://github.com/ganeshrvel/pub-scaff/blob/master/LICENSE "MIT License") that covers the project. Feel free to contact the maintainers if that's a concern.


### Buy me a coffee
Help me keep the app FREE and open for all.
Paypal me: [paypal.me/ganeshrvel](https://paypal.me/ganeshrvel "paypal.me/ganeshrvel")

### Contacts
Please feel free to contact me at ganeshrvel@outlook.com

### More repos
- [Electron React Redux Advanced Boilerplate](https://github.com/ganeshrvel/electron-react-redux-advanced-boilerplate "Electron React Redux Advanced Boilerplate")
- [OpenMTP  - Advanced Android File Transfer Application for macOS](https://github.com/ganeshrvel/openmtp "OpenMTP  - Advanced Android File Transfer Application for macOS")
- [Tutorial Series by Ganesh Rathinavel](https://github.com/ganeshrvel/tutorial-series-ganesh-rathinavel "Tutorial Series by Ganesh Rathinavel")

### License
scaff | Scaffold Generator for Dart and Flutter. [MIT License](https://github.com/ganeshrvel/pub-scaff/blob/master/LICENSE "MIT License").

Copyright © 2018-Present Ganesh Rathinavel
