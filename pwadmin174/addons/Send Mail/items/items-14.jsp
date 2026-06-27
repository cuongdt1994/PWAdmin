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
//14
	String[][] items = 
	{
		{"Frostcovered City Materials", "0", "0", "0", "0", "0", "0", "0"},
		{"16596", "Aeolianol", "0", "0", "0", "100", "100", "0"},
		{"16629", "Aeolianol Fragment", "0", "0", "0", "100", "100", "0"},
		{"16612", "Arcance Plate Shard", "0", "0", "0", "100", "100", "0"},
		{"16579", "Arcane Plate", "0", "0", "0", "100", "100", "0"},
		{"16633", "Blizzard Fragment", "0", "0", "0", "100", "100", "0"},
		{"16635", "Blizzard Heart", "0", "0", "0", "100", "100", "0"},
		{"16634", "Blizzard Stamp", "0", "0", "0", "100", "100", "0"},
		{"16595", "Broken Soul", "0", "0", "0", "100", "100", "0"},
		{"16628", "Broken Soul Fragment", "0", "0", "0", "100", "100", "0"},
		{"16622", "Broken Styren Axe", "0", "0", "0", "100", "100", "0"},
		{"16593", "Devourer's Bone", "0", "0", "0", "100", "100", "0"},
		{"16626", "Devourer's Bone Fragment", "0", "0", "0", "100", "100", "0"},
		{"16582", "Devourer's Relics", "0", "0", "0", "100", "100", "0"},
		{"16615", "Devourer's Relics Fragment", "0", "0", "0", "100", "100", "0"},
		{"16618", "Dying Might", "0", "0", "0", "100", "100", "0"},
		{"16606", "Flora Grave", "0", "0", "0", "100", "100", "0"},
		{"16584", "Flora Plume", "0", "0", "0", "100", "100", "0"},
		{"16617", "Flora Plume Fragment", "0", "0", "0", "100", "100", "0"},
		{"16735", "Frost Jail Key", "0", "0", "0", "30", "30", "0"},
		{"16608", "Frost Stamp Right Part", "0", "0", "0", "100", "100", "0"},
		{"16590", "Frostedge Axe", "0", "0", "0", "100", "100", "0"},
		{"16623", "Frostedge Axe Shard", "0", "0", "0", "100", "100", "0"},
		{"16636", "Glacier Seal Fragment", "0", "0", "0", "100", "100", "0"},
		{"16601", "Howling Soul", "0", "0", "0", "100", "100", "0"},
		{"16605", "Impact", "0", "0", "0", "100", "100", "0"},
		{"16316", "Jade of Chih Essence", "0", "0", "0", "100", "100", "0"},
		{"16309", "Jade of Chih Fragment", "0", "0", "0", "100", "100", "0"},
		{"16317", "Jade of Hsin Essence", "0", "0", "0", "100", "100", "0"},
		{"16310", "Jade of Hsin Fragment", "0", "0", "0", "100", "100", "0"},
		{"16313", "Jade of Jin Essence", "0", "0", "0", "100", "100", "0"},
		{"16306", "Jade of Jin Fragment", "0", "0", "0", "100", "100", "0"},
		{"16314", "Jade of Li Essence", "0", "0", "0", "100", "100", "0"},
		{"16308", "Jade of Li Fragment", "0", "0", "0", "100", "100", "0"},
		{"16318", "Jade of Ming Essence", "0", "0", "0", "100", "100", "0"},
		{"16311", "Jade of Ming Fragment", "0", "0", "0", "100", "100", "0"},
		{"16319", "Jade of Tao Essence", "0", "0", "0", "100", "100", "0"},
		{"16312", "Jade of Tao Fragment", "0", "0", "0", "100", "100", "0"},
		{"16315", "Jade of Yi Essence", "0", "0", "0", "100", "100", "0"},
		{"16307", "Jade of Yi Fragment", "0", "0", "0", "100", "100", "0"},
		{"16585", "Might of Emperor", "0", "0", "0", "100", "100", "0"},
		{"16586", "Rage of Rebels", "0", "0", "0", "100", "100", "0"},
		{"16604", "Rebellion Seal", "0", "0", "0", "100", "100", "0"},
		{"16619", "Rebels' Injustice", "0", "0", "0", "100", "100", "0"},
		{"16597", "Seelenol", "0", "0", "0", "100", "100", "0"},
		{"16630", "Seelenol Fragment", "0", "0", "0", "100", "100", "0"},
		{"16600", "Sign of Antiquity", "0", "0", "0", "100", "100", "0"},
		{"16631", "Soul of Frost", "0", "0", "0", "100", "100", "0"},
		{"16578", "Styren's Shield", "0", "0", "0", "100", "100", "0"},
		{"16611", "Styren's Shield Shard", "0", "0", "0", "100", "100", "0"},
		{"16589", "Styren's Spear", "0", "0", "0", "100", "100", "0"},
		{"25153", "The Past of Frostcovered City", "0", "0", "0", "100", "100", "0"},
		{"16650", "Ultimate Orbs", "0", "0", "0", "100", "100", "0"},
		{"16583", "Waterproof Orb", "0", "0", "0", "100", "100", "0"},
		{"16616", "Waterproof Orb Shard", "0", "0", "0", "100", "100", "0"},
		{"16594", "Waterproof Spear", "0", "0", "0", "100", "100", "0"},
		{"16627", "Waterproof Spear Fragment", "0", "0", "0", "100", "100", "0"},
//
	};
%>