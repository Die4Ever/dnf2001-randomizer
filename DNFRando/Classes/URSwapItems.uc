class URSwapItems extends URActorsBase;

simulated function FirstEntry()
{
    SwapAll(class'Inventory', 100);
    SwapAll(class'AIPawn', 100);
}
