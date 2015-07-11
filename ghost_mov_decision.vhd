library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.defines.all;

entity ghost_mov is
port(--clk        :  in std_logic;
	 --rst        :  in std_logic;
	 current_dir :  in DIR_t;
	 pac_x       :  in MAP_COORD_X_t;
	 pac_y       :  in MAP_COORD_Y_t;
     ghost_x     :  in MAP_COORD_X_t;	 
     ghost_y     :  in MAP_COORD_Y_t;
	 ghost_dir   : out DIR_t
	 --pinky_x  : out MAP_COORD_X_t;
	 --pinky_y  : out MAP_COORD_Y_t
	 );
end ghost_mov;

architecture behav of ghost_mov is
 signal target_x : MAP_COORD_X_t;
 signal target_y : MAP_COORD_Y_t;
 --signal g_x      : MAP_COORD_X_t;
 --signal g_y      : MAP_COORD_Y_t;
 signal aux_x    : integer range -MAP_N_TILES_X to MAP_N_TILES_X ;
 signal aux_y    : integer range -MAP_N_TILES_Y to MAP_N_TILES_Y ;
 signal s_tx     : MAP_TILES_X_t;
 signal s_ty     : MAP_TILES_Y_t;

 signal s_cond_left     : std_logic;    
 signal s_cond_right    : std_logic;
 signal s_cond_up       : std_logic;
 signal s_cond_down     : std_logic; 
 signal s_dir    : std_logic_vector(3 downto 0);
 signal s_u      : std_logic; 
 signal s_d      : std_logic;
 signal s_l      : std_logic;
 signal s_r      : std_logic;



 begin

 s_tx <= ghost_x / 8;
 s_ty <= ghost_y / 8;

 s_u <= s_dir(3);
 s_d <= s_dir(2);
 s_l <= s_dir(1);
 s_r <= s_dir(0);

 target_x <= pac_x;
 target_y <= pac_y;
 aux_x <= target_x - ghost_x;
 aux_y <= target_y - ghost_y;
 
 s_conds: process(aux_x,aux_y)
 begin
 s_cond_right <= '0';
 s_cond_left <= '0';
 s_cond_down <= '0';
 s_cond_up <= '0';
 
 if(aux_x >= aux_y) and (aux_x <= - aux_y) then s_cond_right <= '1';
elsif(aux_x >= -aux_y) and (aux_x <= aux_y) then s_cond_left <= '1';
elsif(aux_x <= aux_y) and (aux_x >= - aux_y) then s_cond_down <= '1';
elsif(aux_x <= aux_y) and (aux_x <= - aux_y) then s_cond_right <= '1';
end if;

end process;



decision_proc : process(s_cond_up, s_cond_down, s_cond_left, s_cond_right,s_dir,current_dir)
begin
 ghost_dir <= DIR_UP;

 if s_cond_up <= '1'  and s_u <= '1' and current_dir /= DIR_DOWN   then
  ghost_dir <= DIR_UP;
 elsif s_cond_right <= '1' and s_r <= '1' and current_dir /= DIR_LEFT then
  ghost_dir <= DIR_RIGHT;
 elsif s_cond_down <= '1' and s_d <= '1' and current_dir /= DIR_UP then
  ghost_dir <= DIR_DOWN;
 elsif s_cond_down <= '1' and s_d <= '1' and current_dir /= DIR_RIGHT then
  ghost_dir <= DIR_LEFT;
 end if ;
end process;

map_phys_rom :entity work.map_phys(RTL)
port map(tx      => s_tx,
	     ty      => s_ty,
	     dataout => s_dir
	     );

 end;