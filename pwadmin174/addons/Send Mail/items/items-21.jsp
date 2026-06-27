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
//21
	String[][] items = 
	{
		{"13043", "Mold: Heavy Plate of Lava", "0", "0", "0", "1", "1", "0"},
		{"13044", "Mold: Heavy Plate of Phantom", "0", "0", "0", "1", "1", "0"},
		{"13045", "Mold: Dragonflame Plate", "0", "0", "0", "1", "1", "0"},
		{"13046", "Mold: Proud Plate of Corsair", "0", "0", "0", "1", "1", "0"},
		{"13047", "Mold: Plate of the Vigiliant (Plate of Endless Warden)", "0", "0", "0", "1", "1", "0"},
		{"13048", "Mold: Plate of Demon Lord", "0", "0", "0", "1", "1", "0"},
		{"13049", "Mold: Armor of Evil Den", "0", "0", "0", "1", "1", "0"},
		{"13050", "Mold: Armor of Barbarian Shaman", "0", "0", "0", "1", "1", "0"},
		{"13051", "Mold: Armor of Grieving Sorrow", "0", "0", "0", "1", "1", "0"},
		{"13052", "Mold: Armor of Millenary Bless", "0", "0", "0", "1", "1", "0"},
		{"13053", "Mold: Armor of Dark Floria", "0", "0", "0", "1", "1", "0"},
		{"13055", "Mold: Sorcerer's Robe of Lava", "0", "0", "0", "1", "1", "0"},
		{"13056", "Mold: Steppenwolf Lord's Cape", "0", "0", "0", "1", "1", "0"},
		{"13057", "Mold: Devil's Cape of Ares", "0", "0", "0", "1", "1", "0"},
		{"13058", "Mold: Cape of Underworld Slayer", "0", "0", "0", "1", "1", "0"},
		{"13060", "Mold: Vicious Cuisse", "0", "0", "0", "1", "1", "0"},
		{"13061", "Mold: Cuisses of Devined Beast", "0", "0", "0", "1", "1", "0"},
		{"13062", "Mold: Cuisses of Sea Captain", "0", "0", "0", "1", "1", "0"},
		{"13063", "Mold: Cuisses of Brahma", "0", "0", "0", "1", "1", "0"},
		{"13064", "Mold: Cuisses of Hamadryad", "0", "0", "0", "1", "1", "0"},
		{"13066", "Mold: Shinguards of Wolf Rage", "0", "0", "0", "1", "1", "0"},
		{"13067", "Mold: Zombie Warrior Leggings", "0", "0", "0", "1", "1", "0"},
		{"13068", "Mold: Genie Shins (Shinguards of Ashura)", "0", "0", "0", "1", "1", "0"},
		{"13069", "Mold: Dark Shinguards of Hedes", "0", "0", "0", "1", "1", "0"},
		{"13070", "Mold: Demon Punisher Cuisse", "0", "0", "0", "1", "1", "0"},
		{"13072", "Mold: Pants of Fire's Fury", "0", "0", "0", "1", "1", "0"},
		{"13073", "Mold: Fine Emerald Slacks", "0", "0", "0", "1", "1", "0"},
		{"13074", "Mold: Pants of Dragon Scales", "0", "0", "0", "1", "1", "0"},
		{"13075", "Mold: Dark Pants of Hedes", "0", "0", "0", "1", "1", "0"},
		{"13076", "Mold: Demonvision Lega (Pants of Demonic Evil)", "0", "0", "0", "1", "1", "0"},
		{"13078", "Mold: Soul Devourer's Greaves", "0", "0", "0", "1", "1", "0"},
		{"13079", "Mold: Greaves of Fallen", "0", "0", "0", "1", "1", "0"},
		{"13080", "Mold: Scribe's Shoes", "0", "0", "0", "1", "1", "0"},
		{"13081", "Mold: Tromh's Boots", "0", "0", "0", "1", "1", "0"},
		{"13082", "Mold: Boots of Tiger Strength", "0", "0", "0", "1", "1", "0"},
		{"13083", "Mold: Light Boots of Hermit", "0", "0", "0", "1", "1", "0"},
		{"13085", "Mold: Boots of Devinity", "0", "0", "0", "1", "1", "0"},
		{"13086", "Mold: Boots of Shadow Fountain", "0", "0", "0", "1", "1", "0"},
		{"13087", "Mold: Flame Boots of Intensity", "0", "0", "0", "1", "1", "0"},
		{"13088", "Mold: Boots of Soul Reaper", "0", "0", "0", "1", "1", "0"},
		{"13090", "Mold: Warrior's Clutches", "0", "0", "0", "1", "1", "0"},
		{"13091", "Mold: Inferno Bracers", "0", "0", "0", "1", "1", "0"},
		{"13092", "Mold: Heavy Vambraces of Hermit", "0", "0", "0", "1", "1", "0"},
		{"13094", "Mold: Blood Bracers of Fang", "0", "0", "0", "1", "1", "0"},
		{"13095", "Mold: Bracers of Abanddonment", "0", "0", "0", "1", "1", "0"},
		{"13096", "Mold: Soul Purify Bracers", "0", "0", "0", "1", "1", "0"},
		{"13097", "Mold: Sleeves of Sea Captain", "0", "0", "0", "1", "1", "0"},
		{"13098", "Mold: Sleeves of Demon Sword", "0", "0", "0", "1", "1", "0"},
		{"13100", "Mold: Lantern Ghoul's Helm", "0", "0", "0", "1", "1", "0"},
		{"13101", "Mold: Helmet of Lion Spirit", "0", "0", "0", "1", "1", "0"},
		{"13102", "Mold: Helm of Aqua Viciousness", "0", "0", "0", "1", "1", "0"},
		{"13103", "Mold: Helmet of Pirate", "0", "0", "0", "1", "1", "0"},
		{"13104", "Mold: Heavy Helmet of Ape", "0", "0", "0", "1", "1", "0"},
		{"13105", "Mold: Helmet of Endlessness", "0", "0", "0", "1", "1", "0"},
		{"13107", "Mold: Necromania Hat", "0", "0", "0", "1", "1", "0"},
		{"13108", "Mold: Crystal Headdress", "0", "0", "0", "1", "1", "0"},
		{"13109", "Mold: Light Hat of Devil Bone", "0", "0", "0", "1", "1", "0"},
		{"13110", "Mold: Hat of the Arch Wizard", "0", "0", "0", "1", "1", "0"},
		{"13112", "Mold: Cape of Tauran Chieftain", "0", "0", "0", "1", "1", "0"},
		{"13113", "Mold: Cape of Elite Leather", "0", "0", "0", "1", "1", "0"},
		{"14073", "Mold: Robe of Blood Might", "0", "0", "0", "1", "1", "0"},
		{"14071", "Mold: Cuisses of Blood Might", "0", "0", "0", "1", "1", "0"},
		{"14072", "Mold: Bracers of Blood Might", "0", "0", "0", "1", "1", "0"},
		{"14077", "Mold: Bracers of Blood Moon", "0", "0", "0", "1", "1", "0"},
		{"14075", "Mold: Sleeves of Blood Moon", "0", "0", "0", "1", "1", "0"},
		{"14074", "Mold: Vambraces of Blood Moon", "0", "0", "0", "1", "1", "0"},
		{"14079", "Mold: Blood Spirit Boots", "0", "0", "0", "1", "1", "0"},
		{"14081", "Mold: Blood Spirit Bracers", "0", "0", "0", "1", "1", "0"},
		{"14078", "Mold: Blood Spirit Greaves", "0", "0", "0", "1", "1", "0"},
		{"14083", "Mold: Legion Shinguards", "0", "0", "0", "1", "1", "0"},
		{"14084", "Mold: Legion Wrap", "0", "0", "0", "1", "1", "0"},
		{"14082", "Mold: Legion Vambraces", "0", "0", "0", "1", "1", "0"},
//
	};
%>