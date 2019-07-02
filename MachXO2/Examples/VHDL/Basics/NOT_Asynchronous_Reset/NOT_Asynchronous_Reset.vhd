-- @brief       NOT_Gate_Asynchronous_Reset.vhd
-- @details     This example describes a NOT gate with asynchronous Reset line.
--
--
-- @return      N/A
--
-- @author      Manuel Caballero
-- @date        02/July/2019
-- @version     02/July/2019    The ORIGIN
-- @pre         This firmware was tested on the Lattice MachXO2 7000HE breakout board with Lattice Diamond ( 3.10.3.144 )
-- @warning     N/A.
-- @pre         This code belongs to AqueronteBlog ( http://unbarquero.blogspot.com ).

LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY machxo2;
USE machxo2.all;

-- Entity
ENTITY NOT_Gate_Asynchronous_Reset IS
	PORT (
			d, reset, clk 	:	IN	STD_LOGIC;
			q				: 	OUT	STD_LOGIC
		  );
END ENTITY NOT_Gate_Asynchronous_Reset;

-- Architecture
ARCHITECTURE NOT_Gate of NOT_Gate_Asynchronous_Reset IS
SIGNAL aux_q : STD_LOGIC := '0';

-- NOT gate with Asynchronous Reset
BEGIN	  
NOT_Gate:	PROCESS(clk, reset)	
				BEGIN
					IF (reset = '1') THEN
						aux_q <= '0';
					ELSIF(clk'EVENT AND clk = '1') THEN
						aux_q <= NOT d;
					END IF;
			END PROCESS;
			
			-- Update the output
			q <= aux_q;
END ARCHITECTURE NOT_Gate;