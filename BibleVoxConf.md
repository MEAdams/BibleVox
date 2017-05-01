## Directory: BibleVox

# Forward:

## Assumptions:

1. The target system possesses an already properly functioning Festival speech engine installation including the additional high quality voices available from the CMU website [(CMU Festival website)](http://www.festvox.org/). Festival 2.4, the latest version as of this writing, is available (as of this writing) from the Ubuntu software repository. However, the high quality CMU voices are not. The BibleVox project provides BASH scripts useful for obtaining the Festival software and voices directly from the CMU website (see [BibleVox/Engine](./Engine/EngineDirDoc.md)).

# BibleVox Configuration:

1. From the "BibleVox" directory, run: *[./BibleVoxConf.bash](./BibleVoxConf.bash)*.

2. A ".festivalrc" file now exists in the user's home directory that instructs the Festival speech engine to load and use the "BibleVox/Tools/Lexes/BibleVoxLex.scm" pronunciation lexicon.
