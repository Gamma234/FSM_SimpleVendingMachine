module stimulus ;

wire [31:0] total_coin ;
wire [31:0] exchange_coin ;
wire [8*30:1] legal_choice ; 
wire [8*10:1] item ; 
wire [1:0] condition ; // 00 : information, 01 : out, 10 : exchange

reg [31:0] coin ;
reg [3:0] drink_choose ;
reg cancel ;
reg CLOCK, CLEAR ;

FSM fsm( total_coin, exchange_coin, legal_choice, item, condition,
         coin, drink_choose, cancel, CLOCK, CLEAR ) ;

always #5 CLOCK = ~CLOCK ;

initial begin

    CLOCK = 1'b1 ;
    CLEAR = 1'b1 ;
    cancel = 1'b0 ;

    #10 
    CLEAR = 1'b0 ;
    coin = 32'd10 ;
	
    #10 coin = 32'd5 ;
    #10 coin = 32'd1 ;
    #10 coin = 32'd10 ;
    #10 coin = 32'd0 ;
    #10 drink_choose = 4'd3 ;
    #10 drink_choose = 4'd0 ;

	#10 coin = 32'd1 ;
	#10 coin = 32'd5 ;
    #10 coin = 32'd10 ;
    #10 coin = 32'd10 ;
    #10 coin = 32'd0 ;
    #10 drink_choose = 4'd1 ;
    #10 drink_choose = 4'd0 ;
	
	#10 coin = 32'd50 ;
	#10 coin = 32'd10 ;
    #10 coin = 32'd5 ;
    #10 coin = 32'd1 ;
    #10 coin = 32'd0 ;
    #10 drink_choose = 4'd2 ;
    #10 drink_choose = 4'd0 ;
	
	#10 coin = 32'd10 ;
	#10 coin = 32'd10 ;
    #10 coin = 32'd1 ;
    #10 coin = 32'd50 ;
    #10 coin = 32'd0 ;
    #10 drink_choose = 4'd4 ;
    #10 drink_choose = 4'd0 ;
	
    #10 coin = 32'd5 ;
	#10 coin = 32'd10 ;
    #10 coin = 32'd0 ;
    #10 drink_choose = 4'd4 ; // not enough money 
    #10 drink_choose = 4'd0 ;
	
	#10 coin = 32'd1 ;
	#10 coin = 32'd5 ;	
	#10 
	cancel = 1'b1 ;
	#10
	cancel = 1'b0 ;
	coin = 32'd0 ;

	#10 coin = 32'd10 ;	
	#10 
	cancel = 1'b1 ;
	#10
	cancel = 1'b0 ;
	coin = 32'd0 ;

end

initial begin
	$monitor( $time, " coin %d,  total %d dollars,  %s", coin, total_coin, legal_choice ) ;
end

always @( condition ) begin
    if ( condition == 2'b01 ) begin
        $display( $time, " %s out", item ) ;
    end
    else if ( condition == 2'b10 ) begin
        $display( $time, " exchange %d dollars", exchange_coin ) ;
    end
end

endmodule 
