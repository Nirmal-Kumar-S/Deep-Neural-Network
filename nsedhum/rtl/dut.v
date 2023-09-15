module MyDesign (
//---------------------------------------------------------------------------
//Control signals
  output  reg dut_busy                    ,
  input   wire dut_run                    , 
  input   wire reset_b                    ,  
  input   wire clk                        ,
 
//---------------------------------------------------------------------------
//input SRAM interface
  output reg        input_sram_write_enable    ,
  output reg [11:0] input_sram_write_addresss  ,
  output reg [15:0] input_sram_write_data      ,
  output reg [11:0] input_sram_read_address    ,
  input wire [15:0] input_sram_read_data       ,

//---------------------------------------------------------------------------
//Output SRAM interface
  output reg        output_sram_write_enable    ,
  output reg [11:0] output_sram_write_addresss  ,
  output reg [15:0] output_sram_write_data      ,
  output reg [11:0] output_sram_read_address    ,
  input wire [15:0] output_sram_read_data       ,
  
  //Scratchpad SRAM interface
  output reg        scratchpad_sram_write_enable    ,
  output reg [11:0] scratchpad_sram_write_addresss  ,
  output reg [15:0] scratchpad_sram_write_data      ,
  output reg [11:0] scratchpad_sram_read_address    ,
  input wire [15:0] scratchpad_sram_read_data       ,

//---------------------------------------------------------------------------
//weights SRAM interface                                                       
  output reg        weights_sram_write_enable    ,
  output reg [11:0] weights_sram_write_addresss  ,
  output reg [15:0] weights_sram_write_data      ,
  output reg [11:0] weights_sram_read_address    ,
  input wire [15:0] weights_sram_read_data       

);

reg signed [7:0] i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16; //Registers for input matrix
reg signed [7:0] k1,k2,k3,k4,k5,k6,k7,k8,k9; //Registers for weight matrix
reg signed [19:0] conv1,conv2,conv3,conv4; //Convolution result
reg signed [7:0] relu1,relu2,relu3,relu4; //Relu result
reg signed [7:0] max,max1,max2; //Max Pooling Result
reg [3:0] current_state;
reg [3:0] next_state;
reg [11:0] starting_point; 
reg [7:0] matrix_size;
reg [11:0] row_counter,row_max;
reg [11:0] column_counter,column_max;
reg [7:0] store;
reg [19:0] write_address_counter;
reg write_flag;
reg matrix_size_flag;
reg next_matrix_flag;

localparam state_0   =  3'b000; // Reset state
localparam state_1   =  3'b001; // state 1
localparam state_2   =  3'b010; // state 2
localparam state_3   =  3'b011; // state 3
localparam state_4   =  3'b100; // state 4
localparam state_5   =  3'b101; // state 5
localparam state_6   =  3'b110; // state 6
localparam state_7   =  3'b111; // state 7
localparam state_8   = 4'b1000; // state 8
localparam state_9   = 4'b1001; // state 9
localparam state_10  = 4'b1010; // state 10 
localparam state_11  = 4'b1011; // state 11
localparam state_12  = 4'b1100; // state 12
localparam state_13  = 4'b1101; // state 13
localparam state_14  = 4'b1110; // state 14

always@(posedge clk or negedge reset_b)
begin
if(!reset_b)
current_state<=4'b0000;
else
current_state<=next_state;
end

