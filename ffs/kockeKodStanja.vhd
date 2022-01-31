-- Libraries.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity automat is
	port(
		iCLK	:  in std_logic;
		inRST	:  in std_logic;	-- asinhroni reset, aktivan na 0
		oRE 	: out std_logic;
		oYE 	: out std_logic;
		oGR 	: out std_logic;
		oIZLAZ	: out std_logic_vector(3 downto 0)
	);
end entity;

architecture arch of automat is
	-- Constants.
	constant cMod11 : std_logic_vector(3 downto 0) := "1010";

	-- Signals.
	type tSTATE is ();
	signal sSTATE, sNEXT_STATE : tSTATE;

	signal sCNT 	: std_logic_vector(3 downto 0) := "0000";
	signal sWR_EN 	: std_logic;
	signal sDATA 	: std_logic_vector(3 downto 0);
	
	
begin

	-- Brojač po mod11
	process (iCLK, inRST) begin
		if (inRST = '0') then 
			sCNT <= "0000";
		elsif (rising_edge(iCLK)) then	
			if (sWR_EN = '1')
				sCNT <= sDATA;
			elsif (sCNT = cMod11) then 
				sCNT <= "0000";
			else
				sCNT <= sCNT + 1;
			end if;
		end if;
	end process;

	-- Registar za stanje automata
	process (iCLK, inRST) begin
		if (inRST = '0') then 
			sSTATE <= IDLE;
		elsif (rising_edge(iCLK)) then 
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	-- Funkcija promene stanja
	process (sCNT, sSTATE) begin
		case sSTATE is

			when IDLE =>
				if (sCNT = "0100") then 
					sNEXT_STATE <= RED;
				elsif (sCNT = "0000") then 
					sNEXT_STATE <= GREEN;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when RED =>
				if (sCNT = "1000") then 
					sNEXT_STATE <= IDLE;
				else
					sNEXT_STATE <= RED;
				end if;

			when GREEN =>
				if (sCNT = "1000") then 
					sNEXT_STATE <= YELLOW;
				else
					sNEXT_STATE <= GREEN;
				end if;

			when YELLOW =>
				if (sCNT = "0011") then 
					sNEXT_STATE <= IDLE;
				else
					sNEXT_STATE <= YELLOW;
				end if;

			when others =>
				sNEXT_STATE <= IDLE;
		
		end case;
	end process;


	--- MOŽDA VALJA ---

	-- Registar za izlazni podatak
	process (iCLK, inRST) begin
		if (inRST = '0') then 
			sDATA <= "0000";
		elsif (rising_edge(iCLK)) then 
			sDATA <= sNEXT_DATA;
		end if;
	end process;

	-- Funkcija izlaza
	process (sSTATE, sDATA) begin 
		case sSTATE is

			when RED =>
				if (iCNT = "1000") then
					oWR_EN <= '1';
					sNEXT_DATA <= "0000";
				end if;

			when YELLOW =>
				if (iCNT = "1010") then 
					oWR_EN <= '1';
					sNEXT_DATA <= "0010";
				end if;

			when else =>
				oWR_EN <= '0';
				sNEXT_DATA <= "0000";

		end case;
	end process;
	
	-------------------

	-- Dekoder za izlaz
	oYE <= '1' if sSTATE = YELLOW else '0';
	oRE <= '1' if sSTATE = RED or (sSTATE = IDLE and sCNT = 4) else '0';
	oGR <= '1' if sSTATE = GREEN or sSTATE = YELLOW or (sSTATE = IDLE and sCNT = 0) else '0';
	
end architecture;
