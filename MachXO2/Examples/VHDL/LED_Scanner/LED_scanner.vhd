-- @brief       LED_Scanner.vhd
-- @details     [TODO] This example shows how to make an LED blink every 0.5 second. While reset pin is 'HIGH',
--				all LEDs are off.
--
--				Internal oscillator is used at 53.20MHz.
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

LIBRARY machxo2;
USE machxo2.all;


ENTITY LED_block IS
	PORT (
			reset	:	IN		STD_LOGIC;
			led0	: 	BUFFER	STD_LOGIC;
			led1	: 	BUFFER	STD_LOGIC;
			led2	: 	BUFFER	STD_LOGIC;
			led3	: 	BUFFER	STD_LOGIC;
			led4	: 	BUFFER	STD_LOGIC;
			led5	: 	BUFFER	STD_LOGIC;
			led6	: 	BUFFER	STD_LOGIC;
			led7	: 	BUFFER	STD_LOGIC
		  );
END LED_block;

ARCHITECTURE LED of LED_block IS
	SIGNAL clk		: STD_LOGIC;
	
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
   PROCESS(clk, reset)
      VARIABLE count :   INTEGER RANGE 0 TO 25_000_000;
   BEGIN
      IF (reset = '1') THEN
		count :=  0;
		led0   <= '1';							-- LED0 off
		led1   <= '1';							-- LED1 off
		led2   <= '1';							-- LED2 off
		led3   <= '1';							-- LED3 off
		led4   <= '1';							-- LED4 off
		led5   <= '1';							-- LED5 off
		led6   <= '1';							-- LED6 off
		led7   <= '1';							-- LED7 off 
	  ELSIF(clk'EVENT AND clk = '1') THEN
         IF(count < 25_000_000) THEN
            count := count + 1;
         ELSE
            count := 0;
            led7 <= NOT led7;					-- Change LED7 state				
         END IF;
      END IF;
   END PROCESS;
END LED;