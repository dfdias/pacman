library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity ghost_draws is
	port(
		map_x      :  in MAP_COORD_X_t;
		map_y      :  in MAP_COORD_Y_t;
		ghost_x    :  in MAP_COORD_X_t;
		ghost_y    :  in MAP_COORD_Y_t;
		texture_id :  in DIR_t;
		ARGB       : out VGA_ARGB_t
	);
end ghost_draws;

architecture struct of ghost_draws is
	signal s_aux_x           : integer range (-MAP_COORD_X+8) to (MAP_COORD_X+8)-1;
	signal s_aux_y           : integer range (-MAP_COORD_Y+8) to (MAP_COORD_Y+8)-1;
	signal s_tex_x, s_tex_y  : integer range 0 to 16-1;
	signal s_tex_blinky_ARGB : VGA_ARGB_t;
   signal s_tex_inky_ARGB   : VGA_ARGB_t; 
   signal s_tex_pinky_ARGB  : VGA_ARGB_t;
   signal s_tex_clyde_ARGB  : VGA_ARGB_t;
   signal s_texture_id        : integer range 0 to 4-1;

begin

	s_aux_x <= (map_x - ghost_x + (16/2));
	s_aux_y <= (map_y - ghost_y + (16/2));


	tex_id_decode : process(texture_id)
	begin
	if texture_id = DIR_RIGHT then
     s_texture_id <= 0;
	elsif texture_id = DIR_LEFT then
     s_texture_id <= 1;
	elsif texture_id = DIR_UP then
	 s_texture_id <= 2;
	elsif texture_id = DIR_DOWN then
	 s_texture_id <= 3;
	end if;
	end process;

	blinky_textures : entity work.blinky_tex_rom(RTL)
	port map(
		texture_id => s_texture_id,
		stx          => s_tex_x,
		sty          => s_tex_y,
		ARGB       => s_tex_blinky_ARGB
	);


	--inky_textures : entity work.inky_tex_rom(RTL)
	--port map(
	--	texture_id => texture_id,
	--	x          => s_tex_x,
	--	y          => s_tex_y,
	--	ARGB       => s_tex_inky_ARGB
	--);

	--pinky_textures : entity work.pinky_tex_rom(RTL)
	--port map(
	--	texture_id => texture_id,
	--	x          => s_tex_x,
	--	y          => s_tex_y,
	--	ARGB       => s_tex_pinky_ARGB
	--);


	--clyde_textures : entity work.clyde_tex_rom(RTL)
	--port map(
	--	texture_id => texture_id,
	--	x          => s_tex_x,
	--	y          => s_tex_y,
	--	ARGB       => s_tex_clyde_ARGB
	--);
	position : process(s_aux_x, s_aux_y)
	begin
		s_tex_x <= 0;
		s_tex_y <= 0;
		
		if ( s_aux_x >= 0 and s_aux_x < 16) then
		if ( s_aux_y >= 0 and s_aux_y < 16) then
			s_tex_x <= s_aux_x;
			s_tex_y <= s_aux_y;
		end if ;
		end if;
		
	end process;

	color : process(s_aux_x, s_aux_y, s_tex_blinky_ARGB)
	begin
		ARGB <= "0000"; 
		
		if ( s_aux_x >= 0 and s_aux_x < 16) then
		if ( s_aux_y >= 0 and s_aux_y < 16) then
			ARGB <= s_tex_blinky_ARGB;
		end if ;
		end if;
		
	end process;

end struct;

