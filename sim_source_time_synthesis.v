`timescale 1 ps / 1 ps
`define XIL_TIMING

module IOBUF_UNIQ_BASE_
   (IO,
    O,
    I,
    T);
  inout IO;
  output O;
  input I;
  input T;

  wire I;
  wire IO;
  wire O;
  wire T;

  IBUF IBUF
       (.I(IO),
        .O(O));
  OBUFT OBUFT
       (.I(I),
        .O(IO),
        .T(T));
endmodule

(* NotValidForBitStream *)
module I2Cpwm
   (clk,
    sda_in,
    reset,
    scl_in,
    pwm_out,
    sda,
    dat,
    scl);
  input clk;
  inout sda_in;
  input reset;
  input scl_in;
  output pwm_out;
  inout sda;
  inout [7:0]dat;
  inout scl;

  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [7:0]dat;
  wire [7:0]dat_IBUF;
  wire pwm_out;
  wire reset;
  wire reset_IBUF;
  wire scl;
  wire scl_OBUF;
  wire scl_i_1_n_0;
  wire scl_in;
  wire scl_in_IBUF;
  wire scl_prev;
  wire scl_prev_i_1_n_0;
  wire sda;
  wire sda_OBUF;
  wire sda_i_1_n_0;
  wire sda_in;
  wire sda_in_IBUF;
  wire sda_in_IOBUF_inst_i_2_n_0;
  wire sda_in_IOBUF_inst_i_3_n_0;
  wire sda_in_IOBUF_inst_i_4_n_0;
  wire sda_in_TRI;
  wire sda_prev;
  wire sda_prev_i_1_n_0;
  wire \t1[0]_i_1_n_0 ;
  wire \t1[1]_i_1_n_0 ;
  wire \t1[2]_i_1_n_0 ;
  wire \t1_reg_n_0_[0] ;
  wire \t1_reg_n_0_[1] ;
  wire \t1_reg_n_0_[2] ;
  wire \t2[0]_i_1_n_0 ;
  wire \t2[1]_i_1_n_0 ;
  wire \t2[2]_i_1_n_0 ;
  wire \t2_reg_n_0_[0] ;
  wire \t2_reg_n_0_[1] ;
  wire \t2_reg_n_0_[2] ;

initial begin
 $sdf_annotate("asdas_time_synth.sdf",,,,"tool_control");
