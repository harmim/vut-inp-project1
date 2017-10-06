-- Author: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>

-------------------------- Knihovny --------------------------
library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--------------------------------------------------------------


-------------------------- Entity ----------------------------
-- maticový diplej 8x8
entity ledc8x8 is
	port (
		SMCLK : in std_logic; -- hlavní hodinový signál
		RESET : in std_logic; -- signál pro asynchonní inicializaci hodnot
		ROW : out std_logic_vector(0 to 7); -- signály pro výběr řádku matice
		LED : out std_logic_vector(0 to 7) -- signály pro výběr sloupce matice
	);
end ledc8x8;
--------------------------------------------------------------


-------------------------- Architektury ----------------------
-- behaviorální popis entity ledc8x8
architecture main of ledc8x8 is
	-- povolovací signál
	signal ce : std_logic := '0';
	-- signál pro čítač generující ce
	signal ce_cnt : std_logic_vector(7 downto 0) := (others => '0');
	-- signály posílané do ROW (10000000 = 1. řádek)
	signal rows_active : std_logic_vector(0 to 7) := "10000000";
	-- singály posílané do LED (11111111 = všechny LED jsou neaktivní)
	signal leds_active : std_logic_vector(0 to 7) := (others => '1');
begin
	-- čítač generující signál ce (dělení frekvence CLK/256)
	ce_gen: process(SMCLK, RESET)
	begin
		if RESET = '1' then
			ce_cnt <= (others => '0');
		elsif SMCLK'event and SMCLK = '1' then
			ce_cnt <= ce_cnt + 1;
		end if;
	end process ce_gen;
	ce <= '1' when ce_cnt = X"FF" else '0';


	-- výběr aktivních LED v řádku tak, aby se vytvořil obraz
	-- iniciálů DH
	leds_activate: process(rows_active)
	begin
		case rows_active is
			when "10000000" => leds_active <= "00111010";
			when "01000000" => leds_active <= "01011010";
			when "00100000" => leds_active <= "01011010";
			when "00010000" => leds_active <= "01011000";
			when "00001000" => leds_active <= "01011010";
			when "00000100" => leds_active <= "01011010";
			when "00000010" => leds_active <= "01011010";
			when "00000001" => leds_active <= "00111010";
			when others => leds_active <= (others => '1');
		end case;
	end process leds_activate;
	-- nastavení LED aktuálními signály leds_active
	LED <= leds_active;


	-- výběr řádku (postupně se prochází přes všechny řádky)
	rows_activate: process(SMCLK, RESET, ce)
	begin
		if RESET = '1' then
			rows_active <= "10000000";
		elsif SMCLK'event and SMCLK = '1' then
			if ce = '1' then
				rows_active <= rows_active(7) & rows_active(0 to 6);
			end if;
		end if;
	end process rows_activate;
	-- nastavení ROW aktuálními signály rows_active
	ROW <= rows_active;
end main;
--------------------------------------------------------------