always@(*) begin
casex (current_state)
//Initial State
state_0:begin
input_sram_read_address=0;
if(dut_run==1'b1)
begin
next_state=state_1;
end
else
begin
next_state=state_0;
end
end
//Read size of input matrix
state_1:begin
input_sram_read_address=starting_point-1;
next_state=state_2;
end
//Read i1,i2 from input matrix
state_2:begin
input_sram_read_address=starting_point;
next_state=state_3;
end
//Read i3,i4 from input matrix
state_3:begin
input_sram_read_address=starting_point+1;
next_state=state_4;
end
//Read i5,i6 from input matrix
state_4:begin
input_sram_read_address=starting_point+(matrix_size>>1);
next_state=state_5;
end
//Read i7,i8 from input matrix
state_5:begin
input_sram_read_address=starting_point+(matrix_size>>1)+1;
next_state=state_6;
end
//Read i9,i10 from input matrix
state_6:begin
input_sram_read_address=starting_point+matrix_size;
next_state=state_7;
end
//Read i11,i12 from input matrix
state_7:begin
input_sram_read_address=starting_point+(matrix_size)+1;
next_state=state_8;
end
//Read i13,i4 from input matrix
state_8:begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1);
next_state=state_9;
end
//Read i15,i6 from input matrix
state_9:begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+1;
next_state=state_10;
end
state_10:begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+1;
next_state=state_11;
end
//Check End of matrix and Read size of next input matrix if present
state_11:begin
if(row_counter==row_max-1 && column_counter==column_max-1)
begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+2;
end
else
begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+1;
end
next_state=state_12;
end
state_12:begin
if(row_counter==row_max-1 && column_counter==column_max-1)
begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+2;
end
else
begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+1;
end
next_state=state_13;
end
state_13:begin
if(row_counter==row_max-1 && column_counter==column_max-1)
begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+2;
end
else
begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+1;
end
next_state=state_14;
end
//Check End of matrix and if next matrix present got to state 1 else to state 0
//Check End of row or column and go to state 2 accordingly
state_14:begin
if(row_counter==row_max-1 && column_counter==column_max-1)
begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+2;
end
else
begin
input_sram_read_address=starting_point+(matrix_size)+(matrix_size>>1)+1;
end
if(row_counter==row_max && column_counter==column_max && next_matrix_flag==0)
begin
next_state=state_0;
end
else if(row_counter==row_max && column_counter==column_max && next_matrix_flag==1)
begin
next_state=state_1;
end
else if(column_counter!=column_max)
begin
next_state=state_2;
end
else if(row_counter!=row_max)
begin
next_state=state_2;
end
else
begin
next_state=state_0;
end
end

default:
begin
input_sram_read_address=0;
next_state=state_0;
end
endcase
end

