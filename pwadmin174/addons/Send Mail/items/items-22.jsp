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
//22
	String[][] items = 
	{
		{"12996", "Mold: Thunderous Frenzy", "0", "0", "0", "1", "1", "0"},
		{"13005", "Mold: Solar Redemption", "0", "0", "0", "1", "1", "0"},
		{"13016", "Mold: Oceanic Sky", "0", "0", "0", "1", "1", "0"},
		{"13017", "Mold: Apocalyptic Tornado", "0", "0", "0", "1", "1", "0"},
		{"13030", "Mold: Sign of Ordinance", "0", "0", "0", "1", "1", "0"},
		{"13041", "Mold: Sovereignty of the Sun", "0", "0", "0", "1", "1", "0"},
		{"13042", "Mold: The Punisher", "0", "0", "0", "1", "1", "0"},
		{"13054", "Mold: Aero-Speeder's Vest", "0", "0", "0", "1", "1", "0"},
		{"13059", "Mold: Cape of Fairy's Delicacy", "0", "0", "0", "1", "1", "0"},
		{"13065", "Mold: Cuisses of Archangel", "0", "0", "0", "1", "1", "0"},
		{"13071", "Mold: Shinguatds of Yuanshi", "0", "0", "0", "1", "1", "0"},
		{"13077", "Mold: Pants of Misty Violet", "0", "0", "0", "1", "1", "0"},
		{"13084", "Mold: Mountain Conquerer Boots", "0", "0", "0", "1", "1", "0"},
		{"13089", "Mold: Boots of Soul Impact", "0", "0", "0", "1", "1", "0"},
		{"13093", "Mold: Burning Sun Bracers", "0", "0", "0", "1", "1", "0"},
		{"13099", "Mold: The Minister's Bracer", "0", "0", "0", "1", "1", "0"},
		{"13106", "Mold: Silent Chord Helm", "0", "0", "0", "1", "1", "0"},
		{"13111", "Mold: Hat of Lunar Gravity", "0", "0", "0", "1", "1", "0"},
		{"13118", "Mold: Thunderstorm Talisman", "0", "0", "0", "1", "1", "0"},
		{"13119", "Mold: Brute Force Talisman", "0", "0", "0", "1", "1", "0"},
		{"13125", "Mold: Bohemian's Mark", "0", "0", "0", "1", "1", "0"},
		{"13131", "Mold: Fairie Power Necklace", "0", "0", "0", "1", "1", "0"},
		{"13137", "Mold: Jade Firestarter", "0", "0", "0", "1", "1", "0"},
		{"13143", "Mold: Wraith Amulet", "0", "0", "0", "1", "1", "0"},
		{"13149", "Mold: Earth Guardian's Seal", "0", "0", "0", "1", "1", "0"},
		{"13156", "Mold: Ring of Brute Strength", "0", "0", "0", "1", "1", "0"},
		{"13157", "Mold: Ring of Perpetual Change", "0", "0", "0", "1", "1", "0"},
		{"13165", "Mold: The Faerie's Secret", "0", "0", "0", "1", "1", "0"},
		{"13166", "Mold: Peaceful Existence", "0", "0", "0", "1", "1", "0"},
		{"13167", "Dragonling Essence", "0", "0", "0", "1", "1", "0"},
//
	};
%>