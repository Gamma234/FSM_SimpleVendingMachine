module FSM( total_coin, exchange_coin, legal_choice, item, condition, 
            give_coin, drink_choose, cancel, clock, clear ) ;

output [31:0] total_coin ;
reg [31:0] total_coin ;
output [31:0] exchange_coin ;
reg [31:0] exchange_coin ;
output [8*30:1] legal_choice ;
reg [8*30:1] legal_choice ;
output [8*10:1] item ; 
reg [8*10:1] item ; 
output [1:0] condition ; 
reg [1:0] condition ; 

input [31:0] give_coin ;
input [3:0] drink_choose ;
input cancel ;
input clock, clear ;

parameter S0 = 2'd0, S1 = 2'd1, S2 = 2'd2, S3 = 2'd3 ;

reg [1:0] state ;
reg [1:0] next_state ;

always @( posedge clock )
    if ( clear ) begin
        state <= S0 ;
        total_coin <= 0 ;
        legal_choice <= "" ;
        item <= "" ;
        condition <= 2'b00 ;
    end
    else begin
        state <= next_state ;
    end

always @( state ) begin

    //$display( $time, " state = %d ", state ) ;

    case ( state )
        S0 : begin
		
                condition = 2'b00 ; 

                if ( give_coin ) total_coin = total_coin + give_coin ;
                else total_coin = total_coin + 32'd0 ;
				
				if ( total_coin >= 32'd25 ) legal_choice = "tea | coke | coffee | milk" ;
                else if ( total_coin >= 32'd20 ) legal_choice = "tea | coke | coffee" ;
                else if ( total_coin >= 32'd15 ) legal_choice = "tea | coke" ;
                else if ( total_coin >= 32'd10 ) legal_choice = "tea" ;
                else legal_choice = "" ;

             end
        S1 : begin
		
                condition = 2'b00 ;  

                if ( give_coin ) total_coin = total_coin + give_coin ;
                else total_coin = total_coin + 32'd0 ;

                if ( total_coin >= 32'd25 ) legal_choice = "tea | coke | coffee | milk" ;
                else if ( total_coin >= 32'd20 ) legal_choice = "tea | coke | coffee" ;
                else if ( total_coin >= 32'd15 ) legal_choice = "tea | coke" ;
                else if ( total_coin >= 32'd10 ) legal_choice = "tea" ;
                else legal_choice = "" ;

             end
        S2 : begin
		
                condition = 2'b01 ;

                if ( drink_choose == 4'd1 && total_coin >= 32'd10 ) begin
                    item = "tea" ;
                    exchange_coin = total_coin - 32'd10 ; 
                end 
                else if ( drink_choose == 4'd2 && total_coin >= 32'd15 ) begin
                    item = "coke" ;
                    exchange_coin = total_coin - 32'd15 ;     
                end
                else if ( drink_choose == 4'd3 && total_coin >= 32'd20 ) begin
                    item = "coffee" ;
                    exchange_coin = total_coin - 32'd20 ; 
                end
                else if ( drink_choose == 4'd4 && total_coin >= 32'd25 ) begin
                    item = "milk" ;
                    exchange_coin = total_coin - 32'd25 ; 
                end   
				else begin
				    item = "nothing" ;
					exchange_coin = total_coin ;
				end
				
             end
        S3 : begin 
                condition = 2'b10 ;  
                total_coin = 32'd0 ;  
				legal_choice = "" ;	
             end
    endcase

end

always @( state or give_coin or cancel or drink_choose ) begin

    case ( state )
        S0 : begin 
                if ( cancel ) begin 
					exchange_coin = total_coin ;
                    next_state = S3 ;
                end
                else if ( give_coin == 32'd0 ) begin
					next_state = S2 ;
				end
                else begin
                    next_state = S1 ;
                end
             end
        S1 : begin 
		        if ( cancel ) begin
					exchange_coin = total_coin ;
                    next_state = S3 ;
                end
                else if ( give_coin == 32'd0 ) begin
				    next_state = S2 ;
                end
                else begin
                    next_state = S0 ;
                end
             end
        S2 : begin 
                next_state = S3 ;
             end
        S3 : begin 
                next_state = S0 ;
             end
        default : next_state = S0 ;
    endcase

end

endmodule
