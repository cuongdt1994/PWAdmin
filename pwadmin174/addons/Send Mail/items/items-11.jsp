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
//11
	String[][] items = 
	{
		{"19148", "Advanced Mystical Page", "0", "0", "0", "9999", "9999", "0"},
		{"20746", "Apocalypse Page", "0", "0", "0", "100", "100", "0"},
		{"20747", "Chrono Page", "0", "0", "0", "100", "100", "0"},
		{"23943", "COF Directorate Secret Letter", "0", "0", "0", "9999", "9999", "0"},
		{"19236", "Crab Meat Jiaozi", "ac0d00000a000000102700004b000000", "0", "0", "9999", "9999", "0"},
		{"20447", "Dexterity Material", "0", "0", "0", "1000", "1000", "0"},
		{"24410", "Fantasy Fruit", "334a0000", "0", "16403", "1", "1", "0"},
		{"5382", "Makeover Scroll", "0", "0", "8", "1", "1", "0"},
		{"14353", "Martial Arts Scroll", "0", "0", "0", "10", "10", "0"},
		{"18186", "Mysterious Page", "0", "0", "8", "99999", "99999", "0"},
		{"18185", "Mystical Tome Page", "0", "0", "8", "99999", "99999", "0"},
		{"20444", "Power Material", "0", "0", "0", "1000", "1000", "0"},
		{"12831", "Scarlet Fruit", "ad180000", "0", "0", "0", "0", "0"},
		{"20446", "Spirit Material", "0", "0", "0", "1000", "1000", "0"},
		{"20445", "Stamina Material", "0", "0", "0", "1000", "1000", "0"},
		{"21652", "Ten Million Big Note", "00000a000f00a000", "0", "0", "1000", "1000", "0"},
//
	};
%>