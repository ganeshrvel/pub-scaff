### Introduction

##### Scaffold Generator for Dart and Flutter.

**scaff** is a simple command-line utility for generating Dart and Flutter components from template files.
It is a very tedious job to keep replicating the boilerplate codes every time you try to add a new component in your app. Using scaff, you can generate dart or flutter components from the custom-defined templates. You can even include template variables in the component files and directories name for easy and flexible scaffolding.

**scaff** uses 'Mustache templating library' variable schemes for defining and processing the template files.


## Installation/Upgrade

```shell
$ pub global activate scaff
```

## Usage
```shell
$ pub global run scaff
```

## Example
Let us create a simple component. First of all, we need to create a working directory and it should contain a scaff.setup.json file. The scaff.setup.json file should contain all the template variables used in the working directory.
The component subdirectories and files should be included inside the working directory. 
The files and directories name may contain template variables as well.

Template variable examples: {{var1}}, {{className}}Base, {{fileName}}_store

The example template directory structure:
```
component_templates
│   └── general_store_architecture
│       ├── scaff.setup.json
│       └── {{componentName}}
│           ├── {{componentName}}.dart
│           └── {{componentName}}_store.dart
```

1) Create a new directory in the project root

```shell
$ mkdir -p component_templates/general_store_architecture
$ cd component_templates/general_store_architecture
```

2) Create the component directory

```shell
$ mkdir {{componentName}}
$ cd {{componentName}}
```

3) Create the component template file

```shell
$ touch {{componentName}}.dart
```

4) Add the code to {{componentName}}.dart file

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
$ touch {{componentName}}_store.dart
```

6) Add the code to {{componentName}}_store.dart file

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
  "variables": [
	"componentName",
	"className"
  ],
  "mappedVariables": {
	"componentName": "login",
	"className": "LoginScreen"
  }
}
```

- `variables` holds a list of template variables. The CLI will prompt for the user input.
- `mappedVariables` holds the values for the template variables. The generator will pick values from the `mappedVariables` automatically, if required.
- You may use either of the one or in combination. CLI will skip the prompt if the value for a template variable is already available inside the `mappedVariables`.

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
Enter source directory (/path/component_templates/general_store_architecture) »
Enter destination directory (/path/component_templates/general_store_architecture/__component__) »
Enter template extension (dart) » 
Enter 'componentName' variable value » login
Enter 'className' variable value » Login
```

12) The destination directory will have the newly generated component.
The destination directory structure:

```
└── login
    ├── login.dart
    └── login_store.dart
```

### Buy me a coffee
Help me keep the app FREE and open for all.
Paypal me: [paypal.me/ganeshrvel](https://paypal.me/ganeshrvel "paypal.me/ganeshrvel")

### Contacts
Please feel free to contact me at ganeshrvel@outlook.com

### About

- Author: [Ganesh Rathinavel](https://www.linkedin.com/in/ganeshrvel "Ganesh Rathinavel")
- License: [MIT](https://github.com/ganeshrvel/openmtp/blob/master/LICENSE "MIT")
- Package URL: [https://pub.dev/packages/scaff](https://pub.dev/packages/scaff "https://pub.dev/packages/scaff")
- Repo URL: [https://github.com/ganeshrvel/pub-scaff](https://github.com/ganeshrvel/pub-scaff/ "https://github.com/ganeshrvel/pub-scaff")
- Contacts: ganeshrvel@outlook.com

### License
scaff | Scaffold Generator for Dart and Flutter. [MIT License](https://github.com/ganeshrvel/pub-scaff/blob/master/LICENSE "MIT License").

Copyright © 2018-Present Ganesh Rathinavel
