library std;
library ieee;
use ieee.std_logic_1164.all;

package components is

    component priority_encoder_4to2 is
        port(
            x : in  std_logic_vector(3 downto 0);
            y : out std_logic_vector(1 downto 0)
            );
    end component;

    component comparator3 is
    	port(
			x: in std_logic_vector(2 downto 0) ;
			y: in std_logic_vector(2 downto 0);
			equal_flag: out std_logic
			);
    end component;

     component comparator5 is
    	port(
			x: in std_logic_vector(4 downto 0) ;
			y: in std_logic_vector(4 downto 0);
			equal_flag: out std_logic
			);
    end component;
    component adder is
       port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
    end component;

--<<<<<<< HEAD
    component data_forwarding_block is
        port(
            source_reg_address: in std_logic_vector(2 downto 0) ;
            ex_RF_write: in std_logic ;
            ex_destination_reg_address: in std_logic_vector(2 downto 0) ;
            mem_RF_write: in std_logic ;
            mem_destination_reg_address: in std_logic_vector(2 downto 0) ;
            wb_RF_write: in std_logic ;
            wb_destination_reg_address: in std_logic_vector(2 downto 0) ;
            data_select: out std_logic_vector(2 downto 0)
            );
    end component;

    component HDU_Data is
        port(
            source_reg_address1: in std_logic_vector(2 downto 0);
            source_reg_address2: in std_logic_vector(2 downto 0);
            instruction_word: in std_logic_vector(15 downto 0);
            rr_mem_write: in std_logic;
            rr_z_en: in std_logic;
            rr_destination_reg_address: in std_logic_vector(2 downto 0);
            R7_en: out std_logic;
            IF_ID_en: out std_logic;
            NOP_mux_sel: out std_logic
        );
    end component;

    component HDU_Control is
        port(
            ID_R7d: in std_logic_vector(2 downto 0);
            RR_R7d: in std_logic_vector(2 downto 0);
            EX_R7d: in std_logic_vector(2 downto 0);
            MEM_R7d: in std_logic_vector(2 downto 0);
            PC_MUX1_sel: out std_logic;
            PC_MUX2_sel: out std_logic_vector(1 downto 0);
            flush_assign: out std_logic_vector(3 downto 0)
        );
    end component;


--=======
    component DataRegister is
        generic (data_width:integer);
        port (Din: in std_logic_vector(data_width-1 downto 0);
              Dout: out std_logic_vector(data_width-1 downto 0);
              clk, enable: in std_logic);
    end component;

    component mux_4to1 is
      port (
        input1: in std_logic_vector(15 downto 0) ;
        input2: in std_logic_vector(15 downto 0) ;
        input3: in std_logic_vector(15 downto 0) ;
        input0: in std_logic_vector(15 downto 0) ;
        output0: out std_logic_vector(15 downto 0) ;
        select_signal: in std_logic_vector(1 downto 0)
      ) ;
    end component ; -- mux_4to1
    component mux_2to1 is
      port (
        input1: in std_logic_vector(15 downto 0) ;
        input0: in std_logic_vector(15 downto 0) ;
        output0: out std_logic_vector(15 downto 0) ;
        select_signal: in std_logic
      ) ;
    end component ; -- mux_4to1
    component RF_decoder is
       port (x: in std_logic_vector(2 downto 0); y: out std_logic_vector(6 downto 0));
    end component;
    component shift7 is
       port(x: in std_logic_vector(8 downto 0);
        y: out std_logic_vector(15 downto 0));
    end component;
    component reg_file is
       port(A1: in std_logic_vector(2 downto 0);
        A2: in std_logic_vector(2 downto 0);
        A3: in std_logic_vector(2 downto 0);
        D3: in std_logic_vector(15 downto 0);
        D1: out std_logic_vector(15 downto 0);
        D2: out std_logic_vector(15 downto 0);
        clk,reset: in std_logic;
        --control signals
        RF_write: in std_logic
        --rout_0,rout_1,rout_2,rout_3,rout_4,rout_5,rout_6,rout_7: out std_logic_vector(15 downto 0)
        );
    end component;


-->>>>>>> 8df1c7e9c6625a725a0285da5631555be69d8172


end package;  -- components 
