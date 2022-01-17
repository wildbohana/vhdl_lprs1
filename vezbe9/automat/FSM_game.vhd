library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;

entity FSM_game is port ( 
	iRST  : in  std_logic;
	iCLK  : in  std_logic;
	iA	   : in  std_logic_vector(1 downto 0);
	iB	   : in  std_logic_vector(1 downto 0);
	oA  	: out std_logic;
	oB  	: out std_logic
	);
end entity;

architecture Behavioral of FSM_game is
	type tSTATE is (DRAW, A_LEAD, B_LEAD, A_WIN, B_WIN);
	signal sSTATE, sNEXT_STATE : tSTATE;

	signal sWIN : std_logic_vector(1 downto 0);
	signal --;
	
begin

	-- Registar - asinhroni reset
	process(iCLK, iRST) begin
		if(iRST = '1') then 
			sSTATE <= DRAW;
		elsif(rising_edge(iCLK)) then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	-- Funkcija prelaza stanja
	process (sSTATE, iA, iB) begin			-- samo ulazni signali ovde
		case(sSTATE) is
			when DRAW =>
				if (iA = "01") then 
					sNEXT_STATE <= A_LEAD;
				elsif (iB = "01") then 
					sNEXT_STATE <= B_LEAD;
				else
					sNEXT_STATE <= DRAW;
				end if;
			
			when A_LEAD =>
				if (iA = "01") then 
					sNEXT_STATE <= A_WIN;
				elsif (iB = "01") then 
					sNEXT_STATE <= DRAW;
				elsif (iB = "10") then
					sNEXT_STATE <= B_LEAD;
				else
					sNEXT_STATE <= A_LEAD;
				end if;

			when B_LEAD =>
				if (iB = "01") then 
					sNEXT_STATE <= B_WIN;
				elsif (iA = "01") then 
					sNEXT_STATE <= DRAW;
				elsif (iA = "10") then
					sNEXT_STATE <= A_LEAD;
				else
					sNEXT_STATE <= B_LEAD;
				end if;

			when A_WIN =>
				sNEXT_STATE <= A_WIN;

			when B_WIN =>
				sNEXT_STATE <= B_WIN;

			when others =>
				sNEXT_STATE <= DRAW;
		end case;
	end process;

	-- Funkcija izlaza
	sWIN <=	"01" when sSTATE = A_WIN else
			"10" when sSTATE = B_WIN else
			"00";

	oA <= '1' when sWIN = "01" else '0';
	oB <= '1' when sWIN = "10" else '0';

end Behavioral;
