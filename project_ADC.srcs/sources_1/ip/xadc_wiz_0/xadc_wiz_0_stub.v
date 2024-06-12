// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Sun Jun  9 16:39:13 2024
// Host        : HIEHOM running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/76958/Desktop/vivadospace/project_ADC/project_ADC.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0_stub.v
// Design      : xadc_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module xadc_wiz_0(daddr_in, dclk_in, den_in, di_in, dwe_in, reset_in, 
  vauxp1, vauxn1, busy_out, channel_out, do_out, drdy_out, eoc_out, eos_out, alarm_out, vp_in, vn_in)
/* synthesis syn_black_box black_box_pad_pin="daddr_in[6:0],dclk_in,den_in,di_in[15:0],dwe_in,reset_in,vauxp1,vauxn1,busy_out,channel_out[4:0],do_out[15:0],drdy_out,eoc_out,eos_out,alarm_out,vp_in,vn_in" */;
  input [6:0]daddr_in;
  input dclk_in;
  input den_in;
  input [15:0]di_in;
  input dwe_in;
  input reset_in;
  input vauxp1;
  input vauxn1;
  output busy_out;
  output [4:0]channel_out;
  output [15:0]do_out;
  output drdy_out;
  output eoc_out;
  output eos_out;
  output alarm_out;
  input vp_in;
  input vn_in;
endmodule
