<%
	// item DB for send mail
//
	// items[index][0] -> item id
	// items[index][1] -> item name
	// items[index][2] -> xml octets for this item
    // items[index][3] -> Mask (default = 1)
    // items[index][4] -> Proctype (soulbound) (default = 0)
    // items[index][5] -> Stacked (default = 1)
    // items[index][6] -> Max Count (default = 1)
    // items[index][7] -> Expires In (default = 0)
// 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ITEM MASK:
// 
// 0 = Not To Be Equipped
// 1 = Weapon
// 2= Helmet
// 4 = Necklace
// 8 = Robe
// 16 = Chest Armor
// 32 = Belt
// 64 = Leg Armor
// 128 = Foot Armor
// 256 = Arm Armor
// 1536 = Ring
// 1536 = Ring
// 2048 = Ammunition
// 4096 = Flyer Mount
// 8192 = Chest Clothing/Fashion
// 16384 = Leg Clothing/Fashion
// 32768 = Foot Clothing/Fashion
// 65536 = Arm Clothing/Fashion
// 131072 = Hierogram
// 262144 = Heaven Book/Tome
// 524288 = Chat Smiley
// 1048576 = HP Charm
// 2097152 = MP Charm
// 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ITEM PROCTYPE:
// 
// 32791 = SoulBound
// 64 = Bind on equipping
// 55 = (? CHRONO KEY){cannot drop , cannot trade , cannot sell to npc}
// 19 = (? FB Tabs){cannot drop , cannot trade}
// 8 = (? Clothing/Binding Charm){}
// 1 = (? Revival Scroll){}
// 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Expire Date:
// value is equal to the unix clock time you want the item to expire
// ie...
// to get current unix time type "date +%s"
// (or... (it) is the time in seconds that have elapsed since 01-01-1970 00:00:00 UTC)
// add the amount of time you want the item to last, in seconds, to current unix time
// (ie. 7 days = 604800 seconds, so you would add 604800 to current time)
// 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//13
	String[][] items = 
	{
		{"Twilight Temple Armor And Accessory Soul Edges", "0", "0", "0", "0", "0", "0", "0"},
		{"15432", "Souledge: Acrobatic Armlets", "0", "0", "0", "1", "1", "0"},
		{"15429", "Souledge: Acrobatic Boots", "0", "0", "0", "1", "1", "0"},
		{"15426", "Souledge: Acrobatic Pants", "0", "0", "0", "1", "1", "0"},
		{"15423", "Souledge: Acrobatic Robe", "0", "0", "0", "1", "1", "0"},
		{"15453", "Souledge: Belt of the Earth", "0", "0", "0", "1", "1", "0"},
		{"15458", "Souledge: Belt of the Stars", "0", "0", "0", "1", "1", "0"},
		{"15457", "Souledge: Belt of the Tides", "0", "0", "0", "1", "1", "0"},
		{"15445", "Souledge: Chintien's Helmet", "0", "0", "0", "1", "1", "0"},
		{"15412", "Souledge: Cuisses of Might", "0", "0", "0", "1", "1", "0"},
		{"15455", "Souledge: Divine Wind Belt", "0", "0", "0", "1", "1", "0"},
		{"15449", "Souledge: Divine Wind Necklace", "0", "0", "0", "1", "1", "0"},
		{"15446", "Souledge: Drum God's Hat", "0", "0", "0", "1", "1", "0"},
		{"15459", "Souledge: Drum God's Ring", "0", "0", "0", "1", "1", "0"},
		{"15415", "Souledge: Greaves of Might", "0", "0", "0", "1", "1", "0"},
		{"15428", "Souledge: Intangible Boots", "0", "0", "0", "1", "1", "0"},
		{"15422", "Souledge: Intangible Robe", "0", "0", "0", "1", "1", "0"},
		{"15431", "Souledge: Intangible Sleeves", "0", "0", "0", "1", "1", "0"},
		{"15425", "Souledge: Intangible Trousers", "0", "0", "0", "1", "1", "0"},
		{"15456", "Souledge: Luna's Belt", "0", "0", "0", "1", "1", "0"},
		{"15450", "Souledge: Luna's Necklace", "0", "0", "0", "1", "1", "0"},
		{"15434", "Souledge: Lunar Chaser Armor", "0", "0", "0", "1", "1", "0"},
		{"15440", "Souledge: Lunar Chaser Boots", "0", "0", "0", "1", "1", "0"},
		{"15443", "Souledge: Lunar Chaser Bracers", "0", "0", "0", "1", "1", "0"},
		{"15437", "Souledge: Lunar Chaser Shins", "0", "0", "0", "1", "1", "0"},
		{"15420", "Souledge: Mountcrasher Bracers", "0", "0", "0", "1", "1", "0"},
		{"15414", "Souledge: Mountcrasher Cuisses", "0", "0", "0", "1", "1", "0"},
		{"15417", "Souledge: Mountcrasher Greaves", "0", "0", "0", "1", "1", "0"},
		{"15411", "Souledge: Mountcrasher Plate", "0", "0", "0", "1", "1", "0"},
		{"15447", "Souledge: Necklace of the Earth", "0", "0", "0", "1", "1", "0"},
		{"15452", "Souledge: Necklace of the Stars", "0", "0", "0", "1", "1", "0"},
		{"15451", "Souledge: Necklace of the Tides", "0", "0", "0", "1", "1", "0"},
		{"15409", "Souledge: Plate of Might", "0", "0", "0", "1", "1", "0"},
		{"15460", "Souledge: Ring of the Naga", "0", "0", "0", "1", "1", "0"},
		{"15444", "Souledge: Skywalker Bracers", "0", "0", "0", "1", "1", "0"},
		{"15435", "Souledge: Skywalker Shell", "0", "0", "0", "1", "1", "0"},
		{"15438", "Souledge: Skywalker Shins", "0", "0", "0", "1", "1", "0"},
		{"15441", "Souledge: Skywalker Shoes", "0", "0", "0", "1", "1", "0"},
		{"15427", "Souledge: Snow Dance Boots", "0", "0", "0", "1", "1", "0"},
		{"15424", "Souledge: Snow Dance Pants", "0", "0", "0", "1", "1", "0"},
		{"15421", "Souledge: Snow Dance Robe", "0", "0", "0", "1", "1", "0"},
		{"15430", "Souledge: Snow Dance Sleeves", "0", "0", "0", "1", "1", "0"},
		{"15454", "Souledge: Sunshine Belt", "0", "0", "0", "1", "1", "0"},
		{"15448", "Souledge: Sunshine Necklace", "0", "0", "0", "1", "1", "0"},
		{"15439", "Souledge: Swiftwind Boots", "0", "0", "0", "1", "1", "0"},
		{"15442", "Souledge: Swiftwind Bracers", "0", "0", "0", "1", "1", "0"},
		{"15433", "Souledge: Swiftwind Chest", "0", "0", "0", "1", "1", "0"},
		{"15436", "Souledge: Swiftwind Shins", "0", "0", "0", "1", "1", "0"},
		{"15419", "Souledge: Tiger Roar Bracers", "0", "0", "0", "1", "1", "0"},
		{"15416", "Souledge: Tiger Roar Greaves", "0", "0", "0", "1", "1", "0"},
		{"15413", "Souledge: Tiger Roar Leggings", "0", "0", "0", "1", "1", "0"},
		{"15410", "Souledge: Tiger Roar Plate", "0", "0", "0", "1", "1", "0"},
		{"15418", "Souledge: Vambraces of Might", "0", "0", "0", "1", "1", "0"},
		{"Twilight Temple Weapon Souledges", "0", "0", "0", "0", "0", "0", "0"},
		{"15387", "Souledge: Abomination", "0", "0", "0", "1", "1", "0"},
		{"15406", "Souledge: Acalanatha Wand", "0", "0", "0", "1", "1", "0"},
		{"15397", "Souledge: Ashura's Sign", "0", "0", "0", "1", "1", "0"},
		{"15343", "Souledge: Beacon Axes", "0", "0", "0", "1", "1", "0"},
		{"15341", "Souledge: Behemoth Axes", "0", "0", "0", "1", "1", "0"},
		{"15326", "Souledge: Behemoth Blade", "0", "0", "0", "1", "1", "0"},
		{"15373", "Souledge: Behemoth Fists", "0", "0", "0", "1", "1", "0"},
		{"15363", "Souledge: Behemoth Spear", "0", "0", "0", "1", "1", "0"},
		{"15366", "Souledge: Blade of Flame", "0", "0", "0", "1", "1", "0"},
		{"15367", "Souledge: Blade of Ghouls", "0", "0", "0", "1", "1", "0"},
		{"15385", "Souledge: Blinding Radiance", "0", "0", "0", "1", "1", "0"},
		{"15402", "Souledge: Broken Dream", "0", "0", "0", "1", "1", "0"},
		{"15371", "Souledge: Buddha Fists", "0", "0", "0", "1", "1", "0"},
		{"15330", "Souledge: Cavalier Scimitar", "0", "0", "0", "1", "1", "0"},
		{"15384", "Souledge: Chained Jail", "0", "0", "0", "1", "1", "0"},
		{"15351", "Souledge: Chaos", "0", "0", "0", "1", "1", "0"},
		{"15358", "Souledge: Consumer of Souls", "0", "0", "0", "1", "1", "0"},
		{"15368", "Souledge: Courage Fists", "0", "0", "0", "1", "1", "0"},
		{"15350", "Souledge: Dark Aura Axes", "0", "0", "0", "1", "1", "0"},
		{"15364", "Souledge: Dark Aura Spear", "0", "0", "0", "1", "1", "0"},
		{"15334", "Souledge: Dark Scimitar", "0", "0", "0", "1", "1", "0"},
		{"15372", "Souledge: Deitnia Fists", "0", "0", "0", "1", "1", "0"},
		{"15360", "Souledge: Desert Thrust", "0", "0", "0", "1", "1", "0"},
		{"15345", "Souledge: Devil Axes", "0", "0", "0", "1", "1", "0"},
		{"15356", "Souledge: Devil Heart", "0", "0", "0", "1", "1", "0"},
		{"15327", "Souledge: Devilblade", "0", "0", "0", "1", "1", "0"},
		{"15375", "Souledge: Divine Touch", "0", "0", "0", "1", "1", "0"},
		{"15336", "Souledge: Dragon Extinguisher", "0", "0", "0", "1", "1", "0"},
		{"15324", "Souledge: Dragonblade", "0", "0", "0", "1", "1", "0"},
		{"15393", "Souledge: Dragonbow", "0", "0", "0", "1", "1", "0"},
		{"15357", "Souledge: Dragonlance", "0", "0", "0", "1", "1", "0"},
		{"15386", "Souledge: Dream Crasher", "0", "0", "0", "1", "1", "0"},
		{"15398", "Souledge: Endless Vague", "0", "0", "0", "1", "1", "0"},
		{"15389", "Souledge: Falling Star", "0", "0", "0", "1", "1", "0"},
		{"15401", "Souledge: Fantasy", "0", "0", "0", "1", "1", "0"},
		{"15382", "Souledge: Flash Crossbow", "0", "0", "0", "1", "1", "0"},
		{"15388", "Souledge: Flashing Glory", "0", "0", "0", "1", "1", "0"},
		{"15404", "Souledge: Garuda's Flame Wing", "0", "0", "0", "1", "1", "0"},
		{"15374", "Souledge: Ghostfists", "0", "0", "0", "1", "1", "0"},
		{"15344", "Souledge: Ghostility Axes", "0", "0", "0", "1", "1", "0"},
		{"15322", "Souledge: Ghostofficer's Choice", "0", "0", "0", "1", "1", "0"},
		{"15396", "Souledge: Grief Breath", "0", "0", "0", "1", "1", "0"},
		{"15339", "Souledge: Heraldry Axes", "0", "0", "0", "1", "1", "0"},
		{"15380", "Souledge: Hurricane Crossbow", "0", "0", "0", "1", "1", "0"},
		{"15353", "Souledge: Jade Spear", "0", "0", "0", "1", "1", "0"},
		{"15342", "Souledge: Lion King Axes", "0", "0", "0", "1", "1", "0"},
		{"15347", "Souledge: Lorebeast", "0", "0", "0", "1", "1", "0"},
		{"15403", "Souledge: Mirage", "0", "0", "0", "1", "1", "0"},
		{"15331", "Souledge: Mirage Scimitar", "0", "0", "0", "1", "1", "0"},
		{"15348", "Souledge: Monarch Axes", "0", "0", "0", "1", "1", "0"},
		{"15365", "Souledge: Monarch Spear", "0", "0", "0", "1", "1", "0"},
		{"15376", "Souledge: Murderous Touch", "0", "0", "0", "1", "1", "0"},
		{"15321", "Souledge: Petrified Femur", "0", "0", "0", "1", "1", "0"},
		{"15352", "Souledge: Petrified Lance", "0", "0", "0", "1", "1", "0"},
		{"15354", "Souledge: Piercer", "0", "0", "0", "1", "1", "0"},
		{"15359", "Souledge: Raging Lion", "0", "0", "0", "1", "1", "0"},
		{"15329", "Souledge: Ravager", "0", "0", "0", "1", "1", "0"},
		{"15333", "Souledge: Sacred Divinity", "0", "0", "0", "1", "1", "0"},
		{"15355", "Souledge: Saw Piercer", "0", "0", "0", "1", "1", "0"},
		{"15405", "Souledge: Scaredevil", "0", "0", "0", "1", "1", "0"},
		{"15328", "Souledge: Scarless Blade", "0", "0", "0", "1", "1", "0"},
		{"15349", "Souledge: Scarlet Axes", "0", "0", "0", "1", "1", "0"},
		{"15332", "Souledge: Scarlet Scimitar", "0", "0", "0", "1", "1", "0"},
		{"15377", "Souledge: Shadowforce", "0", "0", "0", "1", "1", "0"},
		{"15361", "Souledge: Shatterstar Spear", "0", "0", "0", "1", "1", "0"},
		{"15340", "Souledge: Shinroaxes", "0", "0", "0", "1", "1", "0"},
		{"15325", "Souledge: Shinroblade", "0", "0", "0", "1", "1", "0"},
		{"15335", "Souledge: Shinrotwins", "0", "0", "0", "1", "1", "0"},
		{"15337", "Souledge: Skeleton Axes", "0", "0", "0", "1", "1", "0"},
		{"15369", "Souledge: Skywarrior Fists", "0", "0", "0", "1", "1", "0"},
		{"15391", "Souledge: Soul Crusher", "0", "0", "0", "1", "1", "0"},
		{"15383", "Souledge: Soul Freeze", "0", "0", "0", "1", "1", "0"},
		{"15390", "Souledge: Soul Snatcher", "0", "0", "0", "1", "1", "0"},
		{"15370", "Souledge: Soulgatherer Fists", "0", "0", "0", "1", "1", "0"},
		{"15381", "Souledge: Spirit Crossbow", "0", "0", "0", "1", "1", "0"},
		{"15346", "Souledge: Star Axes", "0", "0", "0", "1", "1", "0"},
		{"15394", "Souledge: Striker", "0", "0", "0", "1", "1", "0"},
		{"15378", "Souledge: Swiftwind Crossbow", "0", "0", "0", "1", "1", "0"},
		{"15379", "Souledge: Thunder Crossbow", "0", "0", "0", "1", "1", "0"},
		{"15338", "Souledge: Thunderbolt Axes", "0", "0", "0", "1", "1", "0"},
		{"15392", "Souledge: Unicorn", "0", "0", "0", "1", "1", "0"},
		{"15323", "Souledge: Warriorblade", "0", "0", "0", "1", "1", "0"},
		{"15408", "Souledge: Wheel of Fate Denial", "0", "0", "0", "1", "1", "0"},
		{"15407", "Souledge: Wheel of Life", "0", "0", "0", "1", "1", "0"},
		{"15400", "Souledge: Wraith Conquerer", "0", "0", "0", "1", "1", "0"},
		{"15362", "Souledge: Wrathsoul Spear", "0", "0", "0", "1", "1", "0"},
		{"15395", "Souledge: Xyloedges", "0", "0", "0", "1", "1", "0"},
		{"15399", "Souledge: Yaksa", "0", "0", "0", "1", "1", "0"},
//
	};
%>