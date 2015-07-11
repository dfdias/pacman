library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.defines.all;

entity ghost_controller is 
port (clk            :  in std_logic;
	  rst            :  in std_logic;

      pac_x          : in MAP_COORD_X_t;
      pac_y          : in MAP_COORD_Y_t;

	  ghost_x        : out MAP_COORD_X_t;
      ghost_y        : out MAP_COORD_Y_t;

      ghost_tex_id  : DIR_t
       );
end ghost_controller;

architecture behav of ghost_controller is 


	signal s_ghost_x, s_ghost_x_next : MAP_COORD_X_t;
	signal s_ghost_y, s_ghost_y_next : MAP_COORD_Y_t;
	signal PS ,NS                : DIR_t;
	signal s_ghost_dir           : DIR_t;
	signal s_u,s_d,s_l,s_r       : std_logic;
	signal s_phys                : std_logic_vector(3 downto 0);
	signal s_tx                  : MAP_TILES_X_t;
	signal s_ty                  : MAP_TILES_Y_t; 
	signal s_stx                 : integer range 0 to 8-1;
	signal s_sty                 : integer range 0 to 8-1;
   signal s_reset               : std_logic;

begin

	mov_sync_mangr : process(rst, clk)
	begin
	   if(rst = '1') then 
		  s_ghost_x <= 14*8 + 0;
		  s_ghost_y <= 26*8  + 4;
		--  cnt     <= 0;
		  PS      <= DIR_START;
		elsif rising_edge(clk) then
		 PS <= NS;
		 s_ghost_x <= s_ghost_x_next;
		 s_ghost_y <= s_ghost_y_next;
		 --cnt     <= cnt_next;	 

		end if;
	end process;

	mov_state_mangr: process(PS,s_ghost_dir,s_ghost_x,s_ghost_y)
	begin
		NS <= PS;
		
		s_ghost_x_next <= s_ghost_x;
		s_ghost_y_next <= s_ghost_y;
--		cnt_next <= cnt + 1;
		
		if s_ghost_dir = DIR_UP then
			NS <= DIR_UP;
			s_ghost_y_next <= s_ghost_y - 1;
		
		elsif s_ghost_dir <= DIR_DOWN then
			NS <= DIR_DOWN;
			s_ghost_y_next <= s_ghost_y+1;

		elsif s_ghost_dir <= DIR_RIGHT then
			NS <= DIR_RIGHT;
			s_ghost_x_next <= s_ghost_x+1;
			
		elsif s_ghost_dir <= DIR_LEFT then
			NS <= DIR_LEFT;
			s_ghost_x_next <= s_ghost_x-1;
			
		elsif PS = DIR_UP  then 
			s_ghost_y_next <= s_ghost_y-1;
			
		elsif PS = DIR_DOWN then 
			s_ghost_y_next <= s_ghost_y+1;
			
		elsif PS = DIR_RIGHT then 
			s_ghost_x_next <= s_ghost_x+1;
			
		elsif PS = DIR_LEFT then 
			s_ghost_x_next <= s_ghost_x-1;
	
		end if;
	end process;

ghost_decision_struct : entity work.ghost_mov(behav)
port map(current_dir => PS,
	     pac_x       => pac_x,
	     pac_y       => pac_y,
	     ghost_x     => s_ghost_x,
	     ghost_y     => s_ghost_y,
	     ghost_dir   => s_ghost_dir
	     );

	ghost_x <= s_ghost_x;
	ghost_y <= s_ghost_y; 


end behav;



