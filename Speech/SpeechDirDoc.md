## Directory: BibleVox/Speech

# Forward:

The BibleVox software feeds the SWORD Project's electronic formats of English language Bible texts to the Festival speech engine for rendering [(CrossWire website)](https://www.crosswire.org/). The BibleVox project uses the Bible study application program named "Xiphos", which is available from the Ubuntu software repository, to most easily manage Sword Project Bible modules. Newer versions of Xiphos might be available directly through the Xiphos website ([Xiphos website](http://xiphos.org/)). Xiphos is a great Linux Bible study application and is highly recommended by the BibleVox project. Xiphos possesses a "Read Selection Aloud" capability that employs, on Linux, the Festival speech engine. Therefore, Xiphos is able to take advantage of an installed BibleVox pronunciation lexicon as-well-as any of the installed high quality Festival voices. However, Xiphos cannot at this time make use of the BibleVox TTS enhancements nor does it possess the flexibility or speed of the BibleVox Bible speech tools. It is hoped that this will be addressed in the near future.

The BibleVox project uses the "Diatheke" command-line-interface (CLI) Bible study application program within its *"./sword_speak.bash"* script (see [Diatheke](https://crosswire.org/wiki/Frontends:Diatheke)). Diatheke will have access to all Bible texts obtained with the Xiphos Bible study software. Diatheke is available (as of this writing) from the Ubuntu software repository.

# Ubuntu Fast-track:

1. Run: *"sudo apt-get install xiphos"*.
2. Run: *"sudo apt-get install diatheke"*.
3. The "KJV" module will be installed and available by default. Other modules can be installed through the Xiphos "Module Manager" available from the "Edit" menu. Please read the Xiphos documentation for details.

# General:

These BASH scripts serve as BibleVox project demonstrations and support BibleVox development.

[*./bible.bash*](./bible.bash)

[*./dictionary.bash*](./dictionary.bash)

These SCHEME scripts are used by BibleVox to initialize and configure the Festival speech engine.

[*./init_speech.scm*](./init_speech.scm)

[*./init_voice.scm*](./init_voice.scm)

These BASH scripts are used by BibleVox to facilitate Bible Text-To-Speech (TTS) processing.

[*./sword_speak.bash*](./sword_speak.bash)

[*./text_fltrs.bash*](./text_fltrs.bash)

# Specific:

## Bible Narration:

The BibleVox *"./bible.bash"* script provides a fast, unencumbered and specific Bible text narration capability adequate for supporting BibleVox pronunciation lexicon development and maintenance, and is useful in the development of applicable Festival speech engine refinements. It serves as a BibleVox demonstration intended to encourage developers of robust Bible study software to consider integrating BibleVox capabilities into their products and allows BibleVox users to enjoy Bible text narration in the meantime.

To use the Festival speech engine for BibleVox Bible text narration, run: *"./bible.bash textName"*, where "textName" is the name of the Sword Bible module to be accessed (i.e. obtained by Xiphos). For example, *./bible.bash ESV* will access the Sword project's English Standard Version Bible module. Likewise, *./bible.bash KJV* will access the Sword project's King James Version Bible module.

### Book name:

Upon execution, you are prompted with: *"Enter bible book:"*. Type the name of the Bible book you wish to access. As you type each letter of the book name, search results will be displayed containing your typed letters appearing in red colored characters. The search results narrow down possibilities as you type each letter. Here is a sample session:

1. ./bible.bash ESV
2. Initial prompt: "Enter bible book:"
3. If you type the letter "m", the prompt will update.
4. New prompt: "Enter bible book: malachi  Mark  Matthew  Micah"
5. If you type the letter "a", the prompt again updates.
6. New prompt: "Enter bible book: malachi  Mark  Matthew"
7. If you type the letter "t", the prompt again updates.
8. New prompt: "Enter bible book: matthew"
9. Hit "ENTER" to accept the name or use "BACKSPACE" to edit it.

### Chapter number:

Upon accepting "Matthew" as a book name, you are prompted with: *"Enter a chapter number [1..28]:"*. Note that the prompt presents you with the valid chapter numbers of 1 to 28. Type "1". You can either hit "ENTER" to accept the chapter number, or type additional numbers or hit "BACKSPACE" to edit it.

### Verse number(s):

Upon accepting "1" as a chapter number, you are prompted with: *"Verse (# or #-# or ENTER) [1-25]:"*. Note that the prompt presents you with the valid verse numbers of 1 to 25. Typing "1" followed by hitting "ENTER" causes Matthew 1:1 to be recited. Typing "1-16" followed by hitting "ENTER" causes Matthew 1:1-16 to be recited (i.e. the male genealogy of Jesus). Hitting "ENTER" without typing a number causes Matthew 1:1-25 to be recited (i.e. the entire chapter).

### Output results:

The selected Bible text will be displayed so that you may read along with the narration if you like. Verse numbers are displayed for your convenience. However, verse numbers and other unnecessary and distracting items, such as all punctuation marks, are omitted from the narration. Festival will attempt to approximate applicable punctuation mark pauses and textual phrasings that a human reader might perform. Festival also will attempt to approximate some voice inflections that a human reader might perform.

Once narration has completed, you are prompted with: *"<_SPACE_> repeat, <_ENTER_> continue, <_ESC_> exit, <_CTRL-C_> abort:*". Simply hit the applicable key(s) to perform your choice. The "CTRL-C" command is the only one available for aborting a narration or errant prompt entry. If the script is misbehaving, the user changes his mind, or the user wishes to terminate a narration; simply hit the "CTRL-C" key combination to abort the script and then hit the "UP-ARROW" key followed by "ENTER" to restart the *./bible.bash* script.

## Dictionary Narration:

The BibleVox *"./dictionary.bash"* script provides a fast, unencumbered and specific Bible word narration capability adequate for supporting BibleVox pronunciation lexicon development and maintenance.

To use the Festival speech engine for BibleVox Bible word narration, run *"./dictionary.bash dictName"*, where "dictName" is the name of the BibleVox dictionary menu file to be accessed. For example, *./dictionary.bash BibleVoxDict* will access the default BibleVox dictionary menu file. All BibleVox dictionary menu files are maintained in the [BibleVox/Tools/Lexes](../Tools/Lexes/LexesDirDoc.md) directory.

### Word selection:

Upon execution, you are prompted with: *"Enter search word:"*. Type the word you wish to access. As you type each letter of the word, search results will be displayed that contain your typed letters appearing in red colored characters. The search results narrow down possibilities as you type each letter. Here is a sample session:

1. ./dictionary.bash BibleVoxDict
2. Initial prompt: "Enter search word:"
3. If you type the letter "a", the prompt will update.
4. New prompt: "Enter search word: (list of too many words to fit the display)"
5. If you type another letter "a", the prompt again updates.
6. New prompt: "Enter search word: aaron  Aaronite  Aaronites"
7. If you type the letters "roni", the prompt updates with each new letter.
8. New prompt: "Enter search word: aaronite Aaronites"
9. Hit "ENTER" to accept "Aaronite" or continue spelling "Aaronites" followed by hitting "ENTER" or use "BACKSPACE" to edit the search word.

### Output results:

Upon accepting the word "Aaron", the name "Aaron" will be pronounced and the display will be updated with the following information:

1. Enter search word: Aaron

2. pns  EHR-uhn  Aar'on  person

3. ("Aaron" nnp (((eh r) 1) ((ax n) 0)))

4. <_SPACE_> repeat, <_ENTER_> continue, <_ESC_> exit, <_CTRL-C_> abort:

Line number 1 displays the selected word. Line number 2 provides the search word's parts-of-speech tag (Proper Noun Singular), its pronunciation specified in "SndSpell" notation, its syllable structure specified in classical notation, and its word category definition (person). Line number 3 provides the search word's pronunciation specified in the Defense Advanced Research Projects Agency (DARPA) phonetic alphabet (i.e. ArpaBet) as presented in the Carnegie Mellon University (CMU) dictionary, SCHEME language format. Refer to [BibleVox/Docs](../Docs/DocsDirDoc.md) for discussions and explanations of each of these items.

Line number 4 displays the prompt: *"<_SPACE_> repeat, <_ENTER_> continue, <_ESC_> exit, <_CTRL-C_> abort:*". Simply hit the applicable key(s) to perform your choice. The "CTRL-C" command is the only one available for aborting a narration or errant prompt entry. If the script is misbehaving, the user changes his mind, or the user wishes to terminate a narration; simply hit the "CTRL-C" key combination to abort the script and then hit the "UP-ARROW" key followed by "ENTER" to restart the *./dictionary.bash* script.
