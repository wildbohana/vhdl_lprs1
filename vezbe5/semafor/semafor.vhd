library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Semafor is
    port ( 	iCLK    : in  std_logic;
			iRST    : in  std_logic;
			iOK     : in  std_logic;
			iHAZ    : in  std_logic;
			oRED    : out std_logic;
			oYELLOW : out std_logic;
			oGREEN  : out std_logic);
end Semafor;

architecture Behavioral of Semafor is

	-- za zadatak 5 dodamo stanje blink
	type tSTATE is (IDLE, RED, RED_YELLOW, GREEN, YELLOW, HAZARD, BLINK);
	signal sSTATE, sNEXT_STATE : tSTATE;
	
	signal sCNT : std_logic_vector(2 downto 0);
	signal sTC : std_logic;

begin

	-- brojač pola us (broji po modulu 5)
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sCNT <= "000";
		elsif(rising_edge(iCLK)) then
			if(sCNT = 4) then
				sCNT <= "000";
			else
				sCNT <= sCNT + 1;
			end if;
		end if;
	end process;

	sTC <= '1' when sCNT = 4 else '0';

	-- registar za pamćenje stanja automata
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sSTATE <= IDLE;
		elsif(rising_edge(iCLK)) then
			if(sTC = '1') then					-- usporavanje sistema (4. zadatak)
				sSTATE <= sNEXT_STATE;
			end if;
		end if;
	end process;

	-- funkcija prelaza stanja
	process (sSTATE, iHAZ, iOK) begin
		case sSTATE is

			when IDLE =>
				if(iOK = '1') then
					sNEXT_STATE <= RED;
				else
					sNEXT_STATE <= IDLE;
				end if;

			when RED =>
				if(iHAZ = '1') then
					sNEXT_STATE <= HAZARD;
				else
					sNEXT_STATE <= RED_YELLOW;
				end if;

			when RED_YELLOW =>
				if(iHAZ = '1') then
					sNEXT_STATE <= HAZARD;
				else
					sNEXT_STATE <= GREEN;
				end if;

			when GREEN =>
				if(iHAZ = '1') then
					sNEXT_STATE <= HAZARD;
				else
					sNEXT_STATE <= YELLOW;
				end if;

			when YELLOW =>
				if(iHAZ = '1') then
					sNEXT_STATE <= HAZARD;
				else
					sNEXT_STATE <= RED;
				end if;

			when HAZARD =>
				if(iOK = '1') then
					sNEXT_STATE <= RED;
				else
					sNEXT_STATE <= BLINK;
				end if;

			when BLINK =>							-- dodamo blink za zad 5.
				if(iOK = '1') then
					sNEXT_STATE <= RED;
				else
					sNEXT_STATE <= HAZARD;
				end if;

			when others =>
				sNEXT_STATE <= IDLE;

		end case;
	end process;
	
	-- funkcija izlaza
	oRED <=
		'1' when sSTATE = RED or sSTATE = RED_YELLOW else '0';
	oYELLOW <=
		'1' when sSTATE = YELLOW or sSTATE = RED_YELLOW or sSTATE = BLINK else '0';
	oGREEN <=
		'1' when sSTATE = GREEN	or sSTATE = HAZARD else '0';
 
end Behavioral;