end
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF \dat_OBUF[0]_inst 
       (.I(dat_IBUF[0]),
        .O(dat[0]));
  OBUF \dat_OBUF[1]_inst 
       (.I(dat_IBUF[1]),
        .O(dat[1]));
  OBUF \dat_OBUF[2]_inst 
       (.I(dat_IBUF[2]),
        .O(dat[2]));
  OBUF \dat_OBUF[3]_inst 
       (.I(dat_IBUF[3]),
        .O(dat[3]));
  OBUF \dat_OBUF[4]_inst 
       (.I(dat_IBUF[4]),
        .O(dat[4]));
  OBUF \dat_OBUF[5]_inst 
       (.I(dat_IBUF[5]),
        .O(dat[5]));
  OBUF \dat_OBUF[6]_inst 
       (.I(dat_IBUF[6]),
        .O(dat[6]));
  OBUF \dat_OBUF[7]_inst 
       (.I(dat_IBUF[7]),
        .O(dat[7]));
  FDRE #(
    .INIT(1'b0)) 
    \dat_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(1'b0),
        .Q(dat_IBUF[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dat_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(1'b0),
        .Q(dat_IBUF[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dat_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(1'b0),
        .Q(dat_IBUF[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dat_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(1'b0),
        .Q(dat_IBUF[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dat_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(1'b0),
        .Q(dat_IBUF[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dat_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(1'b0),
        .Q(dat_IBUF[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dat_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(1'b0),
        .Q(dat_IBUF[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dat_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(1'b0),
        .Q(dat_IBUF[7]),
        .R(1'b0));
  OBUFT pwm_out_OBUF_inst
       (.I(1'b0),
        .O(pwm_out),
        .T(1'b1));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  OBUF scl_OBUF_inst
       (.I(scl_OBUF),
        .O(scl));
  LUT6 #(
    .INIT(64'h0000000090909000)) 
    scl_i_1
       (.I0(scl_in_IBUF),
        .I1(scl_prev),
        .I2(\t2_reg_n_0_[2] ),
        .I3(\t2_reg_n_0_[0] ),
        .I4(\t2_reg_n_0_[1] ),
        .I5(reset_IBUF),
        .O(scl_i_1_n_0));
  IBUF scl_in_IBUF_inst
       (.I(scl_in),
        .O(scl_in_IBUF));
  LUT3 #(
    .INIT(8'h14)) 
    scl_prev_i_1
       (.I0(reset_IBUF),
        .I1(scl_in_IBUF),
        .I2(scl_prev),
        .O(scl_prev_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    scl_prev_reg
       (.C(clk_IBUF_BUFG),
        .CE(scl_prev_i_1_n_0),
        .D(scl_in_IBUF),
        .Q(scl_prev),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    scl_reg
       (.C(clk_IBUF_BUFG),
        .CE(scl_i_1_n_0),
        .D(scl_prev),
        .Q(scl_OBUF),
        .R(1'b0));
  OBUF sda_OBUF_inst
       (.I(sda_OBUF),
        .O(sda));
  LUT6 #(
    .INIT(64'h0000000090909000)) 
    sda_i_1
       (.I0(sda_prev),
        .I1(sda_in_IBUF),
        .I2(\t1_reg_n_0_[2] ),
        .I3(\t1_reg_n_0_[0] ),
        .I4(\t1_reg_n_0_[1] ),
        .I5(reset_IBUF),
        .O(sda_i_1_n_0));
  IOBUF_UNIQ_BASE_ sda_in_IOBUF_inst
       (.I(1'b0),
        .IO(sda_in),
        .O(sda_in_IBUF),
        .T(sda_in_TRI));
  FDRE #(
    .INIT(1'b0)) 
    sda_in_IOBUF_inst_i_1
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sda_in_IOBUF_inst_i_2_n_0),
        .Q(sda_in_TRI),
        .R(1'b0));
  LUT1 #(
    .INIT(2'h1)) 
    sda_in_IOBUF_inst_i_2
       (.I0(sda_in_IOBUF_inst_i_3_n_0),
        .O(sda_in_IOBUF_inst_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    sda_in_IOBUF_inst_i_3
       (.I0(reset_IBUF),
        .I1(sda_in_IOBUF_inst_i_4_n_0),
        .O(sda_in_IOBUF_inst_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    sda_in_IOBUF_inst_i_4
       (.I0(sda_in_TRI),
        .O(sda_in_IOBUF_inst_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    sda_prev_i_1
       (.I0(sda_prev),
        .I1(sda_in_IBUF),
        .I2(reset_IBUF),
        .O(sda_prev_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    sda_prev_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sda_prev_i_1_n_0),
        .Q(sda_prev),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    sda_reg
       (.C(clk_IBUF_BUFG),
        .CE(sda_i_1_n_0),
        .D(sda_prev),
        .Q(sda_OBUF),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hF0F00009F0F00909)) 
    \t1[0]_i_1 
       (.I0(sda_prev),
        .I1(sda_in_IBUF),
        .I2(reset_IBUF),
        .I3(\t1_reg_n_0_[1] ),
        .I4(\t1_reg_n_0_[0] ),
        .I5(\t1_reg_n_0_[2] ),
        .O(\t1[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF000F000F009F900)) 
    \t1[1]_i_1 
       (.I0(sda_prev),
        .I1(sda_in_IBUF),
        .I2(reset_IBUF),
        .I3(\t1_reg_n_0_[1] ),
        .I4(\t1_reg_n_0_[0] ),
        .I5(\t1_reg_n_0_[2] ),
        .O(\t1[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0F0F0F909000000)) 
    \t1[2]_i_1 
       (.I0(sda_prev),
        .I1(sda_in_IBUF),
        .I2(reset_IBUF),
        .I3(\t1_reg_n_0_[1] ),
        .I4(\t1_reg_n_0_[0] ),
        .I5(\t1_reg_n_0_[2] ),
        .O(\t1[2]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \t1_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\t1[0]_i_1_n_0 ),
        .Q(\t1_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \t1_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\t1[1]_i_1_n_0 ),
        .Q(\t1_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \t1_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\t1[2]_i_1_n_0 ),
        .Q(\t1_reg_n_0_[2] ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hA1A5A0A0A0A0A1A5)) 
    \t2[0]_i_1 
       (.I0(reset_IBUF),
        .I1(\t2_reg_n_0_[1] ),
        .I2(\t2_reg_n_0_[0] ),
        .I3(\t2_reg_n_0_[2] ),
        .I4(scl_in_IBUF),
        .I5(scl_prev),
        .O(\t2[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h889C88888888889C)) 
    \t2[1]_i_1 
       (.I0(reset_IBUF),
        .I1(\t2_reg_n_0_[1] ),
        .I2(\t2_reg_n_0_[0] ),
        .I3(\t2_reg_n_0_[2] ),
        .I4(scl_in_IBUF),
        .I5(scl_prev),
        .O(\t2[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAB40AA00AA00AB40)) 
    \t2[2]_i_1 
       (.I0(reset_IBUF),
        .I1(\t2_reg_n_0_[1] ),
        .I2(\t2_reg_n_0_[0] ),
        .I3(\t2_reg_n_0_[2] ),
        .I4(scl_in_IBUF),
        .I5(scl_prev),
        .O(\t2[2]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \t2_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\t2[0]_i_1_n_0 ),
        .Q(\t2_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \t2_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\t2[1]_i_1_n_0 ),
        .Q(\t2_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \t2_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\t2[2]_i_1_n_0 ),
        .Q(\t2_reg_n_0_[2] ),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
