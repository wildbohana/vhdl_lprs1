-- Libraries.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity automat is
	port(
		iCLK	:  in std_logic;
		inRST	:  in std_logic;		-- asinhroni, aktivan na 0
		iDNA	:  in std_logic_vector(1 downto 0);
		oCOUNT	: out std_logic_vector(7 downto 0)
	);
end entity;

architecture arch of automat is
	-- Constants.
	constant A : std_logic_vector(1 downto 0) := 00;
	constant T : std_logic_vector(1 downto 0) := 11;
	constant C : std_logic_vector(1 downto 0) := 01;
	constant G : std_logic_vector(1 downto 0) := 10;
	
	-- Signals.
	type tSTATE is (IDLE, AXX, ATX, ATG);
	signal sSTATE, sNEXT_STATE : tSTATE;
	
	signal sEN : std_logic;
	signal sCNT : std_logic_vector(7 downto 0);

	
begin
	-- Tražimo sekvencu ATG

	--.*  FSM  *.--
	-- Registar za pamćenje stanja
	process (iCLK, inRST) begin
		if (inRST = '0') then
			sSTATE <= IDLE;
		elsif (rising_edge(iCLK)) then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	-- Funkcija prelaza stanjaa automata
	process (iDNA, sSTATE) begin
		case sSTATE is

			when IDLE =>
				if (iDNA = A) then 
					sNEXT_STATE <= AXX;
				else
					sNEXT_STATE <= IDLE;
				end if;
			
			when AXX =>
				if (iDNA = T) then
					sNEXT_STATE <= ATX;
				elsif (iDNA = A) then 
					sNEXT_STATE <= AXX;
				else
					sNEXT_STATE <=IDLE;
				end if;

			when ATX =>
				if (iDNA = G) then 
					sNEXT_STATE <= ATG;
				elsif (iDNA = A) then 
					sNEXT_STATE <= AXX;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when ATG =>
				if (iDNA = A) then
					sNEXT_STATE <= AXX;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when others =>
				sNEXT_STATE <= IDLE;
		end case;
	end process;

	-- Dozvola za brojač
	sEN <= '1' when sSTATE = ATG else '0';

	-- Brojač
	process (iCLK, inRST) begin
		if (inRST = '0') then
			sCNT <= "00000000";
		elsif (rising_edge(iCLK)) then		-- OVO NEMOJ ZABORAVITI
			if (sEN <= '1') then 
				sCNT <= sCNT + 1;
			end if;
		end if;
	end process;

	-- Broj pronađenih sekvenci
	oCOUNT <= sCNT;

end architecture;
