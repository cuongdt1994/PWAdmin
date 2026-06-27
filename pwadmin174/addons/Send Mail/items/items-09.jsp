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
//9
	String[][] items = 
	{
		{"Oracles", "0", "0", "0", "0", "0", "0", "0"},
		{"7738", "Oracle I (LvL 30 Striped Spider King)", "1c080000", "0", "0", "30", "30", "0"},
		{"7739", "Oracle II (LvL 35 Wicked Pirate)", "b7070000", "0", "0", "30", "30", "0"},
		{"7740", "Oracle III (LvL 40 Mythical Wolfkin)", "c0070000", "0", "0", "30", "30", "0"},
		{"7741", "Oracle IV (LvL 45 Devourer of the Sky)", "c9070000", "0", "0", "30", "30", "0"},
		{"7742", "Oracle V (LvL 50 Bloodlust Feligar)", "d2070000", "0", "0", "30", "30", "0"},
		{"7743", "Oracle VI (LvL 55 Aerox Divebomber)", "dc070000", "0", "0", "30", "30", "0"},
		{"7744", "Oracle VII (LvL 60 Sori Dualhammer)", "e5070000", "0", "0", "30", "30", "0"},
		{"7745", "Oracle VIII (LvL 65 Sori Dualhammer)", "ee070000", "0", "0", "30", "30", "0"},
		{"7746", "Oracle IX (LvL 70 Eidomas General)", "f7070000", "0", "0", "30", "30", "0"},
		{"7747", "Oracle X (LvL 75 White Pheasant)", "0", "0", "0", "30", "30", "0"},
		{"7748", "Oracle XI (LvL 80 Grinning Cougaret)", "0a080000", "0", "0", "30", "30", "0"},
		{"7749", "Oracle XII (LvL 85 Acephalid Blade Major)", "0", "0", "0", "30", "30", "0"},
		{"8808", "Oracle XIII (LvL 90 Dominator Leoclaw)", "25080000", "0", "0", "30", "30", "0"},
//
	};
%>