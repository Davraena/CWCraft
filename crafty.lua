addon.name    = 'crafty';
addon.author  = 'Lexia';
addon.version = '1.0';
addon.desc    = 'CatsEyeXI crafting guide viewer (bg-wiki Suggested Recipes)';

require('common');
local imgui = require('imgui');

local crafty = T{
    is_open = T{ true },
    search  = T{ string.rep('\0', 128) },
};

-- Source: https://www.bg-wiki.com/ffxi/CatseyeXI_Crafting_Guide#Suggested_Recipes
-- Columns: { level, name, materials, notes }
local CRAFTS = {
    {
        name     = 'Woodworking',
        skill_id = 1,
        color = { 0.60, 0.85, 0.50, 1.0 },
        recipes = {
            {  5, 'Maple Lumber',         'Maple Log',                      '' },
            {  8, 'Ash Lumber',           'Ash Log',                        '' },
            { 13, 'Willow Lumber',        'Willow Log',                     '' },
            { 19, 'Walnut Lumber',        'Walnut Log',                     '' },
            { 22, 'Yew Lumber',           'Yew Log',                        '' },
            { 25, 'Elm Lumber',           'Elm Log',                        '' },
            { 28, 'Chestnut Lumber',      'Chestnut Log',                   '' },
            { 32, 'Chestnut Wand',        'Chestnut Log',                   'Can also desynth for double skillup chances' },
            { 35, 'Oak Lumber',           'Oak Log',                        '' },
            { 36, 'Fairweather Fetish',   'Oak Log',                        'Alt to Oak Logs' },
            { 41, 'Oak Cudgel',           'Oak Log x1',                     'Only uses 1 lumber; desynth to double skillup chances' },
            { 45, 'Rosewood Lumber',      'Rosewood Log',                   '' },
            { 51, 'Mahogany Lumber',      'Mahogany Log',                   '' },
            { 55, 'Oak Pole',             'Oak Log',                        '' },
            { 61, 'Ebony Lumber',         'Ebony Log',                      '' },
            { 68, 'Mahogany Pole',        'Mahogany Log',                   '' },
            { 71, 'Ebony Harp',           'Ebony Log',                      '' },
            { 77, 'Clothespole',          '',                               '' },
            { 81, 'Cabinet',              '',                               '' },
            { 87, 'Mithran Fishing Rod',  '',                               '' },
            { 88, 'Half Partition',       '',                               '' },
            { 94, 'Eight-Sided Pole',     '',                               '' },
            { 97, 'Kapor Lumber',         'Kapor Log',                      '' },
            {100, 'Vejovis Wand',         '',                               '' },
            {104, 'Jacaranda Lumber',     'Jacaranda Log',                  'Logging in East Ronfaure (S) / Jugner Forest (S)' },
        },
    },
    {
        name     = 'Smithing',
        skill_id = 2,
        color = { 0.75, 0.75, 0.80, 1.0 },
        recipes = {
            {  4, 'Bronze Sheet',         'Bronze Ore/Ingot',               '' },
            { 10, 'Bronze Scales',        'Bronze Ore/Ingot',               '' },
            { 15, 'Tin Ingot',            'Tin Ore',                        '' },
            { 20, 'Iron Ingot',           'Iron Ore',                       '' },
            { 24, 'Debahocho',            '',                               '' },
            { 26, 'Iron Scales',          'Iron Ore',                       '' },
            { 30, 'Iron Chain',           'Iron Ore',                       '' },
            { 36, 'Steel Sheet',          '',                               '' },
            { 41, 'Iron Mittens',         'Iron materials',                 '' },
            { 47, 'Mythril Pick',         'Mythril materials',              '' },
            { 52, 'Darksteel Ingot',      'Darksteel Ore',                  '' },
            { 55, 'Darksteel Sheet',      'Darksteel Ore',                  '' },
            { 59, 'Darksteel Scales',     'Darksteel materials',            '' },
            { 62, 'Darksteel Bolt Heads', 'Darksteel materials',            '' },
            { 64, 'Darksteel Mufflers',   'Darksteel materials',            '' },
            { 66, 'Nodowa',               '',                               '' },
            { 70, 'Hien',                 '',                               '' },
            { 73, 'Darksteel Pick',       'Darksteel materials',            '' },
            { 74, 'Dark Bronze Ingot',    'Dark Bronze Ore',                '' },
            { 75, 'Dark Bronze Sheet',    'Dark Bronze Ore',                '' },
            { 75, 'Darksteel Leggings',   'Darksteel materials',            '' },
            { 80, 'Katzbalger',           '',                               '' },
            { 83, 'Darksteel Nodowa',     'Darksteel materials',            '' },
            { 84, 'Thick Mufflers',       '',                               '' },
            { 90, 'Adaman Ingot',         'Adaman Ore',                     'Mining in Grauberg (S) or Pygmytoise in Gustav Tunnel' },
            { 94, 'Adaman Chain',         'Adaman materials',               '' },
            { 98, 'Thokcha Ingot',        'Thokcha Ore',                    'Custom drop from Sky NMs' },
            { 99, 'Wootz Ingot',          'Wootz Ore',                      '' },
            {104, 'Bahadur',              '',                               '' },
        },
    },
    {
        name     = 'Goldsmithing',
        skill_id = 3,
        color = { 1.00, 0.85, 0.30, 1.0 },
        recipes = {
            {  3, 'Copper Ingot',         'Copper Ore',                     '' },
            {  7, 'Copper Hairpin',       'Copper Ingot',                   '' },
            {  9, 'Brass Ingot',          'Copper + Tin materials',         '' },
            { 15, 'Brass Ring',           'Brass Ingot',                    '' },
            { 20, 'Silver Ingot',         'Silver Ore',                     '' },
            { 27, 'Silver Hairpin',       'Silver Ingot',                   '' },
            { 32, 'Silver Ring',          'Silver Ingot',                   '' },
            { 40, 'Mythril Ingot',        'Mythril Ore',                    '' },
            { 47, 'Mythril Ring',         'Mythril Ingot',                  '' },
            { 51, 'Sardonyx/Flame Geode', 'Gemstone + Flame Geode',         'May have from leveling jobs' },
            { 53, 'Gold Ingot',           'Gold Ore',                       '' },
            { 58, 'Gold Hairpin',         'Gold Ingot',                     '' },
            { 60, 'Gold Arrowheads',      'Gold materials',                 '' },
            { 63, 'Platinum Ingot',       'Platinum Ore',                   '' },
            { 66, 'Mythril Gauntlets',    'Mythril materials',              '' },
            { 67, 'Hydro Patas',          '',                               '' },
            { 70, 'Platinum Ring',        'Platinum Ingot',                 '' },
            { 75, 'Jadeite Ring',         'Jadeite + materials',            '' },
            { 81, 'Zircon/Shivite',       'Gemstone + crystal',             'Another easy craft from leveling/meriting' },
            { 85, 'Platinum Bangles',     'Platinum materials',             '' },
            { 89, 'Orichalcum Ingot',     'Orichalcum Ore',                 'Chocobo Digging or Mining' },
            { 92, 'Muscle Belt',          '',                               '' },
            { 95, 'Ruby Ring',            'Ruby materials',                 '' },
            { 97, 'Koenig Shield',        '',                               '' },
            {104, 'Silver Cassandra',     '',                               '' },
        },
    },
    {
        name     = 'Clothcraft',
        skill_id = 4,
        color = { 0.85, 0.60, 0.85, 1.0 },
        recipes = {
            {  3, 'Grass Thread',         'Grass Fiber',                    'Skill to 6' },
            {  4, 'Grass Cloth',          'Grass Fiber',                    'Skill to 7' },
            {  8, 'Cape',                 '',                               '' },
            { 11, 'Cotton Thread',        'Cotton Fiber',                   'Skill to 16' },
            { 12, 'Cotton Cloth',         'Cotton Fiber',                   'Skill to 17' },
            { 18, 'Cotton Cape',          'Cotton Cloth',                   '' },
            { 22, 'Yagudo Fletchings',    'Yagudo Feather x2',              'Extremely cheap; worth doing from ~Lv10' },
            { 22, 'Linen Cloth',          'Flax materials',                 '' },
            { 27, 'Linen Robe',           'Linen Cloth',                    '' },
            { 31, 'Soil Hachimaki',       'Linen materials',                '' },
            { 35, 'Wool Thread',          'Wool materials',                 '' },
            { 42, 'Bird Fletchings',      'Bird Feather x2',                'Extremely cheap from early-mid 30s' },
            { 43, 'Hemp Gorget',          'Hemp materials',                 '' },
            { 45, 'Velvet Cloth',         'Silk/dye materials',             '' },
            { 51, 'Silk Thread',          'Silk materials',                 '' },
            { 52, 'Insect Fletchings',    'Insect Wing x2',                 'Extremely cheap after Bird Fletchings' },
            { 53, 'Silk Cloth',           'Silk materials',                 '' },
            { 55, 'Karakul Thread',       'Karakul materials',              '' },
            { 57, 'Karakul Cloth',        'Karakul materials',              '' },
            { 62, 'Green Ribbon',         '',                               '' },
            { 67, 'Apkallu Fletchings',   'Apkallu Feather',                '' },
            { 72, 'Black Chocobo Fletchings', 'Chocobo materials',          '' },
            { 77, 'Colibri Fletchings',   'Colibri Feather',                '' },
            { 78, 'Rainbow Thread',       '',                               '' },
            { 80, 'Rainbow Cloth',        'Rainbow Thread',                 '' },
            { 82, 'Puk Fletchings',       'Puk materials',                  '' },
            { 84, 'Rainbow Headband',     'Rainbow Cloth',                  '' },
            { 88, 'Wamoura Silk',         'Wamoura materials',              '' },
            { 90, 'Wamoura Cloth',        'Wamoura Silk',                   '' },
            { 94, 'Rainbow Cape',         'Rainbow Cloth',                  '' },
            { 98, 'Wyrdweave',            'Wyrdstrand',                     'Farm from King Crawler in Crawler\'s Nest' },
            {100, 'Swith Cape',           '',                               '' },
            {103, 'Spolia Chapeau',       '',                               '' },
        },
    },
    {
        name     = 'Leathercraft',
        skill_id = 5,
        color = { 0.80, 0.55, 0.35, 1.0 },
        recipes = {
            {  2, 'Sheep Leather',        'Sheep Hide',                     '' },
            {  7, 'Rabbit Mantle',        'Rabbit Hide',                    '' },
            { 11, 'Solea',                'Leather materials',              '' },
            { 17, 'Lizard Cesti',         'Lizard Hide',                    '' },
            { 21, 'Dhalmel Leather',      'Dhalmel Hide',                   '' },
            { 27, 'Dhalmel Mantle',       'Dhalmel Leather',                '' },
            { 31, 'Parchment',            'Animal materials',               '' },
            { 35, 'Ram Leather',          'Ram Hide',                       '' },
            { 43, 'Waistbelt',            'Leather materials',              '' },
            { 49, 'Ram Mantle',           'Ram Leather',                    '' },
            { 53, 'Raptor Strap',         'Raptor Hide',                    '' },
            { 58, 'Raptor Jerkin',        'Raptor materials',               '' },
            { 61, 'Tiger Leather',        'Tiger Hide',                     '' },
            { 62, 'Hard Leather Ring',    'Leather materials',              '' },
            { 69, 'Beak Jerkin',          'Beak materials',                 '' },
            { 71, 'Coeurl Leather',       'Coeurl Hide',                    '' },
            { 75, 'Tiger Mantle',         'Tiger Leather',                  '' },
            { 80, 'Manticore Leather',    'Manticore Hide',                 '' },
            { 85, 'Coeurl Mantle',        'Coeurl Leather',                 '' },
            { 89, 'Coeurl Jerkin',        'Coeurl materials',               '' },
            { 95, 'Tiger Mask',           'Tiger materials',                '' },
            {102, 'Panther Mask',         'Panther materials',              '' },
        },
    },
    {
        name     = 'Bonecraft',
        skill_id = 6,
        color = { 0.90, 0.80, 0.65, 1.0 },
        recipes = {
            {  4, 'Bone Hairpin',         'Bone materials',                 '' },
            { 10, 'Bone Arrowheads',      'Bone materials',                 '' },
            { 16, 'Gelatin',              'Bone materials',                 '' },
            { 21, 'Carapace Powder',      'Carapace materials',             '' },
            { 25, 'Beetle Ring',          'Beetle materials',               '' },
            { 31, 'Beetle Gorget',        'Beetle materials',               '' },
            { 33, 'Beetle Arrowheads',    'Beetle materials',               '' },
            { 37, 'Horn Ring',            'Horn materials',                 '' },
            { 41, 'Bone Knife',           'Bone materials',                 '' },
            { 43, 'Horn Arrowheads',      'Horn materials',                 '' },
            { 47, 'Horn',                 'Horn materials',                 '' },
            { 53, 'Scorpion Arrowheads',  'Scorpion materials',             '' },
            { 60, 'Scorpion Ring',        'Scorpion materials',             '' },
            { 63, 'Demon Arrowheads',     'Demon materials',                '' },
            { 64, 'Scorpion Mask',        'Scorpion materials',             '' },
            { 68, 'Bone Patas',           'Bone materials',                 '' },
            { 69, 'Beast Horn',           'Beast Horn',                     '' },
            { 70, 'Demon\'s Ring',        'Demon materials',                '' },
            { 78, 'Marid Tusk Arrowheads','Marid Tusk',                     '' },
            { 81, 'Marid Ring',           'Marid materials',                '' },
            { 87, 'Dragon Mask',          'Dragon materials',               '' },
            { 93, 'Carapace Helm',        'Carapace materials',             '' },
            { 97, 'Scorpion Helm',        'Scorpion materials',             '' },
            {100, 'Chronos Tooth',        'Chronos Tooth',                  '' },
        },
    },
    {
        name     = 'Alchemy',
        skill_id = 7,
        color = { 0.50, 0.85, 0.95, 1.0 },
        recipes = {
            {  6, 'Tsurara',              '',                               '' },
            {  9, 'Cornstarch',           '',                               '' },
            { 11, 'Poison Dust',          'Giant Stinger',                  'From Bees in Wajaom Woodlands' },
            { 16, 'Mercury',              'Mercury materials',              '' },
            { 18, 'Poison Potion',        'Poison Dust + materials',        '' },
            { 24, 'Silent Oil',           '',                               '' },
            { 29, 'Yellow Textile Dye',   '',                               '' },
            { 34, 'Artificial Lens',      '',                               '' },
            { 40, 'Potion',               '',                               '' },
            { 45, 'Carbon Fiber',         '',                               '' },
            { 50, 'Ether',                '',                               '' },
            { 56, 'Cermet Chunk',         '',                               '' },
            { 60, 'Hi-Potion',            '',                               '' },
            { 61, 'Venom Dust',           'Scorpion Stinger',               '' },
            { 65, 'Chocotonic',           '',                               'Yellow Ginseng from Digging Attowha'},
            { 68, 'Venom Potion',         'Venom Dust',                     '' },
            { 71, 'Holy Maul',            '',                               'Mauls drop from Garnet Quadav' },
            { 76, 'Venom Bolt Heads',     '',                               '' },
            { 78, 'Paralyze Potion',      'Paralysis Dust + materials',     'Buy Paralysis Dust from Stinknix in Lower Jeuno' },
            { 81, 'Holy Wand',            '',                               '' },
            { 86, 'Stun Kukri',           '',                               '' },
            { 87, 'Holy Leather',         '',                               '' },
            { 91, 'Mamushito',            '',                               '' },
            { 93, 'Icarus Wing',          '',                               '' },
            { 97, 'Ice Shield',           '',                               '' },
            { 99, 'Ephedra Ring',         '',                               '' },
            {102, 'Sun Water',            'Philosopher\'s Stone + materials','Stone from Chocobo Digging in Altepa Deserts' },
        },
    },
    {
        name     = 'Cooking',
        skill_id = 8,
        color = { 1.00, 0.65, 0.40, 1.0 },
        recipes = {
            {  3, 'Carrot Broth',         'Water Crystal, San d\'Orian Carrot x4',                                                   '' },
            {  4, 'Hard-boiled Egg',      'Fire Crystal, Lizard Egg x4 (or Bird Egg x6), Distilled Water',                           '' },
            { 10, 'Orange Juice',         'Water Crystal, Saruta Orange x4',                                                          '' },
            { 14, 'Tortilla',             'Fire Crystal, Olive Oil, San d\'Orian Flour, Millioncorn, Rock Salt',                      '' },
            { 20, 'Selbina Butter',       'Ice Crystal, Selbina Milk, Rock Salt',                                                     '' },
            { 20, 'Apple Juice',          'Water Crystal, Faerie Apple x4',                                                           'Craft and dump at NPC' },
            { 22, 'Baked Popoto',         'Fire Crystal, Popoto, Selbina Butter',                                                     '' },
            { 29, 'Insect Ball',          'Earth Crystal, Millioncorn, Little Worm, Distilled Water',                                 '' },
            { 34, 'Iron Bread',           'Fire Crystal, San d\'Orian Flour, Rock Salt, Distilled Water',                             '' },
            { 40, 'Ulbuconut Milk',       'Wind Crystal, Elshimo Coconut or Ulbuconut',                                               '' },
            { 42, 'Pie Dough',            'Water Crystal, San d\'Orian Flour, Selbina Butter, Rock Salt',                             '' },
            { 48, 'Apple Pie',            'Fire Crystal, Pie Dough, Maple Sugar, Cinnamon, Lizard Egg, Faerie Apple',                 'Cap test item' },
            { 50, 'Grape Juice',          'Dark Crystal, San d\'Orian Grape x4',                                                      'Used in later recipes at Lv56 & Lv86' },
            { 51, 'Orange au Lait',       'Water Crystal, Saruta Orange x2, Honey, Selbina Milk',                                    '' },
            { 56, 'Mulsum',               'Ice Crystal, Grape Juice, Honey, Distilled Water',                                         '' },
            { 60, 'Yagudo Drink',         'Dark Crystal, Yagudo Cherry, Buburimu Grape x3',                                           'Cap test item' },
            { 61, 'Stone Cheese',         'Dark Crystal, Selbina Milk, Rock Salt',                                                    'Cheaper alt; vendor back to break even' },
            { 62, 'Apple au Lait',        'Water Crystal, Faerie Apple x2, Honey, Selbina Milk',                                     '' },
            { 68, 'Colored Egg',          'Fire Crystal, San d\'Orian Carrot, Lizard/Bird Egg, La Theine Cabbage, Distilled Water',  '' },
            { 72, 'Pear au Lait',         'Water Crystal, Derfland Pear x2, Honey, Selbina Milk',                                   '' },
            { 79, 'Chocomilk',            'Fire Crystal, Kukuru Bean x4, Selbina Milk, Maple Sugar, Distilled Water, Honey',         '' },
            { 81, 'Pamama au Lait',       'Water Crystal, Pamamas x2, Honey, Selbina Milk',                                          '' },
            { 86, 'Marron Glace',         'Dark Crystal, Maple Sugar, Chestnut x2, Grape Juice',                                     '' },
            { 90, 'Fried Pototo',         'Fire Crystal, Popoto, Olive Oil, White Bread, Bird Egg',                                   'Profitable; ride to 101 while earning gil' },
            { 97, 'Dawn Mulsum',          'Ice Crystal, Holy Water, White Honey, Grape Juice',                                        '' },
            {105, 'Dragon Fruit au Lait', 'Water Crystal, Honey, Selbina Milk, Dragon Fruit x2',                                     '' },
        },
    },
};

