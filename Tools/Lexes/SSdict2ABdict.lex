/******************************************************************************
** File    : SSdict2ABdict.lex
** Project : BibleVox
** Date    : 2016.09.03
** Author  : MEAdams
** Purpose : Convert a SndSpell dictionary to an ArpaBet dictionary
** Usage   : 1. echo "WORD POST SNDSPELL [MARKUP]" | ./SSdict2ABdict
**         : --or--
**         : 2. cat inputFileName | ./SSdict2ABdict > outputFileName
*******************************************************************************
** Notes & : 1. This is FLEX (Fast Lexical Analysis) source code. The file
** Assumes :    name extension of ".lex" has nothing to do with a BibleVox
**         :    lexicon or lex. The FLEX interpreter will convert this code
**         :    into "C" code, which will be compiled in order to create the
**         :    SSdict2ABdict executable program. See makeFlexExec.bash.
**         :
**         : 2. BibleVox SndSpell is a spelling syntax in some ways similar to
**         :    the many other re-spelling guides that have been devised over
**         :    many years and seen on the Internet. However, they all seem to
**         :    "borrow" from similar sets of respellings of english sounds
**         :    and I am unable to discover which system appeared first. The
**         :    BibleVox SndSpell is an attempt to simplify and regularize to
**         :    facilitate ease of memorization and computer use. The other
**         :    systems define multiple spellings for many sounds or sound
**         :    combinations in order to provide varieties more suitable for
**         :    visual recognition within particular word spellings and then
**         :    copyright notices are stamped on them claiming to be unique.
**         :    Such action makes little legal sense since all of these
**         :    "various" systems are very similar (i.e. are not sufficiently
**         :    unique) nor is there an identifiable audit trail allowing the
**         :    "original" system to be identified and credited. The British
**         :    Broadcasting Corporation (BBC) "Text Spelling Guide" might
**         :    have been the original system devised. However, similarities
**         :    can be seen between it and the DARPA ArpaBet as well. The
**         :    BibleVox SndSpell system is specifically reduced in size with
**         :    an increase in logical spelling pattern regularity for ease
**         :    in programming without significant compromise in visual word
**         :    recognition (so says the author). It is developed primarily
**         :    as a means for scripting word pronunciations able to be easily
**         :    translated into English language speech engine specific
**         :    pronunciation lexicon syntax (e.g. the Festival speech engine
**         :    implementation of the DARPA ArpaBet).
**         :
**         : 3. There are three acceptable input line formats:
**         :    Comment and blank lines:
**         :      # Comment text lines begin with "#" in the first column.
**         :
**         :      # Comment text lines and blank lines are simply discarded.
**         :
**         :    Dictionary entries (note that markup comment is optional):
**         :      Word  Part_Of_Speech_Tag  SndSpell  [Syllable/Accent_markup]
**         :
**         :    Example input entries:
**         :      # SndSpell dictionary entries for my name.
**         :      Michael    pns    MIY-kuhl    Mi'chael
**         :      Edward     pns    ED-wuhrd    Ed'ward
**         :      Adams      pns    AD-uhmz     Ad'ams
**         :
**         :      # Note that blank lines also are permitted.
**         :
**         :    Output results from example input entries:
**         :      ("Michael" nnp (((m ay) 1) ((k ax l) 0)))
**         :      ("Edward" nnp (((eh d) 1) ((w er d) 0)))
**         :      ("Adams" nnp (((ae d) 1) ((ax m z) 0)))
**         :
**         : 4. Supported principle Parts-Of-Speech Tags (POST):
**         :      cns - common noun singular
**         :      cnp - common noun plural
**         :      pns - proper noun singular
**         :      pnp - proper noun plural
**         :      vrb - verb
**         :      adj - adjective
**         :      adv - adverb
**         :      nil - undefined
**         :
**         :    It is not deemed necessary to support pronoun, preposition,
**         :    conjunction and interjection directly. However, such words
**         :    can be included by declaring their POST as type "nil".
**         :
**         : 5. In actuality, any text beyond the MARKUP field also will be
**         :    ignored. Therefore, further useful information or comments
**         :    within the SndSpell dictionary are permitted and will not
**         :    affect the resulting ArpaBet dictionary output.
**         :
**         : 6. This code provides minimal (hardly any) error handling.
**         :
*******************************************************************************
** To Do   : 1. Add error handling code. ;)
**         :
*******************************************************************************/
 /* Definitions */
%x TEXT
%x NAME
%x POST
%x ABET
%x DUMP

%{
  int stress = 0;
  int spc = 1;

  void
  space() {
    if (spc) {
      printf(" ");
    }
  }
%}

