addon.name    = 'cwcraft';
addon.author  = 'Lexia';
addon.version = '1.0';
addon.desc    = 'CatsEyeXI crafting guide viewer (bg-wiki Suggested Recipes)';

require('common');
local imgui = require('imgui');

local cwcraft = T{
    is_open = T{ true },
    search  = T{ string.rep('\0', 128) },
};

-- Source: https://www.bg-wiki.com/ffxi/CatseyeXI_Crafting_Guide#Suggested_Recipes
-- Columns: { level, name, materials, notes }
local CRAFTS = {
    {
        name     = 'Fishing',
        skill_id = 0,
        color = { 0.35, 0.70, 1.00, 1.0 },
        recipes = {
            {  0, 'Crayfish',       'Halcyon Rod, Little Worm',                  'West Ronfaure' },
            {  7, 'Moat Carp',      'Halcyon Rod, Insect Ball',                  'West Ronfaure' },
            { 11, 'Quus',           'Halcyon Rod, Sabiki Rig',                   'Korroloka Tunnel' },
            { 19, 'Cheval Salmon',  'Halcyon Rod, Fly Lure',                     'East Ronfaure river' },
            { 21, 'Nebimonite',     'Halcyon Rod, Shrimp Lure',                  'Sea Serpent Grotto' },
            { 27, 'Pipira',         'Halcyon Rod, Minnow',                       'Windurst Waters' },
            { 29, 'Ogre Eel',       'Halcyon Rod, Shrimp Lure',                  'Multiple sea locations' },
            { 35, 'Nosteau Herring','Halcyon Rod, Sardine Ball',                 'Qufim Island' },
            { 39, 'Coral Butterfly','Halcyon Rod, Worm Lure',                    'Kazham' },
            { 40, 'Black Eel',      'Halcyon Rod, Trout Ball',                   'Zeruhn Mines' },
            { 47, 'Icefish',        'Halcyon Rod, Sabiki Rig',                   'Beaucedine Glacier' },
            { 49, 'Giant Donko',    'Composite Rod, Frog Lure',                  'Rabao / E. Altepa Desert' },
            { 50, 'Elshimo Newt',   'Halcyon Rod, Frog Lure',                    'Yhoator Jungle' },
            { 60, 'Crescent Fish',  'Halcyon Rod, Fly Lure',                     'East Sarutabaruta' },
            { 69, 'Zebra Eel',      'Composite Rod, Shrimp Lure',                'Den of Rancor' },
            { 70, 'Bladefish',      'Composite Rod, Meatball / Slice of Bluetail','Multiple seas' },
            { 71, 'Gavial Fish',    'Composite Rod, Lizard Lure / Meatball',     'North Gustaberg' },
            { 81, 'Bastore Bream',  'Composite Rod, Shrimp Lure',                'Port Windurst / Bastok' },
            { 81, 'Mercanbaligi',   'Composite Rod, Shrimp Lure',                'Nashmau' },
            { 86, 'Ahtapot',        'Composite Rod, Shrimp Lure',                'Nashmau' },
            { 90, 'Emperor Fish',   'Composite Rod, Peeled Crayfish / Trout Ball','Beaucedine / Jugner' },
            { 91, 'Dil',            'Halcyon / Hume Rod, Sliced Cod',            'Talacca Cove' },
            { 91, 'Black Sole',     'Composite / Halcyon / Hume Rod, Sinking Minnow / Sliced Cod','Jeuno / Qufim' },
            { 96, 'Armored Pisces', 'Composite Rod, Frog Lure / Minnow',         'Oldton Movalpolos' },
            {108, 'Gerrothorax',    'Composite Rod, Meatball',                   'Pashhow Marshlands (S)' },
        },
    },
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
            {  3, 'Carrot Broth',         'San d\'Orian Carrot x4',                                                   '' },
            {  4, 'Hard-boiled Egg',      'Lizard Egg x4 (or Bird Egg x6), Distilled Water',                           '' },
            { 10, 'Orange Juice',         'Saruta Orange x4',                                                          '' },
            { 14, 'Tortilla',             'Olive Oil, San d\'Orian Flour, Millioncorn, Rock Salt',                      '' },
            { 20, 'Selbina Butter',       'Selbina Milk, Rock Salt',                                                     '' },
            { 20, 'Apple Juice',          'Faerie Apple x4',                                                           'Craft and dump at NPC' },
            { 22, 'Baked Popoto',         'Popoto, Selbina Butter',                                                     '' },
            { 29, 'Insect Ball',          'Millioncorn, Little Worm, Distilled Water',                                 '' },
            { 34, 'Iron Bread',           'San d\'Orian Flour, Rock Salt, Distilled Water',                             '' },
            { 40, 'Ulbuconut Milk',       'Elshimo Coconut or Ulbuconut',                                               '' },
            { 42, 'Pie Dough',            'San d\'Orian Flour, Selbina Butter, Rock Salt',                             '' },
            { 48, 'Apple Pie',            'Pie Dough, Maple Sugar, Cinnamon, Lizard Egg, Faerie Apple',                 'Cap test item' },
            { 50, 'Grape Juice',          'San d\'Orian Grape x4',                                                      'Used in later recipes at Lv56 & Lv86' },
            { 51, 'Orange au Lait',       'Saruta Orange x2, Honey, Selbina Milk',                                    '' },
            { 56, 'Mulsum',               'Grape Juice, Honey, Distilled Water',                                         '' },
            { 60, 'Yagudo Drink',         'Yagudo Cherry, Buburimu Grape x3',                                           'Cap test item' },
            { 61, 'Stone Cheese',         'Selbina Milk, Rock Salt',                                                    'Cheaper alt; vendor back to break even' },
            { 62, 'Apple au Lait',        'Faerie Apple x2, Honey, Selbina Milk',                                     '' },
            { 68, 'Colored Egg',          'San d\'Orian Carrot, Lizard/Bird Egg, La Theine Cabbage, Distilled Water',  '' },
            { 72, 'Pear au Lait',         'Derfland Pear x2, Honey, Selbina Milk',                                   '' },
            { 79, 'Chocomilk',            'Kukuru Bean x4, Selbina Milk, Maple Sugar, Distilled Water, Honey',         '' },
            { 81, 'Pamama au Lait',       'Pamamas x2, Honey, Selbina Milk',                                          '' },
            { 86, 'Marron Glace',         'Maple Sugar, Chestnut x2, Grape Juice',                                     '' },
            { 90, 'Fried Pototo',         'Popoto, Olive Oil, White Bread, Bird Egg',                                   'Profitable; ride to 101 while earning gil' },
            { 97, 'Dawn Mulsum',          'Holy Water, White Honey, Grape Juice',                                        '' },
            {105, 'Dragon Fruit au Lait', 'Honey, Selbina Milk, Dragon Fruit x2',                                     '' },
        },
    },
};

