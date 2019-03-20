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


ENTITY LED_SCANNER_block IS
	PORT (
			reset			:	IN	STD_LOGIC;
			leds_scanner	: 	OUT	STD_LOGIC_VECTOR (7 downto 0)
		  );
END LED_SCANNER_block;

ARCHITECTURE LED of LED_SCANNER_block IS
	SIGNAL clk			: STD_LOGIC;
	signal shift_reg 	: STD_LOGIC_VECTOR (7 DOWNTO 0) := "10000000";
	
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
   PROCESS(clk, reset)
      VARIABLE count :   INTEGER RANGE 0 TO 416_000;
   BEGIN
      IF (reset = '1') THEN
		count 		:=	0;
		shift_reg   <=	"10000000";					-- LED1 on, rest off 
	  ELSIF(clk'EVENT AND clk = '1') THEN
         IF(count < 416_000) THEN
            count := count + 1;
         ELSE
            count := 0;				
         END IF;
      END IF;
   END PROCESS;
  
   leds_scanner   <= shift_reg;						-- Update LEDs 
   
END LED;