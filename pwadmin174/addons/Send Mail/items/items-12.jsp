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
//12
	String[][] items = 
	{
		{"Twilight Temple Materials", "0", "0", "0", "0", "0", "0", "0"},
		{"15271", "Ancient Devil's Horn", "0", "0", "0", "20", "20", "0"},
		{"15278", "Ancient Devil's Soul", "0", "0", "0", "20", "20", "0"},
		{"15244", "Ancient Serpent's Blood", "0", "0", "0", "20", "20", "0"},
		{"15252", "Ancient Serpent's Orb", "0", "0", "0", "20", "20", "0"},
		{"15234", "Ancient Serpent's Skin", "0", "0", "0", "20", "20", "0"},
		{"15267", "Antenna of Consumer of Souls", "0", "0", "0", "20", "20", "0"},
		{"15270", "Astral Stone", "0", "0", "0", "20", "20", "0"},
		{"15228", "Broken Drum", "0", "0", "0", "20", "20", "0"},
		{"15235", "Broken Shard of Gold Armor", "0", "0", "0", "20", "20", "0"},
		{"15230", "Chientien's Armor Shard", "0", "0", "0", "20", "20", "0"},
		{"15227", "Chientien's Edge", "0", "0", "0", "20", "20", "0"},
		{"15239", "Chin's Plate", "0", "0", "0", "20", "20", "0"},
		{"15248", "Claw of Consumer of Souls", "0", "0", "0", "20", "20", "0"},
		{"20451", "Desert Tower Miniature", "0", "0", "0", "1000", "1000", "0"},
		{"15272", "Dust of Devil", "0", "0", "0", "20", "20", "0"},
		{"15265", "Dust of Stars", "0", "0", "0", "20", "20", "0"},
		{"15302", "Empire's Back Image", "0", "0", "0", "20", "20", "0"},
		{"15304", "Empire's Sigh", "0", "0", "0", "20", "20", "0"},
		{"15281", "Evil Minion's Axe Edge", "0", "0", "0", "20", "20", "0"},
		{"15284", "Evil Minion's Burning Heart", "0", "0", "0", "20", "20", "0"},
		{"15260", "Evil Minion's Horn", "0", "0", "0", "20", "20", "0"},
		{"15273", "Evil Minion's Shell", "0", "0", "0", "20", "20", "0"},
		{"15246", "Feng's Black Armor", "0", "0", "0", "20", "20", "0"},
		{"15249", "Feng's Iron Bars", "0", "0", "0", "20", "20", "0"},
		{"15254", "Feng's Steel Armor", "0", "0", "0", "20", "20", "0"},
		{"15259", "Forshura's Arm", "0", "0", "0", "20", "20", "0"},
		{"15236", "Forshura's Armor", "0", "0", "0", "20", "20", "0"},
		{"15237", "Forshura's Black Orb", "0", "0", "0", "20", "20", "0"},
		{"15243", "Forshura's Hook", "0", "0", "0", "20", "20", "0"},
		{"15231", "Framework of Drum", "0", "0", "0", "20", "20", "0"},
		{"15241", "Frenzy Lion's Claw", "0", "0", "0", "20", "20", "0"},
		{"15257", "Frenzy Lion's Edge", "0", "0", "0", "20", "20", "0"},
		{"15233", "Frenzy Lion's Skin", "0", "0", "0", "20", "20", "0"},
		{"15290", "Ghost Lord's Dark Aura", "0", "0", "0", "20", "20", "0"},
		{"15287", "Ghost Lord's Power", "0", "0", "0", "20", "20", "0"},
		{"15300", "Ghost Lord's Protection", "0", "0", "0", "20", "20", "0"},
		{"15266", "Ghost Lord's Ribbon", "0", "0", "0", "20", "20", "0"},
		{"15255", "Giant Ape's Palm", "0", "0", "0", "20", "20", "0"},
		{"15250", "Giant Ape's Skin", "0", "0", "0", "20", "20", "0"},
		{"15264", "Giant Ape's Tail", "0", "0", "0", "20", "20", "0"},
		{"15247", "Giant Ape's Tooth", "0", "0", "0", "20", "20", "0"},
		{"15268", "Giant Beast's Armor", "0", "0", "0", "20", "20", "0"},
		{"15289", "Giant Beast's Black Aura", "0", "0", "0", "20", "20", "0"},
		{"15291", "Giant Beast's Crimson Horn", "0", "0", "0", "20", "20", "0"},
		{"15301", "Giant Beast's Footprint", "0", "0", "0", "20", "20", "0"},
		{"15276", "Giant Beast's Shell", "0", "0", "0", "20", "20", "0"},
		{"15282", "Giant Pincers of Darkness", "0", "0", "0", "20", "20", "0"},
		{"15309", "Golden Mask", "0", "0", "0", "20", "20", "0"},
		{"15253", "Golden Spirit", "0", "0", "0", "20", "20", "0"},
		{"15311", "Heart of Nature", "0", "0", "0", "20", "20", "0"},
		{"15261", "Horn of Feng's horse", "0", "0", "0", "20", "20", "0"},
		{"15306", "Illusion Lord's Stone", "0", "0", "0", "20", "20", "0"},
		{"15298", "Illusion Spring", "0", "0", "0", "20", "20", "0"},
		{"15307", "Illusion Stone", "0", "0", "0", "20", "20", "0"},
		{"15258", "Iron Plate of Darkness", "0", "0", "0", "20", "20", "0"},
		{"15256", "Klunky Sword", "0", "0", "0", "50", "50", "0"},
		{"15251", "Mane of Consumer of Souls", "0", "0", "0", "20", "20", "0"},
		{"15295", "Minister's Stone", "0", "0", "0", "20", "20", "0"},
		{"15296", "Monarch's Will", "0", "0", "0", "20", "20", "0"},
		{"15238", "Mysterious Skull", "0", "0", "0", "50", "50", "0"},
		{"15229", "Piece of Skeleton", "0", "0", "0", "50", "50", "0"},
		{"15277", "Power of the Seven Luminaries", "0", "0", "0", "20", "20", "0"},
		{"15274", "Sacred Mother's Aura", "0", "0", "0", "20", "20", "0"},
		{"15288", "Sacred Mother's Heart", "0", "0", "0", "20", "20", "0"},
		{"15263", "Sacred Mother's Orb", "0", "0", "0", "20", "20", "0"},
		{"15285", "Sacred Mother's Stone", "0", "0", "0", "20", "20", "0"},
		{"15280", "Shards of Darkness", "0", "0", "0", "20", "20", "0"},
		{"15308", "Sign of Twilight", "0", "0", "0", "50", "50", "0"},
		{"15293", "Skaidread's Edge", "0", "0", "0", "20", "20", "0"},
		{"15292", "Skaidread's Orb", "0", "0", "0", "20", "20", "0"},
		{"15286", "Sorceress's Aura", "0", "0", "0", "20", "20", "0"},
		{"15262", "Sorceress's Hand", "0", "0", "0", "20", "20", "0"},
		{"15283", "Sorceress's Hearwear", "0", "0", "0", "20", "20", "0"},
		{"15299", "Sorceress's Soul", "0", "0", "0", "20", "20", "0"},
		{"15242", "Soulgatherer's Mirror", "0", "0", "0", "20", "20", "0"},
		{"15232", "Soulgatherer's Tentacle", "0", "0", "0", "20", "20", "0"},
		{"15279", "Stone of Sacred Temple", "0", "0", "0", "50", "50", "0"},
		{"15275", "Touch of the Seven Luminaries", "0", "0", "0", "20", "20", "0"},
		{"15245", "Tough Shard of Gold Armor", "0", "0", "0", "20", "20", "0"},
		{"15294", "Tsu's Ghost Mask", "0", "0", "0", "20", "20", "0"},
		{"15303", "Tsuchun's Dark Soul", "0", "0", "0", "20", "20", "0"},
		{"15297", "Tsuchun's Silk Whip", "0", "0", "0", "20", "20", "0"},
		{"15305", "Tsuchung's Blazing Wings", "0", "0", "0", "20", "20", "0"},
		{"15310", "Twilight Scepter", "0", "0", "0", "20", "20", "0"},
		{"15461", "Ultimate Substance", "0", "0", "0", "100", "100", "0"},
		{"15240", "War Drum", "0", "0", "0", "20", "20", "0"},
		{"15269", "Wheel of the Seven Luminaries", "0", "0", "0", "20", "20", "0"},
//
	};
%>