------------------------------------------------------------------------
-- Material sources
-- Key = material name string (should match what appears in recipes[3]).
-- Each entry is a list of sources: { type, desc }
-- Types: 'log' | 'mine' | 'harvest' | 'excavate' | 'dig' | 'buy' | 'farm'
------------------------------------------------------------------------

local SOURCES = {
    -- Woodworking logs
    ['Maple Log']        = { { type='log',  desc='East/West Ronfaure, La Theine Plateau' } },
    ['Ash Log']          = { { type='log',  desc='West Ronfaure, Jugner Forest, La Theine Plateau' } },
    ['Willow Log']       = { { type='log',  desc='Jugner Forest, Batallia Downs' } },
    ['Walnut Log']       = { { type='log',  desc='Batallia Downs, North Gustaberg' } },
    ['Yew Log']          = { { type='log',  desc='Batallia Downs, Rolanberry Fields, Grauberg (S)' } },
    ['Elm Log']          = { { type='log',  desc='Pashhow Marshlands, Rolanberry Fields, Grauberg (S)' } },
    ['Chestnut Log']     = { { type='log',  desc='Rolanberry Fields, Sauromugue Champaign, La Theine Plateau' } },
    ['Oak Log']          = { { type='log',  desc='Sauromugue Champaign, Meriphataud Mountains' } },
    ['Rosewood Log']     = { { type='log',  desc='Yhoator Jungle, Yuhtunga Jungle' } },
    ['Mahogany Log']     = { { type='log',  desc='Yhoator Jungle, Cape Teriggan' } },
    ['Ebony Log']        = { { type='log',  desc='Xarcabard, Uleguerand Range, Bibiki Bay' } },
    ['Kapor Log']        = { { type='log',  desc='Yhoator Jungle' } },
    ['Jacaranda Log']    = { { type='log',  desc='Grauberg (S) (Very Rare), East Ronfaure (S)' } },
    -- Smithing ores
    ['Tin Ore']          = { { type='buy',  desc='N Sandy (E-5) Doggomehr or Bastok Metalworks (E-9) Amulya' } },
    ['Iron Ore']         = { { type='mine', desc='Zeruhn Mines, Gusgen Mines, Konschtat Highlands' },
                              { type='buy',  desc='Bastok Mines - Tforge (H-8)' } },
    ['Copper Ore']       = { { type='mine', desc='Zeruhn Mines, Gusgen Mines' },
                              { type='buy',  desc='Port Bastok - Werei (J-8)' } },
    ['Darksteel Ore']    = { { type='mine', desc='Ifrit\'s Cauldron, Beaucedine Glacier' } },
    ['Adaman Ore']       = { { type='mine', desc='Garlaige Citadel (S) (Very Rare)' },
                              { type='farm', desc='Pygmytoise in Gustav Tunnel' } },
    ['Wootz Ore']        = { { type='mine', desc='Grauberg (S) (Very Rare), Mog Garden (Mineral Vein, Rank 6+)' } },
    -- Goldsmithing ores
    ['Silver Ore']       = { { type='mine', desc='Gusgen Mines, Ordelle\'s Caves, Konschtat Highlands' } },
    ['Mythril Ore']      = { { type='mine', desc='Palborough Mines, Gustav Tunnel' } },
    ['Gold Ore']         = { { type='mine', desc='Ifrit\'s Cauldron, Gustav Tunnel' } },
    ['Platinum Ore']     = { { type='mine', desc='Ordelle\'s Caves (Very Rare), Konschtat Highlands (seasonal)' },
                              { type='buy',  desc='Bastok Markets - Teerth (H-8), req. Craftsman rank' } },
    ['Orichalcum Ore']   = { { type='mine', desc='Gustav Tunnel (Crystal Warrior only), Konschtat Highlands (seasonal)' } },
    -- Clothcraft
    ['Grass Fiber']      = { { type='harvest', desc='East/West Sarutabaruta, Tahrongi Canyon' } },
    ['Cotton Fiber']     = { { type='harvest', desc='Tahrongi Canyon, Buburimu Peninsula' } },
    ['Yagudo Feather']   = { { type='buy',  desc='Windurst Waters (H-8) Maqu Molpih / N Sandy Antonian, 36g' },
                              { type='farm', desc='Yagudo in E/W Sarutabaruta, Tahrongi Canyon' } },
    ['Bird Feather']     = { { type='farm', desc='Birds in N/S Gustaberg, La Theine Plateau, Batallia Downs' } },
    ['Rainbow Thread']   = { { type='harvest', desc='Crawlers\' Nest (Very Rare, quest-gated)' } },
    -- Leathercraft hides
    ['Sheep Hide']       = { { type='farm', desc='Sheep in La Theine Plateau, Konschtat Highlands' },
                              { type='buy',  desc='S Sandy (D-8) Cletae, ~100g' } },
    ['Rabbit Hide']      = { { type='farm', desc='Rabbits in East/West Ronfaure' } },
    ['Lizard Hide']      = { { type='buy',  desc='S Sandy (D-8) Cletae, 600g (Initiate rank)' } },
    ['Dhalmel Hide']     = { { type='farm', desc='Wild Dhalmel in Tahrongi Canyon, Bull Dhalmel in Buburimu' },
                              { type='buy',  desc='S Sandy (D-8) Cletae, 2400g (Initiate rank)' } },
    ['Ram Hide']         = { { type='buy',  desc='S Sandy (D-8) Kueh/Cletae, ~937g' } },
    ['Raptor Hide']      = { { type='buy',  desc='S Sandy (D-8) Kueh/Cletae, ~2155g' } },
    ['Tiger Hide']       = { { type='farm', desc='Forest Tiger (Jugner Forest), Sabertooth Tiger (Sauromugue)' },
                              { type='buy',  desc='S Sandy (D-8) Kueh, 1312g (3:00-18:00)' } },
    ['Coeurl Hide']      = { { type='farm', desc='Coeurl (Meriphataud Mts), Champaign Coeurl (Sauromugue)' },
                              { type='buy',  desc='S Sandy (D-8) Kueh, 2700g (3:00-18:00)' } },
    ['Manticore Hide']   = { { type='farm', desc='Manticores in E/W Altepa Desert, Labyrinth of Onzozo' } },
    -- Bonecraft
    ['Marid Tusk']       = { { type='farm', desc='Marid in Bhaflau Thickets, Wajaom Woodlands (break tusks)' },
                              { type='buy',  desc='Windurst Woods (H-13) Retto-Marutto, 4500g (Craftsman rank)' } },
    ['Chronos Tooth']    = { { type='buy',  desc='Trade 23x L.Jadeshell to Antiqix in Castle Oztroja (F-8)' } },
    -- Alchemy
    ['Giant Stinger']    = { { type='farm', desc='Worker/Soldier Pephredo in Wajaom Woodlands' } },
    ['Scorpion Stinger'] = { { type='farm', desc='Maze Scorpion / Labyrinth Scorpion in Maze of Shakhrami' } },
    ['Venom Dust']       = { { type='buy',  desc='Bastok Mines (K-6) Odoba or Lower Jeuno (H-9) Stinknix, 1035g' } },
};

