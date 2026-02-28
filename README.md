# Summary

The Unity3D game engine has a file format with the `.unitypackage` extension
which is used to package and distribute assets for Unity Editor
across different projects.
For its intended purpose it works well; however,
Unity Editor itself requires a Unity Account, EULA
and an Internet connection to "phone home" at regular intervals.
These requirements apply even on the so-called "free" version.
Additionally, Unity Editor is a sizable installation
that takes considerable resources to run and has faced
controversial decisions over the years.
Namely, the unfortunate attempt to add a ["Runtime Fee"](https://youtu.be/LlPOn0nAOeo)
in 2023 created such a big backlash that Unity Technologies had to
reverse their decision.
Even so, the reputational damage was done 
and has made many veterans and would be Unity developers
weary of the Unity3D ecosystem ever since.

Due to the reasons explained above,
installing Unity Editor can be a big ask for someone
whose only goal is to access normal files stored inside a `.unitypackage` file
which is why this shell script was created;
`extractup.sh` is a GNU/Linux shell script extracts a `.unitypackage` file
and reconstructs its original folder hierarchy
without requiring any Unity Technologies software installed on the system.

## Dependencies

You should use a GNU/Linux machine to run this script when possible, 
but other POSIX compliant environments might also work.

On a terminal run the following to make sure scripts dependencies are installed

```shell
which find realpath tar > /dev/null
```

The command will exit without printing anything
if all dependencies are satisfied.
If this is not the case, refer to your distribution documentation
to determine what packages to install.

The `realpath` command needs to accept the parameter `--relative-to=`. 
You can check if your systems version of `realpath` supports this parameter
with the following shell command

```shell
if realpath --relative-to=. . >/dev/null; then echo "Parameter --relative-to= is supported"; else echo "Parameter --relative-to= is not supported"; fi
```

## Usage

```sh
./extractup.sh file.unitypackage [path]
```

1. `file.unitypackage` is required, this is the unitypackage file to extract from
2. `path` is optional, this is where the contents of unitypackage will extract to
   - If omitted, the script uses the input filename without its extension similar to most zip extractors
   - If the path does not yet exist, it will be created
   - In the extracted directory there will be two folders
     1. `guid`: The untouched extracted files exactly how they are stored in the `.unitypackage` file
     2. `tree`: The reconstructed file hierarchy with relative symbolic links back into the `guid` folder