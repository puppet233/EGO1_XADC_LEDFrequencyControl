module ADC(
    input clk,
    input rst,
    input [15:0] sw,         
    output[15:0] led,
    output [7:0] seg,
    output [7:0] an,
    input  vauxp1,
    input  vauxn1
    );  
        reg[7:0] ledtemp = 3'b001;
        reg[27:0] divclk_cnt = 0;      //分频计数值
        reg[15:0] divclk_cnt_1k = 0;      //分频计数值
                reg divclk_1k = 0; 
        reg divclk = 0; 
        reg [7:0] seg=0;
        reg [3:0] an=4'b0001;          //位码
            reg [2:0] cnt = 3'b000; 
            reg [1:0] disp_bit=2'b00;
        reg [3:0] disp_dat=0;          //要显示的数据    
        reg[27:0] maxcnt1 = 0; 
        reg [31:0] seg1=32'h40070676;
        reg [31:0] temp = 0;  
        parameter maxcnt=50000000;   
        parameter    
                       seg_0 = 8'h3f, 
                       seg_1 = 8'h06, 
                       seg_2 = 8'h5b,              
                       seg_3 = 8'h4f,
                       seg_4 = 8'h66,
                       seg_5 = 8'h6d,
                       seg_6 = 8'h7d,
                       seg_7 = 8'h07, 
                       seg_8 = 8'h7f,
                       seg_9 = 8'h6f;
        
wire analog_pos_in, analog_neg_in;
assign analog_pos_in = vauxp1;
assign analog_neg_in = vauxn1;

wire [15:0] do_out;  
// ADC value;高12位输出

wire [4 : 0] channel_out;
// assign led[4:0] = channel_out;

wire eoc_out;

