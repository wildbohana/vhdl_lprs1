-- Libraries.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity automat is
	port(
		iCLK	:  in std_logic;
		inRST	:  in std_logic;		-- sinhroni reset, aktivan na 0
		oRD		: out std_logic;
		oYL		: out std_logic;
		oGR		: out std_logic;
		oB		: out std_logic;
	);
end entity;

architecture arch of automat is
	-- Constants.
	constant cMod14 : std_logic_vector(3 downto 0) := "1101";
	
	-- Signals.
	type tSTATE is (IDLE, RED_1, RED_0, YELLOW, GREEN);
	signal sSTATE, sNEXT_STATE : tSTATE;

	signal sCNT		: std_logic_vector(3 downto 0);
	signal sEN 		: std_logic;
	signal sR		: std_logic;
	signal sY		: std_logic;
	signal sG		: std_logic;
	signal sB		: std_logic;
	
begin
	-- Brojač po mod14
	process (iCLK) begin
		if (rising_edge(iCLK)) then 
			if (inRST = '0') then 
				sCNT <= "0000";
			else
				if (sEN = '1') then
					sCNT <= sCNT + 1;
				end if;
			end if;
		end if;
	end process;

	-- Control block
	sY <= '1' when sCNT = 6 else '0';
	sR <= '1' when sCNT = 7 else '0';
	sG <= '1' when sCNT = 13 else '0';
	
	--.*  FSM  *.--
	-- Registar za prelaze stanja
	process (iCLK) begin
		if (rising_edge(iCLK)) then 
			if (inRST = '0') then
				sSTATE <= IDLE;
			else
				sSTATE <= sNEXT_STATE;
			end if;
		end if;
	end process;

	-- Funkcija prelaza stanja automata
	process (sSTATE, sY, sR, sG) begin
		case sSTATE is

			when IDLE =>
				if sG = '1' then
					sNEXT_STATE <= GREEN;
				elsif sY = '1' then 
					sNEXT_STATE <= YELLOW;
				elsif sR = '1' then 
					sNEXT_STATE <= RED_0;
				end if;
			
			when GREEN =>
				if sCNT = "0101" then 
					sNEXT_STATE <= IDLE;
				else
					sNEXT_STATE <= GREEN;
				end if;

			when YELLOW =>
				sNEXT_STATE <= IDLE;

			when RED_0 =>
				sNEXT_STATE <= RED_1;

			when RED_1 =>
				if sCNT = "1010" then 
					sNEXT_STATE <= IDLE;
				else
					sNEXT_STATE <= RED_0;
				end if;

			when others =>
				sNEXT_STATE <= IDLE;

		end case;
	end process;

	-- Kocka, kocka, kockica --

	sEN <= '1' when (sSTATE = IDLE or sSTATE = GREEN or sSTATE = RED) else '0';
	sB  <= '1' when (sSTATE = GREEN) else '0';

	oB <= sB;

	---------------------------

	-- Decoder
	oYL <= '1' when (sCNT = 6 or sCNT = 11 or sCNT = 12) else '0';
	oRD <= '1' when (sCNT = 7 or sCNT = 8 or sCNT = 9 or sCNT = 10 or sCNT = 11 or sCNT = 12) else '0';
	oGR <= '1' when (sCNT = 0 or sCNT = 1 or sCNT = 2 or sCNT = 3 or sCNT = 13) else '0';

end architecture;
