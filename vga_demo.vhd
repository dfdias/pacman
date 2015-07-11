library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity vga_demo is
	port(
		CLOCK_50    :  in std_logic;
		
		SW          :  in std_logic_vector(1 downto 0);
		KEY         :  in std_logic_vector(3 downto 0);
		
		VGA_CLK     : out std_logic;
		R           : out std_logic;
		G           : out std_logic;
		B           : out std_logic;
		VGA_SYNC_N  : out std_logic;
		VGA_BLANK_N : out std_logic;
		HS          : out std_logic;
		VS          : out std_logic
	);
end vga_demo;

architecture struct of vga_demo is 

	signal s_x                                                    : integer range 0 to 800-1;
	signal s_y                                                    : integer range 0 to 600-1;
	signal s_pac_x                                                : MAP_COORD_X_t;
	signal s_pac_y                                                : MAP_COORD_Y_t;
	signal s_clock                                                : std_logic;
	signal s_RGB                                                  : VGA_RGB_t;
	signal s_r, s_g, s_b                                          : std_logic;
	signal s_score                                                : SCORE_t;
	signal s_ram_x                                                : MAP_TILES_X_t;
	signal s_ram_y                                                : MAP_TILES_Y_t;
   signal s_ghost_x                                                : MAP_TILES_X_t;
	signal s_ghost_y                                                : MAP_TILES_Y_t;
    signal s_ram_value                                           : ENERGYZER_TYPE_t;
    signal s_pac_dir                                              : DIR_t;

    signal s_pac_sprite                                          : integer range 0 to 8;
	 signal s_ghost_tex_id                                       : DIR_t;
	 

begin

	fdiv: entity work.FreqDivStatic(Behavioral)
	generic map(
		K => 500000
	)
	port map(
		clkIn  => CLOCK_50,
		clkOut => s_clock
	);

	pac_controller: entity work.pac_controller(behav)
	port map(
		clk   => s_clock,
		rst   => SW(1),
		up    => KEY(0),
		down  => KEY(1),
		lft   => KEY(2),
		rght  => KEY(3),
		pac_x => s_pac_x,
		pac_y => s_pac_y,
		pac_dir => s_pac_dir,                                             
		pac_sprite =>s_pac_sprite                                       
	);
	
	ghost_controller : entity work.ghost_controller(behav)
	port map(clk => s_clock,
	         rst => SW(1),
				pac_x => s_pac_x,
				pac_y => s_pac_y,
				ghost_x => s_ghost_x,
				ghost_y => s_ghost_y,
				ghost_tex_id => s_ghost_tex_id);

	controller: entity work.game_controller(b)
	port map (clk => CLOCK_50,
			   reset => SW(1),
             score_out => s_score,	       	
			    pac_x => s_pac_x,
	          pac_y => s_pac_y,
	          ram_x => s_ram_x,
	          ram_y => s_ram_y,
	          ram_data => s_ram_value
	);
	
	core: entity work.vga_controller(struct)
	port map(
		clk   => CLOCK_50,
		reset => SW(0),
		
		R  => s_r, 
		G  => s_g,
		B  => s_b,
		
		x  => s_x,
		y  => s_y,
		
		dac_clk     => VGA_CLK,
		dac_red     => R,
		dac_green   => G,
		dac_blue    => B,
		dac_n_sync  => VGA_SYNC_N,
		dac_n_blank => VGA_BLANK_N,
		vga_h_sync  => HS,
		vga_v_sync  => VS
	);

	draw: entity work.vga_draws(behav)
	port map(
		RGB => s_RGB,

		ram_x => s_ram_x,
		ram_y => s_ram_y,
		ram_value => s_ram_value,

      score => s_score,
		pac_dir => s_pac_dir,
		pac_sprite => s_pac_sprite,
		
		ghost_tex_id => s_ghost_tex_id,

 		pac_x => s_pac_x,
		pac_y => s_pac_y,
		
		ghost_x => s_ghost_x,
		ghost_y => s_ghost_y,
		
		vga_x => s_x,
		vga_y => s_y
	);

   
	s_r <= s_RGB(2);
	s_g <= s_RGB(1);
	s_b <= s_RGB(0);

end struct;
