-- @brief       AND_Device_Asynchronous_Reset.vhd
-- @details     This example describes an AND device with asynchronous Reset line.
--
--				Internal oscillator is used at 2.08MHz.
--
--
--
-- @return      N/A
--
-- @author      Manuel Caballero
-- @date        28/June/2019
-- @version     28/June/2019    The ORIGIN
-- @pre         This firmware was tested on the Lattice MachXO2 7000HE breakout board with Lattice Diamond ( 3.10.3.144 )
-- @warning     N/A.
-- @pre         This code belongs to AqueronteBlog ( http://unbarquero.blogspot.com ).

LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY machxo2;
USE machxo2.all;

-- Entity
ENTITY AND_Gate_Asynchronous_Reset IS
	GENERIC (
			CONSTANT INPUT_LINES : INTEGER := 2		-- Number of input lines
			);
	
	PORT (
			d			: 	IN	STD_LOGIC_VECTOR ((INPUT_LINES - 1) DOWNTO 0); 
			reset, clk 	:	IN	STD_LOGIC;
			q			: 	OUT	STD_LOGIC
		  );
END ENTITY AND_Gate_Asynchronous_Reset;

-- Architecture
ARCHITECTURE AND_Gate of AND_Gate_Asynchronous_Reset IS
	--SIGNAL aux_q : STD_LOGIC := '0';

-- AND gate with Asynchronous Reset
BEGIN	  
AND_Gate:	PROCESS(clk, reset)	
				VARIABLE aux_q : STD_LOGIC := '0';
				BEGIN
					IF (reset = '1') THEN
						aux_q := '0';
					ELSIF(clk'EVENT AND clk = '1') THEN
						aux_q := d(0);
						FOR I IN 1 TO ( INPUT_LINES - 1 ) LOOP
							aux_q := aux_q AND d(I); 
						END LOOP;
					END IF;
				q  <= aux_q;
			END PROCESS;
	
			-- Update output
			--q  <= aux_q;
   
END ARCHITECTURE AND_Gate;