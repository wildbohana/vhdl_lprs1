-- biblioteke
library ieee;
use ieee.std_logic_1164.all
use ieee.std_logic_unsigned.all;

entity primer is
	port
		(
		iA : in std_logic;
		iB : in std_logic;
		iSEL : in std_logic_vector(1 downto 0);
		oY : out std_logic_vector(3 downto 0)
		);
end primer;

architecture behavioral of primer is
	-- konstante
	constant mod10 : std_logic_vector(3 downto 0) := "0101";	-- 9 (valjda)

	-- signali
	signal sMUX : std_logic_vector(3 downto 0);
	signal sDEC : std_logic_vector(3 downto 0);
	signal sCNT : std_logic_vector(3 downto 0);
	signal sCASE : std_logic_vector(1 downto 0);

begin

	-------------- KLASIKA --------------

	-- sabirač
	sADD <= sB + sC;

	-- komplementer
	sCOMP <= not(sADD) + 1;

	-- aritmetičko udesno za 2
	sSHIFT <= sADD(3) & sADD(3) & sADD(3 downto 2);

	-- uslovna dodela vrednosti
	oZERO <= '1' when sMUX = 0 else '0';



	-------------- KOMBINACIONI ELEMENTI --------------

	-- prioritetni koder najvišeg prioriteta
	oY <=
		"111" when iX(7) = '1' else
		"110" when iX(6) = '1' else
		"101" when iX(5) = '1' else
		"100" when iX(4) = '1' else
		"011" when iX(3) = '1' else
		"010" when iX(2) = '1' else
		"001" when iX(1) = '1' else
		"000";
	
	-- pripritetni koder najnižeg prioriteta
	oY <=
		"000" when iX(0) = '1' else
		"001" when iX(1) = '1' else
		"010" when iX(2) = '1' else
		"011" when iX(3) = '1' else
		"100" when iX(4) = '1' else
		"101" when iX(5) = '1' else
		"110" when iX(6) = '1' else
		"111";

	-- dekoder
	sDEC <=
		"00000001" when iD = "000" else
		"00000010" when iD = "001" else
		"00000100" when iD = "010" else
		"00001000" when iD = "011" else
		"00010000" when iD = "100" else
		"00100000" when iD = "101" else
		"01000000" when iD = "110" else
		"10000000";
	
	-- multiplekser 2x4
	sMUX <=
		sCNT when iSEL = "00" else
		sDEC when iSEL = "01" else
		sCASE when iSEL = "10" else
		sDEF;


	-------------- PROCESI --------------

	-- if-else proces
	process (iY) begin
		if(iY = "001") then
			sCNT = "1001";
		elsif(iY = "010") then
			sCNT = "0110";
		else
			sCNT = "0000";
		end if;
	end process;

	-- case process
	process (iZ) begin
		case iZ is
			when "11" =>
				sCASE <= "01";
			when "10" =>
				sCASE <= "10";
			when "01" =>
				sCASE <= "10";
			when others =>
				sCASE <= "00";
		end case;
	end process;


	-------------- SEKVENCIJALNI ELEMENTI --------------

	-- brojač, asinhroni reset, rastuća ivica
	process (iRST, iCLK) begin
		if(iRST = '1') then
			sCA <= "0000";
		elsif(iCLK'event and iCLK = '1') then
			if(iEN = '1') then
				sCA <= sCA + 1;
			end if;
		end if;
	end process;

	-- brojač. sinhroni, opadajuća ivica
	process (iCLK) begin
		if(falling_edge(iCLK)) then
			if (iRST = '1') then
				sCS <= "0000";
			elsif (iEN = '1') then
				sCS <= sCS + 1;
			end if;
		end if;
	end process;

	-- pomerački registar
	process (iRST, iCLK) begin
		if (iRST = '1') then
			sSHREG = "0000";
		elsif(rising_edge(iCLK)) then
			if (iLOAD = '1') then
				sSHREG <= iDATA;
			elsif(iSHR = '1' and iSHL = '0') then
				sSHREG <= sSHREG(3) & sSHREG(3 downto 1);
			else
				sSHREG <= sSHREG(2 downto 0) & '0';
			end if;
		end if;
	end process;
	
end architecture;