xadc_wiz_0 ADC (
  //.di_in(di_in),              // input wire [15 : 0] di_in
  .daddr_in({2'b0,channel_out}),        // input wire [6 : 0] daddr_in
  .den_in(eoc_out),            // input wire den_in
  .dwe_in(1'b0),            // input wire dwe_in
  //.drdy_out(drdy_out),        // output wire drdy_out
  .do_out(do_out),            // output wire [15 : 0] do_out
  .dclk_in(clk),          // input wire dclk_in
  .reset_in(~rst),        // input wire reset_in

  .vauxp1(analog_pos_in),            
  .vauxn1(analog_neg_in),              
 
  .channel_out(channel_out),  
  .eoc_out(eoc_out),          // output wire eoc_out
  .alarm_out(),      // output wire alarm_out
  .eos_out(led[3]),         // output wire eos_out
 
  .busy_out()        // output wire busy_out
);



wire [12:0] adcx_data;
assign adcx_data =  do_out[15:4];
assign led[15:4] = adcx_data;

     always @ (clk)
        begin
            if(adcx_data>12'b111001100110)//3686 i.e. 900mv
                            begin  
                            maxcnt1 = 50000000;
                            end
                        else if(12'b110011001101 <adcx_data&&adcx_data<12'b111001100110)//2048 500mv
                            begin

                            maxcnt1 = 45000000;
                            end
                        else if(12'b101100110011 <adcx_data&&adcx_data<12'b110011001101)
                            begin
                            
                            maxcnt1 = 40000000;
                            end
                        else if(12'b100110011001 <adcx_data&&adcx_data<12'b101100110011)
                            begin
                            
                            maxcnt1 = 35000000;
                            end
                        else if(12'b100000000000 <adcx_data&&adcx_data<12'b100110011001)
                            begin
                            
                            maxcnt1 = 30000000;
                            end      
                        else if(12'b011001110000 <adcx_data&&adcx_data<12'b100000000000)
                            begin
                           
                            maxcnt1 = 25000000;
                            end
                        else if(12'b010011001101 <adcx_data&&adcx_data<12'b011001110000)
                            begin
                            
                            maxcnt1 = 20000000;
                            end
                        else if(12'b001100110011 <adcx_data&&adcx_data<12'b010011001101)
                            begin
                                
                            maxcnt1 = 15000000;
                            end                 
                        else if(12'b000110011010 <adcx_data&&adcx_data<12'b001100110011)
                            begin
                             
                            maxcnt1 = 10000000;  
                            end
                        else
                            begin
                            
                            maxcnt1 = 5000000;
                            end
        end
         always@(posedge clk) 
                      begin
                          if(divclk_cnt==maxcnt1)
                          begin
                              divclk =~ divclk;
                              divclk_cnt = 0;
                          end
                          else
                          begin
                               divclk_cnt = divclk_cnt+1'b1;
                          end
                      end
         always@(posedge clk) //1000hz 100000div
              begin
                  if(divclk_cnt_1k==50000)
              begin
                 divclk_1k =~ divclk_1k;
                 
                 divclk_cnt_1k = 0;
              end
              
                else
                
                  begin
                  
                divclk_cnt_1k = divclk_cnt_1k+1'b1;
                
                  end
                  
                end   
                           
         always@(posedge divclk )
         
               begin
                 if(ledtemp[2] == 1)  
                  
                  ledtemp = 3'b001;    //实现循环移位
                  
                  else   
                  
                   ledtemp = ledtemp << 1;   //左移1位
               end
          assign led[2:0]=ledtemp;
            
         always@(posedge divclk)
                    begin
                    cnt = cnt+3'b001;
                            case(cnt) 
                            3'h0:
                            seg1 = {temp[7:0],temp[15:8],temp[23:16],temp[31:24]};
                               //seg1=32'h40070676; //40070676
                            3'h1:
                             seg1 = {temp[15:8],temp[23:16],temp[31:24],temp[7:0]};
                              // seg1=32'h07067640;
                            3'h2:
                            seg1 ={temp[23:16],temp[31:24],temp[7:0],temp[15:8]};
                               //seg1=32'h06764007;
                            3'h3: 
                            seg1 = {temp[31:24],temp[7:0],temp[15:8],temp[23:16]};
                               //seg1=32'h76400706;
                            3'h4: 
                               seg1=32'h793e3f38    ; 
                            3'h5: 
                               seg1=32'h665b3f5b;
                            3'h6: 
                               seg1=32'h793e3f38;
                            3'h7: 
                               seg1=32'h665b3f5b;
                            endcase
                            end
           
               always@(posedge divclk_1k)
               begin
               disp_bit=disp_bit+2'b01;
                   case (disp_bit)
                       2'b00 :
                       begin
                        seg = seg1[7:0];
                        an = 8'b0001; //显示左数第1个数码管,高电平有效
                       end  
                       2'b01 :
                       begin
                        seg = seg1[15:8];
                        an = 8'b0010; //显示左数第2个数码管,高电平有效
                       end  
                       2'b10 :
                       begin
                        seg = seg1[23:16];
                        an = 8'b0100; //显示左数第3个数码管,高电平有效
                       end  
                       2'b11 :
                       begin
                         seg = seg1[31:24];
                         an = 8'b1000; //显示第4个数码管，高电平有效
                       end
                       
                   endcase
                    
               end
               always @ (sw)
                    begin
                        case (sw[3:0])
                        4'b0000 : temp[7:0]= seg_0; //显示"0"
                        4'b0001 : temp[7:0] = seg_1; //显示"1"
                        4'b0010 : temp[7:0]= seg_2; //显示"2"
                        4'b0011 : temp[7:0]= seg_3; //显示"3"
                        4'b0100 :  temp[7:0]= seg_4;
                        4'b0101 :  temp[7:0] = seg_5;
                        4'b0110 :  temp[7:0]= seg_6;
                        4'b0111 :  temp[7:0]= seg_7;
                        4'b1000 :  temp[7:0] = 8'h40;//-
                        4'b1001 :  temp[7:0] = 8'h07;//t
                        4'b1010 :  temp[7:0] = 8'b00111000;//L
                        4'b1011 :  temp[7:0] = 8'b00111110;//U
                        4'b1100 :  temp[7:0] = 8'b01110110;//H
                        4'b1101 :  temp[7:0] = 8'b00110001;//I
                        4'b1110 :  temp[7:0] = 8'b01111011;//E
                        4'b1111 :  temp[7:0] = 8'h79;//E             
                     endcase
                     case (sw[7:4])
                                             4'b0000 : temp[15:8]= seg_0; //显示"0"
                                             4'b0001 : temp[15:8] = seg_1; //显示"1"
                                             4'b0010 : temp[15:8]= seg_2; //显示"2"
                                             4'b0011 : temp[15:8]= seg_3; //显示"3"
                                             4'b0100 :  temp[15:8]= seg_4;
                                             4'b0101 :  temp[15:8] = seg_5;
                                             4'b0110 :  temp[15:8]= seg_6;
                                             4'b0111 :  temp[15:8]= seg_7;
                                             4'b1000 :  temp[15:8] = 8'h40;//-
                                             4'b1001 :  temp[15:8] = 8'h07;//t
                                             4'b1010 :  temp[15:8] = 8'b00111000;//L
                                             4'b1011 :  temp[15:8] = 8'b00111110;//U
                                             4'b1100 :  temp[15:8] = 8'b01110110;//H
                                             4'b1101 :  temp[15:8] = 8'b00110001;//I
                                             4'b1110 :  temp[15:8] = 8'b01111011;//E
                                             4'b1111 :  temp[15:8] = 8'h79;//E             
                                          endcase
                     case (sw[11:8])
                                                                  4'b0000 : temp[23:16]= seg_0; //显示"0"
                                                                  4'b0001 : temp[23:16] = seg_1; //显示"1"
                                                                  4'b0010 : temp[23:16]= seg_2; //显示"2"
                                                                  4'b0011 : temp[23:16]= seg_3; //显示"3"
                                                                  4'b0100 :  temp[23:16]= seg_4;
                                                                  4'b0101 :  temp[23:16] = seg_5;
                                                                  4'b0110 :  temp[23:16]= seg_6;
                                                                  4'b0111 :  temp[23:16]= seg_7;
                                                                  4'b1000 :  temp[23:16] = 8'h40;//-
                                                                  4'b1001 :  temp[23:16] = 8'h07;//t
                                                                  4'b1010 :  temp[23:16] = 8'b00111000;//L
                                                                  4'b1011 :  temp[23:16] = 8'b00111110;//U
                                                                  4'b1100 :  temp[23:16] = 8'b01110110;//H
                                                                  4'b1101 :  temp[23:16] = 8'b00110001;//I
                                                                  4'b1110 :  temp[23:16] = 8'b01111011;//E
                                                                  4'b1111 :  temp[23:16] = 8'h79;//E             
                                                               endcase
                            case (sw[15:12])
                                                                                       4'b0000 : temp[31:24]= seg_0; //显示"0"
                                                                                       4'b0001 : temp[31:24] = seg_1; //显示"1"
                                                                                       4'b0010 : temp[31:24]= seg_2; //显示"2"
                                                                                       4'b0011 : temp[31:24]= seg_3; //显示"3"
                                                                                       4'b0100 :  temp[31:24]= seg_4;
                                                                                       4'b0101 :  temp[31:24] = seg_5;
                                                                                       4'b0110 :  temp[31:24]= seg_6;
                                                                                       4'b0111 :  temp[31:24]= seg_7;
                                                                                       4'b1000 :  temp[31:24] = 8'h40;//-
                                                                                       4'b1001 :  temp[31:24] = 8'h07;//t
                                                                                       4'b1010 :  temp[31:24] = 8'b00111000;//                     
                                                                                       4'b1011 :  temp[31:24] = 8'b00111110;//U
                                                                                       4'b1100 :  temp[31:24] = 8'b01110110;//H
                                                                                       4'b1101 :  temp[31:24] = 8'b00110001;//T
                                                                                       4'b1110 :  temp[31:24] = 8'b01111011;//E
                                                                                       4'b1111 :  temp[31:24] = 8'h79;//E             
                                                                                    endcase                                   
                    end
                 
endmodule