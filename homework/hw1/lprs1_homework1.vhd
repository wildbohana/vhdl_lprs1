library ieee;
-- Libraries.
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity lprs1_homework1 is
	port(
		i_x   :  in std_logic_vector(3 downto 0);
		i_y   :  in std_logic_vector(3 downto 0);
		i_z   :  in std_logic_vector(1 downto 0);
		i_sel :  in std_logic_vector(1 downto 0);
		o_res : out std_logic_vector(3 downto 0);
		o_cmp : out std_logic_vector(1 downto 0);
		o_enc : out std_logic_vector(1 downto 0)
	);
end entity;


architecture arch of lprs1_homework1 is
	-- Signals.
	-- Svi interni signali su 4 bit.
	signal s_shl	: std_logic_vector(3 downto 0);
	signal s_shr	: std_logic_vector(3 downto 0);
	signal s_dec	: std_logic_vector(3 downto 0);
	signal s_add	: std_logic_vector(3 downto 0);
	signal s_sub	: std_logic_vector(3 downto 0);
	signal s_const0	: std_logic_vector(3 downto 0);
	signal s_const1	: std_logic_vector(3 downto 0);
	signal s_mux	: std_logic_vector(3 downto 0);

begin
	-- Design.
	
	-- s_shl je i_x pomereno logički ulevo za 2
	s_shl <= i_x(1 downto 0) & "00";

	-- s_shr je i_y pomereno aritmetički udesno za 2
	s_shr <= i_y(3) & i_y(3) & i_y(3 downto 2);

	-- s_dec je izlaz iz dekodera sa ulazom i_z (n=2)
	s_dec <=
		"1000" when i_z = "11"	else
		"0100" when i_z = "10"	else
		"0010" when i_z = "01"	else
		"0001";

	-- s_add je rezultat sabiranja s_shl + s_shr
	s_add <= s_shl + s_shr;

	-- s_sub je rezultat oduzimanja s_dec - i_x
	s_sub <= s_dec - i_x;

	-- konstante 7 i 13
	s_const0 <= "0111";
	s_const1 <= "1101";

	-- s_mux je izlaz iz multipleksera koji zavisi od i_sel (n=2)
	s_mux <=
		s_const0 when i_sel = "00" else
		s_sub	 when i_sel = "01" else
		s_const1 when i_sel = "10" else
		s_add;

	-- obična dodela
	o_res <= s_mux;

	-- o_cmp je dvobitni signal čije vrednosti bita dobijamo iz dva komparatora
	o_cmp(0) <= '1' when (s_mux = 0) else '0';
	o_cmp(1) <= '1' when (s_mux < 6) else '0';

	-- o_enc je izlaz iz prioritetnog kodera čiji je ulaz s_mux
	o_enc <=
		"11" when s_mux(3) = '1' else
		"10" when s_mux(2) = '1' else
		"01" when s_mux(1) = '1' else
		"00";

end architecture;
