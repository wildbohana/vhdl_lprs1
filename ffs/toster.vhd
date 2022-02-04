-- Libraries.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity automat is
	port(
		iCLK	:  in std_logic;
		iRST	:  in std_logic;		-- sinhroni, aktivan na 1
		iTOAST	:  in std_logic;
		oDONE	: out std_logic;
		oTIME	: out std_logic_vector(5 downto 0);
		oTEMP	: out std_logic_vector(7 downto 0)
	);
end entity;

architecture arch of automat is
	-- Constants.
	constant tMIN  : std_logic_vector(7 downto 0) := "00010100";		-- 20 stepeni
	constant tMAX  : std_logic_vector(7 downto 0) := "11111010";		-- 250 stepeni
	constant tSTEP : std_logic_vector(7 downto 0) := "00001010";		-- 10 stepeni

	constant cMod5	: std_logic_vector(3 downto 0) := "101";			-- 4
	constant c60	: std_logic_vector(5 downto 0) := "111100";			-- 60
	
	-- Signals.
	type tSTATE is (IDLE, WARMUP, TOAST, COOLDOWN);
	signal sSTATE, sNEXT_STATE : tSTATE;

	signal sTEMP 	: std_logic_vector(7 downto 0);
	signal sTIME 	: std_logic_vector(5 downto 0);
	signal sTC1 	: std_logic;			-- dozvola za povećanje temperature
	signal sHEAT 	: std_logic;			-- dozvola za rad grejača
	signal sEN 		: std_logic;			-- dozvola za tajmer tostera
	signal sTC2 	: std_logic;			-- kraj tostiranja

	-- brojač po mod5
	signal sCNT		: std_logic_vector(2 downto 0);	

begin

	-- Brojač koji broji po mod 5, kada je na 4 - sTC1 <= '1'
	process (iCLK) begin
		if (rising_edge(iCLK)) then
			if (iRST = '1') then 
				sCNT <= "000";
			else
				if (sCNT >= cMod5) then 
					sCNT <= "000";
				else
					sCNT <= sCNT + 1;
				end if;
			end if;
		end if;
	end process;

	sTC1 <= '1' when (sCNT = cMod5) else '0';

	-- Senzor za temperaturu - povećava/smanjuje temperaturu u zavisnosti od sHEAT
	process (iCLK) begin
		if (rising_edge(iCLK)) then 
			if (iRST = '1') then 
				sTEMP <= tMIN;
			else
				if (sTC1 = '1') then
					if (sHEAT = '1') then 	-- Povećava temperaturu
						if (sTEMP < tMAX) then 
							sTEMP <= sTEMP + tSTEP;
						end if;
					else					-- Smanjuje temperaturu
						if (sTEMP > tMIN) then 
							sTEMP <= sTEMP - tSTEP;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	-- Tajmer za tostiranje - broji od 60 do 0
	-- (ne vraćaj na 60, ne treba ti loop nego samo jednom da izbroji)
	process (iCLK) begin
		if (rising_edge(iCLK)) then 
			if (iRST) then 
				sTIME <= c60;
			else
				if (sEN = '1') then  
					sTIME <= sTIME - 1;
					
				end if;
			end if;
		end if;
	end process;

	sTC2 <= '0' when sTIME = 0 else '1';

	--.*  FSM  *.--
	-- Registar za pamćenje stanja automata
	process (iCLK) begin
		if (rising_edge(iCLK)) then 
			if (iRST = '1') then 
				sSTATE <= IDLE;
			else
				sSTATE <= sNEXT_STATE;
			end if;
		end if;
	end process;

	-- Funkcija prelaza stanja
	process (sSTATE, iTOAST, sTEMP, sTIME) begin
		case sSTATE is

			when IDLE =>
				if (iTOAST = '1') then 
					sNEXT_STATE <= WARMUP;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when WARMUP =>
				if (sTEMP > 100) then 
					sNEXT_STATE <= TOAST;
				else
					sNEXT_STATE <= WARMUP;
				end if;

			when TOAST =>
				if (sTC2 = '1') then 
					sNEXT_STATE <= COOLDOWN;
				else
					sNEXT_STATE <= TOAST;
				end if;
			
			when COOLDOWN =>
				if (sTEMP < 200) then
					if (iTOAST = '1') then 
						if (sTEMP < 100) then 
							sNEXT_STATE <= WARMUP;
						else
							sNEXT_STATE <= TOAST;
						end if;
					end if;
				elsif (sTEMP > tMIN) then 
					sNEXT_STATE <= COOLDOWN;
				else
					sNEXT_STATE <= IDLE;		-- kada je temperatura 20 stepeni prelazi u IDLE
				end if;
			
			when others =>
				sNEXT_STATE <= IDLE;

		end case;
	end process;

	-- Funkcija izlaza automata
	oDONE <= '1' when (sSTATE = COOLDOWN) else '0';
	sHEAT <= '1' when (sSTATE = WARMUP or sSTATE = TOAST) else '0';
	sEN   <= '1' when (sSTATE = TOAST) else '0';

	oHEAT <= sHEAT;
	oTIME <= sTIME;

end architecture;
