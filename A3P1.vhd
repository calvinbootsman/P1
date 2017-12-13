library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity A3P1 is
	port(
		SW 			: in std_logic_vector(17 downto 0);
		HEX0,HEX1	: out std_logic_vector(6 downto 0);
		CLOCK_50 	: in std_logic
		);
end A3P1;

architecture toplevel of A3P1 is 
signal Clk, Clk_1Hz, enable 	: std_logic;
signal Q1, Q2     				: std_logic_vector( 3 downto 0);
begin


	process (clk) 
   variable cnt : integer range 0 to 30000000 := 0; 
	begin 
		if rising_edge(Clk) then             
			cnt := cnt + 1;             
			if cnt = 25000000 then                 
				cnt := 0; 
            Clk_1Hz <= not Clk_1Hz;             
			end if;         
		end if;     
	end process;  

	c0: entity work.simple_cnt port map(Clk_1Hz,SW(0),SW(1),SW(2),SW(3),Q1 ,SW(7 downto 4), enable);
	c1: entity work.simple_cnt port map(Clk_1Hz,SW(0),SW(1),enable ,SW(3),Q2 ,SW(11 downto 8), open);
	d0: entity work.decoder port map(Q1, HEX0);
	d1: entity work.decoder port map(Q2, HEX1);
	end toplevel;
	
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity simple_cnt is
	port(	clk, ud, cnt_en, rst, ld_en	: in std_logic;
			Q 										: buffer std_logic_vector(3 downto 0);
			D										: out std_logic_vector(3 downto 0);
			cout									: out std_logic
		);
end simple_cnt;

architecture behavior of simple_cnt is
signal overflow: std_logic; 
begin
	process (clk, rst)
	variable temp: std_logic_vector (3 downto 0) :="0000";
	begin
		if rst = '0' then
			if cnt_en = '1' then
				if rising_edge(clk) then
					if (ud = '1') then
						if (temp < "1001") then
							temp := temp + 1;
							overflow <='0';
						elsif (temp = "1001")then
							temp := "0000";
							overflow <= '0';
						end if;
						if (temp = "1001") then		--When it goes to 9 the carry out should go up
							overflow <= '1';
							end if;
					else 
						if (temp > "0000") then
							temp := temp -1;
							overflow <='0';
						elsif (temp = "0000") then
							overflow <='0';
							temp := "1001";						
						end if;
						if (temp = "0000") then		--When it goes to 0 it the carry out should go up
							overflow <= '1';
						end if;
					end if;
					Q <= temp;
				end if;
			end if;
		
			if (ld_en = '1') then 	--ld_en overwrites cnt_en
						temp := D;
						Q <= temp;
					end if;
		else
			temp:= "0000";
			Q <= temp;
		end if;
		
	end process;
	Cout <= overflow;
	
end behavior;	
	
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	
entity decoder is
	port( dc             : in std_logic_vector(3 downto 0);
		   sevensegment	: out std_logic_vector(6 downto 0));
end decoder;

architecture behaviour of decoder is
begin
	process (dc)
	begin
		case dc is
			when "0000" => sevensegment <= "1111110";
			when "0001" => sevensegment <= "0110000";
			when "0010" => sevensegment <= "1101101";
			when "0011" => sevensegment <= "1111001";
			when "0100" => sevensegment <= "0110011";
			when "0101" => sevensegment <= "1011011";
			when "0110" => sevensegment <= "1011111";
			when "0111" => sevensegment <= "1110000";
			when "1000" => sevensegment <= "1111111";
			when "1001" => sevensegment <= "1110011";
			when "1010" => sevensegment <= "1110111";
			when "1011" => sevensegment <= "0011111";
			when "1100" => sevensegment <= "1001110";
			when "1101" => sevensegment <= "0111101";
			when "1110" => sevensegment <= "1001111";
			when "1111" => sevensegment <= "1000111";
		end case;
	end process;
end behaviour;
