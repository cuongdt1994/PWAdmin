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
//3
	String[][] items = 
	{
		{"Player Assist Utilities", "0", "0", "0", "0", "0", "0", "0"},
		{"12808", "Binding Charm", "0", "0", "8", "1", "1", "0"},
		{"3369", "Celestone of Earth", "0", "0", "0", "1000", "1000", "0"},
		{"3368", "Celestone of Heaven", "0", "0", "0", "1000", "1000", "0"},
		{"3370", "Celestone of Human", "0", "0", "0", "1000", "1000", "0"},
		{"12758", "Geographic Map", "1c1b0000", "0", "8", "1", "30", "0"},
		{"12814", "Gold Guardian Charm", "c02709000000003f", "1048576", "8", "1", "1", "0"},
		{"12817", "Gold Spirit Charm", "a0bb0d000000403f", "2097152", "8", "1", "1", "0"},
		{"12361", "Guardian Scroll", "0", "0", "8", "20", "20", "0"},
		{"20216", "Perfect Iron Hammer", "0", "0", "8", "100", "100", "0"},
		{"15761", "Platinum Guardian Charm", "804f12000000003f", "1048576", "8", "1", "1", "0"},
		{"15760", "Platinum Spirit Charm", "40771b000000403f", "2097152", "8", "1", "1", "0"},
		{"3043", "Resurrection Scroll", "0", "0", "1", "10", "10", "0"},
		{"12813", "Silver Guardian Charm", "305705000000003f", "1048576", "8", "1", "1", "0"},
		{"12816", "Silver Spirit Charm", "c80208000000403f", "2097152", "8", "1", "1", "0"},
		{"2100", "Teleport Incense", "c8000000", "0", "8", "20", "20", "0"},
		{"14351", "Teleport Stone", "0", "0", "8", "100", "100", "0"},
		{"12967", "Training Esoterica", "100e0000", "0", "0", "9999", "9999", "0"},
		{"Store", "0", "0", "0", "0", "0", "0", "0"},
		{"12768", "Cage", "0", "0", "8", "10", "100", "0"},
		{"12966", "Inv. Extension Stone", "0", "0", "8", "10", "100", "0"},
		{"12766", "Safe Extension Stone", "0", "0", "8", "10", "100", "0"},
		{"23367", "Super Cage", "0", "0", "8", "1", "9999", "0"},
		{"23365", "Super Inventory Stone", "0", "0", "8", "1", "9999", "0"},
		{"23366", "Super Safe Stone", "0", "0", "8", "1", "9999", "0"},
		{"Character", "0", "0", "0", "0", "0", "0", "0"},
		{"4411", "Advanced Makeover Scroll", "1", "0", "8", "1", "1", "0"},
		{"12761", "Advanced Reset Note", "0", "0", "8", "1", "1", "0"},
		{"12764", "Advanced Reset-all Note", "0", "0", "8", "1", "1", "0"},
		{"12763", "Inter. Reset-all Note", "0", "0", "8", "1", "1", "0"},
		{"12760", "Intermediate Reset Note", "0", "0", "8", "1", "1", "0"},
		{"9709", "Makeover Scroll", "0", "0", "19", "1", "1", "0"},
		{"12832", "Wraith Marshal's Stamp", "0", "0", "0", "100", "100", "0"},
		{"Chat", "0", "0", "0", "0", "0", "0", "0"},
		{"13697", "Bearsy Smiley Set", "2000000", "524288", "8", "1", "1", "0"},
		{"28441", "Fox Smiley Set", "2000000", "524288", "8", "1", "1", "0"},
		{"28650", "Monkey Smiley Set", "4000000", "524288", "8", "1", "1", "0"},
		{"12969", "Piggy Smiley Set", "1000000", "524288", "8", "1", "1", "0"},
		{"12827", "Swordsman Smileys", "3000000", "524288", "8", "1", "1", "0"},
		{"12979", "Teleacoustic", "0", "0", "8", "1", "1", "0"},
		{"24834", "Tiger Smiley Set", "5000000", "524288", "8", "1", "1", "0"},
		{"Refining", "0", "0", "0", "0", "0", "0", "0"},
		{"12980", "Chienkun Stone", "0", "0", "8", "1000", "1000", "0"},
		{"24852", "Dragon Orb Pack (1-5 Star)", "174e0000", "0", "8", "9999", "9999", "0"},
		{"15043", "Dragon Orb (6 Star)", "0", "0", "8", "1000", "1000", "0"},
		{"15044", "Dragon Orb (7 Star)", "0", "0", "8", "1000", "1000", "0"},
		{"15045", "Dragon Orb (8 Star)", "0", "0", "8", "1000", "1000", "0"},
		{"15046", "Dragon Orb (9 Star)", "0", "0", "8", "1000", "1000", "0"},
		{"15047", "Dragon Orb Ocean (10 Star)", "0", "0", "8", "1000", "1000", "0"},
		{"15048", "Dragon Orb Mirage (11 Star)", "0", "0", "8", "1000", "1000", "0"},
		{"15049", "Dragon Orb Flame (12 Star)", "0", "0", "8", "1000", "1000", "0"},
		{"11208", "Mirage Celestone", "0", "0", "8", "1000", "1000", "0"},
		{"Books", "0", "0", "0", "0", "0", "0", "0"},
		{"27260", "Apothecary Training I", "f2520000", "0", "4", "1", "999", "0"},
		{"27232", "Blacksmith Training I", "da520000", "0", "4", "1", "999", "0"},
		{"27252", "Craftsman Training I", "ea520000", "0", "4", "1", "999", "0"},
		{"3447", "Elite Blacksmith Skill", "0", "0", "0", "1", "1", "0"},
		{"3467", "Elite Craftsman Skill", "0", "0", "0", "1", "1", "0"},
		{"3457", "Elite Tailor Skill", "0", "0", "0", "1", "1", "0"},
		{"3448", "Legendary Blacksmith Skill", "0", "0", "0", "1", "1", "0"},
		{"3468", "Legendary Craftsman Skill", "0", "0", "0", "1", "1", "0"},
		{"3458", "Legendary Tailor Skill", "0", "0", "0", "1", "1", "0"},
		{"18235", "Old Book Page", "0", "0", "0", "100", "100", "0"},
		{"19004", "Page of Fate", "0", "0", "0", "100", "100", "0"},
		{"27244", "Tailor Training I", "e2520000", "0", "4", "1", "999", "0"},
		{"Tomes", "0", "0", "0", "0", "0", "0", "0"},
		{" Level 1", "0", "0", "0", "0", "0", "0", "0"},
		{"17607", "A Flowerless Plant", "0", "262144", "0", "1", "1", "0"},
		{"17611", "Eternity's Moon", "0", "262144", "0", "1", "1", "0"},
		{"17583", "Flanker's Tome", "0", "262144", "0", "1", "1", "0"},
		{"17581", "Retribution's Flame", "0", "262144", "0", "1", "1", "0"},
		{"17580", "Tome of Fecundity", "0", "262144", "0", "1", "1", "0"},
		{"17585", "Tome of Grace", "0", "262144", "0", "1", "1", "0"},
		{"17584", "Tome of Hyperbolic Boasts", "0", "262144", "0", "1", "1", "0"},
		{"17582", "Tome of the River Spirits", "0", "262144", "0", "1", "1", "0"},
		{"17579", "Underestimated Resolve", "0", "262144", "0", "1", "1", "0"},
		{" Level 2", "0", "0", "0", "0", "0", "0", "0"},
		//{"17612", "Fire Dance", "
		//{"17608", "Guide to Wolf Hunting", "
		//{"17592", "Mediation's Flame", "
		{"17587", "Misty Peach Blossoms", "0", "262152", "0", "1", "1", "0"},
		//{"17591", "Story of the Blockade", "
		{"17589", "Tale of the Dolt", "0", "262154", "0", "1", "1", "0"},
		{"17590", "Tale of the Peach Fan", "", "262155", "0", "1", "1", "0"},
		{"17588", "Tale of the Red Lotus", "0", "262153", "0", "1", "1", "0"},
		{"17586", "Tome of Iron Will", "0", "262151", "0", "1", "1", "0"},
		{" Level 3", "0", "0", "0", "0", "0", "0", "0"},
		//{"17599", "A Poet's Musings", "
		//{"17595", "Adventures and Mishaps", "
		//{"17609", "Decaying Tome", "
		//{"17593", "Eat, Drink and be Merry", "
		//{"17613", "Scene of Carnage", "
		//{"17594", "Sunset Tales", "
		//{"17597", "Tales of Beauty", "
		//{"17598", "The Bard's Wanderlust", "
		//{"17596", "The Sunny Pass", "
		{" Level 4", "0", "0", "0", "0", "0", "0", "0"},
		//{"17601", "A Bewitching Proposal", "
		//{"17600", "Battle Tactics", "
		//{"17602", "Burning Desire", "
		//{"17605", "Letters of Social Unrest", "
		//{"17606", "The Appetites of Spring", "
		//{"17610", "The River's Edge", "
		//{"17604", "The Rose's Thorn", "
		//{"17614", "The Weak Stream of Many Miles", "
		//{"17603", "Tome of Predestination", "
		{" Level 5", "0", "0", "0", "0", "0", "0", "0"},
		//{"17618", "A Heart like Still Water", "
		//{"0", "The Tsunamis of Yore", "
		//{"0", "2", "
		//{"0", "3", "
		//{"0", "4", "
		//{"0", "5", "
		//{"0", "6", "
		//{"0", "7", "
		//{"0", "8", "
		//{"0", "9", "
		//{"0", "10", "
		//{"0", "11", "
		//{"0", "12", "
		//{"0", "13", "
		//{"0", "14", "
		//{"0", "15", "
		//{"0", "16", "
		//{"0", "17", "
		//{"0", "18", "
		//{"0", "19", "
		//{"0", "0", "
		//{"0", "1", "
		//{"0", "2", "
		//{"0", "3", "
		//{"0", "4", "
		//{"0", "5", "
		//{"0", "6", "
		//{"0", "7", "
		//{"0", "8", "
		//{"0", "9", "
		//{"0", "10", "
		//{"0", "11", "
		//{"0", "12", "
		//{"0", "13", "
		//{"0", "14", "
		//{"0", "15", "
		//{"0", "16", "
		//{"0", "17", "
		//{"0", "18", "
		//{"0", "19", "
		//{"0", "0", "
		//{"0", "1", "
		//{"0", "2", "
		//{"0", "3", "
		//{"0", "4", "
		//{"0", "5", "
		//{"0", "6", "
		//{"0", "7", "
		//{"0", "8", "
		//{"0", "9", "
		//{"0", "10", "
		//{"0", "11", "
		//{"0", "12", "
		//{"0", "13", "
		//{"0", "14", "
		//{"0", "15", "
		//{"0", "16", "
		//{"0", "17", "
		//{"0", "18", "
		//{"0", "19", "
		{" Fate: Scroll of Tome", "0", "0", "0", "0", "0", "0", "0"},
		{"17643", "The Three Scholars", "0", "262145", "0", "1", "1", "0"},
		{"17640", "Divine Brotherhood", "0", "262146", "0", "1", "1", "0"},
		{"17637", "The Plum Harvest", "0", "262147", "0", "1", "1", "0"},
		{"17625", "Chant of the Water Dragon", "0", "262148", "0", "1", "1", "0"},
		{"17616", "The Alms Bowl", "0", "262149", "0", "1", "1", "0"},
		{"17684", "Love: Up and Down", "0", "262150", "0", "1", "1", "0"},
//
	};
%>