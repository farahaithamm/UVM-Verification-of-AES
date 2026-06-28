module ff#(parameter N = 128)(
    input logic clk, rst_n, valid_in,
    input logic[N-1:0] data_in,
    output logic[N-1:0] data_out,
    output reg valid_out
);

always @(posedge clk, negedge rst_n) begin
    if (rst_n) begin
        data_out <= 0;
        valid_out <= 0;
    end
    else if(valid_in) begin
        data_out <= data_in;
        valid_out <= 1;
    end
    else valid_out <= 0;
end
    
endmodule