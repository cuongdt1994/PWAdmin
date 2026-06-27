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
//7
	String[][] items = 
	{
		{"Chi Stones", "0", "0", "0", "0", "0", "0", "0"},
		{"5636", "Chihsing Stone", "0", "0", "0", "1000", "1000", "0"},
		{"5638", "Chiukung Stone", "0", "0", "0", "1000", "1000", "0"},
		{"5631", "Liangyi Stone", "0", "0", "0", "1000", "1000", "0"},
		{"5635", "Liuho Stone", "0", "0", "0", "1000", "1000", "0"},
		{"5637", "Pakua Stone", "0", "0", "0", "1000", "1000", "0"},
		{"5639", "Perfect Stone", "0", "0", "0", "1000", "1000", "0"},
		{"5632", "Santsai Stone", "0", "0", "0", "1000", "1000", "0"},
		{"5633", "Ssuhsiang Stone", "0", "0", "0", "1000", "1000", "0"},
		{"5634", "Wuhsing Stone", "0", "0", "0", "1000", "1000", "0"},
		{"5630", "Yiyuan Stone", "0", "0", "0", "1000", "1000", "0"},
		{"Physical Attack Charms", "0", "0", "0", "0", "0", "0", "0"},
		{"1208", "Blade Charm", "000001000f000500", "0", "0", "500", "500", "0"},
		{"1222", "Elite Blade Charm", "000003000f001900", "0", "0", "500", "500", "0"},
		{"12376", "Elite Stormseeker Charm", "000006000f005000", "0", "0", "500", "500", "0"},
		{"12377", "Radiant Blade Charm", "000007000f006400", "0", "0", "500", "500", "0"},
		{"8039", "Stormseeker Charm", "000004000f002800", "0", "0", "500", "500", "0"},
		{"1221", "Superior Rending Charm", "000002000f000a00", "0", "0", "500", "500", "0"},
		{"8040", "Superior Stormseeker Charm", "000005000f003c00", "0", "0", "500", "500", "0"},
		{"Magical Attack Charms", "0", "0", "0", "0", "0", "0", "0"},
		{"8037", "Charged Charm", "010004000f003200", "0", "0", "500", "500", "0"},
		{"12365", "Elite Charged charm", "010006000f005f00", "0", "0", "500", "500", "0"},
		{"1233", "Elite Fury Charm", "010003000f001e00", "0", "0", "500", "500", "0"},
		{"1230", "Fury Charm", "010001000f000600", "0", "0", "500", "500", "0"},
		{"12367", "Normal Magical Charm", "010007000f007800", "0", "0", "500", "500", "0"},
		{"8038", "Superior Charged Charm", "010005000f004600", "0", "0", "500", "500", "0"},
		{"1231", "Superior Fury Charm", "010002000f000c00", "0", "0", "500", "500", "0"},
		{"Magical Damage Reduction Charms", "0", "0", "0", "0", "0", "0", "0"},
		{"1290", "Azure charm", "0100000014000000c3f5a83e01000000", "0", "0", "500", "500", "0"},
		{"1291", "Lapis charm", "0100000028000000c3f5a83e01000000", "0", "0", "500", "500", "0"},
		{"1293", "Magic Shell", "010000003c000000c3f5a83e01000000", "0", "0", "500", "500", "0"},
		{"Physical Damage Reduction Charms", "0", "0", "0", "0", "0", "0", "0"},
		{"1281", "Cockatrice's Scale charm", "0000000014000000c3f5a83e01000000", "0", "0", "500", "500", "0"},
		{"1286", "Dragon's Scale Charm", "0000000028000000c3f5a83e01000000", "0", "0", "500", "500", "0"},
		{"1289", "Kirin's Scale Charm", "000000003c000000c3f5a83e01000000", "0", "0", "500", "500", "0"},
//
	};
%>