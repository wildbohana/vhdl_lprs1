library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;

entity zad_tb is
end entity;

architecture arch of zad_tb is

	constant i_clk_period : time := 10 ns;

	signal iCLK : std_logic;
	signal iRST : std_logic;

	-- i ovde dodaš i/o signale po potrebi
	signal iA : std_logic;
	signal iB : std_logic;
	signal iSEL : std_logic_vector(1 downto 0);
	signal oY : std_logic_vector(3 downto 0);

begin

	uut : entity work.zad
	port map(
		iCLK => iCLK,
		iRST => iRST,

		-- i tako za ostale gore napisane i/o signale
		iA => iA,
		iB => iB,
		iSEL => iSEL,
		oY => oY

	);

	clk_p: process
	begin
		iCLK <= '0';
		wait for i_clk_period/2;
		iCLK <= '1';
		wait for i_clk_period/2;
	end process;

	stim_p: process
	begin
	
		-- ovde pišeš tb

	wait
	end process;

end architecture;
