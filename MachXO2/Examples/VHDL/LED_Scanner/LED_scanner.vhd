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
-- @version     17/March/2019    The ORIGIN
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
END LED_SCANNER_block;

-- Architecture
ARCHITECTURE LED of LED_SCANNER_block IS
	SIGNAL clk			: STD_LOGIC;
	SIGNAL shift_reg 	: STD_LOGIC_VECTOR (7 DOWNTO 0) := "10000000";
	SIGNAL state		: UNSIGNED(3 DOWNTO 0)			:= (OTHERS => '0');
	
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
		VARIABLE count :   INTEGER RANGE 0 TO LED_DELAY;
		BEGIN
			IF (reset = '1') THEN
				count 	:=	0;
				state   <=	TO_UNSIGNED(1,4);				-- state = 1 
			ELSIF(clk'EVENT AND clk = '1') THEN
				IF(count < LED_DELAY) THEN
					count := count + 1;
					state <= state;
				ELSE
					count := 0;	
					IF(state = TO_UNSIGNED(14,4)) THEN
						state   <=	TO_UNSIGNED(1,4);		-- state = 1
					ELSE
						state <= state + 1;					-- update the state
					END IF;
				END IF;
			END IF;
	END PROCESS;
   
-- Analyze the state    
	LED_State:	PROCESS(state)
		BEGIN
			CASE TO_INTEGER(state) IS
				WHEN 1		=> shift_reg <= "10000000";
				WHEN 2|14	=> shift_reg <= "01000000";
				WHEN 3|13	=> shift_reg <= "00100000";
				WHEN 4|12	=> shift_reg <= "00010000";
				WHEN 5|11	=> shift_reg <= "00001000";
				WHEN 6|10	=> shift_reg <= "00000100";
				WHEN 7|9	=> shift_reg <= "00000010";
				WHEN 8		=> shift_reg <= "00000001";
				WHEN OTHERS	=> shift_reg <= "00000000";
			END CASE;
	END PROCESS;
  
	leds_scanner   <= NOT shift_reg;						-- Update LEDs 
   
END ARCHITECTURE LED;