local TYPE_INFO = {
    log      = { label='Logging',     color={ 0.50, 0.88, 0.50, 1.0 } },
    mine     = { label='Mining',      color={ 0.75, 0.75, 0.80, 1.0 } },
    harvest  = { label='Harvesting',  color={ 1.00, 0.78, 0.35, 1.0 } },
    excavate = { label='Excavating',  color={ 0.80, 0.55, 0.35, 1.0 } },
    dig      = { label='Chocobo Dig', color={ 1.00, 0.90, 0.30, 1.0 } },
    buy      = { label='Buy',         color={ 0.50, 0.85, 0.95, 1.0 } },
    farm     = { label='Farm',        color={ 0.90, 0.50, 0.50, 1.0 } },
};

local function show_source_tooltip(mat_str)
    local sources = SOURCES[mat_str];
    if sources == nil then return; end

    imgui.BeginTooltip();
    imgui.TextColored({ 1.0, 0.90, 0.40, 1.0 }, mat_str);
    imgui.Separator();
    for _, s in ipairs(sources) do
        local ti = TYPE_INFO[s.type] or { label=s.type, color={ 1, 1, 1, 1 } };
        imgui.TextColored(ti.color, string.format('[%s]', ti.label));
        imgui.SameLine();
        imgui.Text(s.desc);
    end
    imgui.EndTooltip();
