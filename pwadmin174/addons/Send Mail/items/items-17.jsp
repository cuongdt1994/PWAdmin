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
//17
	String[][] items = 
	{
		{"Dragon Quest Items", "0", "0", "0", "0", "0", "0", "0"},
		{"8127", "Beast Bone", "0", "0", "100", "100", "0", "0"},
		{"8168", "Compound Venom", "0", "0", "100", "100", "0", "0"},
		{"8138", "Deadly Venom", "0", "0", "100", "100", "0", "0"},
		{"8155", "Element Core", "0", "0", "100", "100", "0", "0"},
		{"8125", "Element Crystal", "0", "0", "100", "100", "0", "0"},
		{"8145", "Element Diamond", "0", "0", "100", "100", "0", "0"},
		{"8135", "Element Essence", "0", "0", "100", "100", "0", "0"},
		{"8165", "Element Light", "0", "0", "100", "100", "0", "0"},
		{"8167", "Fine Orb", "0", "0", "100", "100", "0", "0"},
		{"8152", "Flat Peach", "0", "0", "100", "100", "0", "0"},
		{"8137", "Flexible Sinew", "0", "0", "100", "100", "0", "0"},
		{"8124", "Ghost Charm", "0", "0", "100", "100", "0", "0"},
		{"8172", "Ginseng Fruit", "0", "0", "100", "100", "0", "0"},
		{"8162", "Jade Juyi", "0", "0", "100", "100", "0", "0"},
		{"8158", "Lethal Venom", "0", "0", "100", "100", "0", "0"},
		{"8123", "Mystical Eye", "0", "0", "100", "100", "0", "0"},
		{"12753", "Mystical Mask", "0", "0", "100", "100", "0", "0"},
		{"12756", "Mystical Orb", "0", "0", "100", "100", "0", "0"},
		{"12754", "Mystical Scale", "0", "0", "100", "100", "0", "0"},
		{"12755", "Mystical Totem", "0", "0", "100", "100", "0", "0"},
		{"8154", "Oblivion Soup", "0", "0", "100", "100", "0", "0"},
		{"8132", "Pendant of Glacia", "0", "0", "100", "100", "0", "0"},
		{"8144", "Seele Token", "0", "0", "100", "100", "0", "0"},
		{"8147", "Sharp Tooth", "0", "0", "100", "100", "0", "0"},
		{"8128", "Strong Acid", "0", "0", "100", "100", "0", "0"},
		{"8148", "Strong Venom", "0", "0", "100", "100", "0", "0"},
		{"8157", "Tusk", "0", "0", "100", "100", "0", "0"},
		{"8164", "Underspring Water", "0", "0", "100", "100", "0", "0"},
		{"8142", "Violet Glass", "0", "0", "100", "100", "0", "0"},
		{"8134", "Yin-Yang Charm", "0", "0", "100", "100", "0", "0"},
		{"Dragon Quest Cases", "0", "0", "0", "0", "0", "0", "0"},
		{"11408", "Dragon Scale Case", "0", "0", "1", "1", "0", "0"},
		{"11409", "Dragon Horn Case", "0", "0", "1", "1", "0", "0"},
		{"11410", "Dragon Antenna Case", "0", "0", "1", "1", "0", "0"},
		{"11411", "Dragon Claw Case", "0", "0", "1", "1", "0", "0"},
		{"11412", "Dragon Tail Case", "fa120000", "0", "1", "1", "0", "0"},
		{"11413", "Dragon Tooth Case", "fb120000", "0", "1", "1", "0", "0"},
		{"11414", "Dragon Eye Case", "fc120000", "0", "1", "1", "0", "0"},
		{"11415", "Dragon Saliva Case", "fd120000", "0", "1", "1", "0", "0"},
		{"11416", "Dragon Bone Case", "fe120000", "0", "1", "1", "0", "0"},
		{"11417", "Dragon Blood Case", "ff120000", "0", "1", "1", "0", "0"},
		{"11418", "Dragon Sinew Case", "130000", "0", "1", "1", "0", "0"},
		{"11419", "Dragon Marrow Case", "1130000", "0", "1", "1", "0", "0"},
		{"Dragon Orders", "0", "0", "0", "0", "0", "0", "0"},
		{"11270", "Gold Dragon Order", "0", "0", "1000", "1000", "0", "0"},
		{"11272", "Copper Dragon Order", "0", "0", "1000", "1000", "0", "0"},
		{"11271", "Silver Dragon Order", "0", "0", "1000", "1000", "0", "0"},
		{"Blood", "0", "0", "0", "0", "0", "0", "0"},
		{"14111", "Celestial Being Blood", "0", "0", "100", "100", "0", "0"},
		{"14097", "Claw Blood", "0", "0", "100", "100", "0", "0"},
		{"14104", "Commander Blood", "0", "0", "100", "100", "0", "0"},
		{"14117", "Demon Blood", "0", "0", "100", "100", "0", "0"},
		{"14114", "Earthen Sould Blood", "0", "0", "100", "100", "0", "0"},
		{"14112", "Fiend Blood", "0", "0", "100", "100", "0", "0"},
		{"14098", "Phantom Blood", "0", "0", "100", "100", "0", "0"},
		{"14110", "Pirate Blood", "0", "0", "100", "100", "0", "0"},
		{"14107", "Sacred Beast Blood", "0", "0", "100", "100", "0", "0"},
		{"14109", "Underworld Blood", "0", "0", "100", "100", "0", "0"},
		{"14096", "Xenobeast Blood", "0", "0", "100", "100", "0", "0"},
//
	};
%>