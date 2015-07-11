--blinky_tex_rom;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.defines.all;

entity blinky_tex_rom is
Port (stx        : in integer range 0 to 16;
	  sty        : in integer range 0 to 16;
	  texture_id : in integer range 0 to 4-1;

	  ARGB   : out VGA_ARGB_t);

end blinky_tex_rom;

architecture RTL of blinky_tex_rom is

signal s_dataout : integer range 0 to 4-1;
subtype t is integer range 0 to 4-1;
type st is array (0 to (4*16*16)-1) of t;

constant c_memory : st := ( 

-- rght_tex
	0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,
	0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
	0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,
	0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
   0,0,1,1,2,2,1,1,1,1,2,2,1,1,0,0,
	0,1,1,2,2,3,3,1,1,2,2,3,3,1,1,0,
	1,1,1,2,2,3,3,1,1,2,2,3,3,1,1,1,
	1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
   1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,
	1,1,0,0,0,1,1,0,0,1,1,0,0,0,1,1,
	1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,

-- left _tex
	0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,
	0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
	0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,
	0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
    0,0,1,1,2,2,1,1,1,1,2,2,1,1,0,0,
	0,1,1,3,3,2,2,1,1,3,3,2,2,1,1,0,
	1,1,1,3,3,2,2,1,1,3,3,2,2,1,1,1,
	1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,
	1,1,0,0,0,1,1,0,0,1,1,0,0,0,1,1,
	1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,

--up_tex

	0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,
	0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
	0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,
	0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
    0,0,1,1,3,3,1,1,1,1,3,3,1,1,0,0,
	0,1,1,2,3,3,2,1,1,2,3,3,2,1,1,0,
	1,1,1,2,2,2,2,1,1,2,2,2,2,1,1,1,
	1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,
	1,1,0,0,0,1,1,0,0,1,1,0,0,0,1,1,
	1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,

--down_tex
	0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,
	0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
	0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,
	0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,
    0,0,1,1,2,2,1,1,1,1,2,2,1,1,0,0,
	0,1,1,2,2,3,3,1,1,2,2,2,2,1,1,0,
	1,1,1,2,2,3,3,1,1,2,3,3,2,1,1,1,
	1,1,1,1,2,2,1,1,1,1,3,3,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,
	1,1,0,0,0,1,1,0,0,1,1,0,0,0,1,1,
	1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1);

begin

	s_dataout <= c_memory(texture_id*16*16+stx+sty*16);

color_map: process(s_dataout)
 begin
 	if s_dataout = 0 then  
 		ARGB <= '0' & "000";
 	elsif s_dataout = 1 then
 		ARGB <= "1" & "100"; 
 	elsif s_dataout = 2 then
 		ARGB <= "1" & "111"; 
 	elsif s_dataout = 3 then
 		ARGB <= "1"&"001"; 		
 	end if ;
 end process;

 end RTL;

