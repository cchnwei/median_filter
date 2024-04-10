module median_fliter(
  // input port
  input                  clk,
  input                  rst,
  input               enable,
  input  [7:0]     RAM_IMG_Q,
  input  [7:0]     RAM_OUT_Q,
  // output port
  output          RAM_IMG_OE,
  output          RAM_IMG_WE,
  output [15:0]    RAM_IMG_A,
  output [7:0]     RAM_IMG_D,
  output          RAM_OUT_OE,
  output          RAM_OUT_WE,
  output [15:0]    RAM_OUT_A,
  output [7:0]     RAM_OUT_D,
  output                done
);

  // define parameter 
  parameter INITIAL  = 2'd0;
  parameter READ     = 2'd1;
  parameter SORT     = 2'd2;
  parameter WRITE    = 2'd3;
  parameter WIDTH    = 8;
  parameter DEPTH    = 515;
  //

  // define reg or wire
  reg  [15:0] p0_addr;
  wire [15:0] p1_addr;
  wire [15:0] p2_addr;
  wire [15:0] p3_addr;
  wire [15:0] p4_addr;
  wire [15:0] p5_addr;
  wire [15:0] p6_addr;
  wire [15:0] p7_addr;
  wire [15:0] p8_addr;
  wire [15:0] p0_addr_cnt_up;
  reg  [7:0]  reg0;
  reg  [7:0]  reg1;
  reg  [7:0]  reg2;
  reg  [7:0]  reg3;
  reg  [7:0]  reg4;
  reg  [7:0]  reg5;
  reg  [7:0]  reg6;
  reg  [7:0]  reg7;
  reg  [7:0]  reg8;
  reg  [7:0]  pad0;
  reg  [7:0]  pad1;
  reg  [7:0]  pad2;
  reg  [7:0]  pad3;
  reg  [7:0]  pad4;
  reg  [7:0]  pad5;
  reg  [7:0]  pad6;
  reg  [7:0]  pad7;
  reg  [7:0]  pad8;
  reg  [7:0]  sortNum1;
  reg  [7:0]  sortNum2;
  reg  [7:0]  sortNum3;
  reg  [7:0]  sortNum4;
  reg  [7:0]  sortNum5;
  reg  [7:0]  sortNum6;
  reg  [7:0]  sortNum7;
  reg  [7:0]  sortNum8;
  reg  [7:0]  sortNum9;
  reg  [7:0]  sort1_o;
  reg  [7:0]  sort2_o;
  reg  [7:0]  sort3_o;
  reg  [7:0]  sort4_o;
  reg  [7:0]  sort5_o;
  reg  [7:0]  sort6_o;
  reg  [7:0]  sort7_o;
  reg  [7:0]  sort8_o;
  reg  [1:0]  cs;
  reg  [1:0]  ns;
  reg  [15:0] RAM_IMG_A_reg;
  reg  [15:0] RAM_OUT_A_reg;
  wire [15:0] RAM_IMG_A_cnt_up;
  wire [15:0] RAM_OUT_A_cnt_up;
  reg         RAM_IMG_OE_reg;
  reg         RAM_OUT_WE_reg;
  reg  [8:0]  column_cnt;
  wire [8:0]  column_cnt_up;
  reg  [8:0]  row_cnt;
  wire [8:0]  row_cnt_up;
  reg  [3:0]  read_cnt;
  wire [3:0]  read_cnt_up;
  wire        read_done;
  reg  [2:0]  sort_cnt;
  wire [2:0]  sort_cnt_up;
  wire        sort_done;
  wire        write_done;
  reg         done_reg;
  //

  // logic
  assign p1_addr = p0_addr-16'h0101;
  assign p2_addr = p0_addr-16'h0100;
  assign p3_addr = p0_addr-16'h00ff;
  assign p4_addr = p0_addr-16'h0001;
  assign p5_addr = p0_addr+16'h0001;
  assign p6_addr = p0_addr+16'h00ff;
  assign p7_addr = p0_addr+16'h0100;
  assign p8_addr = p0_addr+16'h0101;
  assign RAM_IMG_A = RAM_IMG_A_reg;
  assign RAM_OUT_A = RAM_OUT_A_reg;
  assign RAM_IMG_A_cnt_up = RAM_IMG_A+1'd1;
  assign RAM_OUT_A_cnt_up = RAM_OUT_A+1'd1;
  assign column_cnt_up = column_cnt+1'd1;
  assign row_cnt_up = row_cnt+1'd1;
  assign read_cnt_up = read_cnt+1'd1;
  assign sort_cnt_up = sort_cnt+1'd1;
  assign p0_addr_cnt_up = p0_addr+1'd1;
  assign RAM_IMG_OE = RAM_IMG_OE_reg;
  assign RAM_OUT_WE = RAM_OUT_WE_reg;
  assign RAM_OUT_D = sort5_o;
  assign read_done = (read_cnt==4'd10);
  assign sort_done = (sort_cnt==3'd7);
  assign done = done_reg;
  assign write_done = (RAM_OUT_A==16'd65535);
  //

  // state transition
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      cs <= INITIAL;
    end else cs <= ns;
  end

  always @(*) begin
    ns = cs;
    case (cs)
      INITIAL:
        begin
          if (enable) begin
            ns = READ;
          end
        end
      READ:
        begin
          if (!read_done) begin
            ns = READ;
          end else ns = SORT;
        end
      SORT:
        begin
          if (!sort_done) begin
            ns = SORT;
          end else ns = WRITE;
        end
      WRITE:
        begin
          ns = READ;
        end
    endcase
  end
  //

  // control signal
  always @(*) begin
    RAM_IMG_OE_reg=0;
    RAM_OUT_WE_reg=0;
    case (cs)
      INITIAL:
        begin

        end
      READ:
        begin
          RAM_IMG_OE_reg=1;
        end
      SORT:
        begin
          
        end
      WRITE:
        begin
          RAM_OUT_WE_reg=1;
        end
    endcase
  end
  //

  // column 0~255
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      column_cnt <= 0;
    end else if (column_cnt!=9'd255 && RAM_OUT_WE) begin
      column_cnt <= column_cnt_up;
    end else if (column_cnt==9'd255 && RAM_OUT_WE) begin
      column_cnt <= 0;
    end
  end
  //

  // row 0~255
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      row_cnt <= 0;
    end else if (column_cnt==9'd255 && RAM_OUT_WE) begin
      row_cnt <= row_cnt_up;
    end
  end
  //

  // p0_addr
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      p0_addr <= 0;
    end else if (RAM_OUT_WE) begin
      p0_addr <= p0_addr_cnt_up;
    end 
  end
  //

  // read_cnt
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      read_cnt <= 0;
    end else if (!read_done && RAM_IMG_OE) begin
      read_cnt <= read_cnt_up;
    end else if (read_done && RAM_IMG_OE) begin
      read_cnt <= 0;
    end
  end
  //

  // RAM_IMG_A
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      RAM_IMG_A_reg <= 0;
    end else if (RAM_IMG_OE) begin
      case (read_cnt)
        4'd0:
          begin
            RAM_IMG_A_reg <= p1_addr;
          end
        4'd1:
          begin
            RAM_IMG_A_reg <= p2_addr;
          end
        4'd2:
          begin
            RAM_IMG_A_reg <= p3_addr;
          end
        4'd3:
          begin
            RAM_IMG_A_reg <= p4_addr;
          end
        4'd4:
          begin
            RAM_IMG_A_reg <= p0_addr;
          end
        4'd5:
          begin
            RAM_IMG_A_reg <= p5_addr;
          end
        4'd6:
          begin
            RAM_IMG_A_reg <= p6_addr;
          end
        4'd7:
          begin
            RAM_IMG_A_reg <= p7_addr;
          end
        4'd8:
          begin
            RAM_IMG_A_reg <= p8_addr;
          end   
      endcase
    end
  end
  //

  // read
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      reg0 <=0;
      reg1 <=0;
      reg2 <=0;
      reg3 <=0;
      reg4 <=0;
      reg5 <=0;
      reg6 <=0;
      reg7 <=0;
      reg8 <=0;
    end else if (RAM_IMG_OE) begin
      case (read_cnt)
        4'd2:
          begin
            reg0 <= RAM_IMG_Q;
          end
        4'd3:
          begin
            reg1 <= RAM_IMG_Q;
          end
        4'd4:
          begin
            reg2 <= RAM_IMG_Q;
          end
        4'd5:
          begin
            reg3 <= RAM_IMG_Q;
          end
        4'd6:
          begin
            reg4 <= RAM_IMG_Q;
          end
        4'd7:
          begin
            reg5 <= RAM_IMG_Q;
          end
        4'd8:
          begin
            reg6 <= RAM_IMG_Q;
          end
        4'd9:
          begin
            reg7 <= RAM_IMG_Q;
          end
        4'd10:
          begin
            reg8 <= RAM_IMG_Q;
          end   
      endcase
    end
  end
  //

  // padding before sort
  always @(*) begin
    pad0 = reg0;
    pad1 = reg1;
    pad2 = reg2;
    pad3 = reg3;
    pad4 = reg4;
    pad5 = reg5;
    pad6 = reg6;
    pad7 = reg7;
    pad8 = reg8;
    if (cs==SORT) begin
      if (row_cnt!=9'd0 && row_cnt!=9'd255 && column_cnt!=9'd0 && column_cnt!=9'd255) begin
        pad0 = reg0;
        pad1 = reg1;
        pad2 = reg2;
        pad3 = reg3;
        pad4 = reg4;
        pad5 = reg5;
        pad6 = reg6;
        pad7 = reg7;
        pad8 = reg8;
      end else begin
        if (row_cnt==9'd0) begin // row0
          pad0 = 0;
          pad1 = 0;
          pad2 = 0;
        end
        if (row_cnt==9'd255) begin // row255
          pad6 = 0;
          pad7 = 0;
          pad8 = 0;
        end
        if (column_cnt==9'd0) begin // column0
          pad0 = 0;
          pad3 = 0;
          pad6 = 0;
        end 
        if (column_cnt==9'd255) begin // column255
          pad2 = 0;
          pad5 = 0;
          pad8 = 0;
        end
      end
      // if (row_cnt==9'd0||column_cnt==9'd0) begin
      //   pad0 = 0;
      // end
      // if (row_cnt==9'd0||column_cnt==9'd255) begin
      //   pad2 = 0;
      // end
      // if (row_cnt==9'd255||column_cnt==9'd0) begin
      //   pad6 = 0;
      // end
      // if (row_cnt==9'd255||column_cnt==9'd255) begin
      //   pad8 = 0;
      // end
      // if (row_cnt==9'd0) begin // row0
      //   pad1 = 0;
      // end
      // if (row_cnt==9'd255) begin // row255
      //   pad7 = 0;
      // end
      // if (column_cnt==9'd0) begin // column0
      //   pad3 = 0;
      // end 
      // if (column_cnt==9'd255) begin // column255
      //   pad5 = 0;
      // end
      // if (row_cnt==9'd0) begin // row0
      //   pad0 = 0;
      //   pad1 = 0;
      //   pad2 = 0;
      // end
      // if (row_cnt==9'd255) begin // row255
      //   pad6 = 0;
      //   pad7 = 0;
      //   pad8 = 0;
      // end
      // if (column_cnt==9'd0) begin // column0
      //   pad0 = 0;
      //   pad3 = 0;
      //   pad6 = 0;
      // end 
      // if (column_cnt==9'd255) begin // column255
      //   pad2 = 0;
      //   pad5 = 0;
      //   pad8 = 0;
      // end
    end
  end
  //

  // sort
  always @(*) begin // 取最大值
    sortNum1 = pad0;
    sortNum2 = pad1;
    sortNum3 = pad2;
    sortNum4 = pad3;
    sortNum5 = pad4;
    sortNum6 = pad5;
    sortNum7 = pad6;
    sortNum8 = pad7;
    sortNum9 = pad8;
    if (cs==SORT) begin
      if (pad0>=pad1 && pad0>=pad2 && pad0>=pad3 && pad0>=pad4 && pad0>=pad5 && pad0>=pad6 && pad0>=pad7 && pad0>=pad8) begin
        sortNum9 = pad0;
        sortNum1 = pad1;
        sortNum2 = pad2;
        sortNum3 = pad3;
        sortNum4 = pad4;
        sortNum5 = pad5;
        sortNum6 = pad6;
        sortNum7 = pad7;
        sortNum8 = pad8;
      end else if (pad1>=pad0 && pad1>=pad2 && pad1>=pad3 && pad1>=pad4 && pad1>=pad5 && pad1>=pad6 && pad1>=pad7 && pad1>=pad8) begin
        sortNum9 = pad1;
        sortNum1 = pad0;
        sortNum2 = pad2;
        sortNum3 = pad3;
        sortNum4 = pad4;
        sortNum5 = pad5;
        sortNum6 = pad6;
        sortNum7 = pad7;
        sortNum8 = pad8;
      end else if (pad2>=pad1 && pad2>=pad0 && pad2>=pad3 && pad2>=pad4 && pad2>=pad5 && pad2>=pad6 && pad2>=pad7 && pad2>=pad8) begin
        sortNum9 = pad2;
        sortNum1 = pad0;
        sortNum2 = pad1;
        sortNum3 = pad3;
        sortNum4 = pad4;
        sortNum5 = pad5;
        sortNum6 = pad6;
        sortNum7 = pad7;
        sortNum8 = pad8;
      end else if (pad3>=pad1 && pad3>=pad2 && pad3>=pad0 && pad3>=pad4 && pad3>=pad5 && pad3>=pad6 && pad3>=pad7 && pad3>=pad8) begin
        sortNum9 = pad3;
        sortNum1 = pad0;
        sortNum2 = pad1;
        sortNum3 = pad2;
        sortNum4 = pad4;
        sortNum5 = pad5;
        sortNum6 = pad6;
        sortNum7 = pad7;
        sortNum8 = pad8;
      end else if (pad4>=pad1 && pad4>=pad2 && pad4>=pad3 && pad4>=pad0 && pad4>=pad5 && pad4>=pad6 && pad4>=pad7 && pad4>=pad8) begin
        sortNum9 = pad4;
        sortNum1 = pad0;
        sortNum2 = pad1;
        sortNum3 = pad2;
        sortNum4 = pad3;
        sortNum5 = pad5;
        sortNum6 = pad6;
        sortNum7 = pad7;
        sortNum8 = pad8;
      end else if (pad5>=pad1 && pad5>=pad2 && pad5>=pad3 && pad5>=pad4 && pad5>=pad0 && pad5>=pad6 && pad5>=pad7 && pad5>=pad8) begin
        sortNum9 = pad5;
        sortNum1 = pad0;
        sortNum2 = pad1;
        sortNum3 = pad2;
        sortNum4 = pad3;
        sortNum5 = pad4;
        sortNum6 = pad6;
        sortNum7 = pad7;
        sortNum8 = pad8;
      end else if (pad6>=pad1 && pad6>=pad2 && pad6>=pad3 && pad6>=pad4 && pad6>=pad5 && pad6>=pad0 && pad6>=pad7 && pad6>=pad8) begin
        sortNum9 = pad6;
        sortNum1 = pad0;
        sortNum2 = pad1;
        sortNum3 = pad2;
        sortNum4 = pad3;
        sortNum5 = pad4;
        sortNum6 = pad5;
        sortNum7 = pad7;
        sortNum8 = pad8;
      end else if (pad7>=pad1 && pad7>=pad2 && pad7>=pad3 && pad7>=pad4 && pad7>=pad5 && pad7>=pad6 && pad7>=pad0 && pad7>=pad8) begin
        sortNum9 = pad7;
        sortNum1 = pad0;
        sortNum2 = pad1;
        sortNum3 = pad2;
        sortNum4 = pad3;
        sortNum5 = pad4;
        sortNum6 = pad5;
        sortNum7 = pad6;
        sortNum8 = pad8;
      end else if (pad8>=pad1 && pad8>=pad2 && pad8>=pad3 && pad8>=pad4 && pad8>=pad5 && pad8>=pad6 && pad8>=pad7 && pad8>=pad0) begin
        sortNum9 = pad8;
        sortNum1 = pad0;
        sortNum2 = pad1;
        sortNum3 = pad2;
        sortNum4 = pad3;
        sortNum5 = pad4;
        sortNum6 = pad5;
        sortNum7 = pad6;
        sortNum8 = pad7;
      end
    end
  end

  always @(posedge clk, posedge rst) begin 
    if (rst) begin
      sort1_o <= 0;
      sort2_o <= 0;
      sort3_o <= 0;
      sort4_o <= 0;
      sort5_o <= 0;
      sort6_o <= 0;
      sort7_o <= 0;
      sort8_o <= 0;
    end else if (cs==SORT) begin
      case (sort_cnt)
        3'd0:
          begin 
            sort1_o <= sortNum1;
            sort2_o <= sortNum2;
            sort3_o <= sortNum3;
            sort4_o <= sortNum4;
            sort5_o <= sortNum5;
            sort6_o <= sortNum6;
            sort7_o <= sortNum7;
            sort8_o <= sortNum8;
          end
        3'd1: // 1<=2 3<=4 5<=6 7<=8
          begin 
            if (sort1_o>=sort2_o) begin
              sort1_o <= sort2_o;
              sort2_o <= sort1_o;
            end
            if (sort3_o>=sort4_o) begin
              sort3_o <= sort4_o;
              sort4_o <= sort3_o;
            end 
            if (sort5_o>=sort6_o) begin
              sort5_o <= sort6_o;
              sort6_o <= sort5_o;
            end
            if (sort7_o>=sort8_o) begin
              sort7_o <= sort8_o;
              sort8_o <= sort7_o;
            end
          end
        3'd2: // 12小34大、56小78大  
          begin
            if (sort1_o>=sort4_o) begin
              sort1_o <= sort4_o;
              sort4_o <= sort1_o;
            end
            if (sort2_o>=sort3_o) begin
              sort2_o <= sort3_o;
              sort3_o <= sort2_o;
            end
            if (sort5_o>=sort8_o) begin
              sort5_o <= sort8_o;
              sort8_o <= sort5_o;
            end
            if (sort6_o>=sort7_o) begin
              sort6_o <= sort7_o;
              sort7_o <= sort6_o;
            end
          end
        3'd3: // 1234、5678兩個序列分別都從小排到大
          begin 
            if (sort1_o>=sort2_o) begin
              sort1_o <= sort2_o;
              sort2_o <= sort1_o;
            end
            if (sort3_o>=sort4_o) begin
              sort3_o <= sort4_o;
              sort4_o <= sort3_o;
            end 
            if (sort5_o>=sort6_o) begin
              sort5_o <= sort6_o;
              sort6_o <= sort5_o;
            end
            if (sort7_o>=sort8_o) begin
              sort7_o <= sort8_o;
              sort8_o <= sort7_o;
            end
          end
        3'd4: // min:1234 max:5678
          begin 
            if (sort1_o>=sort8_o) begin
              sort1_o <= sort8_o;
              sort8_o <= sort1_o;
            end
            if (sort2_o>=sort7_o) begin
              sort2_o <= sort7_o;
              sort7_o <= sort2_o;
            end 
            if (sort3_o>=sort6_o) begin
              sort3_o <= sort6_o;
              sort6_o <= sort3_o;
            end
            if (sort4_o>=sort5_o) begin
              sort4_o <= sort5_o;
              sort5_o <= sort4_o;
            end
          end
        3'd5: // 重複3'd1
          begin 
            if (sort1_o>=sort2_o) begin
              sort1_o <= sort2_o;
              sort2_o <= sort1_o;
            end
            if (sort3_o>=sort4_o) begin
              sort3_o <= sort4_o;
              sort4_o <= sort3_o;
            end 
            if (sort5_o>=sort6_o) begin
              sort5_o <= sort6_o;
              sort6_o <= sort5_o;
            end
            if (sort7_o>=sort8_o) begin
              sort7_o <= sort8_o;
              sort8_o <= sort7_o;
            end
          end
        3'd6: // 重複3'd2
          begin 
            if (sort1_o>=sort4_o) begin
              sort1_o <= sort4_o;
              sort4_o <= sort1_o;
            end
            if (sort2_o>=sort3_o) begin
              sort2_o <= sort3_o;
              sort3_o <= sort2_o;
            end
            if (sort5_o>=sort8_o) begin
              sort5_o <= sort8_o;
              sort8_o <= sort5_o;
            end
            if (sort6_o>=sort7_o) begin
              sort6_o <= sort7_o;
              sort7_o <= sort6_o;
            end
          end
        3'd7: // 重複3'd3 --> 1234、5678兩個序列分別都從小排到大 且 min:1234 max:5678
          begin 
            if (sort1_o>=sort2_o) begin
              sort1_o <= sort2_o;
              sort2_o <= sort1_o;
            end
            if (sort3_o>=sort4_o) begin
              sort3_o <= sort4_o;
              sort4_o <= sort3_o;
            end 
            if (sort5_o>=sort6_o) begin
              sort5_o <= sort6_o;
              sort6_o <= sort5_o;
            end
            if (sort7_o>=sort8_o) begin
              sort7_o <= sort8_o;
              sort8_o <= sort7_o;
            end
          end
      endcase
    end
  end
  //

  // sort_cnt
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      sort_cnt <= 0;
    end else if (!sort_done && cs==SORT) begin
      sort_cnt <= sort_cnt_up; 
    end else if (sort_done && cs==SORT) begin
      sort_cnt <= 0;
    end
  end
  //

  // output signal
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      RAM_OUT_A_reg <= 0;
    end else if (RAM_OUT_WE) begin
      RAM_OUT_A_reg <= RAM_OUT_A_cnt_up;
    end
  end
  //

  // done
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      done_reg <= 0;
    end else if (RAM_OUT_WE && write_done) begin
      done_reg <= 1;
    end
  end
  //
  
endmodule