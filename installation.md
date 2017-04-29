## BibleVox Installation:

# Forward:

## Scope:

1. Ubuntu 16.04 LTS is the author's development platform as of this writing. The BibleVox BASH scripts and documentation provided herein are written specifically for this distribution of the Linux OS. The BibleVox author possesses no useful knowledge of, nor experience with, other operating systems. However, he believes that the provided code, comments and documentation are sufficient for porting BibleVox to some other platforms. Perhaps others possessing applicable knowledge and experience will offer assistance to such endeavors.

## Purposes:

1. The primary product of the BibleVox project is a pronunciation lexicon of English language Bible words and proper names formatted for the Carnegie Mellon University (CMU) Festival speech engine. Included are some enhancements to the Bible Text-To-Speech (TTS) processing capabilities of the Festival speech engine. BibleVox software is provided to enjoy Bible narration and, by way of demonstration, hopefully entice Bible software application developers to consider integrating BibleVox into their products. BibleVox products eventually will be ported also to the CMU Flite speech engine.

2. A secondary product of the BibleVox project is to provide a tools set sufficient for supporting continued development and maintenance of the BibleVox pronunciation lexicon.

3. The BibleVox tools set can readily support other Festival speech engine pronunciation lexicon developments.

4. A BibleVox pronunciation lexicon is much more easily ported to a different speech engine format than is the task of initially creating one.

# General:

This BibleVox "git" repository supports several levels of BibleVox installation:

1. If a pre-compiled Festival package is not available, BibleVox BASH scripts are provided to download, configure, compile and test Festival directly from the source code provided at the [CMU website](http://www.festvox.org/).

2. BibleVox BASH scripts are provided to download and install the recommended high quality Festival voices provided at the CMU website.

2. BibleVox BASH scripts are provided to configure a Festival installation to use the BibleVox pronunciation lexicon and TTS enhancements.

3. BibleVox BASH script Bible and Dictionary tools are provided to enjoy Festival Bible text and pronunciation lexicon word narrations.

4. BibleVox tools software is provided to support continued development and maintenance of the BibleVox pronunciation lexicon.

# Specific:

Several combinations of the following installation options are possible. Read the provided documentation to determine which will serve specific circumstances and purposes.

1. [Festival installation](./Engine/EngineDirDoc.md)

2. [BibleVox configuration](./BibleVoxConf.md)

3. [BibleVox narration](./Speech/SpeechDirDoc.md)

... to be continued
