-- Libraries.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity automat is
	port(
		iCLK		:  in std_logic;
		inRST		:  in std_logic;
		iSEL		:  in std_logic_vector(1 downto 0);
		iDURATION 	:  in std_logic;
		iSTART		:  in std_logic;

		o150W		: out std_logic;
		o300W		: out std_logic;
		o650W 		: out std_logic;
		o800W 		: out std_logic;
		oWARN		: out std_logic
	);
end entity;

architecture arch of automat is
	-- Constants.
	constant cMod8 : std_logic_vector(2 downto 0) := "111";

	-- Signals.
	type tSTATE is (IDLE, HEAT, WRNG);
	signal sSTATE, sNEXT_STATE : tSTATE;

	signal sWARN_CNT_EN : std_logic;
	signal sHEAT_CNT_EN : std_logic;
	signal sHEAT_EN : std_logic;
	signal sWARN_EN : std_logic;
	signal sWARN_CNT_TC : std_logic := '0';			-- kraj ciklusa brojanja
	signal sHEAT_CNT_TC : std_logic := '0';			-- kraj ciklusa brojanja

	signal sWARN_CNT : std_logic_vector(2 downto 0);
	signal sHEAT_CNT : std_logic_vector(7 downto 0); 	-- broji do iDURATION
	
begin

	-- Registar prelaska stanja automata
	process (inRST, iCLK) begin
		if (inRST = '0') then 
			sSTATE <= IDLE;
		elsif (rising_edge(iCLK)) then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	-- Funkcija prelaza stanja
	process (sWARN_CNT_TC, sHEAT_CNT_TC, sSTATE) begin
		case sSTATE is
			
			when IDLE <=
				if (iSTART = '1') then
					sNEXT_STATE <= HEAT;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when HEAT <=
				if (sHEAT_CNT_TC = '1') then
					sNEXT_STATE <= WRNG;
				else
					sNEXT_STATE <= HEAT;
				end if;

			when WRNG <=
				if (sWARN_CNT_TC = '1') then
					sNEXT_STATE <= IDLE;
				else
					sNEXT_STATE <= WRNG;
				end if;

			when others <=
				sNEXT_STATE <= IDLE;

		end case;
	end process;

	-- Kocka, kocka, kockica
	sHEAT_CNT_EN <= '1' when (sSTATE = HEAT) else '0';
	sWARN_CNT_EN <= '1' when (sSTATE = WRNG) else '0';
	sHEAT_EN <= '1' when (sSTATE = HEAT) else '0';
	sWARN_EN <= '1' when (sSTATE = WRNG) else '0';

	-- Brojač za WARNING (mod8)
	process (inRST, iCLK) begin
		if (inRST = '0') then
			sWARN_CNT <= "000";
		elsif (rising_edge(iCLK)) then
			if (sWARN_CNT_EN = '1') then
				if (sWARN_CNT = 7) then 
					sWARN_CNT_TC <= '1';
				else
					sWARN_CNT <= sWARN_CNT + 1;
				end if;
			end if;
		end if;
	end process;

	-- Brojač za HEAT
	process (inRST, iCLK) begin
		if (inRST = '0') then
			sHEAT_CNT <= "000";
		elsif (rising_edge(iCLK)) then
			if (sHEAT_CNT_EN = '1') then
				if (sHEAT_CNT = iDURATION) then 
					sHEAT_CNT_TC <= '1';
				else
					sHEAT_CNT <= sHEAT_CNT + 1;
				end if;
			end if;
		end if;
	end process;

	-- DEMUX
	process (iSEL, sHEAT_EN) begin
		case (iSEL) is

			when "00" =>
				o150W <= sHEAT_EN;
			
			when "01" =>
				o300W <= sHEAT_EN;

			when "10" =>
				o650W <= sHEAT_EN;

			when others =>
				o800W <= sHEAT_EN;
			
		end case;
	end process;

	-- Kraj
	oWARN <= sWARN_EN;

end architecture;