always@(posedge clk)
begin
casex (current_state)
//Initialize values
state_0:
begin
dut_busy<=0;
write_address_counter<=0;
weights_sram_read_address<=0;
starting_point<=1'b1;
end
//Set dut_busy to high
state_1:
begin
dut_busy<=1;
write_flag=0;
matrix_size_flag<=1;
next_matrix_flag=0;
end
//Read the matrix parameters 
state_2:
begin
weights_sram_read_address<=weights_sram_read_address+1;
if(matrix_size_flag==1)
begin
matrix_size<=input_sram_read_data[7:0];
row_max<=(input_sram_read_data[7:0]>>1)-1;
column_max<=(input_sram_read_data[7:0]>>1)-1;
row_counter<=0;
column_counter<=0;
end
else
matrix_size_flag<=0;
end
//Assign values of input matrix & weight matrix to its registers respectively 
state_3:
begin
i1<=input_sram_read_data[15:8];
i2<=input_sram_read_data[7:0];
k1<=weights_sram_read_data[15:8];
k2<=weights_sram_read_data[7:0];
weights_sram_read_address<=weights_sram_read_address+1;
conv1<=0;
conv2<=0;
conv3<=0;
conv4<=0;
relu1=0;
relu2=0;
relu3=0;
relu4=0;
max=0;
max1=0;
max2=0;
end
//Assign values of input matrix & weight matrix to its registers respectively
state_4:
begin
i3<=input_sram_read_data[15:8];
i4<=input_sram_read_data[7:0];
k3<=weights_sram_read_data[15:8];
k4<=weights_sram_read_data[7:0];
weights_sram_read_address<=weights_sram_read_address+1;
end
//Assign values of input matrix & weight matrix to its registers respectively
state_5:
begin
i5<=input_sram_read_data[15:8];
i6<=input_sram_read_data[7:0];
k5<=weights_sram_read_data[15:8];
k6<=weights_sram_read_data[7:0];
weights_sram_read_address<=weights_sram_read_address+1;
end
//Assign values of input matrix & weight matrix to its registers respectively
state_6:
begin
i7<=input_sram_read_data[15:8];
i8<=input_sram_read_data[7:0];
k7<=weights_sram_read_data[15:8];
k8<=weights_sram_read_data[7:0];
end
//Assign values of input matrix & weight matrix to its registers respectively
state_7:
begin
i9<=input_sram_read_data[15:8];
i10<=input_sram_read_data[7:0];
k9<=weights_sram_read_data[15:8];
weights_sram_read_address<=0;
end
//Assign values of input matrix & weight matrix to its registers respectively
state_8:
begin
i11<=input_sram_read_data[15:8];
i12<=input_sram_read_data[7:0];
end
//Assign values of input matrix & weight matrix to its registers respectively
//Calculate Conv1
state_9:
begin
i13<=input_sram_read_data[15:8];
i14<=input_sram_read_data[7:0];
conv1<=i1*k1 + i2*k2 + i3*k3 + i5*k4 + i6*k5 + i7*k6 + i9*k7 + i10*k8 + i11*k9;
end
//Assign values of input matrix & weight matrix to its registers respectively
//Calculate Conv2 & Relu1
state_10:
begin
i15<=input_sram_read_data[15:8];
i16<=input_sram_read_data[7:0];
conv2<=i2*k1 + i3*k2 + i4*k3 + i6*k4 + i7*k5 + i8*k6 + i10*k7 + i11*k8 + i12*k9;
if(conv1[19] == 1'b1)
relu1=1'b0;
else if(conv1 > 7'b1111111)
relu1=7'b1111111;
else
relu1=conv1;
end
//Calculate Conv3, Con4 & Relu2 & Max1
state_11:
begin
conv3<=i5*k1 + i6*k2 + i7*k3 + i9*k4 + i10*k5 + i11*k6 + i13*k7 + i14*k8 + i15*k9;
conv4<=i6*k1 + i7*k2 + i8*k3 + i10*k4 + i11*k5 + i12*k6 + i14*k7 + i15*k8 + i16*k9;
if(conv2[19] == 1'b1)
relu2=1'b0;
else if(conv2 > 7'b1111111)
relu2=7'b1111111;
else
relu2=conv2;
if(relu1 > relu2)
max1=relu1;
else
max1=relu2;
end
//Calculate Relu3, Relu4, Max2 & set max of max1 & max2 to max
//Increment Column & Row Counter
//Enable write sram to write the max value  
state_12:
begin
if(conv3[19] == 1'b1)
relu3=1'b0;
else if(conv3 > 7'b1111111)
relu3=7'b1111111;
else
relu3=conv3;
if(conv4[19] == 1'b1)
relu4=1'b0;
else if(conv4 > 7'b1111111)
relu4=7'b1111111;
else
relu4=conv4;
if(relu3 > relu4)
max2=relu3;
else
max2=relu4;
if(max1 > max2)
max=max1;
else
max=max2;
column_counter<=column_counter+1;
if(column_counter+1 == column_max)
begin
row_counter<=row_counter+1;
end
else
begin
row_counter<=row_counter;
end
output_sram_write_enable<=1;
output_sram_write_addresss<=write_address_counter;
end
//Set next matrix flag to 1 if next element is FFFF
//Write the max value into output sram
state_13:
begin
if(row_counter==row_max && column_counter==column_max && input_sram_read_data[15:0]!=16'b1111111111111111)
begin
next_matrix_flag=1;
end
else if(row_counter==row_max && column_counter==column_max && input_sram_read_data[15:0]==16'b1111111111111111)
begin
next_matrix_flag=0;
end
else
next_matrix_flag=0;
if(write_flag==0)
begin
store<=max;
output_sram_write_data<={max[7:0],8'b00000000};
write_flag=1;
if(next_matrix_flag==1)
begin
write_address_counter<=write_address_counter+1;
end
else
write_address_counter<=write_address_counter;
end
else
begin
output_sram_write_data<={store[7:0],max[7:0]};
write_flag=0;
write_address_counter<=write_address_counter+1;
end
end
//Check End of matrix and if next matrix present set starting position accordingly 
//Check End of column and intialize the counter to 0
state_14:
begin
if(row_counter==row_max && column_counter==column_max && next_matrix_flag==1)
begin
starting_point<=starting_point+(matrix_size)+(matrix_size>>1)+3;
end
else if(column_counter!=column_max)
begin
starting_point<=starting_point+1;
matrix_size_flag<=0;
end
else if(row_counter!=row_max)
begin
starting_point<=starting_point+(matrix_size>>1)+2;
matrix_size_flag<=0;
end
else 
starting_point<=starting_point;
if(column_counter==column_max && row_counter!=row_max)
begin
column_counter<=0;
end
else
begin
column_counter<=column_counter;
end
output_sram_write_enable<=0;
end

default:
dut_busy<=0;
endcase
end
endmodule
