library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity kolo is
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

architecture arch of kolo is
	-- Constants.
	-- za brojač - mod25 ide do 24 (11000)
	constant cMod25	: std_logic_vector(4 downto 0) := "11000";

	-- Signals.
	signal s_en_1us	: std_logic;
	signal s_tc_1us : std_logic;
	signal s_cnt_1us: std_logic_vector(4 downto 0);
	signal s_en0 	: std_logic;
	signal s_tc0 	: std_logic;
	signal s_cnt0 	: std_logic_vector(3 downto 0) := "0000";
	signal s_en1 	: std_logic;
	signal s_cnt1	: std_logic_vector(3 downto 0) := "0000";
	signal s_tc1 	: std_logic;

--------------------------------------------------------------------------------

begin

	-- Kontrola dozvole brojanja, asinhroni reset
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_en <= '0';
		elsif(i_clk'event and i_clk = '1') then
			if(i_rst = '1') then
				s_en <= '0';
			elsif(i_run = '1') then
				s_en <= '1';
			elsif(i_pause = '1') then
				s_en <= '0';
			end if;
		end if;
	end process;
	
	-- Brojač po mod25, asinhroni reset
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt <= "00000";
		elsif(rising_edge(i_clk)) then
			if(s_en = '1') then					-- dozvola brojanja
				if(s_cnt < cMod25) then
					s_cnt <= s_cnt + 1;
				elsif(s_cnt >= cMod25) then
					s_cnt <= "00000";
				end if;
			end if;
		end if;

	end process;

	-- Registar za pamćenje, sinhroni reset
	process(i_clk) begin
		if(falling_edge(i_clk)) then
			if(i_rst = '1') then
				s_cnt_temp <= "00000";
			else
				s_cnt_temp <= s_cnt;
			end if;
		end if;
	end process;


	-- POMERAČKI REGISTAR --
	process (i_rst, i_clk) begin
		if(i_rst = '1') then
			s_shreg <= "00000000";
		elsif(rising_edge(iCLK)) is
			if(i_load = '1') then
				s_shreg <= s_cnt_temp;
			elsif(i_shr = '1' and i_shl = '0') then
				if(i_artih = '1') then				-- aritm. udesno
					s_shreg <= s_shreg(7) & s_shreg(7 downto 1);
				else								-- log. udesno
					s_shreg <= '0' & s_shreg(7 downto 1);
				end if;
			elsif(i_shl = '1' and i_shr = '0') then
				if(i_artih = '1') then				-- aritm. ulevo
					s_shreg <= s_shreg(6 downto 0) & '0';
				else								-- log. ulevo
					s_shreg <= s_shreg(6 downto 0) & '0';
				end if;
			end if;
		end if;
	end process;	



end architecture;
