<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../WEB-INF/lang_vi.jsp"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="../../include/fav.ico">
    <link rel="stylesheet" type="text/css" href="../../include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .skill-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 6px; }
        .skill-item { display: flex; align-items: center; gap: 8px; padding: 5px 10px; background: var(--phx-surface); border-radius: var(--phx-radius); border: 1px solid var(--phx-border); }
        .skill-item img { width: 32px; height: 32px; flex-shrink: 0; object-fit: contain; }
        .skill-item select { font-size: 11px; padding: 2px 4px; flex: 1; min-width: 0; background: #1a1a2e; color: #e0e0e0; border: 1px solid var(--phx-border); border-radius: 3px; }
        .skill-item select option { background: #1a1a2e; color: #e0e0e0; }
        .skill-item .skill-name { font-size: 12px; min-width: 130px; color: var(--phx-text); font-weight: 500; }
        .class-card { margin-bottom: 8px; border: 1px solid var(--phx-border); border-radius: var(--phx-radius); overflow: hidden; }
        .class-card summary { cursor: pointer; padding: 10px 16px; background: var(--phx-surface-2); border-radius: var(--phx-radius); font-weight: 600; color: var(--phx-primary); display: flex; align-items: center; gap: 8px; user-select: none; }
        .class-card summary:hover { background: var(--phx-primary); color: #fff; }
        .class-card .card-body { padding: 12px; }
        .cat-title { font-size: 12px; font-weight: 700; color: var(--phx-primary); margin: 10px 0 6px 0; padding-bottom: 2px; border-bottom: 1px solid var(--phx-border); text-transform: uppercase; letter-spacing: 0.5px; }
        .allclass-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 6px; margin-bottom: 4px; }
        .sticky-submit { position: sticky; bottom: 0; z-index: 100; background: var(--phx-bg); padding: 12px 0; border-top: 2px solid var(--phx-primary); text-align: center; margin-top: 16px; }
    </style>
</head>
<body style="background:transparent; padding:16px;">

<div class="phx-page-header">
    <h1><i class="fa-solid fa-code" style="color:var(--phx-primary)"></i> <%= T("skillhex.title") %></h1>
    <p><%= T("skillhex.gen_skill_xml") %></p>
</div>

<form action="skill.jsp" method="post">

<details class="class-card" open>
    <summary><i class="fa-solid fa-layer-group"></i> <%= T("skillhex.allclass") %></summary>
    <div class="card-body">
        <div class="allclass-grid">
            <div class="skill-item"><img src="icons/9e000000.jpg"><span class="skill-name">Blacksmith</span><select name="9e000000"><option value="0"><%= T("skillhex.unavailable") %></option><% for(int i=1;i<=10;i++){ %><option value="<%=i%>"><%=i%></option><% } %></select></div>
            <div class="skill-item"><img src="icons/9f000000.jpg"><span class="skill-name">Tailor</span><select name="9f000000"><option value="0"><%= T("skillhex.unavailable") %></option><% for(int i=1;i<=10;i++){ %><option value="<%=i%>"><%=i%></option><% } %></select></div>
            <div class="skill-item"><img src="icons/a0000000.jpg"><span class="skill-name">Craftsman</span><select name="a0000000"><option value="0"><%= T("skillhex.unavailable") %></option><% for(int i=1;i<=10;i++){ %><option value="<%=i%>"><%=i%></option><% } %></select></div>
            <div class="skill-item"><img src="icons/a1000000.jpg"><span class="skill-name">Apothecary</span><select name="a1000000"><option value="0"><%= T("skillhex.unavailable") %></option><% for(int i=1;i<=10;i++){ %><option value="<%=i%>"><%=i%></option><% } %></select></div>
            <div class="skill-item"><img src="icons/a7000000.jpg"><span class="skill-name">Town Portal</span><select name="a7000000"><option value="0"><%= T("skillhex.unavailable") %></option><option value="1">1</option></select></div>
        </div>
    </div>
</details>

<%
    String[] classNames = {"Blademaster","Wizard","Barbarian","Venomancer","Archer","Cleric","Assassin","Seeker","Mystic","Duskblade"};
    String[] classIcons = {"fa-sword","fa-hat-wizard","fa-skull","fa-spider","fa-bullseye","fa-cross","fa-mask","fa-feather-pointed","fa-crystal-ball","fa-moon"};

    String[][] allSkills = {
        // 0=Blademaster
        {"01000000","Tiger Maw"},{"02000000","Draw Blood"},{"36000000","Stream Strike"},{"03000000","Aeolian Blade"},
        {"48000000","Mage Bane"},{"49000000","Spirit Chaser"},{"4a000000","Atmos Strike"},{"4b000000","Myriad Sword Stance"},
        {"40000000","Piercing Winds"},{"41000000","Farstrike"},{"42000000","Meteor Rush"},{"43000000","Glacial Spike"},
        {"44000000","Drake Bash"},{"46000000","Highland Cleave"},{"47000000","Fissure"},{"45000000","Heaven's Flame"},
        {"3c000000","Vacuous Palm"},{"3d000000","Shadowless Kick"},{"3e000000","Cyclone Heel"},{"3f000000","Drake's Breath Bash"},
        {"05000000","Drake's Ray"},{"39000000","Ocean's Edge"},{"37000000","Fan of Flames"},{"38000000","Drake Sweep"},
        {"b1000000","Alter Marrow Magical"},{"b2000000","Alter Marrow Physical"},{"4d000000","Aura of the Golden Bell"},{"04000000","Roar of the Pride"},
        {"3a000000","Leap Back"},{"3b000000","Tiger Leap"},{"4c000000","Cloud Sprint"},{"b0000000","Will of the Bodhisatva"},{"b3000000","Diamond Sutra"},
        {"06000000","Blade and Sword Mastery"},{"4e000000","Polearm Mastery"},{"4f000000","Axe and Hammer Mastery"},{"50000000","Fist Weapon Mastery"},
        {"9c030000","Buddha's Guard"},{"82030000","Smack"},{"83030000","Flash"},{"81030000","Bolt of Tyreseus"},{"80030000","Dragon Bane"},
        {"4f070000","Sword Cyclone"},{"1b070000","Reel In"},{"19070000","Flame Tsunami"},{"1a070000","Blade Hurl"},{"17070000","Reckless Rush"},
        // 1=Wizard
        {"51000000","Pyrogram"},{"60000000","Pyroshell"},{"07000000","Crown of Flame"},{"55000000","Divine Pyrogram"},{"56000000","The Dragon's Breath"},
        {"54000000","Will of the Phoenix"},{"08000000","Emberstorm"},{"57000000","Blade Tempest"},
        {"58000000","Gush"},{"b4000000","Glacial Embrace"},{"5a000000","Morning Dew"},{"5b000000","Frostblade"},{"5c000000","Glacial Snare"},
        {"5d000000","Black Ice Dragon Strike"},{"b6000000","Hailstorm"},
        {"61000000","Stone Rain"},{"b5000000","Stone Barrier"},{"0a000000","Pitfall"},{"62000000","Sandstorm"},{"b8000000","Force of Will"},{"63000000","Mountain's Seize"},
        {"59000000","Wellspring Quaff"},{"b7000000","Essential Sutra"},{"64000000","Distance Shrink"},{"09000000","Aqua Spirit"},{"65000000","Earthen Spirit"},{"35000000","Fire Mastery"},
        {"0d070000","Arcane Defense"},{"88030000","Elemental Shell"},{"87030000","Soporific Whisper"},{"86030000","Undine Strike"},{"89030000","Elemental Invocation"},
        {"9d030000","Manifest Virtue"},{"51070000","Spatial Reversion"},{"52070000","Life Reversion"},{"0e070000","Ice Prison"},{"11070000","Sand Miasma"},{"10070000","Blinding Blaze"},
        // 2=Barbarian
        {"66000000","Stomp of the Beast King"},{"c3000000","Garrotte"},{"68000000","Mighty Swing"},{"6a000000","Penetrate Armor"},{"6c000000","Beastial Onslaught"},
        {"0c000000","Swell"},{"69000000","Firestorm"},{"6b000000","Slam"},{"67000000","Armageddon"},
        {"c4000000","Change to White Tiger"},{"c5000000","Flesh Ream"},{"72000000","Alacrity of the Beast"},{"6e000000","Devour"},{"c0000000","Surf Impact"},
        {"6f000000","Sunder"},{"c1000000","Poison Fang"},{"6d000000","Roar"},{"c2000000","Frighten"},
        {"70000000","Feral Regeneration"},{"75000000","Beast King's Inspiration"},{"74000000","Blood Bath"},{"71000000","Strength of the Titans"},{"73000000","Shapeshifting Intensity"},{"c8000000","Invoke the Spirit"},
        {"c6000000","Beastial Rage"},{"c7000000","Swimming Mastery"},{"c9000000","Axe and Hammer Mastery"},
        {"ca030000","Violent Triumph"},{"cb030000","Clean Sweep"},{"cc030000","Untamed Wrath"},{"0f070000","Ancestral Rage"},{"12070000","Berserker's Rage"},
        {"13070000","Raging Slap"},{"14070000","Stomp of the King"},{"15070000","Cornered Beast"},{"16070000","Blood Rush"},
        // 3=Venomancer
        {"76000000","Venomous Scarab"},{"77000000","Ironwood Scarab"},{"78000000","Blazing Scarab"},{"79000000","Frost Scarab"},{"7a000000","Noxious Gas"},{"7b000000","Lucky Scarab"},{"7c000000","Parasitic Nova"},
        {"ca000000","Fox Form"},{"cb000000","Fox Wallop"},{"cc000000","Befuddling Mist"},{"cd000000","Stunning Blow"},{"ce000000","Leech"},{"cf000000","Consume Spirit"},
        {"d0000000","Malefic Crush"},{"d1000000","Purge"},{"d2000000","Amplify Damage"},{"d3000000","Soul Degeneration"},{"d4000000","Crush Vigor"},
        {"d5000000","Bramble Guard"},{"d6000000","Metabolic Boost"},{"d7000000","Nature's Grace"},{"d8000000","Lending Hand"},{"d9000000","Bramble Hood"},
        {"da000000","Soul Transfusion"},{"db000000","Summer Sprint"},{"dc000000","Swimming Mastery"},
        {"7d000000","Tame Beast"},{"7f000000","Revive Pet"},{"7e000000","Heal Pet"},
        {"84030000","Purify Spell"},{"85030000","Tree of Protection"},
        // 4=Archer
        {"8a000000","Take Aim"},{"8b000000","Frost Arrow"},{"8c000000","Winged Shell"},{"8d000000","Quickshot"},
        {"8e000000","Thunderous Blast"},{"8f000000","Serrated Arrow"},{"90000000","Stunning Arrow"},{"91000000","Barrage of Arrows"},
        {"92000000","Winged Pledge"},{"93000000","Leap"},{"94000000","Wingspan Blessing"},{"95000000","Stormrage Eaglespride"},{"96000000","Thunder Shock"},
        {"97000000","Sharpened Tooth Arrow"},{"0b000000","Bow Mastery"},
        {"1c070000","Vicious Arrow"},{"1d070000","Deadly Shot"},{"1e070000","Explosive Arrow"},
        // 5=Cleric
        {"98000000","Plume Shot"},{"99000000","Great Cyclone"},{"9a000000","Ironheart Blessing"},{"9b000000","Chromaric Healing Beam"},
        {"9c000000","Stream of Rejuvenation"},{"9d000000","Magic Shell"},{"9e000000","Elemental Seal"},{"9f000000","Purify"},
        {"a0000000","Wings of Protection"},{"a2000000","Celestial Guardian's Seal"},{"a3000000","Silent Seal"},{"a5000000","Razor Feathers"},
        {"a4000000","Plume Barrier"},{"a7000000","Revive"},{"a6000000","Flight Mastery"},
        {"8d070000","Soaring Aroma"},{"8e070000","Blessing of the Purehearted"},
        // 6=Assassin
        {"dd000000","Twin Strike"},{"de000000","Throatcut"},{"df000000","Shadow Escape"},{"e0000000","Dark Pact"},
        {"e1000000","Raving Slash"},{"e2000000","Life Hunter"},{"e3000000","Focused Mind"},{"e4000000","Tackling Slash"},
        {"e5000000","Inner Harmony"},{"e6000000","Rising Dragon Strike"},{"e7000000","Bloodpaint"},{"e8000000","Cursed Jail"},
        {"e9000000","Shadow Teleport"},{"ea000000","Condensed Thorn"},{"eb000000","Chill of the Deep"},{"ec000000","Wolf's Emblem"},
        {"ed000000","Dagger Mastery"},{"ee000000","Subsea Strike"},
        {"8a030000","Power Dash"},{"8b030000","Shadowstep"},{"8c030000","Elimination"},{"8d030000","Headhunt"},{"8e030000","Wind Shield"},
        // 7=Seeker
        {"ef000000","Northern Sky Waltz"},{"f0000000","Souledge Strike"},{"f1000000","Lightning Strike"},{"f2000000","Sword of Intelligence"},
        {"f3000000","Gemini Slash"},{"f4000000","Heartseeking Blade"},{"f5000000","Ion Spike"},{"f6000000","Arme Nier"},
        {"f7000000","Soulsever"},{"f8000000","Battosai"},{"f9000000","Crimson Soul Stone"},{"fa000000","Eye of The Crow"},
        {"fb000000","Soul of the Crow"},{"fc000000","Crow Slash"},
        {"8f030000","Soul Shatter"},
        // 8=Mystic
        {"fd000000","Break in the Clouds"},{"fe000000","Pouncing Wind"},{"ff000000","Steel Weeping"},
        {"00010000","Summon Wood Fiend"},{"01010000","Summon Cactopod"},{"02010000","Summon Mistwarden"},{"03010000","Summon Craggolem"},
        {"04010000","Thicket"},{"05010000","Absorb Soul"},{"06010000","Cloud Eruption"},{"07010000","Healing Herb"},
        {"08010000","Rattling Thorns"},{"09010000","Galeforce"},{"0a010000","Swirling Gust"},{"0b010000","Nature's Vengeance"},
        {"0c010000","Verdant Mind"},{"0d010000","Befuddling Creeper"},{"0e010000","Flying Sword"},{"0f010000","Falling Petals"},
        {"90030000","Triple Blast"},
        // 9=Duskblade
        {"bd000000","Crimson Veil"},{"be000000","Dragon Emperor's Haki"},
        {"cd030000","Moonblade"},{"ce030000","Sundering Blade"},
    };

    int[] classStarts = {0, 44, 66, 97, 118, 135, 149, 164, 172, 180, 184};

    String[][] classCats = {
        {"Basic","01000000","Short Edge","48000000","Polearm","40000000","Blunt","44000000","Fist","3c000000","All","05000000","Misc / Passive","b1000000","79 / 100","9c030000"},
        {"Fire","51000000","Water","58000000","Earth","61000000","Misc / Passive","59000000","79 / 100","0d070000"},
        {"Human Form","66000000","Tiger Form","c4000000","Bless","70000000","Misc / Passive","c6000000","79 / 100","ca030000"},
        {"Wood","76000000","Fox Form","ca000000","Bless","d5000000","Misc / Passive","da000000","Pet","7d000000","79 / 100","84030000"},
        {"Attack","8a000000","Bless","92000000","Misc / Passive","0b000000","79 / 100","1c070000"},
        {"Attack","98000000","Bless","a0000000","Misc / Passive","a6000000","79 / 100","8d070000"},
        {"Attack","dd000000","79 / 100","8a030000"},
        {"Attack","ef000000","79 / 100","8f030000"},
        {"Attack","fd000000","79 / 100","90030000"},
        {"Attack","bd000000","79 / 100","cd030000"},
    };

    for(int cls = 0; cls < 10; cls++) {
        int start = classStarts[cls];
        int end = classStarts[cls+1];
%>
<details class="class-card">
    <summary><i class="fa-solid <%= classIcons[cls] %>"></i> <%= classNames[cls] %></summary>
    <div class="card-body">
        <div class="skill-grid">
<%
        String currentCat = "";
        for(int s = start; s < end; s++) {
            String hexId = allSkills[s][0];
            String skName = allSkills[s][1];
            // Print category header
            for(int c = 0; c < classCats[cls].length; c += 2) {
                if(classCats[cls][c+1].equals(hexId) && !classCats[cls][c].equals(currentCat)) {
                    currentCat = classCats[cls][c];
%>
        </div><div class="cat-title"><%= currentCat %></div><div class="skill-grid">
<%
                    break;
                }
            }
%>
            <div class="skill-item">
                <img src="icons/<%= hexId %>.jpg" onerror="this.style.display='none'">
                <span class="skill-name"><%= skName %></span>
                <select name="<%= hexId %>">
                    <option value="0"><%= T("skillhex.unavailable") %></option>
                    <% for(int i=1; i<=10; i++){ %><option value="<%=i%>"><%=i%></option><% } %>
                </select>
            </div>
<%
        }
%>
        </div>
    </div>
</details>
<%
    }
%>

<div class="sticky-submit">
    <button type="submit" class="phx-btn phx-btn-primary phx-btn-lg"><i class="fa-solid fa-code"></i> <%= T("skillhex.submit_btn") %></button>
</div>

</form>

</body>
</html>
