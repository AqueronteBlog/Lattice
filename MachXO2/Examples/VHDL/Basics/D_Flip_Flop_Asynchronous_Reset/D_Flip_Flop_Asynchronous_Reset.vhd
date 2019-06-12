-- @brief       D_Flip_Flop_Asynchronous_Reset.vhd
-- @details     [TODO]This example shows how to make an LED scanner. While reset pin is 'HIGH',
--				all LEDs are off.
--
--				Internal oscillator is used at 2.08MHz.
--
--
--
-- @return      N/A
--
-- @author      Manuel Caballero
-- @date        11/June/2019
-- @version     11/June/2019    The ORIGIN
-- @pre         This firmware was tested on the Lattice MachXO2 7000HE breakout board with Lattice Diamond ( 3.10.3.144 )
-- @warning     N/A.
-- @pre         This code belongs to AqueronteBlog ( http://unbarquero.blogspot.com ).

LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY machxo2;
USE machxo2.all;

-- Entity
ENTITY D_Flip_Flop_Asynchronous_Reset IS
	PORT (
			d, reset, clk 	:	IN	STD_LOGIC;
			q, nq			: 	OUT	STD_LOGIC
		  );
END ENTITY D_Flip_Flop_Asynchronous_Reset;

-- Architecture
ARCHITECTURE D_FLIP_FLOP of D_Flip_Flop_Asynchronous_Reset IS
	SIGNAL aux_d : STD_LOGIC := '0';

BEGIN	  
D_FF:	PROCESS(clk, reset)
			BEGIN
				IF (reset = '1') THEN
					aux_d <= '0';
				ELSIF(clk'EVENT AND clk = '1') THEN
					aux_d <= d;
				END IF;
		END PROCESS;
	
	-- Update outputs
	q  <= aux_d;
	nq <= NOT aux_d;
   
END ARCHITECTURE D_FLIP_FLOP;