-- Event: load
ashita.events.register('load', 'crafty_load', function()
end);

-- Event: unload
ashita.events.register('unload', 'crafty_unload', function()
end);

-- Event: command
ashita.events.register('command', 'crafty_command', function(e)
    local args = e.command:args();
    if (#args == 0) then return; end
    if (args[1]:lower() ~= '/crafty') then return; end

    crafty.is_open[1] = not crafty.is_open[1];
    e.blocked = true;
end);

-- Helpers
local function get_craft_skill(skill_id)
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    if (player == nil) then return 0, false; end

    local ok, skill = pcall(function() return player:GetCraftSkill(skill_id); end);
    if (not ok or skill == nil) then return 0, false; end

    return skill:GetSkill(), skill:IsCapped();
end

local function matches_search(recipe, term)
    if (term == '') then return true; end
    local lterm = term:lower();
    if (tostring(recipe[1]):find(lterm, 1, true)) then return true; end
    if (recipe[2]:lower():find(lterm, 1, true))   then return true; end
    if (recipe[3]:lower():find(lterm, 1, true))   then return true; end
    if (recipe[4]:lower():find(lterm, 1, true))   then return true; end
    return false;
end

-- Event: d3d_present (render)
ashita.events.register('d3d_present', 'crafty_present', function()
    if (not crafty.is_open[1]) then return; end

    imgui.SetNextWindowSize({ 700, 500 }, ImGuiCond_FirstUseEver);
    imgui.SetNextWindowSizeConstraints({ 400, 200 }, { 1600, 1200 });

    if (not imgui.Begin('Crystal Warrior Crafting Guide', crafty.is_open, ImGuiWindowFlags_None)) then
        imgui.End();
        return;
    end

    -- Search bar
    imgui.SetNextItemWidth(-1);
    imgui.InputText('##crafty_search', crafty.search, 128);
    local term = crafty.search[1]:match('^[^%z]*') or '';

    imgui.Spacing();

    -- Tab bar for each craft
    if (imgui.BeginTabBar('##crafty_tabs', ImGuiTabBarFlags_None)) then
        for _, craft in ipairs(CRAFTS) do
            local tab_color = craft.color;
            imgui.PushStyleColor(ImGuiCol_Tab,        { tab_color[1]*0.5, tab_color[2]*0.5, tab_color[3]*0.5, 0.8 });
            imgui.PushStyleColor(ImGuiCol_TabHovered, { tab_color[1]*0.7, tab_color[2]*0.7, tab_color[3]*0.7, 1.0 });
            imgui.PushStyleColor(ImGuiCol_TabActive,  { tab_color[1],     tab_color[2],     tab_color[3],     1.0 });

            if (imgui.BeginTabItem(craft.name, nil, ImGuiTabItemFlags_None)) then
                imgui.PopStyleColor(3);

                local my_skill, my_capped = get_craft_skill(craft.skill_id);
                imgui.TextColored(tab_color, ('Your %s Skill: %d%s'):format(craft.name, my_skill, my_capped and ' (Capped)' or ''));
                imgui.Separator();

                local flags = bit.bor(
                    ImGuiTableFlags_BordersOuter,
                    ImGuiTableFlags_BordersInnerH,
                    ImGuiTableFlags_RowBg,
                    ImGuiTableFlags_ScrollY,
                    ImGuiTableFlags_SizingFixedFit
                );

                local avail_x, avail_y = imgui.GetContentRegionAvail();

                if (imgui.BeginTable('##crafty_table_' .. craft.name, 4, flags, { avail_x, avail_y })) then
                    imgui.TableSetupScrollFreeze(0, 1);
                    imgui.TableSetupColumn('Lvl',       ImGuiTableColumnFlags_WidthFixed,   40);
                    imgui.TableSetupColumn('Recipe',    ImGuiTableColumnFlags_WidthFixed,   160);
                    imgui.TableSetupColumn('Materials', ImGuiTableColumnFlags_WidthStretch, 0);
                    imgui.TableSetupColumn('Notes',     ImGuiTableColumnFlags_WidthStretch, 0);
                    imgui.TableHeadersRow();

                    for _, r in ipairs(craft.recipes) do
                        if (matches_search(r, term)) then
                            local reachable = my_skill >= r[1];
                            local row_color = reachable and { 0.40, 1.00, 0.40, 1.0 } or { 1.00, 1.00, 1.00, 1.0 };

                            imgui.TableNextRow();
                            imgui.TableSetColumnIndex(0);
                            imgui.TextColored(row_color, (reachable and '+ ' or '  ') .. tostring(r[1]));
                            imgui.TableSetColumnIndex(1);
                            imgui.TextColored(row_color, r[2]);
                            imgui.TableSetColumnIndex(2);
                            imgui.TextColored(row_color, r[3]);
                            imgui.TableSetColumnIndex(3);
                            if (r[4] ~= '') then
                                imgui.TextColored({ 0.75, 0.75, 0.75, 1.0 }, r[4]);
                            end
                        end
                    end

                    imgui.EndTable();
                end
                imgui.EndTabItem();
            else
                imgui.PopStyleColor(3);
            end
        end
        imgui.EndTabBar();
    end

    imgui.End();
end);
