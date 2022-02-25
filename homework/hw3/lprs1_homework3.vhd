library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- Libraries.

entity lprs1_homework3 is
	port(
		i_clk            :  in std_logic;
		i_rst            :  in std_logic;
		i_base           :  in std_logic_vector(1 downto 0);
		i_sequence       :  in std_logic_vector(63 downto 0);
		i_load_sequence  :  in std_logic;
		i_base_src_sel   :  in std_logic;
		i_cnt_subseq_sel :  in std_logic_vector(1 downto 0);
		o_cnt_subseq     : out std_logic_vector(3 downto 0)
	);
end entity;


architecture arch of lprs1_homework3 is
	-- Constants.
	constant A : std_logic_vector(1 downto 0) := "00";
	constant C : std_logic_vector(1 downto 0) := "01";
	constant G : std_logic_vector(1 downto 0) := "10";
	constant T : std_logic_vector(1 downto 0) := "11";

	-- Sekvence:
	-- seq0:	GGT
	-- seq1:	GGC
	-- seq2:	GAG
	
	-- Signals.
	type t_state is (idle, gxx, ggx, gax, ggt, ggc, gag);
	signal s_state, s_next_state : t_state;

	-- Dozvole brojanja
	signal s_en_subseq0 : std_logic;
	signal s_en_subseq1 : std_logic;
	signal s_en_subseq2 : std_logic;

	-- Brojači
	signal s_cnt_subseq0 : std_logic_vector(3 downto 0) := "0000";	-- mod5  (0100)
	signal s_cnt_subseq1 : std_logic_vector(3 downto 0) := "0000";	-- mod8  (0111)
	signal s_cnt_subseq2 : std_logic_vector(3 downto 0) := "0000";	-- mod10 (1001)

	-- Registri
	signal s_base : std_logic_vector(1 downto 0);			-- baza koju unosimo
	signal s_sh_base : std_logic_vector(1 downto 0);		-- baza preuzeta iz sekvence
	signal s_sh_sequence : std_logic_vector(63 downto 0);		-- sekvenca ?
	signal s_sh_reg : std_logic_vector(63 downto 0);		-- pomerački registar
	