end

-- Event: load
ashita.events.register('load', 'cwcraft_load', function()
end);

-- Event: unload
ashita.events.register('unload', 'cwcraft_unload', function()
end);

-- Event: command
ashita.events.register('command', 'cwcraft_command', function(e)
    local args = e.command:args();
    if (#args == 0) then return; end
    if (args[1]:lower() ~= '/cwcraft') then return; end

    cwcraft.is_open[1] = not cwcraft.is_open[1];
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
ashita.events.register('d3d_present', 'cwcraft_present', function()
    if (AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0) == 0) then return; end
    if (not cwcraft.is_open[1]) then return; end

    imgui.SetNextWindowSize({ 700, 500 }, ImGuiCond_FirstUseEver);
    imgui.SetNextWindowSizeConstraints({ 400, 200 }, { 1600, 1200 });

    if (not imgui.Begin('Crystal Warrior Crafting Guide', cwcraft.is_open, ImGuiWindowFlags_None)) then
        imgui.End();
        return;
    end

    -- Search bar
    imgui.SetNextItemWidth(-1);
    imgui.InputText('##cwcraft_search', cwcraft.search, 128);
    local term = cwcraft.search[1]:match('^[^%z]*') or '';

    imgui.Spacing();

    -- Tab bar for each craft
    if (imgui.BeginTabBar('##cwcraft_tabs', ImGuiTabBarFlags_None)) then
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

                if (imgui.BeginTable('##cwcraft_table_' .. craft.name, 4, flags, { avail_x, avail_y })) then
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
                            if (imgui.IsItemHovered() and SOURCES[r[3]] ~= nil) then
                                show_source_tooltip(r[3]);
                            end
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
