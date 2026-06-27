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
//18
	String[][] items = 
	{
		{"Elite Arrows", "0", "0", "0", "0", "0", "0", "0"},
		{"8551", "Elite Woven Fang Arrow", "0000ffff0000000000000000640000006400000014000000622100000a0000000000000001000000100000000000000001000000e625000001000000", "1073743872", "0", "50000", "50000", "0"},
		{"8552", "Elite Falcon Feather Arrow", "0000ffff000000000000000064000000640000001400000062210000280000000000000004000000100000000000000001000000e625000001000000", "1073743872", "0", "50000", "50000", "0"},
		{"8559", "Elite Pheonix Tail Arrow", "0000ffff000000000000000064000000640000001400000062210000460000000000000007000000100000000000000001000000e625000001000000", "1073743872", "0", "50000", "50000", "0"},
		{"8560", "Elite Dragotenna", "0000ffff00000000000000006400000064000000140000006221000064000000000000000a000000100000000000000001000000e625000001000000", "1073743872", "0", "50000", "50000", "0"},
		{"Elite Bolts", "0", "0", "0", "0", "0", "0", "0"},
		{"8553", "Elite Bone Bolt", "0000ffff0000000000000000640000006400000014000000632100000a0000000000000001000000100000000000000001000000e82500000a000000", "1073743872", "0", "50000", "50000", "0"},
		{"8554", "Elite Iron Bolt", "0000ffff000000000000000064000000640000001400000063210000280000000000000004000000100000000000000001000000e82500000a000000", "1073743872", "0", "50000", "50000", "0"},
		{"8557", "Elite Triple Bladed Bolt", "0000ffff000000000000000064000000640000001400000063210000460000000000000007000000100000000000000001000000e82500000a000000", "1073743872", "0", "50000", "50000", "0"},
		{"8562", "Elite Steel Bolt", "0000ffff00000000000000006400000064000000140000006321000064000000000000000a000000100000000000000001000000e82500000a000000", "1073743872", "0", "50000", "50000", "0"},
		{"Elite Shots", "0", "0", "0", "0", "0", "0", "0"},
		{"8555", "Elite Iron Ore Shot", "0000ffff0000000000000000640000006400000014000000642100000a0000000000000001000000100000000000000001000000e725000005000000", "1073743872", "0", "50000", "50000", "0"},
		{"8556", "Elite Lead Shot", "0000ffff000000000000000064000000640000001400000064210000280000000000000004000000100000000000000001000000e725000005000000", "1073743872", "0", "50000", "50000", "0"},
		{"8558", "Elite Explosive Shot", "0000ffff000000000000000064000000640000001400000064210000460000000000000007000000100000000000000001000000e725000005000000", "1073743872", "0", "50000", "50000", "0"},
		{"8564", "Elite Quake Shot", "0000ffff00000000000000006400000064000000140000006421000064000000000000000a000000100000000000000001000000e725000005000000", "1073743872", "0", "50000", "50000", "0"},
//
	};
%>