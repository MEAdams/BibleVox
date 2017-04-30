## Directory: BibleVox

# Forward:

## Assumptions:

1. The target system possesses an already properly functioning Festival speech engine installation including the additional high quality voices available from the CMU website [(CMU Festival/Flite website)](http://www.festvox.org/). Festival 2.4, the latest version as of this writing, is available (as of this writing) from the Ubuntu software repository. However, the high quality CMU voices are not. The BibleVox project provides BASH scripts useful for obtaining the Festival software and voices directly from the CMU website (see [BibleVox/Engine](./Engine/EngineDirDoc.md)).

2. The user has access to electronic formats of English language Bible texts that can be fed to the Festival speech engine for rendering [(CrossWire website)](https://www.crosswire.org/). The BibleVox project uses the Bible study application program named "Xiphos" that is available from the Ubuntu software repository. However, newer versions (recommended) can be obtained directly through the Xiphos website ([Xiphos website](http://xiphos.org/)). Xiphos can be used for obtaining CrossWire Sword project Bible texts. The BibleVox project uses the "Diatheke" command-line Bible study application program within its *'/sword_speak.bash"* script (see [Diatheke](https://crosswire.org/wiki/Frontends:Diatheke)). Diatheke will have access to all Bible texts obtained with the Xiphos Bible study software. Diatheke is available (as of this writing) from the Ubuntu software repository.

# BibleVox Configuration:

1. From the "BibleVox" directory, run: *[./BibleVoxConf.bash](./BibleVoxConf.bash)*.

2. A ".festivalrc" file now exists in the user's home directory that instructs the Festival speech engine to load and use the "BibleVox/Tools/Lexes/BibleVoxLex.scm" pronunciation lexicon.
