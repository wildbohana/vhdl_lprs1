library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------

-- use sekcija 		-> sve biblioteke koje ćeš koristiti
-- entity sekcija 	-> definišeš sve prolaze (ulazni i izlazni signali)
-- architecture sekcija	-> definišeš unutrašnost sistema (kola u sistemu)

--------------------------------------------------------------------------------

-- Glavna vhdl datoteka --

-- Entity (portovi)
entity ImeEntiteta is
	port (
		iA : in std_logic;
		iB : in std_logic;
		oY : out std_logic
	);
end entity;

-- Architecture (interni signali i telo)
architecture Behavioral of ImeEntiteta is
	
	signal sS : std_logic;
	signal sV : std_logic_vector (3 downto 0)
		
begin
	
	sS <= iA and iB;
	oY <= not(sS);

	-- i uslovna (when) dodela ide ovde

end architecture;

--------------------------------------------------------------------------------

-- Testbenč datoteka --

-- Signali		(entity)
signal sA : std_logic;
signal sB : std_logic;
signal sY : std_logic;

-- Portovi		(entity)
port (
	iA : in std_logic;
	iB : in std_logic;
	oY : out std_logic
);

-- Mapiranje portova	(architecture)
port map (
	iA => sA,
	iB => sB,
	oY => sY
);

-- Signali		(architecture)
stimulus : process
	
begin
	sA <= '0';
	sB <= '0';
	wait for 100 ns;
	sA <= '0';
	sB <= '1';
	wait;

end process stimulus;




--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




-- Bonus : uslovne strukture

-- NAPOMENA: izbegavati paralelne IF i CASE strukture

-- if struktura
process (<sensitivityList>) begin
	if (<condition1>) then
		<statements>
	elsif (<condition2>) then
		<statements>
	else
		<statements>
	end if;
end process;

-- case struktura
process (<sensitivityList>) begin
	case (<signalName>) is
		when <value1> => <statements>;
		when <value2> => <statements>;
		-- ...
		when <valueN> => <statements>;
		when others => <statements>;
	end case;
end process;
