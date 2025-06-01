# flyPlateBuffs-WotLK
flyPlateBuffs is a legacy addon created by [FlyNeko](https://www.curseforge.com/wow/addons/flyplatebuffs) during Legion.  
This is a backport for WoW 3.3.5a (WotLK) with slight customizations and minor additions.

## Features
- Displays buffs/debuffs above nameplates.  
- Can show specific spells larger than others for better visibility and priority.  
- There’s a predefined list of buffs/debuffs in different categories, which you can edit.  
- Offers many display options to customize the addon to your preferences.

<p align="center">
  <img src="https://raw.githubusercontent.com/KhalGH/flyPlateBuffs-WotLK/refs/heads/assets/assets/flyPlateBuffs_img.jpg" 
       alt="flyPlateBuffs_Img" width="95%">
</p>

## Dependency
This addon requires the **C_NamePlate** `API` and **NAME_PLATE_UNIT** `Events` from Retail, which are not available in WoW 3.3.5a by default.  
Support for this API and Events is provided through the custom library **AwesomeWotlk**, created by [FrostAtom](https://github.com/FrostAtom/awesome_wotlk).  
This backport can optionally use [this fork](https://github.com/KhalGH/awesome_wotlk) that includes additional implementations used by the addon.

## Installation
1. Download the [addon](https://github.com/KhalGH/flyPlateBuffs-WotLK/releases/download/v1.0/flyPlateBuffs-WotLK-v1.0.zip) and the [AwesomeWotlk](https://github.com/KhalGH/flyPlateBuffs-WotLK/releases/download/v1.0/AwesomeWotlk.7z) library.  
2. Extract the `flyPlateBuffs` folder into `World of Warcraft/Interface/AddOns/`.  
3. Extract `AwesomeWotlk.7z` and follow the `Instructions.txt` file to implement it.  
4. Restart the game and enable the addon.

## Disclaimer
Private servers may have specific rules regarding the use of custom libraries like **AwesomeWotlk**.  
Please verify your server’s policy to ensure the library is allowed before using it.

