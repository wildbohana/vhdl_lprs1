library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;

entity zad_tb is
end entity;

architecture arch of zad_tb is

	constant i_clk_period : time := 10 ns;

	signal i_clk : std_logic;
	signal i_rst : std_logic;

	-- i ovde dodaš i/o signale po potrebi

begin

	uut : entity work.zad
	port map(
		i_clk => i_clk,
		i_rst => i_rst,

		-- i tako za ostale gore napisane i/o signale
	);

	clk_p: process
	begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
	end process;

	stim_p: process
	begin
		-- ovde pišeš tb
	




	wait
	end process;

end architecture;