%%
 /* Rules */
^\n          { }
^"#"         { BEGIN TEXT; }
<TEXT>.      { }
<TEXT>\n     { BEGIN INITIAL; }

^[a-zA-Z]    { BEGIN NAME; printf("(\"%s", yytext); }
<NAME>\n     { printf("\")\n"); BEGIN INITIAL; }
<NAME>[ \t]+ { BEGIN POST; printf("\" "); }
<NAME>.      { printf("%s", yytext); }

<POST>\n     { printf(")\n"); BEGIN INITIAL; }
<POST>[ \t]+ { BEGIN ABET; spc=0; printf(" ((("); }

<POST>"adj"  { printf("jj"); }
<POST>"adv"  { printf("rb"); }
<POST>"cnp"  { printf("nns"); }
<POST>"cns"  { printf("nn"); }
<POST>"nil"  { printf("nil"); }
<POST>"pnp"  { printf("nnps"); }
<POST>"pns"  { printf("nnp"); }
<POST>"vrb"  { printf("vb"); }

<ABET>"-"    { spc=0; printf(") %d) ((", stress); }
<ABET>\n     { spc=0; printf(") %d)))\n", stress); BEGIN INITIAL; }
<ABET>[ \t]+ { spc=0; printf(") %d)))", stress); BEGIN DUMP; }

<DUMP>.      { }
<DUMP>\n     { printf("\n"); BEGIN INITIAL; }

<ABET>"a"    { stress=0; space(); printf("ae"); spc=1; }
<ABET>"ah"   { stress=0; space(); printf("aa"); spc=1; }
<ABET>"ahr"  { stress=0; space(); printf("aa r"); spc=1; }
<ABET>"ao"   { stress=0; space(); printf("ao"); spc=1; }
<ABET>"ay"   { stress=0; space(); printf("ey"); spc=1; }
<ABET>"b"    { stress=0; space(); printf("b"); spc=1; }
<ABET>"ch"   { stress=0; space(); printf("ch"); spc=1; }
<ABET>"d"    { stress=0; space(); printf("d"); spc=1; }
<ABET>"e"    { stress=0; space(); printf("eh"); spc=1; }
<ABET>"ee"   { stress=0; space(); printf("iy"); spc=1; }
<ABET>"eh"   { stress=0; space(); printf("eh"); spc=1; }
<ABET>"ehr"  { stress=0; space(); printf("eh r"); spc=1; }
<ABET>"i"    { stress=0; space(); printf("ih"); spc=1; }
<ABET>"ih"   { stress=0; space(); printf("ih"); spc=1; }
<ABET>"ihr"  { stress=0; space(); printf("ih r"); spc=1; }
<ABET>"iy"   { stress=0; space(); printf("ay"); spc=1; }
<ABET>"f"    { stress=0; space(); printf("f"); spc=1; }
<ABET>"g"    { stress=0; space(); printf("g"); spc=1; }
<ABET>"h"    { stress=0; space(); printf("hh"); spc=1; }
<ABET>"j"    { stress=0; space(); printf("jh"); spc=1; }
<ABET>"k"    { stress=0; space(); printf("k"); spc=1; }
<ABET>"l"    { stress=0; space(); printf("l"); spc=1; }
<ABET>"m"    { stress=0; space(); printf("m"); spc=1; }
<ABET>"n"    { stress=0; space(); printf("n"); spc=1; }
<ABET>"ng"   { stress=0; space(); printf("ng"); spc=1; }
<ABET>"o"    { stress=0; space(); printf("aa"); spc=1; }
<ABET>"oh"   { stress=0; space(); printf("ow"); spc=1; }
<ABET>"ohr"  { stress=0; space(); printf("ao r"); spc=1; }
<ABET>"oo"   { stress=0; space(); printf("uw"); spc=1; }
<ABET>"ow"   { stress=0; space(); printf("aw"); spc=1; }
<ABET>"oy"   { stress=0; space(); printf("oy"); spc=1; }
<ABET>"p"    { stress=0; space(); printf("p"); spc=1; }
<ABET>"r"    { stress=0; space(); printf("r"); spc=1; }
<ABET>"s"    { stress=0; space(); printf("s"); spc=1; }
<ABET>"sh"   { stress=0; space(); printf("sh"); spc=1; }
<ABET>"t"    { stress=0; space(); printf("t"); spc=1; }
<ABET>"th"   { stress=0; space(); printf("th"); spc=1; }
<ABET>"dh"   { stress=0; space(); printf("dh"); spc=1; }
<ABET>"u"    { stress=0; space(); printf("ah"); spc=1; }
<ABET>"uh"   { stress=0; space(); printf("ax"); spc=1; }
<ABET>"uhr"  { stress=0; space(); printf("er"); spc=1; }
<ABET>"uu"   { stress=0; space(); printf("uh"); spc=1; }
<ABET>"v"    { stress=0; space(); printf("v"); spc=1; }
<ABET>"w"    { stress=0; space(); printf("w"); spc=1; }
<ABET>"y"    { stress=0; space(); printf("y"); spc=1; }
<ABET>"z"    { stress=0; space(); printf("z"); spc=1; }
<ABET>"zh"   { stress=0; space(); printf("zh"); spc=1; }

