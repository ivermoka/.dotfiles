
# Table of Contents

  1.  [Setup](#org7a2708f)
      1.  [Check Lua Compatibility](#org0e142f3)
      2.  [Fork the repo and install Lain as a user](#org6359bfc)
      3.  [Set the path in Awesome](#org49f3073)
  2.  [Build-and-Test Dev cycle](#org3855b9d)
      1.  [Adding a new widget](#orgda535fb)
      2.  [Testing the widget](#org5beb0e0)
  3.  [Merging your changes](#org594a7f0)
      1.  [Make a Pull Request](#org86829a7)
      2.  [Document your Widget](#orge329779)



<a id="orgf52da43"></a>

# Contributing to Lain

This small guide takes you through the setup, development, and merging process required to add a widget to lain.

<a id="org7a2708f"></a>

## Setup


<a id="org0e142f3"></a>

### Check Lua Compatibility

First ensure that your AwesomeWM Lua version and that your Luarocks
Lua version have the same major version.

You can verify this easily via:

-   `luarocks config lua_version`
-   `awesome --version`

If, for example, your Luarocks version is 5.4 and your Awesome version
is 5.3, then it likely means that you installed Awesome through your
system package manager.

If this is the case, then follow the [Installing current git master as
a package receipts](https://github.com/awesomeWM/awesome?tab=readme-ov-file#installing-current-git-master-as-a-package-receipts) guide on the [awesomeWM/awesome](https://github.com/awesomeWM/awesome) repository to build
an up-to-date version of Awesome.

If your Luarocks version is smaller, then update Luarocks first and repeat the above.


<a id="org6359bfc"></a>

### Fork the Repository and install Lain as a user

Fork the repo under your own account and then clone it locally

```bash
git clone git@github.com:<yourusername>/lain
cd lain
luarocks make --local --force
```

The make command will build and compile the lain library in the local
directory and then install it to your user Luarocks library (`--local`),
overwriting any previous lain library there (`--force`).

At this point, there should be only one "lain" package on your system.
You can check by running

```bash
luarocks list
```

This should show that there is only one lain installed on the system,
and it resolves to `/home/<your-account>/.luarocks/lib/luarocks/rocks-<version>`

If not, remove any other mentions of lain, either through luarocks, or
if you have to, by deleting the package directories forcefully.


<a id="org49f3073"></a>

### Set the path in Awesome

At this point, Luarocks might know where your packages are, but Awesome might not.

To explicitly tell it where to look for your newly built lain library,
add the following to the top of your `awesome/rc.lua`

```lua
-- we assume that your Lua is version 5.4
package.path = package.path .. ';/home/<your-account>/.luarocks/share/lua/5.4/?/init.lua'
local lain = require("lain")
```

The "?" should automatically resolve to the "lain" package when invoked.


<a id="org3855b9d"></a>

## Build-and-Test Dev cycle

Once the above setup is complete, you should be able to restart your
awesomeWM and see no change (because we haven't modified lain yet).


<a id="orgda535fb"></a>

### Adding a new widget

First, read the [widget usage wiki](https://github.com/lcpz/lain/wiki/Widgets#usage) page. Then, note that for every new
widget you add in the `widget/contrib` directory, you need to add a
corresponding entry in the rockspec.

#### Example

- If I make a new widget file `widget/contrib/klingon.lua`
- Then I need to add the following entry to build modules section in `lain-scm-1.rockspec`

  ```lua     
  build = {
     type = "builtin",
     modules = {
        ...
        ...
        ["lain.widget.contrib.klingon"] = "widget/contrib/klingon.lua",
        ...
        ...
     }
  }
  ```

<a id="org5beb0e0"></a>

### Testing the widget

AwesomeWM reads from the installed Luarocks directory that we set in the above `package.path`, not from the
source dev directory itself, so for every code change you need to run

```bash
luarocks make --local --force  
```

and then reload your AwesomeWM config.


<a id="org594a7f0"></a>

## Merging your changes


<a id="org86829a7"></a>

### Make a Pull Request

Once you've committed your code to git and pushed to your fork, you
need to make PR against <https://github.com/lcpz/lain>, with a
description of what your widget does.


<a id="orge329779"></a>

### Document your Widget

You should also add a page to the [lain Wiki](https://github.com/lcpz/lain/wiki/), which you can do on Github itself. Ideally, you need to:

-   Add a page about your widget: the title should just be the lowercase name of your widget (no spaces)
-   Modify [the contrib page](https://github.com/lcpz/lain/wiki/Widgets#users-contributed), and add a link to your widget page there.

