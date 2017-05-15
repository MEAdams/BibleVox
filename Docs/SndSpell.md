## Topic: SndSpell

# General:

BibleVox SndSpell is a spelling syntax in some ways similar to the many other re-spelling guides that have been devised over many years and seen on the Internet. However, they all seem to "borrow" from similar sets of respellings of english sounds and I am unable to discover which system appeared first. The BibleVox SndSpell is an attempt to simplify and regularize to facilitate ease of memorization and computer use. The other systems define multiple spellings for many sounds or sound combinations in order to provide varieties more suitable for visual recognition within particular word spellings and then copyright notices are stamped on them claiming to be unique. Such action makes little legal sense since all of these "various" systems are very similar (i.e. are not sufficiently unique) nor is there an identifiable audit trail allowing the "original" system to be identified and credited. The British Broadcasting Corporation (BBC) "Text Spelling Guide" might have been the original system devised. However, similarities can be seen between it and the DARPA ArpaBet as well. The BibleVox SndSpell system is specifically reduced in size with an increase in logical spelling pattern regularity for ease in programming without significant compromise in visual word recognition (so says the author). It is developed primarily as a means for scripting word pronunciations able to be easily translated into English language speech engine specific pronunciation lexicon syntax (e.g. the Festival speech engine implementation of the DARPA ArpaBet).

## Festival Implementation of DARPA Phone Set (ArpaBet):

### VOWELS:

#### *Monophthongs:*

    Phone   Sound               Examples
    -----   -----               --------
    EY      Long  A             ate, bate
    AE      Short a             at, bat
    IY      Long  E             eat, beat
    EH      Short e             egg, beg
    AY      Long  I             eye, bye
    IH      Short i             it, bit
    OW      Long  O             oat, boat
    AA      Short o             ox, box
    AO      Short o             all, ball
    UW      Long  U, Long OO    ooh, boo
    AH      Short u             us, bus
    UH      Short oo            hook, book
    AX      unaccented          nav[a]l, tak[e]n, per[i]l,
                                lem[o]n, foc[u]s, [a]bout

#### *Diphthongs:*

    Phone   Sound               Examples
    -----   -----               --------
    EY      ey                  ey, bay
    AY      aye                 aye, buy
    OW      owe                 owe, bow (n)
    AW      ow                  ow, bow (v)
    OY      oy                  oy, boy

#### *R-colored:*

    Phone   Sound               Examples
    -----   -----               --------
    ER      ur                  earn, burn


### CONSONANTS:

#### *Stops:*

    Phone   Examples
    -----   --------
    P       pat, tap
    B       bat, tab
    T       tip, pit
    D       dab, bad
    K       keel, leek
    G       gut, tug

#### *Fricatives:*

    Phone   Examples
    -----   --------
    F       fought, rough
    V       votes, stove
    TH      theme, math
    DH      them, writhe 
    S       sap, pass
    Z       zoo, ooze
    SH      shop, posh
    ZH      asian, seizure
    HH      host, house

#### *Affricates:*

    Phone   Examples
    -----   --------
    CH      chair, perch
    JH      just, smudge

#### *Nasals:*

    Phone   Examples
    -----   --------
    M       mar, ram
    N       no, on
    NG      sing, anger

#### *Liquids:*

    Phone   Examples
    -----   --------
    L       lap, pal
    R       reel, leer

#### *Semivowels:*

    Phone   Examples
    -----   --------
    Y       yam, yet
    W       wasp, swap

## BibleVox SndSpell to DARPA ArpaBet Translation:

    SndSpell    ArpaBet         SndSpell    ArpaBet
    --------    -------         ----        -------
    a           ae              ng          ng
    ah          aa              o           aa
    ahr         aa r            oh          ow
    ao          ao              ohr         ao r
    ay          ey              oo          uw
    b           b               ow          aw
    ch          ch              oy          oy
    d           d               p           p
    e           eh              r           r
    ee          iy              s           s
    eh          eh              sh          sh
    ehr         eh r            t           t
    i           ih              th          th
    ih          ih              dh          dh
    ihr         ih r            u           ah
    iy          ay              uh          ax
    f           f               uhr         er
    g           g               uu          uh
    h           hh              v           v
    j           jh              w           w
    k           k               y           y
    l           l               z           z
    m           m               zh          zh
    n           n

## SndSpell usage (similar in concept to other sytems):
(i.e. Syllables separated by hyphens. Stressed syllables given in CAPITALS.)

### Vowels:

    a   as in hat           iy  as in high
    ah  as in cot           o   as in not
    ahr as in bar           oh  as in no
    ao  as in law           ohr as in corn
    ay  as in day           oo  as in boot
    e   as in get           ow  as in out
    eh  as in get           oy  as in boy
    ee  as in street        u   as in cup
    ehr as in hair          uh  as in ago
    i   as in bit           uhr as in fur
    ih  as in bit           uu  as in book
    ihr as in mirror

### Consonants:

    b  as in bat            p  as in pen
    ch as in church         r  as in red
    d  as in day            s  as in sit
    f  as in fit            sh as in ship
    g  as in get            t  as in top
    h  as in hat            th as in thin
    j  as in jack           dh as in there
    k  an in king           v  as in vet
    l  as in leg            w  as in will
    m  as in man            y  as in yes
    n  as in not            z  as in zebra
    ng as in singer         zh as in measure

## Example usage:
(By convention, single syllable words are always respelled accented.)

BIY: MIY-kuhl ED-wuhrd AD-uhms, FRUM YUNGZ-town, OF muh-HOHN-ing KOWN-tee, oh-HIY-oh. HOHM OF DHUH YUNGZ-town STAYT YOO-ni-VUHR-si-tee PEN-gwinz AND MIY AHL-muh MAH-tuhr.

By: Michael Edward Adams, from Youngstown, of Mahoning County, Ohio. Home of the Youngstown State University Penguins and my alma mater.
