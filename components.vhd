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

    component generic_mux_2to1 is
    generic(data_width:integer);
          port (
            input1: in std_logic_vector(data_width-1 downto 0) ;        --selct is '1'
            input0: in std_logic_vector(data_width-1 downto 0) ;        --selct is '0'
            output0: out std_logic_vector(data_width-1 downto 0) ;
            select_signal: in std_logic
                ) ; 
    end component ; -- mux_4to1

    component mux_4to1 is
      port (
        input0: in std_logic_vector(15 downto 0) ;
        input1: in std_logic_vector(15 downto 0) ;
        input2: in std_logic_vector(15 downto 0) ;
        input3: in std_logic_vector(15 downto 0) ;
        output0: out std_logic_vector(15 downto 0) ;
        select_signal: in std_logic_vector(1 downto 0)
      ) ;
    end component ; -- mux_4to1
    component mux_2to1 is
      port (
        input0: in std_logic_vector(15 downto 0) ;
        input1: in std_logic_vector(15 downto 0) ;
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

    component adder is
        port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
    end component;
    component xorer is
       port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
    end component;
    component nander is
       port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
    end component;


    component sign_ext6 is
       port(x: in std_logic_vector(5 downto 0);
        y: out std_logic_vector(15 downto 0));
    end component;

   component sign_ext9 is
       port(x: in std_logic_vector(8 downto 0);
        y: out std_logic_vector(15 downto 0));
    end component;

    component Decoder is
    port(
        instruction_word: in std_logic_vector(15 downto 0);
        control_word: out std_logic_vector(19 downto 0); 
        Rs1: out std_logic_vector(2 downto 0); 
        Rs2: out std_logic_vector(2 downto 0); 
        Rd: out std_logic_vector(2 downto 0)
    );
    end component;

    component special_pe is
   port(input0: in std_logic_vector(7 downto 0);
        input_sel,clk: in std_logic;

    output0: out std_logic_vector(7 downto 0);
    Rsel: out std_logic_vector(2 downto 0);
    flag: out std_logic);
    end component;

    component alu is
        port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0);
                carry,zero: out std_logic;
                --control signals
                op_code:in std_logic_vector(1 downto 0));
    end component;

    component bram is
        port (clk : in std_logic;
            address : in std_logic_vector(15 downto 0);
            we : in std_logic;
            data_i : in std_logic_vector(15 downto 0);
            data_o : out std_logic_vector(15 downto 0)
         );
    end component;


    component I_Fetch is 
        port(
            PC_MUX2_sel: in std_logic; --select signal for 2to1 MUX
            PC_MUX1_sel: in std_logic_vector(1 downto 0); --select signal of 4to1 MUX
            R7_ID: in std_logic_vector(15 downto 0);
            R7_RR: in std_logic_vector(15 downto 0);
            R7_EX: in std_logic_vector(15 downto 0);
            R7_MEM: in std_logic_vector(15 downto 0);
            PC_plus1: out std_logic_vector(15 downto 0);
            PC: out std_logic_vector(15 downto 0);
            IW: out std_logic_vector(15 downto 0);
            clk: in std_logic;
            reset: in std_logic
            );
    end component;


    component EX is    
        port(
            Rs1, Rs2: in std_logic_vector(15 downto 0);
            SE_6: in std_logic_vector(15 downto 0);
            alu_a_sel, alu_b_sel: in std_logic;
            alu_op: in std_logic_vector(1 downto 0);
            alu_out: out std_logic_vector(15 downto 0);
            flag_out: out std_logic_vector(1 downto 0);
            clk: in std_logic;
            reset: in std_logic
            );
    end component;


    component MEM is 
        port(
            Rs1: in std_logic_vector(15 downto 0);
            mem_address_sel: in std_logic;
            RA_plus_n: in std_logic_vector(15 downto 0); --for LM, SM
            alu_out: in std_logic_vector(15 downto 0);
            mem_write: in std_logic;
            mem_out: out std_logic;
            clk: in std_logic;
            reset: in std_logic
            );
    end component;

    component WB is 
        port(
            Rd: in std_logic_vector(2 downto 0);
            wb_address_sel: in std_logic_vector(1 downto 0);
            mem_out: in std_logic_vector(15 downto 0); --for LM, SM
            alu_out: in std_logic_vector(15 downto 0); --arithmetic instructions
            shifter_out: in std_logic_vector(15 downto 0);
            flag_out: in std_logic_vector(1 downto 0);
            RF_write: in std_logic;
            flag_write: in std_logic;
            clk: in std_logic;
            reset: in std_logic
        );
    end component;

    component staller is
        port(
            control_word: in std_logic_vector(19 downto 0) ;        
            control_word_for_stall: out std_logic_vector(19 downto 0)   
        );
    end component; 

    component NOP_mux is
        port (
            control_word: in std_logic_vector(19 downto 0) ;  --select is '1', input1 
            control_word_for_stall: in std_logic_vector(19 downto 0); --select is '0', input0 
            pipelined_control_word : out std_logic_vector(14 downto 0); 
            NOP_mux_sel : in std_logic  
        ) ;
    end component; 

-->>>>>>> 8df1c7e9c6625a725a0285da5631555be69d8172


end package;  -- components 
