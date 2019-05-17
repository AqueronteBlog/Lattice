-- @brief       LED_Blinky.vhd
-- @details     This example shows how to make an LED blink ( LED1 ) every ~0.5 second. While reset pin is 'HIGH',
--				all LEDs are off.
--
--				Internal oscillator is used at 53.20MHz.
--
--
--
-- @return      N/A
--
-- @author      Manuel Caballero
-- @date        26/December/2018
-- @version     3/April/2019	    Code was improved
---				26/December/2018    The ORIGIN
-- @pre         This firmware was tested on the Lattice MachXO2 7000HE breakout board with Lattice Diamond ( 3.10.3.144 )
-- @warning     N/A.
-- @pre         This code belongs to AqueronteBlog ( http://unbarquero.blogspot.com ). All rights reserved.

LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY machxo2;
USE machxo2.all;


ENTITY LED_block IS
	GENERIC (
			CONSTANT LED_DELAY : INTEGER := 25_000_000		-- Delay between LEDs ( 25000000 * ( 1 / 53.20MHz ) = 469.92ms )
			);
		  
	PORT (
			reset			:	IN	STD_LOGIC;
			leds_bar		: 	OUT	STD_LOGIC_VECTOR (7 downto 0)
		  );
END LED_block;

ARCHITECTURE LED of LED_block IS
	SIGNAL clk			: STD_LOGIC;
	SIGNAL shift_reg 	: STD_LOGIC_VECTOR (7 DOWNTO 0) := "10000000";
	TYPE state_LEDs IS 	 (S1, S2 );  									-- Define the states for LEDs
	SIGNAL state 		: state_LEDs; 
	
	--internal oscillator
   COMPONENT OSCH
      GENERIC (
            NOM_FREQ: STRING := "53.20"
			  );
      PORT( 
            STDBY    : IN  STD_LOGIC;
            OSC      : OUT STD_LOGIC;
            SEDSTDBY : OUT STD_LOGIC
		   );
   END COMPONENT;
BEGIN
	--internal oscillator
   OSCInst0: OSCH
      GENERIC MAP (NOM_FREQ  => "53.20")
      PORT MAP (STDBY => '0', OSC => clk, SEDSTDBY => OPEN);
	  
	-- Generate a delay ( 25000000 * ( 1 / 53.20MHz ) = 469.92ms ) and analyze the reset pin	  
	LED_Divider: PROCESS(clk, reset)
		VARIABLE count :   INTEGER RANGE 0 TO LED_DELAY := 0;
		BEGIN
		IF (reset = '1') THEN
			count 	:=	0;
			state   <=	S1;									-- state = S1 
		ELSIF(clk'EVENT AND clk = '1') THEN
			IF(count < LED_DELAY) THEN
				count := count + 1;
				state <= state;
			ELSE
				count := 0;	
				-- State machine for the LEDs (S1 -> LED1, S2 -> LED2, and so on)
				CASE state IS
					WHEN S1		=> state <= S2;
					WHEN S2		=> state <= S1;
					WHEN OTHERS	=> state <= S1;
				END CASE;
			END IF;
		END IF;
	END PROCESS;

	-- Analyze the state    
	LED_State:	PROCESS(state)
		BEGIN
			CASE state IS
				WHEN S1		=> shift_reg <= "10000000";		-- Only LED1 ON
				WHEN OTHERS	=> shift_reg <= "00000000";		-- All LEDs OFF
			END CASE;
	END PROCESS;
  
	leds_bar   <= NOT shift_reg;							-- Update LEDs 
END ARCHITECTURE LED;