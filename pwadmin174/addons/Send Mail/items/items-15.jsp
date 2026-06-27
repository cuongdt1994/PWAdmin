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
//15
	String[][] items = 
	{
		{"Lunar Glade Materials", "0", "0", "0", "0", "0", "0", "0"},
		{"16468", "Ancient Tinder", "0", "0", "0", "100", "100", "0"},
		{"16454", "Aqua Crystal", "0", "0", "0", "100", "100", "0"},
		{"16460", "Aqua Essence", "0", "0", "0", "100", "100", "0"},
		{"16448", "Aqua Fragment", "0", "0", "0", "100", "100", "0"},
		{"16444", "Blue Soulgem", "0", "0", "0", "100", "100", "0"},
		{"16459", "Chaos Crystal", "0", "0", "0", "100", "100", "0"},
		{"16465", "Chaos Essence", "0", "0", "0", "100", "100", "0"},
		{"16453", "Chaos Fragment", "0", "0", "0", "100", "100", "0"},
		{"16467", "Chromatic Tinder", "0", "0", "0", "100", "100", "0"},
		{"20451", "Desert Tower Miniature", "0", "0", "0", "1000", "1000", "0"},
		{"16456", "Earth Crystal", "0", "0", "0", "100", "100", "0"},
		{"16462", "Earth Essence", "0", "0", "0", "100", "100", "0"},
		{"16450", "Earth Fragment", "0", "0", "0", "100", "100", "0"},
		{"16548", "Essence Crystal", "0", "0", "0", "100", "100", "0"},
		{"16545", "Essence Of Nature", "0", "0", "0", "100", "100", "0"},
		{"16455", "Flame Crystal", "0", "0", "0", "100", "100", "0"},
		{"16461", "Flame Essence", "0", "0", "0", "100", "100", "0"},
		{"16449", "Flame Fragment", "0", "0", "0", "100", "100", "0"},
		{"16546", "Fragment Crystal", "0", "0", "0", "100", "100", "0"},
		{"16445", "Green Soulgem", "0", "0", "0", "100", "100", "0"},
		{"20449", "Leaf of Unicorn Forest", "0", "0", "0", "1000", "1000", "0"},
		{"16457", "Life Crystal", "0", "0", "0", "100", "100", "0"},
		{"16463", "Life Essence", "0", "0", "0", "100", "100", "0"},
		{"16451", "Life Fragment", "0", "0", "0", "100", "100", "0"},
		{"16443", "Red Soulgem", "0", "0", "0", "100", "100", "0"},
		{"16458", "Steel Crystal", "0", "0", "0", "100", "100", "0"},
		{"16464", "Steel Essence", "0", "0", "0", "100", "100", "0"},
		{"16452", "Steel Fragment", "0", "0", "0", "100", "100", "0"},
		{"20450", "Stone of the Scarred", "0", "0", "0", "1000", "1000", "0"},
		{"20448", "Tear of Heaven", "0", "0", "0", "1000", "1000", "0"},
		{"16547", "Transparent Crystal", "0", "0", "0", "100", "100", "0"},
		{"16466", "Unknown Tinder", "0", "0", "0", "100", "100", "0"},
		{"16446", "White Soulgem", "0", "0", "0", "100", "100", "0"},
		{"Other Lunar Glade", "0", "0", "0", "0", "0", "0", "0"},
		{"23576", "Ancient Helm Mold", "0", "0", "0", "9999", "9999", "0"},
		{"23565", "Ancient Necklace Mold", "0", "0", "0", "9999", "9999", "0"},
		{"23573", "Ancient Ring Mold", "0", "0", "0", "9999", "9999", "0"},
		{"16469", "Buddha's Servant's Blood", "0", "0", "0", "9999", "9999", "0"},
		{"16470", "Burning Soul's Heart", "0", "0", "0", "9999", "9999", "0"},
		{"23577", "Crystal of Relic of Wind", "0", "0", "0", "9999", "9999", "0"},
		{"23570", "Erhli's Treasure", "0", "0", "0", "9999", "9999", "0"},
		{"23578", "Essence of Primal Fear", "0", "0", "0", "9999", "9999", "0"},
		{"23564", "Eye of Burning Soul", "0", "0", "0", "9999", "9999", "0"},
		{"23568", "Gem of Hauntery Queen", "0", "0", "0", "9999", "9999", "0"},
		{"16472", "Genesiac Blink's Skin", "0", "0", "0", "9999", "9999", "0"},
		{"23567", "Gloom of Mystical Jarax", "0", "0", "0", "9999", "9999", "0"},
		{"23563", "Heart of Genesiac Blink", "0", "0", "0", "9999", "9999", "0"},
		{"23575", "Horn of Drake Fling", "0", "0", "0", "9999", "9999", "0"},
		{"16473", "Massaca Seben's Bone Shard", "0", "0", "0", "9999", "9999", "0"},
		{"16471", "Mystical Jarax's Poison", "0", "0", "0", "9999", "9999", "0"},
		{"23571", "Ring Fragment of Primal Fear", "0", "0", "0", "9999", "9999", "0"},
		{"23572", "Scale of Drake Fling", "0", "0", "0", "9999", "9999", "0"},
		{"23562", "Seal of Buddha's Servant", "0", "0", "0", "9999", "9999", "0"},
		{"23566", "Shard of Relic of Wind", "0", "0", "0", "9999", "9999", "0"},
		{"23569", "Tali's Treasure", "0", "0", "0", "9999", "9999", "0"},
		{"23574", "Tooth of Massaca Seben", "0", "0", "0", "9999", "9999", "0"},
//
	};
%>