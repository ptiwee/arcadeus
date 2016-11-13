class UserConfig {
    </ label="Enable Animations", options="Yes,No", order=1 />
    conf_animate="Yes";

    </label="Enable Artworks", options="Yes,No", order=2 />
    conf_artworks="Yes";
}

local SCREEN_WIDTH = fe.layout.width;
local SCREEN_HEIGHT = fe.layout.height;

local MARGIN = SCREEN_HEIGHT/100;

local SNAP_WIDTH = 2*SCREEN_WIDTH/3;
local SNAP_HEIGHT = 2*SCREEN_HEIGHT/3;

local INFO_WIDTH = SCREEN_WIDTH - SNAP_WIDTH;
local INFO_HEIGHT = SNAP_HEIGHT;

local CONV_HEIGHT = SCREEN_HEIGHT - SNAP_HEIGHT - 6*MARGIN;
local CONV_WIDTH = SCREEN_WIDTH;

local TILE_WIDTH = CONV_HEIGHT - 4*MARGIN;
local TILE_HEIGHT = TILE_WIDTH;
local TILES_NB = SCREEN_WIDTH/TILE_WIDTH + 3;
local TILES_CENTER = 2*SCREEN_WIDTH/9;
local MAIN_TILE = 2;
local MAIN_WIDTH = 0;
local MAIN_HEIGHT = 0;
local BORDER = TILE_WIDTH/40;

local SYSTEM_WIDTH = SNAP_HEIGHT/2;
local SYSTEM_HEIGHT = SYSTEM_WIDTH;

local CONTROLS_WIDTH = SCREEN_HEIGHT-SNAP_HEIGHT-CONV_HEIGHT-2*BORDER
local CONTROLS_HEIGHT = CONTROLS_WIDTH

local TRANSITION_MS = 120;

local config = fe.get_config();
local animate = (config["conf_animate"] == "Yes") ? true : false;
local artworks = (config["conf_artworks"] == "Yes") ? true : false;

