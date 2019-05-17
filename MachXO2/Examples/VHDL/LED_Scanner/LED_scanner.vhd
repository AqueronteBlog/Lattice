-- @brief       LED_Scanner.vhd
-- @details     This example shows how to make an LED scanner. While reset pin is 'HIGH',
--				all LEDs are off.
--
--				Internal oscillator is used at 2.08MHz.
--
--
--
-- @return      N/A
--
-- @author      Manuel Caballero
-- @date        17/March/2019
-- @version     23/March/2019    More generic code with a state machine.
--				17/March/2019    The ORIGIN
-- @pre         This firmware was tested on the Lattice MachXO2 7000HE breakout board with Lattice Diamond ( 3.10.3.144 )
-- @warning     N/A.
-- @pre         This code belongs to AqueronteBlog ( http://unbarquero.blogspot.com ). All rights reserved.

LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY machxo2;
USE machxo2.all;

-- Entity
ENTITY LED_SCANNER_block IS
	GENERIC (
			CONSTANT LED_DELAY : INTEGER := 208_000		-- Delay between LEDs ( 208000 * ( 1 / 2.08MHz ) = 100ms )
			);
		  
	PORT (
			reset			:	IN	STD_LOGIC;
			leds_scanner	: 	OUT	STD_LOGIC_VECTOR (7 downto 0)
		  );
END ENTITY LED_SCANNER_block;

-- Architecture
ARCHITECTURE LED of LED_SCANNER_block IS
	SIGNAL clk			: STD_LOGIC;
	SIGNAL shift_reg 	: STD_LOGIC_VECTOR (7 DOWNTO 0) := "10000000";
	TYPE state_LEDs IS 	 (S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14);  	-- Define the states for LEDs
	SIGNAL state 		: state_LEDs;    													-- Create a signal that uses those states
	
	--internal oscillator
   COMPONENT OSCH
      GENERIC (
				NOM_FREQ: STRING := "2.08"
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
      GENERIC MAP (NOM_FREQ  => "2.08")
      PORT MAP (STDBY => '0', OSC => clk, SEDSTDBY => OPEN);

-- Generate a delay ( 208000 * ( 1 / 2.08MHz ) = 100ms ) and analyze the reset pin	  
	LED_Divider:	PROCESS(clk, reset)
		VARIABLE count :   INTEGER RANGE 0 TO LED_DELAY := 0;
		BEGIN
			IF (reset = '1') THEN
				count 	:=	0;
				state   <=	S1;				-- state = 1 
			ELSIF(clk'EVENT AND clk = '1') THEN
				IF(count < LED_DELAY) THEN
					count := count + 1;
					state <= state;
				ELSE
					count := 0;	
					-- State machine for the LEDs (S1 -> LED1, S2 -> LED2, and so on)
					CASE state IS
						WHEN S1		=> state <= S2;
						WHEN S2		=> state <= S3;
						WHEN S3		=> state <= S4;
						WHEN S4		=> state <= S5;
						WHEN S5		=> state <= S6;
						WHEN S6		=> state <= S7;
						WHEN S7		=> state <= S8;
						WHEN S8		=> state <= S9;
						WHEN S9		=> state <= S10;
						WHEN S10	=> state <= S11;
						WHEN S11	=> state <= S12;
						WHEN S12	=> state <= S13;
						WHEN S13	=> state <= S14;
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
				WHEN S2|S14	=> shift_reg <= "01000000";		-- Only LED2 ON
				WHEN S3|S13	=> shift_reg <= "00100000";		-- Only LED3 ON
				WHEN S4|S12	=> shift_reg <= "00010000";		-- Only LED4 ON
				WHEN S5|S11	=> shift_reg <= "00001000";		-- Only LED5 ON
				WHEN S6|S10	=> shift_reg <= "00000100";		-- Only LED6 ON
				WHEN S7|S9	=> shift_reg <= "00000010";		-- Only LED7 ON
				WHEN S8		=> shift_reg <= "00000001";		-- Only LED8 ON
				WHEN OTHERS	=> shift_reg <= "00000000";		-- All LEDs OFF
			END CASE;
	END PROCESS;
  
	leds_scanner   <= NOT shift_reg;						-- Update LEDs 
   
END ARCHITECTURE LED;