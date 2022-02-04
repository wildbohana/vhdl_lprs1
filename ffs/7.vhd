-- Libraries.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity automat is
	port(
		iCLK	:  in std_logic;
		inRST	:  in std_logic;		-- asinhroni reset, aktivan na 0
		oRED	: out std_logic;
		oGREEN	: out std_logic;
		oBLUE	: out std_logic
	);
end entity;

architecture arch of automat is
	-- Constants.
	constant cMod9 : std_logic_vector(3 downto 0) := "1000";
	
	-- Signals.
	type tSTATE is (IDLE, BLUE, GREEN, RED, WRITE_CNT);
	signal sSTATE, sNEXT_STATE : tSTATE;
	
	signal sD : std_logic_vector(3 downto 0);
	signal sCNT : std_logic_vector(3 downto 0);
	signal sWR_EN : std_logic;

begin

	-- Brojač po mod9
	process (inRST, iCLK) begin
		if (inRST = '0') then
			sCNT <= "0000";
		elsif (rising_edge(iCLK)) then
			if (sWR_EN = '1') then 
				sCNT <= sD;
			else
				if (sCNT = cMod9) then
					sCNT <= "0000";
				else
					sCNT <= sCNT + 1;
				end if;
			end if;
		end if;
	end process;

	-- Registar za pamćenje stanja
	process (inRST, iCLK) begin
		if (inRST = '0') then 
			sSTATE <= IDLE;
		elsif (rising_edge(iCLK)) then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	-- Funkija promene stanja automata
	process (sSTATE, sCNT) begin
		case sSTATE is

			when IDLE =>
				if (sCNT = "0011") then
					sNEXT_STATE <= RED;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when RED =>
				if (sCNT = "0101") then 
					sNEXT_STATE <= GREEN;
				else
					sNEXT_STATE <= RED;
				end if;

			when GREEN =>
				if (sCNT = "0111") then
					sNEXT_STATE <= WRITE_CNT;
				else
					sNEXT_STATE <= GREEN;
				end if;

			when WRITE_CNT =>
				sNEXT_STATE <= BLUE;

			when BLUE =>
				if (sCNT = "0000") then
					sNEXT_STATE <= IDLE;
				else
					sNEXT_STATE <= BLUE;
				end if;

			when others =>
				sNEXT_STATE <= IDLE;
		end case;
	end process;

	-- Ono sa kockicama
	sD <= "0110" when (sSTATE = WRITE_CNT) else "0000";
	sWR_EN <= '1' when (sSTATE = WRITE_CNT) else '0';	

	-- Lampice
	oRED 	<= '1' when sSTATE = RED 	else '0';
	oGREEN 	<= '1' when sSTATE = GREEN 	else '0';
	oBLUE 	<= '1' when sSTATE = BLUE 	else '0';

end architecture;
