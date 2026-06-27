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
//5
	String[][] items = 
	{
		{"Materials", "0", "0", "0", "0", "0", "0", "0"},
		{"6758", "Amulet Wood", "0", "0", "0", "100", "100", "0"},
		{"830", "Animal Fur", "0", "0", "0", "100", "100", "0"},
		{"817", "Anthracite", "0", "0", "0", "100", "100", "0"},
		{"813", "Azureworm Silk", "0", "0", "0", "100", "100", "0"},
		{"6760", "Buddha Wood", "0", "0", "0", "100", "100", "0"},
		{"818", "Charcoal", "0", "0", "0", "100", "100", "0"},
		{"6765", "Cloudflow Muslin", "0", "0", "0", "100", "100", "0"},
		{"816", "Coal", "0", "0", "0", "100", "100", "0"},
		{"815", "Coal Dust", "0", "0", "0", "100", "100", "0"},
		{"823", "Colored Glue", "0", "0", "0", "100", "100", "0"},
		{"829", "Compacted Glaze", "0", "0", "0", "100", "100", "0"},
		{"827", "Compound Oil", "0", "0", "0", "100", "100", "0"},
		{"812", "Compound Thread", "0", "0", "0", "100", "100", "0"},
		{"821", "Concentrated Glue", "0", "0", "0", "100", "100", "0"},
		{"6754", "Copper Bar", "0", "0", "0", "100", "100", "0"},
		{"808", "Corundum Powder", "0", "0", "0", "100", "100", "0"},
		{"810", "Cotton Thread", "0", "0", "0", "100", "100", "0"},
		{"819", "Extruded Charcoal", "0", "0", "0", "100", "100", "0"},
		{"797", "Fine Lumber", "0", "0", "0", "100", "100", "0"},
		{"828", "Glaze", "0", "0", "0", "100", "100", "0"},
		{"809", "Granite", "0", "0", "0", "100", "100", "0"},
		{"806", "Gravel", "0", "0", "0", "100", "100", "0"},
		{"825", "Grease", "0", "0", "0", "100", "100", "0"},
		{"6762", "Hard Rim Muslin", "0", "0", "0", "100", "100", "0"},
		{"804", "High Alloy Steel", "0", "0", "0", "100", "100", "0"},
		{"801", "High-carbon Steel", "0", "0", "0", "100", "100", "0"},
		{"798", "High-grade Lumber", "0", "0", "0", "100", "100", "0"},
		{"6755", "Hsuan Iron Bar", "0", "0", "0", "100", "100", "0"},
		{"6759", "Hsuan Wood", "0", "0", "0", "100", "100", "0"},
		{"832", "Leather", "0", "0", "0", "100", "100", "0"},
		{"6763", "Locust Wing Muslin", "0", "0", "0", "100", "100", "0"},
		{"795", "Logs", "0", "0", "0", "100", "100", "0"},
		{"799", "Lumber Essence", "0", "0", "0", "100", "100", "0"},
		{"6756", "Mythril Bar", "0", "0", "0", "100", "100", "0"},
		{"820", "Organic Glue", "0", "0", "0", "100", "100", "0"},
		{"800", "Pig Iron", "0", "0", "0", "100", "100", "0"},
		{"826", "Purified Oil", "0", "0", "0", "100", "100", "0"},
		{"802", "Refined Steel", "0", "0", "0", "100", "100", "0"},
		{"833", "Reinforced Leather", "0", "0", "0", "100", "100", "0"},
		{"831", "Rough Fur", "0", "0", "0", "100", "100", "0"},
		{"796", "Rough Lumber", "0", "0", "0", "100", "100", "0"},
		{"807", "Rubstone Powder", "0", "0", "0", "100", "100", "0"},
		{"805", "Sandstone", "0", "0", "0", "100", "100", "0"},
		{"811", "Silk Thread", "0", "0", "0", "100", "100", "0"},
		{"803", "Steel Alloy", "0", "0", "0", "100", "100", "0"},
		{"822", "Strong Glue", "0", "0", "0", "100", "100", "0"},
		{"824", "Super Glue", "0", "0", "0", "100", "100", "0"},
		{"834", "Superior Leather", "0", "0", "0", "100", "100", "0"},
		{"6761", "Sutra Wood", "0", "0", "0", "100", "100", "0"},
		{"814", "Vega String", "0", "0", "0", "100", "100", "0"},
		{"6764", "Willow Muslin", "0", "0", "0", "100", "100", "0"},
		{"6757", "Wrought Gold Bar", "0", "0", "0", "100", "100", "0"},
		{"Jade", "0", "0", "0", "0", "0", "0", "0"},
		{"781", "Blue Jade", "0", "0", "0", "1000", "1000", "0"},
		{"780", "Broken Blue Jade", "0", "0", "0", "1000", "1000", "0"},
		{"782", "Broken Cyan Jade", "0", "0", "0", "1000", "1000", "0"},
		{"771", "Broken Orange Jade", "0", "0", "0", "1000", "1000", "0"},
		{"773", "Broken Red Jade", "0", "0", "0", "1000", "1000", "0"},
		{"775", "Broken Verdant Jade", "0", "0", "0", "1000", "1000", "0"},
		{"778", "Broken Yellow Jade", "0", "0", "0", "1000", "1000", "0"},
		{"783", "Cyan Jade", "0", "0", "0", "1000", "1000", "0"},
		{"772", "Orange Jade", "0", "0", "0", "1000", "1000", "0"},
		{"774", "Red Jade", "0", "0", "0", "1000", "1000", "0"},
		{"776", "Verdant Jade", "0", "0", "0", "1000", "1000", "0"},
		{"779", "Yellow Jade", "0", "0", "0", "1000", "1000", "0"},
//
	};
%>