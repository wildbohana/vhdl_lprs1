
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- Libraries.

entity lprs1_homework2 is
	port(
		i_clk    :  in std_logic;
		i_rst    :  in std_logic;
		i_run    :  in std_logic;
		i_pause  :  in std_logic;
		o_digit0 : out std_logic_vector(3 downto 0);
		o_digit1 : out std_logic_vector(3 downto 0);
		o_digit2 : out std_logic_vector(3 downto 0);
		o_digit3 : out std_logic_vector(3 downto 0)
	);
end entity;


architecture arch of lprs1_homework2 is
	-- Constants.
	-- mod25 ide do 24 (11000), mod10 do 9 (1001), mod6 do 5 (0101)
	constant cMod25	: std_logic_vector(4 downto 0) := "11000";	
	constant cMod10 : std_logic_vector(3 downto 0) := "1001";
	constant cMod6  : std_logic_vector(3 downto 0) := "0101";

	-- Signals.
	signal s_en_1us	: std_logic;
	signal s_tc_1us 	: std_logic;
	signal s_cnt_1us 	: std_logic_vector(4 downto 0);
	signal s_en0 		: std_logic;
	signal s_tc0 		: std_logic;
	signal s_cnt0 		: std_logic_vector(3 downto 0) := "0000";
	signal s_en1 		: std_logic;
	signal s_cnt1		: std_logic_vector(3 downto 0) := "0000";
	signal s_tc1 		: std_logic;
	
begin
	-- Body.

	-- Kontrola dozvole brojanja, signal s_en_us:
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_en_1us <= '0';
		elsif(i_clk'event and i_clk = '1') then
			if(i_rst = '1') then
				s_en_1us <= '0';
			elsif(i_run = '1') then
				s_en_1us <= '1';
			elsif(i_pause = '1') then
				s_en_1us <= '0';
			elsif(i_pause = '1' and i_run = '1') then
				s_en_1us <= '1';
			end if;
		end if;

	end process;

	-- Brojač jedne 1 us, signal s_cnt_1us:
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt_1us <= "00000";
		elsif(rising_edge(i_clk)) then
			if(s_en_1us = '1') then							-- signal iz kontrole dozvole brojanja
				if(s_cnt_1us < cMod25) then
					s_cnt_1us <= s_cnt_1us + 1;
				elsif(s_cnt_1us >= cMod25) then
					s_cnt_1us <= "00000";
				end if;
			end if;
		end if;

	end process;

	-- Kombinaciona provera za aktivaciju signala s_tc_1us (kraj brojača):
	s_tc_1us <= '1' when s_cnt_1us = "00000" else
					'0';

	-- and kapija za signale s_en_1us i s_tc_1us -> dozvola brojanja s_en0:
	s_en0 <= s_en_1us and s_tc_1us;

	-- Brojač jedne nulte cifre, signal s_cnt0:
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt0 <= "0000";
		elsif(i_clk'event and i_clk = '1') then
			if(s_en0 = '1') then								-- dozvola brojanja
				if(s_cnt0 < cMod10) then
					s_cnt0 <= s_cnt0 + 1;
				elsif(s_cnt0 >= cMod10) then
					s_cnt0 <= "0000";
				end if;
			end if;
		end if;

	end process;

	-- Kombinaciono provera za aktivaciju signala s_tc0 (kraj brojača):
	s_tc0 <=	'1' when s_cnt0 = "1001" else
				'0';

	-- and kapija za signale s_en0 i s_tc0 -> dozvola brojanja s_en1:
	s_en1 <= s_en0 and s_tc0;

	-- Vezivanje internog i izlaznog signala brojača:
	o_digit0 <= s_cnt0;

	-- Brojač jedne prve cifre, signal s_cnt1:
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt1 <= "0000";
		elsif(rising_edge(i_clk)) then
			if(s_en1 = '1') then								-- dozvola brojanja
				if(s_cnt1 < cMod6) then
					s_cnt1 <= s_cnt1 + 1;
				elsif(s_cnt1 >= cMod6) then
					s_cnt1 <= "0000";
				end if;
			end if;
		end if;

	end process;

	-- Kombinaciona provera za aktivaciju signala s_tc1 (kraj brojača):
	s_tc1 <= '1' when s_cnt1 = "0101" else
				'0';
	
	-- Vezivanje internog i izlaznog signala brojača:
	o_digit1 <= s_cnt1;

	-- Dodela vrednosti signalu o_digit2 (6)
	o_digit2 <= "0110";

	-- Dodela vrednosti signalu o_digit3 (15)
	o_digit3 <= "1111";
	
end architecture;
