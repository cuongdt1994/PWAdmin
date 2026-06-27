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
//23
	String[][] items = 
	{
		{"13114", "Mold: Amulet of Thromh", "0", "0", "0", "1", "1", "0"},
		{"13115", "Mold: Necklace of the Legion", "0", "0", "0", "1", "1", "0"},
		{"13116", "Mold: Equine Talisman", "0", "0", "0", "1", "1", "0"},
		{"13117", "Mold: Fairie Fox Amulet", "0", "0", "0", "1", "1", "0"},
		{"13120", "Mold: Dark Cone Amulet", "0", "0", "0", "1", "1", "0"},
		{"13121", "Mold: Sorcerer's Pearl", "0", "0", "0", "1", "1", "0"},
		{"13122", "Mold: Amulet of the Black Hand", "0", "0", "0", "1", "1", "0"},
		{"13123", "Mold: Drakeshadow Amulet", "0", "0", "0", "1", "1", "0"},
		{"13124", "Mold: Swordsman's Amulet", "0", "0", "0", "1", "1", "0"},
		{"13126", "Mold: Skysunder Amulet", "0", "0", "0", "1", "1", "0"},
		{"13127", "Mold: Servant's Necklace", "0", "0", "0", "1", "1", "0"},
		{"13128", "Mold: Nature's Breath", "0", "0", "0", "1", "1", "0"},
		{"13129", "Mold: Sky Demon's Pearl", "0", "0", "0", "1", "1", "0"},
		{"13130", "Mold: Demonic Mark", "0", "0", "0", "1", "1", "0"},
		{"13132", "Mold: Beast Horn Powder", "0", "0", "0", "1", "1", "0"},
		{"13133", "Mold: Bones of the Dead", "0", "0", "0", "1", "1", "0"},
		{"13134", "Mold: Pirate King's Seal", "0", "0", "0", "1", "1", "0"},
		{"13135", "Mold: Demon Slaughter Belt", "0", "0", "0", "1", "1", "0"},
		{"13136", "Mold: Mystical Armor Seal", "0", "0", "0", "1", "1", "0"},
		{"13138", "Mold: Golden Seasnake Amulet", "0", "0", "0", "1", "1", "0"},
		{"13139", "Mold: Mystical Realm Pendant", "0", "0", "0", "1", "1", "0"},
		{"13140", "Mold: Thunderking's Seal", "0", "0", "0", "1", "1", "0"},
		{"13141", "Mold: Amulet of Passion", "0", "0", "0", "1", "1", "0"},
		{"13142", "Mold: Jade Unicorn Pendant", "0", "0", "0", "1", "1", "0"},
		{"13144", "Mold: Tarantula Belt", "0", "0", "0", "1", "1", "0"},
		{"13145", "Mold: Widow's Ghost Amulet", "0", "0", "0", "1", "1", "0"},
		{"13146", "Mold: Viper's Seal", "0", "0", "0", "1", "1", "0"},
		{"13147", "Mold: Ghostly Belt", "0", "0", "0", "1", "1", "0"},
		{"13148", "Mold: Anger of the Beast Soul", "0", "0", "0", "1", "1", "0"},
		{"13150", "Mold: Crazed Lupine Ring", "0", "0", "0", "1", "1", "0"},
		{"13151", "Mold: Barbaric Warrior's Ring", "0", "0", "0", "1", "1", "0"},
		{"13152", "Mold: Rage of Crixalis", "0", "0", "0", "1", "1", "0"},
		{"13153", "Mold: Misty Forest Ring", "0", "0", "0", "1", "1", "0"},
		{"13154", "Mold: Ring of the Heavenly Lord", "0", "0", "0", "1", "1", "0"},
		{"13155", "Mold: Band from Heaven's Jail", "0", "0", "0", "1", "1", "0"},
		{"13158", "Mold: Ring of Blazing Fury", "0", "0", "0", "1", "1", "0"},
		{"13159", "Mold: Vicious Ring", "0", "0", "0", "1", "1", "0"},
		{"13160", "Mold: Fiend's Ring", "0", "0", "0", "1", "1", "0"},
		{"13161", "Mold: Demon Panther Ring", "0", "0", "0", "1", "1", "0"},
		{"13162", "Mold: Demon's Heart Ring", "0", "0", "0", "1", "1", "0"},
		{"13163", "Mold: Secret of the Dark Spirit", "0", "0", "0", "1", "1", "0"},
		{"13164", "Mold: Dark Flower Spirit's Ring", "0", "0", "0", "1", "1", "0"},
		{"14070", "Mold: Army Commander's Amulet", "0", "0", "0", "1", "1", "0"}
//
	};
%>