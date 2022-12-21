# dnf2001-randomizer

Install [the DNF2001 Restoration Project](https://www.moddb.com/mods/dnf2001-restoration-project/downloads/duke-nukem-restoration-first-slice-10).

Download [DNFRando.u](https://github.com/Die4Ever/dnf2001-randomizer/raw/main/DNFRando.u) into your game's `System` folder.

Edit your `DukeForever.ini` in your Player directory, like `Players\Die4Ever\DukeForever.ini`

Change `UDesktopClassName` from `UDesktopClassName=dnWindow.UDukeDesktopWindow` to `UDesktopClassName=DNFRando.DNFRandoDesktop`

Now when you click New Game, the title of the pop-up window should say "Rando New Game Selection". Items and characters will be swapped around.

## For Developers to Compile

Open `System\DukeEd.exe` in the game folder, go to the Actor Classes tab, and do File -> Export All Scripts. Now you can close DukeEd. Copy the DNFRando folder into the game's folder. Edit the config `System\default.ini`

Comment out the line `EditPackages=Editor` by putting a semicolon in front of it, like `;EditPackages=Editor`, and at the bottom of the section right below `EditPackages=brushes\EditorTools` add the line `EditPackages=DNFRando`

Now you can run `del DNFRando.u & ucc make` to compile.
