## Directory: BibleVox/Engine

# Forward:

The BibleVox project uses the Carnegie Mellon University (CMU) Festival speech engine. Festival 2.4 is the latest version released by CMU as of this writing. A Festival 2.4 binary (i.e. executable) package is available (as of this writing) from the Ubuntu software repository. The Ubuntu Festival executable package should be installed and used if not pursuing Festival speech engine development or if other reasons do not necessitate obtaining Festival source code. If only the Ubuntu executable package will be installed, skip forward to the "Specific: ./install_festival_voices.bash" section of this document. Otherwise, continue with what follows.

Before proceeding, insure that the Ubuntu "build-essential" and "libncurses5-dev" packages are installed:

1. Run: "*sudo apt-get install build-essential*"

2. Run: "*sudo apt-get install libncurses5-dev*"

Please read this entire document before performing any operations.

# General:
This directory provides BASH scripts that automate the downloading, unpacking and building of the CMU Festival 2.4 speech engine source code on an Ubuntu 16.04 LTS platform. Your mileage may vary if using these scripts elsewhere. You can click on the links below to view the BASH source code to see what operations will take place or if you would rather manually perform these operations or need to modify them for your particular target platform.

## Dnload scripts:

These scripts may be manually executed only when the "BibleVox/Engine/packed" directory already exists. They are run with "user" privileges (i.e. not as "root").

[*./dnload_festival_code.bash*](./dnload_festival_code.bash) (2.1MB download)

[*./dnload_festival_voices.bash*](./dnload_festival_voices.bash) (576MB download)

[*./dnload_ubuntu_mods.bash*](./dnload_ubuntu_mods.bash) (97.2kB download)

## Unpack scripts:
These scripts may be manually executed only when the "BibleVox/Engine/build" directory already exists. They are run with "user" privileges (i.e. not as "root").

[*./unpack_festival_code.bash*](./unpack_festival_code.bash) (11.1MB unpacked)

[*./unpack_festival_voices.bash*](./unpack_festival_voices.bash) (786MB unpacked)

[*./unpack_ubuntu_mods.bash*](./unpack_ubuntu_mods.bash) (504kB unpacked)

## Top level scripts:

The "Specific" section of this document discusses these scripts.

[*./build_festival.bash*](./build_festival.bash) (878MB total build, 578MB total download)

[*./install_festival_voices.bash*](./install_festival_voices.bash) (786MB copied)

[*./run_festival_tests.bash*](./run_festival_tests.bash) (2.3MB waves created)

# Specific:

## ./build_festival.bash:

In order to spare yourself the gory details, you can simply execute the *"./build_festival.bash"* script with "user" privileges (i.e. do not run with "root" privileges). This script will create the necessary directories within the "BibleVox/Engine" software tree and download, unpack and compile the Festival software as well as run some verification tests. You can safely ignore any compiler "warning" messages. Compiler "error" messages, however, should not occur and do need to be investigated and corrected. You will get a couple of "INCORRECT" messages during the verification tests. These can be safely ignored as well. It appears that these are bugs or intentional failures within the test results verifications and are not actual errors (go figure). However, every test should not fail. That would indicate an actual problem. This script will not apply the "Ubuntu mods". They are downloaded and made available should you care to refer to or implement them (I do not use them in BibleVox development work).

The downloaded and compiled software remains within the "BibleVox/Engine" software tree for development projects and will not be installed over the Festival binary package that is available from the Ubuntu software repository. There is nothing wrong with the Ubuntu Festival binary package and should be used instead where speech engine development work is not being pursued. Note that subsequent builds (i.e. recompiles) are supported without having again to download the software. The existence of the "packed" directory is used as a flag to the *"./build_festival.bash"* script so as to not again download the software.

## ./install_festival_voices.bash:

If you do run the *"./build_festival.bash"* script, the high quality Festival voices are downloaded and installed into the "BibleVox/Engine" software tree. However, they will not be installed into the Festival binary software tree that was created by installing Festival from the Ubuntu software repository. The *"./install_festival_voices.bash"* script will accomplish this when run with "root" privileges (i.e. it will not succeed if run with only "user" privileges).

If you do not run the *"./build_festival.bash"* script (e.g. because you are using the Ubuntu Festival executable package), but do wish to install the high quality Festival voices into the Festival binary software tree, then do the following:

1. Manually create a directory named "packed" under the "BibleVox/Engine" software tree.

2. Execute the *"./dnload_festival_voices.bash"* script with "user" privileges (i.e. do not run as "root").

3. Manually create a directory named "build" under the "BibleVox/Engine" software tree.

4. Execute the *"./unpack_festival_voices.bash"* script with "user" privileges (i.e. do not run as "root").

5. Run: *"sudo ./install_festival_voices.bash"* script. If no errors occurred, the new high quality voices are now available from within the Ubuntu Festival speech engine installation.

## ./run_festival_tests.bash

If you do run the *"./build_festival.bash"* script, the *"run_festival_tests.bash"* script will be executed in order to produce test wave files for each installed Festival voice. A short "allphones.txt" test file is processed by the Festival Text-To-Speech (TTS) mode and the resulting wave files are placed into the "BibleVox/Engine/build/examples" directory. Each can be played with a suitable "wave" sound file player in order to hear what each voice sounds like. This script will not run if only the Ubuntu Festival executable package is installed.