local bg = fe.add_text("", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
bg.set_bg_rgb(239, 239, 239);

/* Video Snap */
local snap_bg = fe.add_image("snap_bg.jpg", 0, 0, SNAP_WIDTH, SNAP_HEIGHT);
local snap;
if (artworks) {
    snap = fe.add_artwork("snap", 0, 0, SNAP_WIDTH, SNAP_HEIGHT);
    snap.preserve_aspect_ratio = true;
    snap.video_flags = Vid.NoAudio;
    snap.trigger = Transition.EndNavigation;
}

/* System */
local system = fe.add_image("systems/[DisplayName]", 0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT);

/* Title */
local title_txt = fe.add_text("[Title]", SNAP_WIDTH, 0, INFO_WIDTH, INFO_HEIGHT/3);
title_txt.charsize = SCREEN_HEIGHT/14;
title_txt.word_wrap = true;
title_txt.font = "Single";
title_txt.style = Style.Bold;

local title_art = null;
if (artworks) {
    title_art = fe.add_artwork("wheel", SNAP_WIDTH + 4*MARGIN, MARGIN, INFO_WIDTH - 8*MARGIN, INFO_HEIGHT/4 - 2*MARGIN);
    title_art.preserve_aspect_ratio = true;
}

/* Extra infos */
local extra = fe.add_text("[Extra]", SNAP_WIDTH, INFO_HEIGHT/4, INFO_WIDTH, 2*INFO_HEIGHT/4);
extra.align = Align.Centre;
extra.word_wrap = true;
extra.charsize = SCREEN_HEIGHT/50;
extra.font = "Lato-Medium";
extra.set_rgb(124, 137, 144);

/* Copyright */
local publisher = null;
if (artworks) {
    publisher = fe.add_image("pubs/[Manufacturer]", SNAP_WIDTH + MARGIN, 6*INFO_HEIGHT/8 + 4*MARGIN, INFO_WIDTH - 2*MARGIN, INFO_HEIGHT/8 - 4*MARGIN);
    publisher.preserve_aspect_ratio = true;
}

local copyright = fe.add_text("© [Year] [Manufacturer]", SNAP_WIDTH, 7*INFO_HEIGHT/8, INFO_WIDTH, INFO_HEIGHT/8);
copyright.align = Align.Centre;
copyright.charsize = SCREEN_HEIGHT/42;
copyright.font = "BebasNeueBold";
copyright.set_rgb(124, 137, 144);

/* Conveyor */
local conv_shadow = fe.add_image("conv_shadow.png", 0, SNAP_HEIGHT-BORDER, CONV_WIDTH, BORDER);
local conv_shadow2 = fe.add_image("conv_shadow2.png", 0, SNAP_HEIGHT+CONV_HEIGHT, CONV_WIDTH, BORDER);
local conv_bg = fe.add_text("", 0, SNAP_HEIGHT, CONV_WIDTH, CONV_HEIGHT);

/* Controls */
local btn_left_right = fe.add_image("btn_left_right.png", 2*SCREEN_WIDTH/5, SNAP_HEIGHT+CONV_HEIGHT+BORDER, CONTROLS_WIDTH, CONTROLS_HEIGHT);
local txt_left_right = fe.add_text("JEU", 2*SCREEN_WIDTH/5 + CONTROLS_WIDTH, SNAP_HEIGHT+CONV_HEIGHT+BORDER, SCREEN_WIDTH/5 - CONTROLS_WIDTH, CONTROLS_HEIGHT);
txt_left_right.align = Align.Left;
txt_left_right.charsize = SCREEN_HEIGHT/38;
txt_left_right.font = "BebasNeueBold";
txt_left_right.set_rgb(124, 137, 144);

local btn_up_down = fe.add_image("btn_up_down.png", 3*SCREEN_WIDTH/5, SNAP_HEIGHT+CONV_HEIGHT+BORDER, CONTROLS_WIDTH, CONTROLS_HEIGHT);
local txt_up_down = fe.add_text("CONSOLE", 3*SCREEN_WIDTH/5 + CONTROLS_WIDTH, SNAP_HEIGHT+CONV_HEIGHT+BORDER, SCREEN_WIDTH/5 - CONTROLS_WIDTH, CONTROLS_HEIGHT);
txt_up_down.align = Align.Left;
txt_up_down.charsize = SCREEN_HEIGHT/38;
txt_up_down.font = "BebasNeueBold";
txt_up_down.set_rgb(124, 137, 144);

local btn_a = fe.add_image("btn_a.png", 4*SCREEN_WIDTH/5, SNAP_HEIGHT+CONV_HEIGHT+BORDER, CONTROLS_WIDTH, CONTROLS_HEIGHT);
local txt_a = fe.add_text("JOUER", 4*SCREEN_WIDTH/5 + CONTROLS_WIDTH, SNAP_HEIGHT+CONV_HEIGHT+BORDER, SCREEN_WIDTH/5 - CONTROLS_WIDTH, CONTROLS_HEIGHT);
txt_a.align = Align.Left;
txt_a.charsize = SCREEN_HEIGHT/38;
txt_a.font = "BebasNeueBold";
txt_a.set_rgb(124, 137, 144);

/* Clic sound */
local clic = null;
if (animate)
    clic = fe.add_sound("clic.mp3");

local colors = [
	[97, 189, 109],
	[26, 188, 156],
	[84, 172, 210],
	[44, 130, 201],
	[147, 101, 184],
	[71, 85, 119],
	[251, 160, 38],
	[235, 107, 86],
    [226, 80, 65],
    [163, 143, 132],
];

function strToColor(string) {
	local sum = 0;

	for (local i=0; i<string.len(); i++)
		sum += string[i];

	return colors[sum%colors.len()];
}

local tiles = [];

class Tile {
    m_art = null;
    m_txt = null;
    m_shadow = null;
    m_pos = 0;
    m_size_x = 0;
    m_size_y = 0;

    function refresh(percent) {
        if (m_pos < MAIN_TILE) {
            m_txt.x = TILES_CENTER - tiles[MAIN_TILE].m_txt.width/2 + (m_pos - MAIN_TILE + percent) * (3*BORDER + TILE_WIDTH);
        } else if (m_pos == MAIN_TILE) {
            m_txt.x = TILES_CENTER - tiles[MAIN_TILE].m_txt.width/2 + percent * (3*BORDER + TILE_WIDTH);
        } else {
            m_txt.x = TILES_CENTER + tiles[MAIN_TILE].m_txt.width/2 + 3*BORDER + (m_pos - MAIN_TILE - 1 + percent) * (3*BORDER + TILE_WIDTH);
        }

        align();
    } 

    function swap(other) {
        if (artworks) {
            try {
                m_art.swap(other.m_art);
            }
            catch (e)
            {
                local tmp = other.m_art;
                other.m_art = m_art;
                m_art = tmp;
            }
        }
    }

    function reload() {
        if (artworks) {
            m_size_x = m_art.texture_width;
            m_size_y = m_art.texture_height;

            if (m_size_x < m_size_y) {
                m_art.subimg_width = m_size_x;
                m_art.subimg_height = m_size_x;
            } else {
                m_art.subimg_width = m_size_y;
                m_art.subimg_height = m_size_y;
            }
        }

		local color = strToColor(fe.game_info(Info.Title, m_pos - 2));
		m_txt.set_bg_rgb(color[0], color[1], color[2]);
    } 

    function grow(percent) {
        m_txt.height = TILE_HEIGHT + (MAIN_HEIGHT - TILE_HEIGHT) * percent;
        m_txt.width = TILE_WIDTH + (MAIN_WIDTH - TILE_WIDTH) * percent;

        m_txt.y = SNAP_HEIGHT + (2 + 4*percent)*MARGIN + TILE_HEIGHT - m_txt.height;

        align();

        if (artworks) {
            if (m_size_x < m_size_y) {
                m_art.subimg_height = m_size_x + (m_size_y - m_size_x) * percent;
                m_art.subimg_width = m_size_x;
            } else {
                m_art.subimg_height = m_size_y;
                m_art.subimg_width = m_size_y + (m_size_x - m_size_y) * percent;
            }
        }
    }

    function align() {
        if (artworks) {
            m_art.x = m_txt.x;
            m_art.y = m_txt.y;
            m_art.width = m_txt.width;
            m_art.height = m_txt.height;
        }

        m_shadow.x = m_txt.x - BORDER;
        m_shadow.y = m_txt.y - BORDER;
        m_shadow.width = m_txt.width + 2*BORDER;
        m_shadow.height = m_txt.height + 2*BORDER;
    }

    constructor(pos) {
        m_pos = pos;

        m_shadow = fe.add_image("shadow.png");

        m_txt = fe.add_text("[Title]", 0, 0, 0, 0);
        m_txt.charsize = SCREEN_HEIGHT/26;
        m_txt.word_wrap = true;
        m_txt.font = "BebasNeueBold";
        m_txt.set_rgb(239, 239, 239);

        m_txt.y = SNAP_HEIGHT + 2*MARGIN;
        m_txt.width = TILE_WIDTH;
        m_txt.height = TILE_HEIGHT;
        m_txt.index_offset = m_pos - MAIN_TILE;

        if (artworks) {
            m_art = fe.add_artwork("flyer");
            m_art.index_offset = m_pos - MAIN_TILE;
        }

    }
}

for (local i=0; i<TILES_NB; i++)
    tiles.push(Tile(i));

function on_transition(ttype, var, ttime) {
    /* Refresh display colors */
    if (ttype == Transition.ToNewList) {
		switch (fe.list.name) {
			case "arcade":
			case "nes":
            case "sms":
			case "megadrive":
            case "gamegear":
            MAIN_WIDTH = TILE_WIDTH * 1.35;
            MAIN_HEIGHT = TILE_HEIGHT * 1.89;
			break;

			case "gameboy":
			case "gbc":
			case "gba":
            case "ngpx":
			case "playstation":
            MAIN_WIDTH = TILE_WIDTH * 1.5;
            MAIN_HEIGHT = TILE_HEIGHT * 1.5;
			break;

			case "snes":
			case "n64":
            MAIN_WIDTH = TILE_WIDTH * 1.8;
            MAIN_HEIGHT = TILE_HEIGHT * 1.35;
			break;

            default:
            MAIN_WIDTH = TILE_WIDTH * 1.5;
            MAIN_HEIGHT = TILE_HEIGHT * 1.5;
            break;
		}

		switch (fe.list.name) {
			case "arcade":
			conv_bg.set_bg_rgb(230, 81, 0);
			break;
			case "nes":
			conv_bg.set_bg_rgb(209, 72, 65);
			break;
			case "snes":
			conv_bg.set_bg_rgb(251, 192, 45);
			break;
			case "n64":
			conv_bg.set_bg_rgb(76, 175, 80);
			break;
            case "gameboy":
            conv_bg.set_bg_rgb(83, 83, 83);
            break;
            case "gbc":
			conv_bg.set_bg_rgb(0, 168, 133);
			break;
            case "gba":
            conv_bg.set_bg_rgb(85, 57, 130);
            break;
            case "sms":
            conv_bg.set_bg_rgb(20, 132, 152);
            break;
			case "megadrive":
			conv_bg.set_bg_rgb(41, 105, 176);
			break;
            case "gamegear":
            conv_bg.set_bg_rgb(55, 71, 79);
            break;
            case "neogeo":
            conv_bg.set_bg_rgb(40, 50, 78);
            break;
            case "ngpx":
            conv_bg.set_bg_rgb(250, 197, 28);
            break;
			case "playstation":
			conv_bg.set_bg_rgb(33, 33, 33);
			break;
		}
    }

    /* Reload tiles */
    if (ttype == Transition.ToNewList ||
        ttype == Transition.FromOldSelection) {
        for (local i=0; i<tiles.len(); i++)
            tiles[i].reload();
    }

    /* Resize main title */
    if (ttype == Transition.ToNewList) {
        tiles[MAIN_TILE].grow(1);
    }

    /* Refresh tiles position */
    if (ttype == Transition.ToNewList ||
        ttype == Transition.FromOldSelection) {
        for (local i=0; i<tiles.len(); i++)
            tiles[i].refresh(0);
    }

    /* Switch title art/text */
    if (ttype == Transition.ToNewList ||
        ttype == Transition.FromOldSelection) {
        if (artworks) {
            if (fe.get_art("wheel") == "") {
                title_txt.visible = true;
                title_art.visible = false;
            } else {
                title_txt.visible = false;
                title_art.visible = true;
            }
        }

        local color = strToColor(fe.game_info(Info.Title));
        title_txt.set_rgb(color[0], color[1], color[2]);

        if (fe.game_info(Info.Manufacturer) == "" &&
            fe.game_info(Info.Year) == "") {
            copyright.visible = false;
        } else {
            copyright.visible = true;
        }
    }

    return false;
}

function on_animate(ttype, var, ttime) {
    /* Animate transition */
    if (ttype == Transition.ToNewSelection) {
        if (ttime < TRANSITION_MS) {
            if (tiles[MAIN_TILE].m_txt.height > TILE_HEIGHT)
                tiles[MAIN_TILE].grow(1-ttime.tofloat()/TRANSITION_MS);

            for (local i=0; i<tiles.len(); i++)
                tiles[i].refresh(-var * ttime.tofloat()/TRANSITION_MS);

            return true;
        }

        tiles[MAIN_TILE].grow(0);

        if (var > 0) {
            for (local i=1; i<tiles.len(); i++)
                tiles[i].swap(tiles[i-1]);
        } else {
            for (local i=tiles.len()-2; i>=0; i--)
                tiles[i].swap(tiles[i+1]);
        }
    }

    /* Continue conveyor */
    if (ttype == Transition.FromOldSelection) {
		if (fe.get_input_state("Left") ||
            fe.get_input_state("Joy0 Left") ||
            fe.get_input_state("Joy1 Left")) {
			fe.signal("prev_game");
		} else if (fe.get_input_state("Right") ||
            fe.get_input_state("Joy0 Right") ||
            fe.get_input_state("Joy1 Right")) {
			fe.signal("next_game");
        }
    }

    /* Second animation: Regrow main tile */
    if (ttype == Transition.EndNavigation) {
        if (ttime < TRANSITION_MS) {
            tiles[MAIN_TILE].grow(ttime.tofloat()/TRANSITION_MS);

            for (local i=0; i<tiles.len(); i++)
                tiles[i].refresh(0);

            return true;
        }

        tiles[MAIN_TILE].grow(1);

        for (local i=0; i<tiles.len(); i++)
            tiles[i].refresh(0);
    }

    /* Play a sound */
    if (ttype == Transition.ToNewList ||
        ttype == Transition.FromOldSelection) {
        clic.playing = true;
    }

    return false;
}

fe.add_transition_callback("on_transition");
if (animate)
    fe.add_transition_callback("on_animate");