<ABET>"A"    { stress=1; space(); printf("ae"); spc=1; }
<ABET>"AH"   { stress=1; space(); printf("aa"); spc=1; }
<ABET>"AHR"  { stress=1; space(); printf("aa r"); spc=1; }
<ABET>"AO"   { stress=1; space(); printf("ao"); spc=1; }
<ABET>"AY"   { stress=1; space(); printf("ey"); spc=1; }
<ABET>"B"    { stress=1; space(); printf("b"); spc=1; }
<ABET>"CH"   { stress=1; space(); printf("ch"); spc=1; }
<ABET>"D"    { stress=1; space(); printf("d"); spc=1; }
<ABET>"E"    { stress=1; space(); printf("eh"); spc=1; }
<ABET>"EE"   { stress=1; space(); printf("iy"); spc=1; }
<ABET>"EH"   { stress=1; space(); printf("eh"); spc=1; }
<ABET>"EHR"  { stress=1; space(); printf("eh r"); spc=1; }
<ABET>"I"    { stress=1; space(); printf("ih"); spc=1; }
<ABET>"IH"   { stress=1; space(); printf("ih"); spc=1; }
<ABET>"IHR"  { stress=1; space(); printf("ih r"); spc=1; }
<ABET>"IY"   { stress=1; space(); printf("ay"); spc=1; }
<ABET>"F"    { stress=1; space(); printf("f"); spc=1; }
<ABET>"G"    { stress=1; space(); printf("g"); spc=1; }
<ABET>"H"    { stress=1; space(); printf("hh"); spc=1; }
<ABET>"J"    { stress=1; space(); printf("jh"); spc=1; }
<ABET>"K"    { stress=1; space(); printf("k"); spc=1; }
<ABET>"L"    { stress=1; space(); printf("l"); spc=1; }
<ABET>"M"    { stress=1; space(); printf("m"); spc=1; }
<ABET>"N"    { stress=1; space(); printf("n"); spc=1; }
<ABET>"NG"   { stress=1; space(); printf("ng"); spc=1; }
<ABET>"O"    { stress=1; space(); printf("aa"); spc=1; }
<ABET>"OH"   { stress=1; space(); printf("ow"); spc=1; }
<ABET>"OHR"  { stress=1; space(); printf("ao r"); spc=1; }
<ABET>"OO"   { stress=1; space(); printf("uw"); spc=1; }
<ABET>"OW"   { stress=1; space(); printf("aw"); spc=1; }
<ABET>"OY"   { stress=1; space(); printf("oy"); spc=1; }
<ABET>"P"    { stress=1; space(); printf("p"); spc=1; }
<ABET>"R"    { stress=1; space(); printf("r"); spc=1; }
<ABET>"S"    { stress=1; space(); printf("s"); spc=1; }
<ABET>"SH"   { stress=1; space(); printf("sh"); spc=1; }
<ABET>"T"    { stress=1; space(); printf("t"); spc=1; }
<ABET>"TH"   { stress=1; space(); printf("th"); spc=1; }
<ABET>"DH"   { stress=1; space(); printf("dh"); spc=1; }
<ABET>"U"    { stress=1; space(); printf("ah"); spc=1; }
<ABET>"UH"   { stress=1; space(); printf("ax"); spc=1; }
<ABET>"UHR"  { stress=1; space(); printf("er"); spc=1; }
<ABET>"UU"   { stress=1; space(); printf("uh"); spc=1; }
<ABET>"V"    { stress=1; space(); printf("v"); spc=1; }
<ABET>"W"    { stress=1; space(); printf("w"); spc=1; }
<ABET>"Y"    { stress=1; space(); printf("y"); spc=1; }
<ABET>"Z"    { stress=1; space(); printf("z"); spc=1; }
<ABET>"ZH"   { stress=1; space(); printf("zh"); spc=1; }

%%
 /* Subroutines */
