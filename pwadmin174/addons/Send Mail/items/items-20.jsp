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
//20
	String[][] items = 
	{
		{"Legendary Weapon Molds", "0", "0", "0", "0", "0", "0", "0"},
		{"12985", "Mold: Sword of Burning Clouds", "0", "0", "0", "1", "1", "0"},
		{"12986", "Mold: Eagle's Claw", "0", "0", "0", "1", "1", "0"},
		{"12987", "Mold: Shady Blade", "0", "0", "0", "1", "1", "0"},
		{"12988", "Mold: Illusive Lunar Cutlass", "0", "0", "0", "1", "1", "0"},
		{"12989", "Mold: Brahma's Lash", "0", "0", "0", "1", "1", "0"},
		{"12990", "Mold: Demonic Rebuttal", "0", "0", "0", "1", "1", "0"},
		{"12992", "Mold: Sound Chaser", "0", "0", "0", "1", "1", "0"},
		{"12993", "Mold: Ghoul Bane", "0", "0", "0", "1", "1", "0"},
		{"12994", "Mold: Massive Champion", "0", "0", "0", "1", "1", "0"},
		{"12995", "Mold: Dragon's Bite", "0", "0", "0", "1", "1", "0"},
		{"12997", "Mold: Radiant Fist", "0", "0", "0", "1", "1", "0"},
		{"12998", "Mold: Sting of Thorns", "0", "0", "0", "1", "1", "0"},
		{"12999", "Mold: Fist of the Arch Devil", "0", "0", "0", "1", "1", "0"},
		{"13001", "Mold: Annihilator of Souls", "0", "0", "0", "1", "1", "0"},
		{"13002", "Mold: Dark Flash", "0", "0", "0", "1", "1", "0"},
		{"13004", "Mold: Dragonfly Assualt Blade", "0", "0", "0", "1", "1", "0"},
		{"13003", "Mold: Fist of Heroism", "0", "0", "0", "1", "1", "0"},
		{"13006", "Mold: Poleaxe of the Righteous", "0", "0", "0", "1", "1", "0"},
		{"13007", "Mold: Handaxes of Demonic Roar", "0", "0", "0", "1", "1", "0"},
		{"13008", "Mold: Xeno's Sledgehammer", "0", "0", "0", "1", "1", "0"},
		{"13009", "Mold: Gale Dual Hammers", "0", "0", "0", "1", "1", "0"},
		{"13010", "Mold: Hefty Poleaxe of Giants", "0", "0", "0", "1", "1", "0"},
		{"13011", "Mold: Calamity Axes of Blood", "0", "0", "0", "1", "1", "0"},
		{"13012", "Mold: Cudgel of Ancient Alloy", "0", "0", "0", "1", "1", "0"},
		{"13015", "Mold: Cudgel of the Barbarian Lord", "0", "0", "0", "1", "1", "0"},
		{"13013", "Mold: Dragon's Vibrancy", "0", "0", "0", "1", "1", "0"},
		{"13014", "Mold: Demonbane", "0", "0", "0", "1", "1", "0"},
		{"13018", "Mold: Flame Wand", "0", "0", "0", "1", "1", "0"},
		{"13019", "Mold: Mirage Sword", "0", "0", "0", "1", "1", "0"},
		{"13020", "Mold: Order of the Stars", "0", "0", "0", "1", "1", "0"},
		{"13021", "Mold: Wheel of Fate", "0", "0", "0", "1", "1", "0"},
		{"13022", "Mold: Fine Pataka of Bodhi", "0", "0", "0", "1", "1", "0"},
		{"13023", "Mold: Dragon's Will", "0", "0", "0", "1", "1", "0"},
		{"13024", "Mold: Sakyamuni's Light", "0", "0", "0", "1", "1", "0"},
		{"13025", "Mold: Glaives of Divinity", "0", "0", "0", "1", "1", "0"},
		{"13028", "Mold: Requiem Blade", "0", "0", "0", "1", "1", "0"},
		{"13026", "Mold: Midnight Black", "0", "0", "0", "1", "1", "0"},
		{"13027", "Mold: Demon Thunder", "0", "0", "0", "1", "1", "0"},
		{"13029", "Mold: Aura of Buddha", "0", "0", "0", "1", "1", "0"},
		{"13031", "Mold: Moonlight Bow", "0", "0", "0", "1", "1", "0"},
		{"13032", "Mold: Lightcatcher", "0", "0", "0", "1", "1", "0"},
		{"13033", "Mold: Sinister Shooter", "0", "0", "0", "1", "1", "0"},
		{"13034", "Mold: The Penetrator", "0", "0", "0", "1", "1", "0"},
		{"13035", "Mold: Solarslayer", "0", "0", "0", "1", "1", "0"},
		{"13036", "Mold: Wind and the Clouds", "0", "0", "0", "1", "1", "0"},
		{"13037", "Mold: Guardian of the Realm", "0", "0", "0", "1", "1", "0"},
		{"13039", "Mold: Windcatcher", "0", "0", "0", "1", "1", "0"},
		{"13040", "Mold: Burst of Vacuity", "0", "0", "0", "1", "1", "0"},
		{"13038", "Mold: Demonic Whirlwind", "0", "0", "0", "1", "1", "0"},
		{"14069", "Mold: Beaconfires", "0", "0", "0", "1", "1", "0"},
		{"26425", "Mold: Soulreaper Blade", "0", "0", "0", "1", "1", "0"},
		{"26426", "Mold: Screamer Dual Thorns", "0", "0", "0", "1", "1", "0"},
		{"26427", "Mold: Dissector Dagger", "0", "0", "0", "1", "1", "0"},
		{"26428", "Mold: Cloud Thorn", "0", "0", "0", "1", "1", "0"},
		{"26429", "Mold: Evilstare Dual Daggers", "0", "0", "0", "1", "1", "0"},
		{"26430", "Mold: Shadow Legend", "0", "0", "0", "1", "1", "0"},
		{"26431", "Mold: Glowfall Wings", "0", "0", "0", "1", "1", "0"},
		{"26432", "Mold: Lunarwave Soulsphere", "0", "0", "0", "1", "1", "0"},
		{"26433", "Mold: Snowflake Soulsphere", "0", "0", "0", "1", "1", "0"},
		{"26434", "Mold: Bluemoon Souldrill", "0", "0", "0", "1", "1", "0"},
		{"26435", "Mold: Phoenix Soulsphere", "0", "0", "0", "1", "1", "0"},
		{"26436", "Mold: Radiant Souldrill", "0", "0", "0", "1", "1", "0"},
		{"26437", "Mold: Bloodpain Soulglaive", "0", "0", "0", "1", "1", "0"},
		{"26438", "Mold: Skyshaker Soulglaive", "0", "0", "0", "1", "1", "0"},
//
	};
%>