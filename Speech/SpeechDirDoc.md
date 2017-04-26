## Directory: BibleVox/Speech

# Forward:

### Assumptions:

1. The target system possesses an already properly functioning Festival speech engine installation including the additional high quality voices available from the CMU website [(CMU Festival/Flite website)](http://www.festvox.org/). Festival 2.4, the latest version as of this writing, is available (as of this writing) from the Ubuntu software repository. However, the high quality CMU voices are not. The BibleVox project provides BASH scripts useful for obtaining the Festival software and voices directly from the CMU website (see [BibleVox/Engine](../Engine/EngineDirDoc.md)).

2. The user has access to electronic formats of English language Bible texts that can be fed to the Festival speech engine for rendering [(CrossWire website)](https://www.crosswire.org/). The BibleVox project uses the Bible study application program named "Xiphos" that is available from the Ubuntu software repository. However, newer versions (recommended) can be obtained directly through the Xiphos website ([Xiphos website](http://xiphos.org/)). Xiphos can be used for obtaining CrossWire Sword project Bible texts. The BibleVox project uses the "Diatheke" command-line Bible study application program within its *'/sword_speak.bash"* script (see [Diatheke](https://crosswire.org/wiki/Frontends:Diatheke)). Diatheke will have access to all Bible texts obtained with the Xiphos Bible study software. Diatheke is available (as of this writing) from the Ubuntu software repository.

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

### Bible Narration:

The BibleVox *"./bible.bash"* script provides a fast, unencumbered and specific Bible text narration capability adequate for supporting BibleVox pronunciation lexicon development and maintenance, and is useful in the development of applicable Festival speech engine refinements. It serves as a BibleVox demonstration intended to encourage developers of robust Bible study software to consider integrating BibleVox capabilities into their products and allows BibleVox users to enjoy Bible text narration in the meantime.

To use the Festival speech engine for Bible text narration, run: *"./bible.bash textName"*, where "textName" is the name of the Sword Bible module to be accessed (i.e. obtained by Xiphos). For example, *./bible.bash ESV* will access the Sword project's English Standard Version Bible module. Likewise, *./bible.bash KJV* will access the Sword project's King James Version Bible module.

#### Book name:

Upon execution, you are prompted with: *"Enter bible book:"*. Enter the name of the Bible book you wish to access. As you enter each letter of the book name, search results containing your typed letters will be displayed. The search results narrow down possibilities as you type each letter. Here is a sample session:

1. ./bible.bash ESV
2. Initial prompt: "Enter bible book:"
3. If you type the letter "m", the prompt will update.
4. New prompt: "Enter bible book: malachi  Mark  Matthew  Micah"
5. If you type the letter "a", the prompt again updates.
6. New prompt: "Enter bible book: malachi  Mark  Matthew"
7. If you type the letter "t", the prompt again updates.
8. New prompt: "Enter bible book: matthew"
9. Hit "Enter" to accept the name or "Backspace" to edit it.

#### Chapter number:

Upon accepting "Matthew" as a book name, you are prompted with: *"Enter a chapter number [1..28]:"*. Note that the prompt presents you with the valid chapter numbers of 1 to 28. Type "1". You can either hit "Enter" to accept the chapter number, or type additional numbers or hit "Backspace" to edit it.

#### Verse number(s):

Upon accepting "1" as a chapter number, you are prompted with: *"Verse (# or #-# or Enter) [1-25]:"*. Note that the prompt presents you with the valid verse numbers of 1 to 25. Typing "1" followed by "Enter" causes Matthew 1:1 to be recited. Typing "1-16" followed by "Enter" causes Matthew 1:1-16 to be recited (i.e. the male genealogy of Jesus). Typing "Enter" without including a number causes Matthew 1:1-25 to be recited (i.e. the entire chapter).

#### Output results:

The selected Bible text will be displayed so that you may read along with the narration if you like. Verse numbers are displayed for your convenience. However, verse numbers and other unnecessary and distracting items, such as all punctuation marks, are omitted from the narration. Festival will attempt to approximate applicable punctuation mark pauses and textual phrasings that a human reader might perform. Festival also will attempt to approximate some voice inflections that a human reader might perform.

