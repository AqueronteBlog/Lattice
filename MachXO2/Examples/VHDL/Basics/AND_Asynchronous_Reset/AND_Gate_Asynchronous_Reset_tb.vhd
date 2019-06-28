
-- VHDL Test Bench Created from source file AND_Gate_Asynchronous_Reset.vhd -- Fri Jun 28 20:30:20 2019

--
-- Notes: 
-- 1) This testbench template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the unit under test.
-- Lattice recommends that these types always be used for the top-level
-- I/O of a design in order to guarantee that the testbench will bind
-- correctly to the timing (post-route) simulation model.
-- 2) To use this template as your testbench, change the filename to any
-- name of your choice with the extension .vhd, and use the "source->import"
-- menu in the ispLEVER Project Navigator to import the testbench.
-- Then edit the user defined section below, adding code to generate the 
-- stimulus for your design.
-- 3) VHDL simulations will produce errors if there are Lattice FPGA library 
-- elements in your design that require the instantiation of GSR, PUR, and
-- TSALL and they are not present in the testbench. For more information see
-- the How To section of online help.  
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

	COMPONENT AND_Gate_Asynchronous_Reset
	PORT(
		d : IN std_logic_vector(2 downto 0);
		reset : IN std_logic;
		clk : IN std_logic;          
		q : OUT std_logic
		);
	END COMPONENT;

	SIGNAL d :  std_logic_vector(2 downto 0);
	SIGNAL reset :  std_logic;
	SIGNAL clk :  std_logic;
	SIGNAL q :  std_logic;
	
	CONSTANT PERIOD : time := 20 ns;

BEGIN

-- Please check and add your generic clause manually
	uut: AND_Gate_Asynchronous_Reset PORT MAP(
		d => d,
		reset => reset,
		clk => clk,
		q => q
	);


-- *** Test Bench - User Defined Section ***
-- CLK process
CLK1:	PROCESS
BEGIN
	clk <= '1';
	WAIT FOR PERIOD/2;
	clk <= '0';
	WAIT FOR PERIOD/2;	
END PROCESS;

-- Testbench
tb: PROCESS
   BEGIN
      reset <= '1';
	  WAIT FOR 15 ns;
	  reset <= '0';
	  
	  LOOP
	  	d <= '00';
	  	WAIT FOR 40 ns;
	  	d <= '01';
	  	WAIT FOR 40 ns;
		d <= '10';
	  	WAIT FOR 40 ns;
		d <= '11';
	  	WAIT FOR 40 ns;
	  END LOOP;
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
