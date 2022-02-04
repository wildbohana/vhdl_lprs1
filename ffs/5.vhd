-- Libraries.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity automat is
	port(
		iCLK	:  in std_logic;
		iRST	:  in std_logic;
		iCAR	:  in std_logic_vector(1 downto 0);
		oTOTAL	: out std_logic_vector(7 downto 0);
		oOPEN	: out std_logic;
		oWARNING: out std_logic
	);
end entity;

architecture arch of automat is
	-- Constants.
	
	-- Signals.
	type tSTATE is (IDLE, WRNG, FREE_ENTRY, OPEN_GUEST, OPEN_MEMBER);
	signal sSTATE, sNEXT_STATE : tSTATE;

	signal sCNT1 : std_logic_vector(3 downto 0);	-- broji do 14
	signal sCNT2 : std_logic_vector(7 downto 0);	-- broji goste?

	signal sRESET : std_logic;
	signal sENABLE : std_logic;

begin
	-- iCAR vrednosti
	-- 00 - na ulazu nema automobila
	-- 01 na ulazu čeka član kluba
	-- 10 na ulazu ne čeka član kluba
	-- 15 taktova posle 01 može tačno jedan automobil da uđe


	--.*  FSM  *.--
	-- Registar za pamćenje stanja automata
	process (inRST, iCLK) begin
		if (inRST = '0') then
			sSTATE <= IDLE;
		elsif (rising_edge(iCLK)) then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	-- Funkcija prelaza stanja
	process (sSTATE, iCAR) begin
		case sSTATE is

			when IDLE =>
				if (iCAR = "01") then
					sNEXT_STATE <= OPEN_MEMBER;
				elsif (iCAR = 10) then 
					sNEXT_STATE <= WRNG;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when WRNG =>
				sNEXT_STATE <= IDLE;

			when OPEN_MEMBER =>
				sNEXT_STATE <= FREE_ENTRY;
			
			when FREE_ENTRY =>
				if (sCNT = 14) then
					sNEXT_STATE <= IDLE;
				elsif (iCAR = "01") then 
					sNEXT_STATE <= OPEN_MEMBER;
				elsif (iCAR = "10") then
					sNEXT_STATE <= OPEN_GUEST;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when OPEN_GUEST =>
				sNEXT_sTATE <= IDLE;

			when others => IDLE;

		end case;
	end process;

	-- Dozvole na kraju promene stanja
	sRESET   <= '0' when (sSTATE = FREE_ENTRY) else '0';
	sENABLE  <= '1' when (sSTATE = OPEN_MEMBER or sSTATE = OPEN_GUEST) else '0';
	oWARNING <= '1' when (sSTATE = WRNG) else '0';

	-- Brojač za taktove u FSM
	process (sRESET, iCLK) begin
		if (sRESET = '1') then
			sCNT1 <= "0000";
		elsif (rising_edge(iCLK)) then 
			sCNT1 <= sCNT1 + 1;
		end if;
	end process;

	-- Brojač automobila u garaži
	process (inRST, iCLK) begin
		if (inRST = '0') then
			sCNT2 <= "00000000";
		elsif (rising_edge(iCLK)) then
			if (sENABLE = '1') then
				sCNT2 <= sCNT2 + 1;
			end if;
		end if;
	end process;

	-- Kraj
	oTOTAL <= sCNT2;

end architecture;
