class DNFRando extends URInfo;

var PlayerPawn MainPlayer;
var string localURL;
var int seed, tseed;

var private int CrcTable[256]; // for string hashing to do more stable seeding
var URBase modules[32];
var int num_modules;

var bool bTickEnabled;// just for the tests to inspect

function Init()
{
    local int i;
    localURL = string(Level);
    i = InStr(localURL, ".");
    if(i > -1) {
        localURL = Left(localURL, i);
    }
    l(self$".Init(), localURL: "$localURL$", DNFRando Version: "$VersionString());
    CrcInit();
    Enable('Tick');
    bTickEnabled = true;
}

function InitDataStorage()
{
    local URDataStorage ds;
    local PlayerPawn p;
    p = GetPlayerPawn();
    ds = URDataStorage(p.FindInventoryType(class'URDataStorage'));
    if(ds == None) {
        ds = p.spawn(class'URDataStorage');
        l("InitDataStorage spawned "$ds);
        p.AddInventory(ds);
        ds.seed = Rand(999999);
    }
    seed = ds.seed;
    SetSeed(ds.seed);
}

function URBase LoadModule(class<URBase> moduleclass)
{
    local URBase m;
    l("loading module "$moduleclass);

    /*m = FindModule(moduleclass, true);
    if( m != None ) {
        info("found already loaded module "$m);
        if(m.dxr != Self) m.Init(Self);
        return m;
    }*/

    m = Spawn(moduleclass, None);
    if ( m == None ) {
        err("failed to load module "$moduleclass);
        return None;
    }
    modules[num_modules] = m;
    num_modules++;
    m.Init(Self);
    l("finished loading module "$m);
    return m;
}

function LoadModules()
{
    LoadModule(class'URSwapItems');
}

event Tick( float Delta )
{
    MainPlayer = GetPlayerPawn();
    if(MainPlayer == None) return;

    InitDataStorage();
    LoadModules();
    RandoFirstEntry();
    Disable('Tick');
    bTickEnabled = false;
    LoginActivePlayers();
    RandoAnyEntry();
}

function RandoFirstEntry()
{
    local int i;
    l("RandoFirstEntry(), seed: "$seed);
    for(i=0;i<num_modules;i++) {
        modules[i].PreFirstEntry();
    }
    for(i=0;i<num_modules;i++) {
        modules[i].FirstEntry();
    }
    for(i=0;i<num_modules;i++) {
        modules[i].PostFirstEntry();
    }
}

function LoginActivePlayers()
{
    local PlayerPawn p;

    foreach AllActors(class'PlayerPawn', p) {
        PlayerLogin(p);
    }
}

function RandoAnyEntry()
{
    local int i;
    if(bTickEnabled) return;
    l("RandoAnyEntry(), seed: "$seed);
    for(i=0;i<num_modules;i++) {
        modules[i].AnyEntry();
    }
}

function PlayerLogin(PlayerPawn p)
{
    local int i;
    if(bTickEnabled) return;
    l("PlayerLogin("$p$"), seed: "$seed);
    for(i=0;i<num_modules;i++) {
        modules[i].PlayerLogin(p);
    }
}

simulated final function int SetSeed(int s)
{
    local int oldseed;
    oldseed = tseed;
    l("SetSeed global seed: "$seed$", old tseed: "$oldseed$", new tseed: "$s);
    if(s == 0) s++;
    tseed = s;
    return tseed;
}

simulated final function int rng(int max)
{
    const gen1 = 1073741821;// half of gen2, rounded down
    const gen2 = 2147483643;
    tseed = gen1 * tseed * 5 + gen2 + (tseed/5) * 3;
    // in unrealscript >>> is right shift and filling the left with 0s, >> shifts but keeps the sign
    // this means we don't need abs, which is a float function anyways
    return (tseed >>> 8) % max;
}


// ============================================================================
// CrcInit https://web.archive.org/web/20181105143221/http://unrealtexture.com/Unreal/Downloads/3DEditing/UnrealEd/Tutorials/unrealwiki-offline/crc32.html
//
// Initializes CrcTable and prepares it for use with Crc.
// ============================================================================

simulated final function CrcInit() {

    const CrcPolynomial = 0xedb88320;

    local int CrcValue;
    local int IndexBit;
    local int IndexEntry;

    for (IndexEntry = 0; IndexEntry < 256; IndexEntry++) {
        CrcValue = IndexEntry;

        for (IndexBit = 8; IndexBit > 0; IndexBit--)
        {
            if ((CrcValue & 1) != 0)
                CrcValue = (CrcValue >>> 1) ^ CrcPolynomial;
            else
                CrcValue = CrcValue >>> 1;
        }

        CrcTable[IndexEntry] = CrcValue;
    }
}


// ============================================================================
// Crc
//
// Calculates and returns a checksum of the given string. Call CrcInit before.
// ============================================================================

simulated final function int Crc(coerce string Text) {

    local int CrcValue;
    local int IndexChar;

    //if(CrcTable[1] == 0)
        //err("CrcTable uninitialized?");

    CrcValue = 0xffffffff;

    for (IndexChar = 0; IndexChar < Len(Text); IndexChar++)
        CrcValue = (CrcValue >>> 8) ^ CrcTable[Asc(Mid(Text, IndexChar, 1)) ^ (CrcValue & 0xff)];

    return CrcValue;
}

simulated function DNFRando GetRando()
{
    return Self;
}
/*
function RunTests()
{
    local int i, failures;
    l("starting RunTests()");
    for(i=0; i<num_modules; i++) {
        modules[i].StartRunTests();
        if( modules[i].fails > 0 ) {
            failures++;
            Player.ShowHud(true);
            err( "ERROR: " $ modules[i] @ modules[i].fails $ " tests failed!" );
        }
        else
            l( modules[i] $ " passed tests!" );
    }

    if( failures == 0 ) {
        l( "all tests passed!" );
    } else {
        Player.ShowHud(true);
        err( "ERROR: " $ failures $ " modules failed tests!" );
    }
}

function ExtendedTests()
{
    local int i, failures;
    l("starting ExtendedTests()");
    for(i=0; i<num_modules; i++) {
        modules[i].StartExtendedTests();
        if( modules[i].fails > 0 ) {
            failures++;
            Player.ShowHud(true);
            err( "ERROR: " $ modules[i] @ modules[i].fails $ " tests failed!" );
        }
        else
            l( modules[i] $ " passed tests!" );
    }

    if( failures == 0 ) {
        l( "all extended tests passed!" );
    } else {
        Player.ShowHud(true);
        err( "ERROR: " $ failures $ " modules failed tests!" );
    }
}
*/
defaultproperties
{
    NetPriority=0.1
}
