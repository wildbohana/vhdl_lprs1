library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------

-- use sekcija -> sve biblioteke koje ćeš koristiti
-- entity sekcija -> definišeš sve prolaze (portovi) (ulazni i izlazni signali)
-- architecture sekcija -> definišeš unutrašnost sistema (kola u sistemu)

--------------------------------------------------------------------------------

-- glavni hdl fajl --

-- entitet - portovi
entity ImeEntiteta is
	port (
		iA : in std_logic;
		iB : in std_logic;
		oY : out std_logic
	);
end entity;

-- arhitektura - interni signali i telo (funkcije)
architecture Behavioral of ImeEntiteta is
	signal sS : std_logic;
	signal sV : std_logic_vector (3 downto 0) --> vektor sa 4 bita u signalu
begin
	sS <= iA and iB;
	oY <= not(sS);
-- i uslovna (when) dodela ide ovde
end architecture;

--------------------------------------------------------------------------------

-- testbenč datoteka --

-- signali				(entity)
signal sA : std_logic;
signal sB : std_logic;
signal sY : std_logic;

-- portovi				(entity)
port (
	iA : in std_logic;
	iB : in std_logic;
	oY : out std_logic
);

-- mapiranje portova	(architecture)
port map (
	iA => sA,
	iB => sB,
	oY => sY
);

-- signali				(architecture)
stimulus : process
begin
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




-- bonus : uslovne strukture

-- NAPOMENA: izbegavatu paralelne IF i CASE strukture

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
