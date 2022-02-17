
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;

entity lprs1_homework3_tb is
end entity;

architecture arch of lprs1_homework3_tb is
	-- Constants.
	constant A : std_logic_vector(1 downto 0) := "00";
	constant C : std_logic_vector(1 downto 0) := "01";
	constant G : std_logic_vector(1 downto 0) := "10";
	constant T : std_logic_vector(1 downto 0) := "11";
	
	
	constant i_clk_period : time := 10 ns;
	
	signal i_clk            : std_logic;
	signal i_rst            : std_logic;
	signal i_base           : std_logic_vector(1 downto 0);
	signal i_sequence       : std_logic_vector(63 downto 0);
	signal i_load_sequence  : std_logic;
	signal i_base_src_sel   : std_logic;
	signal i_cnt_subseq_sel : std_logic_vector(1 downto 0);
	signal o_cnt_subseq     : std_logic_vector(3 downto 0);
	
begin
	
	uut: entity work.lprs1_homework3
	port map(
		i_clk            => i_clk,
		i_rst            => i_rst,
		i_base           => i_base,
		i_sequence       => i_sequence,
		i_load_sequence  => i_load_sequence,
		i_base_src_sel   => i_base_src_sel,
		i_cnt_subseq_sel => i_cnt_subseq_sel,
		o_cnt_subseq     => o_cnt_subseq
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
		-- Test cases:

		-- Pripreme
		i_sequence <= "0000000000000000000000000000000000000000000000000000000000000000";
		i_load_sequence <= '1';				-- i_sequence ulazi u registar
		i_base_src_sel <= '0';				-- i_base ulazi u brojač
		i_cnt_subseq_sel <= "00";			-- izbor ispisa brojača
		i_rst <= '0';
		
		-- Prva sekvenca: CCGA TCAG TCTG TCAT AAGC AAAC CCGC GGCG
		i_base <= C;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;

		i_base <= T;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;

		i_base <= T;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= T;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;
		
		i_base <= T;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;
		i_base <= T;
		wait for i_clk_period;
		
		i_base <= A;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;

		i_base <= A;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;

		i_base <= C;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;
		
		i_base <= G;
		wait for i_clk_period;	
		i_base <= G;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;				-- GGC, ispis 01
		i_base <= G;
		wait for 2 * i_clk_period;

		-- Multiplekser
		i_cnt_subseq_sel <= "00";
		wait for i_clk_period;			--> greška 2.1
		i_cnt_subseq_sel <= "01";
		wait for i_clk_period;			--> greška 2.2
		i_cnt_subseq_sel <= "10";
		wait for i_clk_period;			--> greška 2.3

		-- Učitaj prvu sekvencu u registar
		i_base_src_sel <= '0';				-- i_base ulazi u brojač
		i_load_sequence <= '1';				-- upisujemo i_sequence u s_sh_reg
		wait for i_clk_period;
		i_load_sequence <= '0';				-- s_sh_reg šiftujemo u levo

		-- Resetuj sekvencu
		i_sequence <= "0000000000000000000000000000000000000000000000000000000000000000";

		-- Resetuj signale sa izborima
		i_base_src_sel <= '0';				-- i_base ulazi u brojač
		i_cnt_subseq_sel <= "00";			-- ispis brojača

		-- Resetuj automat na 14 taktova
		i_rst <= '1';
		wait for 14 * i_clk_period;
		i_rst <= '0';


		-- Druga sekvenca: TTGC CAGT AACA GCTA CAGC CGAA AACT TCAG
		i_base <= T;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;

		i_base <= C;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;
		i_base <= T;
		wait for i_clk_period;
		
		i_base <= A;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;
		
		i_base <= G;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= T;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;
		
		i_base <= C;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;
		
		i_base <= C;
		wait for i_clk_period;	
		i_base <= G;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;
		
		i_base <= A;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;
		i_base <= T;
		wait for i_clk_period;
		
		i_base <= T;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;
		i_base <= G;
		wait for 2 * i_clk_period;

		-- Multiplekser
		i_cnt_subseq_sel <= "00";
		wait for i_clk_period;			--> greška 2.1
		i_cnt_subseq_sel <= "01";
		wait for i_clk_period;			--> greška 2.2
		i_cnt_subseq_sel <= "10";
		wait for i_clk_period;			--> greška 2.3		

		-- Kraj sekvence
		i_base_src_sel <= '0';				-- i_base je izvor baze
		i_load_sequence <= '0';				-- s_sh_reg šiftujemo u levo

		-- Resetuj sekvekcu
		i_sequence <= "0000000000000000000000000000000000000000000000000000000000000000";

		-- Resetuj automat
		i_rst <= '1';
		wait for 14 * i_clk_period;
		i_rst <= '0';


		-- Do kraja sistem ostavi u stanju reset
		i_load_sequence <= '0';
		i_base_src_sel <= '0';
		i_cnt_subseq_sel <= "00";
		i_rst <= '1';
		i_base <= "00";
		i_sequence <= "0000000000000000000000000000000000000000000000000000000000000000";

		wait;
	end process;
	
end architecture;
