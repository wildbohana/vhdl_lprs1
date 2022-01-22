library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------

-- ENTITY --
entity svega is
	port(
		iA 		:  in std_logic_vector(7 downto 0);
		iB 		:  in std_logic_vector(2 downto 0);
		iSEL 	:  in std_logic_vector(1 downto 0);
		oY 		: out std_logic_vector(3 downto 0);
		oZERO 	: out std_logic
	);
end entity;

--------------------------------------------------------------------------------

-- ARHITEKTURA --
architecture Behavioral of svega is
	-- navedi sve signale (vektori)
	signal sCODER	: std_logic_vector(2 downto 0);			-- 3 bit
	signal sADD		: std_logic_vector(3 downto 0);			-- 4 bit
	signal sB		: std_logic_vector(3 downto 0);
	signal sC		: std_logic_vector(3 downto 0);
	signal sCOMP	: std_logic_vector(3 downto 0);
	signal sSHIFT	: std_logic_vector(3 downto 0);
	signal sDEC		: std_logic_vector(7 downto 0);			-- 8 bit
	signal sDEC_HIGH : std_logic_vector(3 downto 0);
	signal sDEC_LOW : std_logic_vector(3 downto 0);
	signal sMUX		: std_logic_vector(3 downto 0);
	
begin

---------------------------------- KOMPONENTE ----------------------------------

-- MULTIPLEKSER --
--> 2^n ulaza, n upravljačkih ulaza, jedan izlaz
-- (izlaz je jedan od ulaza) (opcioni signal dozvole)

sMUX <=
	sCOMP     when iSEL = "00" else
	sSHIFT    when iSEL = "01" else
	sDEC_HIGH when iSEL = "10" else
	sDEC_LOW;
	
--------------------------------------------------------------------------------

-- DEMULTIPLEKSER -- 
--> jedan ulaz, n upravljačkih ulaza, 2^n izlaza
-- (ulaz se preslikava na jedan od izlaza) (opcioni signal dozvole)

sDEM <=	NEMAMO;		-- ali ide preko procesa

--------------------------------------------------------------------------------

-- DEKODER --
--> n ulaza, 2^n izlaza
-- (izlaz zavisi od vrednosti ulaza) (opcioni signal dozvole)

sDEC <=
	"00000001" when iB = "000" else
	"00000010" when iB = "001" else
	"00000100" when iB = "010" else
	"00001000" when iB = "011" else
	"00010000" when iB = "100" else
	"00100000" when iB = "101" else
	"01000000" when iB = "110" else
	"10000000";

--------------------------------------------------------------------------------

-- KODER --
--> 2^n ulaza, n izlaza
-- (prioritetni koder - gleda najviši bit sa 1) (opcioni signal dozvole?)

sCODER <=
	"111" when iA(7) = '1' else
	"110" when iA(6) = '1' else
	"101" when iA(5) = '1' else
	"100" when iA(4) = '1' else
	"011" when iA(3) = '1' else
	"010" when iA(2) = '1' else
	"001" when iA(1) = '1' else
	"000";

------------------------------------ OSTALO ------------------------------------

-- KOMPARATOR --
	oEQ <= '1' when A=B else '0';
	oGT <= '1' when A>B else '0';
	oLT <= '1' when A<B else '0';

-- SABIRAČ --
	sB   <= iB(2) & iB;				-- Proširi za bit znaka
	sC   <= sCODER(2) & sCODER;		-- Proširi za bit znaka
	sADD <= sB + sC;

-- LOGIČKI POMERAČ --
-- (samo dodaje 0 levo ili desno) -> ovo je logičko pomeranje za 2 udesno
	sSHR <= "00" & sADD(3 downto 2); 

-- ARITMETIČKI POMERAČ --
-- (dodatno kopira skroz levu vrednost) -> ovo je aritmetičko pomeranje za 2 udesno
	sASHR <= sADD(3) & sADD(3) & sADD(3 downto 2);

-- KOMPLEMENTER 2 --
	sCOMP  <= not(sADD) + 1;

-- SELEKTIVNO KOPIRANJE --
	sDEC_HIGH	<=	sDEC(7 downto 4);
	sDEC_LOW	<=	sDEC(3 downto 0);

-- KRAJ -> DODELA VREDNOSTI OUT SIGNALIMA
	oY <= sMUX;	
	oZERO <= '1' when sMUX = 0 else '0';		-- Za poređenje ide obična 0, bez ''

end architecture;