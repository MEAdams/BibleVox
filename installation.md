## Installation:

### Assumptions:
To control the initial scope of the BibleVox project and get the lexicon into the hands of other developers most quickly, the following is assumed:

1. The target system possesses an already properly functioning Festival speech engine installation including the additional high quality voices available from the CMU website [(CMU Festival/Flite website)](http://www.festvox.org/).

2. The user of the target system is able to operate the Festival speech engine and make use of its TTS capabilities [(Festival documentation)](http://www.festvox.org/docs/manual-2.4.0/).

3. The user has access to electronic formats of English language Bible texts that can be fed to the Festival speech engine for rendering [(CrossWire website)](https://www.crosswire.org/).

Note: The scope of the BibleVox project will be later expanded to provide helps for those not so familiar with the operation of the Festival speech engine as well as include modifications that the BibleVox project has developed that improve its Bible TTS rendering.

### Instructions:
1. Shut down any already running instance of the Festival speech engine.

2. Copy the .festivalrc and BibleVoxLex.scm files into your top level "home" directory.

3. Start the Festival speech engine.

4. Use the Festival Text-To-Speech (TTS) capabilities to render the user's selection of Bible text.

5. Use a text editor and modify the .festivalrc file in order to configure user selectable options. For example, if installed, alternate Festival voices can be selected by commenting/uncommenting the applicable code. Note that Festival must be restarted in order to make any file alterations active.

6. Be patient while the BibleVox author continues building and enhancing this Git/GitHub project site.

