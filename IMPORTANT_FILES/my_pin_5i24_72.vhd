library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.IDROMConst.all;

package PIN_OWEN_5i20_72 is
	constant ModuleID : ModuleIDType :=( 
		(WatchDogTag,	x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,	WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,	x"00",	ClockLowTag,	x"03",	PortAddr&PadT,		IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(QcountTag,	x"02",	ClockLowTag,	x"04",	QcounterAddr&PadT,	QCounterNumRegs,		x"00",	QCounterMPBitMask),
		(PWMTag,	x"00",	ClockHighTag,	x"01",	PWMValAddr&PadT,	PWMNumRegs,			x"00",	PWMMPBitMask),
		(StepGenTag,	x"02",	ClockLowTag,	x"08",	StepGenRateAddr&PadT,		StepGenNumRegs,		x"00",	StepGenMPBitMask),
		(LEDTag,	x"00",	ClockLowTag,	x"01",	LEDAddr&PadT,	LEDNumRegs,				x"00",	LEDMPBitMask),
		(NullTag,	x"00",	NullTag,	x"00",	NullAddr&PadT,		x"00",					x"00",	x"00000000"),
		(NullTag,	x"00",	NullTag,	x"00",	NullAddr&PadT,		x"00",					x"00",	x"00000000"),
		(NullTag,	x"00",	NullTag,	x"00",	NullAddr&PadT,		x"00",					x"00",	x"00000000"),
		(NullTag,	x"00",	NullTag,	x"00",	NullAddr&PadT,		x"00",					x"00",	x"00000000"),
		(NullTag,	x"00",	NullTag,	x"00",	NullAddr&PadT,		x"00",					x"00",	x"00000000"),
		(NullTag,	x"00",	NullTag,	x"00",	NullAddr&PadT,		x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000")
		);
		
	
	
	constant PinDesc : PinDescType :=(
-- 	Base func  sec unit sec func 	 sec pin		

                -- this goes totally unused
		IOPortTag & x"03" & StepGenTag & x"81",	  -- UNUSED
		IOPortTag & x"03" & StepGenTag & x"82",   -- UNUSED
		IOPortTag & x"03" & StepGenTag & x"83",   -- UNUSED
		IOPortTag & x"03" & StepGenTag & x"84",   -- UNUSED
		IOPortTag & x"03" & StepGenTag & x"85",   -- UNUSED
		IOPortTag & x"03" & StepGenTag & x"86",   -- UNUSED
		IOPortTag & x"04" & StepGenTag & x"81",   -- UNUSED
		IOPortTag & x"04" & StepGenTag & x"82",   -- UNUSED
		IOPortTag & x"04" & StepGenTag & x"83",   -- UNUSED
		IOPortTag & x"04" & StepGenTag & x"84",   -- UNUSED
		IOPortTag & x"04" & StepGenTag & x"85",   -- UNUSED
		IOPortTag & x"04" & StepGenTag & x"86",   -- UNUSED
		IOPortTag & x"05" & StepGenTag & x"81",   -- UNUSED
		IOPortTag & x"05" & StepGenTag & x"82",   -- UNUSED
		IOPortTag & x"05" & StepGenTag & x"83",   -- UNUSED
		IOPortTag & x"05" & StepGenTag & x"84",   -- UNUSED
		IOPortTag & x"05" & StepGenTag & x"85",   -- UNUSED
		IOPortTag & x"05" & StepGenTag & x"86",   -- UNUSED
		IOPortTag & x"06" & StepGenTag & x"81",   -- UNUSED
		IOPortTag & x"06" & StepGenTag & x"82",   -- UNUSED
		IOPortTag & x"06" & StepGenTag & x"83",   -- UNUSED
		IOPortTag & x"06" & StepGenTag & x"84",   -- UNUSED
		IOPortTag & x"06" & StepGenTag & x"85",   -- UNUSED
		IOPortTag & x"06" & StepGenTag & x"86",   -- UNUSED

                -- config for port P3
		IOPortTag & x"00" & NullTag & NullPin,    -- 25
		IOPortTag & x"00" & NullTag & NullPin,    -- 26
		IOPortTag & x"07" & StepGenTag & x"81",   -- DUMMY - not used on board
		IOPortTag & x"07" & StepGenTag & x"82",   -- DUMMY
		IOPortTag & x"07" & StepGenTag & x"83",   -- DUMMY
		IOPortTag & x"00" & PWMTag & x"81",       -- 30 PWM
		IOPortTag & x"08" & NullTag & NullPin,    -- 31 GPIO
		IOPortTag & x"08" & NullTag & NullPin,    -- 32 GPIO
		IOPortTag & x"08" & NullTag & NullPin,    -- 33 GPIO
		IOPortTag & x"09" & NullTag & NullPin,    -- 34 GPIO
		IOPortTag & x"00" & StepGenTag & x"82",   -- 35 GX_DIR
		IOPortTag & x"00" & StepGenTag & x"81",   -- 36 GX_STP
		IOPortTag & x"01" & StepGenTag & x"82",	-- 37 GY_DIR
      IOPortTag & x"01" & StepGenTag & x"81",   -- 38 GY_STP
		IOPortTag & x"09" & NullTag & NullPin,    -- 39
		IOPortTag & x"09" & NullTag & NullPin,    -- 40
		IOPortTag & x"10" & NullTag & NullPin,    -- 41
		IOPortTag & x"10" & NullTag & NullPin,    -- 42
		IOPortTag & x"10" & NullTag & NullPin,    -- 43
		IOPortTag & x"11" & NullTag & NullPin,    -- 44
		IOPortTag & x"11" & NullTag & NullPin,    -- 45
		IOPortTag & x"11" & NullTag & NullPin,    -- 46
		IOPortTag & x"12" & NullTag & NullPin,    -- 47
		IOPortTag & x"12" & NullTag & NullPin,    -- 48

                -- config for port P1
		IOPortTag & x"00" & NullTag & NullPin,    -- 49
		IOPortTag & x"00" & NullTag & NullPin,    -- 50
		IOPortTag & x"00" & NullTag & NullPin,    -- 51
		IOPortTag & x"00" & NullTag & NullPin,	   -- 52
		IOPortTag & x"00" & NullTag & NullPin,    -- 53
		IOPortTag & x"00" & NullTag & NullPin,    -- 54
		IOPortTag & x"00" & NullTag & NullPin,    -- 55
		IOPortTag & x"00" & NullTag & NullPin,    -- 56
		IOPortTag & x"00" & NullTag & NullPin,    -- 57
		IOPortTag & x"00" & NullTag & NullPin,    -- 58
		IOPortTag & x"00" & NullTag & NullPin,    -- 59
		IOPortTag & x"00" & NullTag & NullPin,    -- 60
		IOPortTag & x"00" & NullTag & NullPin,    -- 61
		IOPortTag & x"00" & NullTag & NullPin,    -- 62
		IOPortTag & x"00" & NullTag & NullPin,    -- 63
		IOPortTag & x"00" & NullTag & NullPin,    -- 64
		IOPortTag & x"00" & NullTag & NullPin,	  -- 65
		IOPortTag & x"00" & NullTag & NullPin,    -- 66
		IOPortTag & x"00" & NullTag & NullPin,    -- 67
		IOPortTag & x"00" & NullTag & NullPin,    -- 68
		IOPortTag & x"00" & NullTag & NullPin,    -- 69
		IOPortTag & x"02" & StepGenTag & x"81",   -- 70 GZ_STP
		IOPortTag & x"02" & StepGenTag & x"82",   -- 71 GZ_DIR
		IOPortTag & x"00" & NullTag & NullPin,    -- 72

		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);					

end package PIN_OWEN_5i20_72;
