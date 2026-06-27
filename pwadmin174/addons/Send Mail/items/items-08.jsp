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
//8
	String[][] items = 
	{
		{"Wines", "0", "0", "0", "0", "0", "0", "0"},
		{"13309", "Afterglow Wine (FB 79)", "0", "0", "0", "1", "1", "0"},
		{"13308", "Ancientwell Wine (FB 69)", "0", "0", "0", "1", "1", "0"},
		{"13304", "Bamboo Wine (FB 29)", "0", "0", "0", "1", "1", "0"},
		{"13307", "Chiennan Spring Wine (FB 59)", "0", "0", "0", "1", "1", "0"},
		{"13305", "Daughter's Wine (FB 39)", "0", "0", "0", "1", "1", "0"},
		{"13306", "Frangrances Wine (FB 51)", "0", "0", "0", "1", "1", "0"},
		{"13303", "Osmanthus Wine (FB 19)", "0", "0", "0", "1", "1", "0"},
		{"13311", "Tukang's Wine (FB 89)", "0", "0", "0", "1", "1", "0"},
		{"13310", "Wine of Everlasting Sorrow (FB 99)", "0", "0", "0", "1", "1", "0"},
//
	};
%>