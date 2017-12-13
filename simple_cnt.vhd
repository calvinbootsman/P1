library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity simple_cnt is
	port(clk, ud, cnt_en, rst, ld_en: in std_logic;
		Q, D: buffer std_logic_vector(3 downto 0);
		cout: out std_logic
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


end;