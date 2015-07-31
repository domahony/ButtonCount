module HZGenerator (input clk, output tick);

reg[14: 0] cnt;

always @(posedge clk)
begin
	cnt <= cnt + 15'd1;
end

assign tick = &cnt;

endmodule