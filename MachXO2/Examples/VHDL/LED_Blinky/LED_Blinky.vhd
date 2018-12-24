LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;

LIBRARY machxo2;
USE machxo2.all;


ENTITY LED_block IS
	PORT (
			reset	:	IN 	STD_LOGIC;
			led		: 	OUT	STD_LOGIC
		  );
END LED_block;

ARCHITECTURE LED1 of LED_block IS
	SIGNAL clk: STD_LOGIC;
	
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
      GENERIC MAP ( NOM_FREQ  => "53.20" )
      PORT MAP ( STDBY => '0', OSC => clk, SEDSTDBY => OPEN );
   PROCESS( clk, reset )
      VARIABLE count 		:   INTEGER RANGE 0 TO 25_000_000;
	  VARIABLE myLED_State 	:   STD_LOGIC	:= '0';
   BEGIN
	  IF ( reset <= '1' ) THEN
			count := 0;
			led <= '0';
      ELSIF( clk'EVENT AND clk = '1' ) THEN
         IF( count < 25_000_000 ) THEN
            count := count + 1;
         ELSE
            count := 0;
            led <= NOT myLED_State;
         END IF;
      END IF;
   END PROCESS;
END LED1;