class DNFRMutator extends Mutator;

var DNFRando rando;

function DNFRando GetRando()
{
    if( rando != None ) return rando;
    foreach AllActors(class'DNFRando', rando) return rando;
    rando = Spawn(class'DNFRando');
    log("GetRando(), rando: "$rando, self.name);
    rando.Init();// just in case we need to pass in an argument later
    return rando;
}

function ModifyPlayer( Pawn Other )
{
    local PlayerPawn p;
    p = PlayerPawn(Other);
    if(p == None) return;
    GetRando();
    rando.PlayerLogin(p);
}

event PreBeginPlay()
{
    log("PreBeginPlay", self.name);
    GetRando();
    rando.RandoAnyEntry();
}
