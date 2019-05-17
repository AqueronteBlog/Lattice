-- @brief       LED_Scanner_tb.vhd
-- @details     Testbench for LED_Scanner file.
--
--
--
-- @return      N/A
--
-- @author      Manuel Caballero
-- @date        24/March/2019
-- @version     24/March/2019    The ORIGIN
-- @pre         This firmware was tested on the Lattice MachXO2 7000HE breakout board with Lattice Diamond ( 3.10.3.144 )
-- @warning     N/A.
-- @pre         This code belongs to AqueronteBlog ( http://unbarquero.blogspot.com ). All rights reserved.

LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY machxo2;
USE machxo2.all;

-- Testbench entity
ENTITY LED_Scanner_tb IS
END LED_Scanner_tb;

-- Testbench architecture
ARCHITECTURE test of LED_Scanner_tb IS
	CONSTANT 	myDelay : INTEGER := 208_000;
	SIGNAL 		myReset : STD_LOGIC;
	SIGNAL 		myLEDs  : STD_LOGIC_VECTOR (7 downto 0);
	
BEGIN
	LED_SCANNER :	ENTITY WORK.LED_SCANNER_block
					GENERIC MAP
					(
						LED_DELAY => myDelay
					)
					PORT MAP
					(
						reset 		 => myReset,
						leds_scanner => myLEDs
					);
	
	SIMULATION : PROCESS
	BEGIN
		-- [TODO] Complete the simulation part
	END PROCESS SIMULATION;
END ARCHITECTURE test;