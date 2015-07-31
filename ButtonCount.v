module ButtonCount(input clk, input button, output[7:0] segment, output[7:0] digit, 
output TxD);

wire button_state, button_up, button_down;

debounce DB(
.clk				(clk),
.button 			(button),
.button_state	(button_state),
.button_up		(button_up),
.button_down	(button_down));

reg[3:0] d0 = 3'd0;
reg[3:0] d1 = 3'd0;
reg[3:0] d2 = 3'd0;
reg[3:0] d3 = 3'd0;
reg[3:0] d4 = 3'd0;
reg[3:0] d5 = 3'd0;
reg[3:0] d6 = 3'd0;
reg[3:0] d7 = 3'd0;

reg[2:0] sdigit = 0;
reg[3:0] sdigit_val = 3'd0;

wire hztick;

HZGenerator hz(
.clk(clk),
.tick(hztick)
);

always @(posedge clk)
begin
	if (hztick) 
		sdigit <= sdigit + 3'd1;
end

reg[23:0] tx_to_send = 0;
reg send = 0;

always @(*)
begin
		case (sdigit) 
		3'd0: begin sdigit_val = d0; end
		3'd1: begin sdigit_val = d1; end
		3'd2: begin sdigit_val = d2; end
		3'd3: begin sdigit_val = d3; end
		3'd4: begin sdigit_val = d4; end
		3'd5: begin sdigit_val = d5; end
		3'd6: begin sdigit_val = d6; end
		3'd7: begin sdigit_val = d7; end
		endcase
	end

always @(posedge clk)
begin
	send = button_up & ~send;
	if (button_up)
	begin
		d0 = d0 + 3'd1;
		tx_to_send = tx_to_send + 23'd1;
		if (d0 == 10) begin d1 = d1 + 3'd1; d0 = 3'd0; end;
		if (d1 == 10) begin d2 = d2 + 3'd1; d1 = 3'd0; end;
		if (d2 == 10) begin d3 = d3 + 3'd1; d2 = 3'd0; end;
		if (d3 == 10) begin d4 = d4 + 3'd1; d3 = 3'd0; end;
		if (d4 == 10) begin d5 = d5 + 3'd1; d4 = 3'd0; end;
		if (d5 == 10) begin d6 = d6 + 3'd1; d5 = 3'd0; end;
		if (d6 == 10) begin d7 = d7 + 3'd1; d6 = 3'd0; end;
		if (d7 == 10) begin d1 = d1 + 3'd1; d7 = 3'd0; end;
		end
end

RS232TX rs232tx(
	.clk(clk),
	.Tx_start(send),
	.dbuffer(tx_to_send),
	.Tx(TxD)
);

LED led(
.clk(clk),
.enable(hztick),
.val (sdigit_val),
.sidx (sdigit),
.digit(digit),
.segment(segment));
	
endmodule