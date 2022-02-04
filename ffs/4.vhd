-- Libraries.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity automat is
	port(
		iCLK	:  in std_logic;
		inRST	:  in std_logic;		-- asinhroni reset, aktivan na 0
		iDNA	:  in std_logic_vector(1 downto 0);
		oCOUNT	: out std_logic_vector(7 downto 0);
		oWARN	: out std_logic
	);
end entity;

architecture arch of automat is
	-- Constants.
	constant A : std_logic_vector(1 downto 0) := "00";
	constant T : std_logic_vector(1 downto 0) := "11";
	constant C : std_logic_vector(1 downto 0) := "01";
	constant G : std_logic_vector(1 downto 0) := "10";

	-- Signals.
	type tSTATE is (IDLE, TXX, TG, TA, STP);
	signal sSTATE, sNEXT_STATE : tSTATE;

	signal sEN : std_logic;
	signal sCNT : std_logic_vector(7 downto 0);
		
begin
	-- Tri uzastopna stop kodona - trigeruju STOP stanje
	-- Stop kodoni: TAG, TAA, TGA

	-- Registar za pamćenje stanja
	process (inRST, iCLK) begin
		if (inRST = '0') then 
			sSTATE <= IDLE;
		elsif (rising_edge(iCLK)) then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	-- Funkcija za prelaze stanja
	process (sSTATE, iDNA) begin
		case sSTATE is

			when IDLE =>
				if (iDNA = T) then 
					sNEXT_STATE <= TXX;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when TXX =>
				if (iDNA = A) then
					sNEXT_STATE <= TAX;
				elsif (iDNA = G) then 
					sNEXT_STATE <= TGX;
				elsif (iDNA = T) then 
					sNEXT_STATE <= TXX;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when TAX =>
				if (iDNA = G) then 
					sNEXT_STATE <= STP;
				elsif (iDNA = A) then 
					sNEXT_STATE <= STP;
				elsif (iDNA = T) then
					sNEXT_STATE <= TXX;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when TGX =>
				if (iDNA = A) then
					sNEXT_STATE <= STP;
				elsif (iDNA = T) then 
					sNEXT_STATE <= TXX;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when others =>
				sNEXT_STATE <= IDLE;

		end case;
	end process;

	-- Dozvola brojanja
	sEN <= '1' when sSTATE = STP else '0';

	-- Brojač
	process (inRST, iCNT) begin
		if (inRST = '0') then
			sCNT <= "00000000";
		elsif (rising_edge(iCLK)) then
			if (sEN = '1') then
				sCNT <= sCNT + 1;
			end if;
		end if;
	end process;
	
	-- Komparator na kraju
	oWARN <= '1' when (sCNT = 3) else '0';

	-- Kraj
	oCOUNT <= sCNT;

end architecture;
