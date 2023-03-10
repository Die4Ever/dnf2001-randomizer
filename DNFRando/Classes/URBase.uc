class URBase extends URInfo;

var DNFRando rando;
var transient float overallchances;

function Init(DNFRando trando)
{
    rando = trando;
}

simulated function DNFRando GetUR()
{
    return rando;
}

simulated function PreFirstEntry();
simulated function FirstEntry();
simulated function PostFirstEntry();

simulated function AnyEntry();
simulated function PostAnyEntry();

simulated function ReEntry(bool IsTravel);

simulated function PlayerLogin(PlayerPawn player)
{
    l("PlayerLogin("$player$")");
}

simulated function PlayerRespawn(PlayerPawn player)
{
    l("PlayerRespawn("$player$")");
}

simulated function PlayerAnyEntry(PlayerPawn player)
{
    l("PlayerAnyEntry("$player$")");
}


simulated function int SetSeed(coerce string name)
{
    return rando.SetSeed( rando.Crc(rando.seed $ rando.localURL $ name) );
}

simulated function int SetGlobalSeed(coerce string name)
{
    return rando.SetSeed( rando.seed + rando.Crc(name) );
}

simulated function int rng(int max)
{
    return rando.rng(max);
}

simulated function bool rngb()
{
    return rando.rng(100) < 50;
}

simulated function float rngf()
{// 0 to 1.0
    local float f;
    f = float(rando.rng(100001))/100000.0;
    //l("rngf() "$f);
    return f;
}

simulated function float rngfn()
{// -1.0 to 1.0
    return rngf() * 2.0 - 1.0;
}

simulated function float rngrange(float val, float min, float max)
{
    local float mult, r, ret;
    mult = max - min;
    r = rngf();
    ret = val * (r * mult + min);
    //l("rngrange r: "$r$", mult: "$mult$", min: "$min$", max: "$max$", val: "$val$", return: "$ret);
    return ret;
}

simulated function float rngrecip(float val, float max)
{
    local float f;
    f = rngrange(1, 1, max);
    if( rngb() ) {
        f = 1 / f;
    }
    return val * f;
}

simulated function float rngrangeseeded(float val, float min, float max, coerce string classname)
{
    local float mult, r, ret;
    local int oldseed;
    oldseed = rando.SetSeed( rando.seed + rando.Crc(classname) );//manually set the seed to avoid using the level name in the seed
    mult = max - min;
    r = rngf();
    ret = val * (r * mult + min);
    //l("rngrange r: "$r$", mult: "$mult$", min: "$min$", max: "$max$", val: "$val$", return: "$ret);
    rando.SetSeed(oldseed);
    return ret;
}

simulated function float rngexp(float origmin, float origmax, float curve)
{
    local float frange, f, min, max;
    min = origmin;
    max = origmax;
    if(min != 0)
        min = pow(min, 1/curve);
    max = pow(max+1.0, 1/curve);
    frange = max-min;
    f = rngf()*frange + min;
    f = pow(f, curve);
    f = FClamp( f, origmin, origmax );
    return f;
}

simulated function float initchance()
{
    if(overallchances > 0.01 && overallchances < 99.99) warning("initchance() overallchances == "$overallchances);
    overallchances=0;
    return rngf()*100.0;
}

simulated function bool chance(float percent, float r)
{
    overallchances+=percent;
    if(overallchances>100.01) warning("chance("$percent$", "$r$") overallchances == "$overallchances);
    return r>= (overallchances-percent) && r< overallchances;
}

simulated function bool chance_remaining(int r)
{
    local int percent;
    percent = 100 - overallchances;
    return chance(percent, r);
}

simulated function bool chance_single(float percent)
{
    return rngf()*100.0 < percent;
}
