library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity pac_draws is
	port(
		map_x      :  in MAP_COORD_X_t;
		map_y      :  in MAP_COORD_Y_t;
		
		pac_x      :  in MAP_COORD_X_t;
		pac_y      :  in MAP_COORD_Y_t;
		pac_dir    :  in DIR_t;
		pac_sprite :  in integer range 0 to 8;
		
		ARGB       : out VGA_ARGB_t
	);
end pac_draws;

architecture struct of pac_draws is
	signal s_aux_x    : integer range (-MAP_COORD_X+8) to (MAP_COORD_X+8)-1;
	signal s_aux_y    : integer range (-MAP_COORD_Y+8) to (MAP_COORD_Y+8)-1;
	signal s_tex_ARGB : VGA_ARGB_t;
	signal s_tex_x, s_tex_y : integer range 0 to 16-1;
	signal texture_id : integer range 0 to 9-1;

begin

	s_aux_x <= (map_x - pac_x + (16/2));
	s_aux_y <= (map_y - pac_y + (16/2));

	process(pac_dir, pac_sprite)
	begin
		texture_id <= 8;
		
		if pac_sprite = 0 then
			texture_id <= 0;
		
		elsif pac_dir = DIR_START then
			texture_id <= 8;
		
		else
			texture_id <= pac_sprite;
		
		end if;
		
	end process;
	
	textures : entity work.pac_textures(RTL)
	port map(
		texture_id => texture_id,
		x          => s_tex_x,
		y          => s_tex_y,
		ARGB       => s_tex_ARGB
	);

	position : process(s_aux_x, s_aux_y, pac_dir)
	begin
		s_tex_x <= 0;
		s_tex_y <= 0;
		
		if ( s_aux_x >= 0 and s_aux_x < 16) then
		if ( s_aux_y >= 0 and s_aux_y < 16) then
			s_tex_x <= s_aux_x;
			s_tex_y <= s_aux_y;
			
			if    pac_dir = DIR_LEFT then
				s_tex_x <= 15 - s_aux_x;
				s_tex_y <=      s_aux_y;

			elsif pac_dir = DIR_UP then
				s_tex_x <=      s_aux_y;
				s_tex_y <= 15 - s_aux_x;
				
			elsif pac_dir = DIR_DOWN then
				s_tex_x <=      s_aux_y;
				s_tex_y <=      s_aux_x;

			end if;
			
		end if ;
		end if;
		
	end process;

	color : process(s_aux_x, s_aux_y, s_tex_ARGB)
	begin
		ARGB <= "0000"; 
		
		if ( s_aux_x >= 0 and s_aux_x < 16) then
		if ( s_aux_y >= 0 and s_aux_y < 16) then
			ARGB <= s_tex_ARGB;
		end if ;
		end if;
		
	end process;

--	rgb_mngr : process (pac_dir,s_aux_x, s_aux_y)
--	begin
--		if ( s_aux_x >= 0 and s_aux_x < 16) then
--		if ( s_aux_y >= 0 and s_aux_y < 16) then
--			if pac_dir = UP then
--				ARGB <= s_tex_up_ARGB;
--			elsif pac_dir = DOWN then
--       ARGB <= s_tex_down_ARGB;
--      elsif pac_dir <= LEFT then
--       ARGB <= s_tex_left_ARGB;
--      elsif pac_dir = RIGHT then
--       ARGB <= s_tex_right_ARGB;
--      end if;      			
--	 end if ;
--	 end if;
--	end process;

end struct;
