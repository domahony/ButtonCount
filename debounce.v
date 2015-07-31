module debounce(clk, button, button_state, button_up, button_down);

input clk;
input button;
output reg button_state;
output button_up;
output button_down;

reg sync1;
always @(posedge clk)
begin
	sync1 <= ~button;
end

reg sync2;
always @(posedge clk)
begin
	sync2 <= sync1;
end

reg[15:0] PB_cnt;

wire PB_idle = (button_state==sync2);
wire PB_cnt_max = &PB_cnt;

always @(posedge clk)
if (PB_idle)
	PB_cnt <= 0;
else
begin
	PB_cnt <= PB_cnt + 16'd1;
	if (PB_cnt_max) button_state <= ~button_state;
end

assign button_down = ~PB_idle & PB_cnt_max & ~button_state;
assign button_up = ~PB_idle & PB_cnt_max & button_state;

endmodule
