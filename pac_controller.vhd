library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.defines.all;

entity pac_controller is 
port (clk : in std_logic;
		rst :in std_logic;
		
 		up : in std_logic;
	  	down : in std_logic;
	  	lft : in std_logic;
	  	rght : in std_logic;


     	pac_x : out integer range 0 to 28*8-1;
      pac_y : out integer range 0 to 36*8-1;
	   pac_dir : out DIR_t;
      pac_sprite : out integer range 1 to 8
		
       );
end pac_controller;

architecture behav of pac_controller is 

	--signal s_u, down, rght, lft : std_logic;
	signal s_pac_x, s_pac_x_next : integer range 0 to 28*8-1;
	signal s_pac_y, s_pac_y_next : integer range 0 to 36*8-1;
	signal PS ,NS : DIR_t;
	signal s_u,s_d,s_l,s_r : std_logic;
	signal s_phys : std_logic_vector(3 downto 0);
	signal s_tx : integer range 0 to 28-1;
	signal s_ty : integer range 0 to 36-1;
	signal s_stx: integer range 0 to 7;
	signal s_sty: integer range 0 to 7;
	constant T                   : integer := 100;
   signal cnt                   : integer range 0 to T;
   signal cnt_next              : integer range 0 to T;

begin

	s_tx <= (s_pac_x)/8;
	s_ty <= (s_pac_y)/8;

	s_stx <= s_pac_x - s_tx * 8;
	s_sty <= s_pac_y - s_ty * 8;

	map_phys_rom: entity work.map_phys(RTL)
	port map (tx => s_tx,
					ty => s_ty,
					dataout => s_phys);

	s_u <= s_phys(3);
	s_d <= s_phys(2);
	s_l <= s_phys(1);
	s_r <= s_phys(0);

	mov_sync_mangr : process(rst, clk)
	begin
		if(rst = '1') then 
			s_pac_x <= 14*8 + 0;
			s_pac_y <= 26*8 + 4;
			PS <= DIR_START;
			cnt <= 0;
		elsif rising_edge(clk) then
			PS <= NS;
			s_pac_x <= s_pac_x_next;
			s_pac_y <= s_pac_y_next;
			cnt     <= cnt_next;
		end if;
	end process;

	pac_dir <= PS;

	mov_state_mangr: process(up,down,lft,rght,PS,s_u,s_d,s_l,s_r,s_pac_x,s_pac_y,s_stx,s_sty)
	begin
		NS <= PS;
		
		s_pac_x_next <= s_pac_x;
		s_pac_y_next <= s_pac_y;
		cnt_next     <= cnt;
			
		if up= '1' and s_u = '1' and s_stx = 3 then
			NS <= DIR_UP;
			s_pac_y_next <= s_pac_y-1;
			cnt_next     <= cnt + 1;

		elsif down = '1' and s_d = '1' and s_stx = 3 then
			NS <= DIR_DOWN;
			s_pac_y_next <= s_pac_y+1;
			cnt_next     <= cnt + 1;
		
		elsif rght = '1'  and s_r = '1' and s_sty = 4 then
			NS <= DIR_RIGHT;
			s_pac_x_next <= s_pac_x+1;
			cnt_next     <= cnt + 1;
			
		elsif lft = '1' and s_l = '1' and s_sty = 4 then
			NS <= dIR_LEFT;
			s_pac_x_next <= s_pac_x-1;
			cnt_next     <= cnt + 1;
		
		elsif PS = DIR_UP and (s_u = '1' or s_sty > 4) then 
			s_pac_y_next <= s_pac_y-1;
			cnt_next     <= cnt + 1;
			
		elsif PS = DIR_DOWN and (s_d = '1' or s_sty < 4) then 
			s_pac_y_next <= s_pac_y+1;
			cnt_next     <= cnt + 1;
			
		elsif PS = DIR_RIGHT and (s_r = '1' or s_stx < 3) then 
			s_pac_x_next <= s_pac_x+1;
			cnt_next     <= cnt + 1;
			
		elsif PS = DIR_LEFT and (s_l = '1' or s_stx > 3) then 
			s_pac_x_next <= s_pac_x-1;
			cnt_next     <= cnt + 1;
	
		elsif s_pac_x = 27 * 8 and s_pac_y = 18*8 then
		  s_pac_x_next <= 1;
		  s_pac_y_next <= 18*8;
		  
		elsif s_pac_x = 0 and s_pac_y = 18*8 then
		  s_pac_x_next <= 27*8;
		  s_pac_y_next <= 18*8;
			
		end if;
	
	end process;
	



	txt_mngr : process (NS,PS,cnt)
	begin
		pac_sprite <= 8;

	 if (NS /= PS) then 
	  pac_sprite <= 1;
	 elsif  cnt  <= T rem 16 then
	  pac_sprite <= 2;
	 elsif cnt <= 2*(T rem 16) then
	  pac_sprite <= 3;
	 elsif cnt <= 3*(T rem 16) then
	  pac_sprite <= 4;
	 elsif cnt <= 4*(T rem 16) then
	  pac_sprite <= 4;
	 elsif cnt <= 5*(T rem 16) then
	  pac_sprite <= 5;	  
	 elsif cnt <= 6*(T rem 16) then
	  pac_sprite <= 6;	 	
	 elsif cnt <= 7*(T rem 16) then
	  pac_sprite <= 7;
	 elsif cnt <= 8*(T rem 16) then
	  pac_sprite <= 8;
	 elsif cnt <= 9*(T rem 16) then
	  pac_sprite <= 7;
	 elsif cnt <= 10*(T rem 16) then
	  pac_sprite <= 6;
	 elsif cnt <= 11*(T rem 16) then
	  pac_sprite <= 5;
	 elsif cnt <= 12*(T rem 16) then
	  pac_sprite <= 4;
	 elsif cnt <= 13*(T rem 16) then
	  pac_sprite <= 3;
	 elsif cnt <= 14*(T rem 16) then
	  pac_sprite <= 2;
	 elsif cnt <= T then
	  pac_sprite <= 1;
	 end if;
	end process;
	
	pac_x <= s_pac_x;
	pac_y <= s_pac_y; 

end behav;