begin
	-- Body.
	
	-- 1 --
	-- Registar za pamćenje stanja
	-- Sinhroni reset
	process (i_clk) begin
		if (falling_edge(i_clk)) then
			if (i_rst = '1') then
				s_state <= idle;
			else
				s_state <= s_next_state;
			end if;
		end if;
	end process;

	-- Funkcija prelaza stanja
	process (s_state, s_base) begin						
		case (s_state) is

			when idle =>
				if (s_base = G) then
					s_next_state <= gxx;
				else
					s_next_state <= idle;
				end if;
			
			when gxx =>
				if (s_base = g) then
					s_next_state <= ggx;
				elsif (s_base = a) then
					s_next_state <= gax;
				else
					s_next_state <= idle;
				end if;

			when ggx =>
				if (s_base = t) then
					s_next_state <= ggt;
				elsif (s_base = c) then
					s_next_state <= ggc;
				else
					s_next_state <= idle;
				end if;

			when gax =>
				if (s_base = g) then
					s_next_state <= gag;
				else
					s_next_state <= idle;
				end if;

			when ggt =>
				if (s_base = G) then
					s_next_state <= gxx;
				else
					s_next_state <= idle;
				end if;

			when ggc =>
				if (s_base = G) then
					s_next_state <= gxx;
				else
					s_next_state <= idle;
				end if;

			when gag =>
				if (s_base = G) then
					s_next_state <= gxx;
				else
					s_next_state <= idle;
				end if;

			when others =>
				s_next_state <= idle;

		end case;
	end process;

	-- Dozvole brojanja za brojače
	s_en_subseq0 <= '1' when s_state = ggt else '0';
	s_en_subseq1 <= '1' when s_state = ggc else '0';
	s_en_subseq2 <= '1' when s_state = gag else '0';

	-- 2 --
	-- Brojač GGT podsekvence (mod5)
	-- Sinhroni reset
	process (i_clk) begin
		if (falling_edge(i_clk)) then
			if (i_rst = '1') then
				s_cnt_subseq0 <= "0000";
			else
				if (s_en_subseq0 = '1') then
					if (s_cnt_subseq0 >= 4) then
						s_cnt_subseq0 <= "0000";
					elsif (s_cnt_subseq0 < 4) then
						s_cnt_subseq0 <= s_cnt_subseq0 + 1;
					end if;
				end if;
			end if;
		end if;
	end process;

	-- 3 --
	-- Brojač GGC podsekvence (mod8)
	-- Asinhroni reset
	process (i_clk, i_rst) begin
		if (i_rst = '1') then
			s_cnt_subseq1 <= "0000";
		elsif (falling_edge(i_clk)) then
			if (s_en_subseq1 = '1') then
				if (s_cnt_subseq1 >= 7) then
					s_cnt_subseq1 <= "0000";
				elsif (s_cnt_subseq1 < 7) then
					s_cnt_subseq1 <= s_cnt_subseq1 + 1;
				end if;
			end if;
		end if;
	end process;

	-- 4 --
	-- Brojač GAG podsekvence (mod10)
	-- Asinhroni reset
	process (i_clk, i_rst) begin
		if (i_rst = '1') then
			s_cnt_subseq2 <= "0000";
		elsif (falling_edge(i_clk)) then
			if (s_en_subseq2 = '1') then
				if (s_cnt_subseq2 >= 9) then
					s_cnt_subseq2 <= "0000";
				elsif (s_cnt_subseq2 < 9) then
					s_cnt_subseq2 <= s_cnt_subseq2 + 1;
				end if;
			end if;
		end if;
	end process;

	-- 5 --
	-- Izlazni MUX za selekciju izlaza brojača
	-- Preko process-case
	process (i_cnt_subseq_sel, s_cnt_subseq0, s_cnt_subseq1, s_cnt_subseq2) begin
		case (i_cnt_subseq_sel) is
			when "00" => o_cnt_subseq <= s_cnt_subseq0;
			when "01" => o_cnt_subseq <= s_cnt_subseq1;
			when "10" => o_cnt_subseq <= s_cnt_subseq2;
			when others => o_cnt_subseq <= "0000";
		end case;
	end process;

	-- 6 --
	-- Ulazni MUX za selekciju baze koja će ući u brojač
	-- Preko process-case
	process (i_base_src_sel, i_base, s_sh_base) begin
		case (i_base_src_sel) is
			when '0' => s_base <= i_base;
			when '1' => s_base <= s_sh_base;		-- vrednost iz pom. reg.
			when others => s_base <= "00";
		end case;
	end process;

	-- 7 --
	-- Pomerački registar koji šalje jednu po jednu bazu iz sekvence u automat
	-- Sinhroni reset
	process (i_clk) begin			--> greška 1.1
		if (falling_edge(i_clk)) then
			if (i_rst = '1') then
				s_sh_base <= "00";
			else
				s_sh_base <= s_sh_reg(63 downto 62);	-- uzimamo 2 najviša bita iz registra
			end if;
		end if;
	end process;

	-- Dodela vrednosti pomeračkom registru
	-- Sinhroni reset
	process (i_clk) begin			--> greška 1.2
		if (falling_edge(i_clk)) then
			if i_rst = '1') then
				s_sh_reg <= "0000000000000000000000000000000000000000000000000000000000000000";
			else
				s_sh_reg <= s_sh_sequence;
			end if;
		end if;
	end process;

	-- Kombinaciona mreža pomeračkog registra preko when-else
	s_sh_sequence <=
		i_sequence when i_load_sequence = '1' else
		 s_sh_reg(61 downto 0) & "00";

end architecture;
