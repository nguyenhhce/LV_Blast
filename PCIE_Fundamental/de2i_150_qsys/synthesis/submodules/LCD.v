module	LCD(	
		input	   iCLK,
		input	   iRST_N,
		output	[7:0]LCD_DATA,
		output	LCD_RW,
		output	LCD_EN,
		output	LCD_RS,
		input	[7:0]txt00,
		input	[7:0]txt01,
		input	[7:0]txt02,
		input	[7:0]txt03,
		input	[7:0]txt04,
		input	[7:0]txt05,
		input	[7:0]txt06,
		input	[7:0]txt07,
		input	[7:0]txt08,
		input	[7:0]txt09,
		input	[7:0]txt0A,
		input	[7:0]txt0B,
		input	[7:0]txt0C,
		input	[7:0]txt0D,
		input	[7:0]txt0E,
		input	[7:0]txt0F,
		input	[7:0]txt10,
		input	[7:0]txt11,
		input	[7:0]txt12,
		input	[7:0]txt13,
		input	[7:0]txt14,
		input	[7:0]txt15,
		input	[7:0]txt16,
		input	[7:0]txt17,
		input	[7:0]txt18,
		input	[7:0]txt19,
		input	[7:0]txt1A,
		input	[7:0]txt1B,
		input	[7:0]txt1C,
		input	[7:0]txt1D,
		input	[7:0]txt1E,
		input	[7:0]txt1F
);

//	Internal Wires/Registers
reg	[5:0]	LUT_INDEX;
reg	[8:0]	LUT_DATA;
reg	[5:0]	mLCD_ST;
reg	[17:0]	mDLY;
reg			mLCD_Start;
reg	[7:0]	mLCD_DATA;
reg			mLCD_RS;
wire		mLCD_Done;

parameter	LCD_INTIAL	=	0;
parameter	LCD_LINE1	=	5;
parameter	LCD_CH_LINE	=	LCD_LINE1+16;
parameter	LCD_LINE2	=	LCD_LINE1+16+1;
parameter	LUT_SIZE	=	39;//LCD_LINE1+32+1;

always@(posedge iCLK)
begin
	if(!iRST_N)
	begin
		LUT_INDEX	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
	end
	else
	begin
		if(LUT_INDEX<LUT_SIZE)
		begin
			case(mLCD_ST)
			0:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;					
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	3;
					end
				end
			3:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mLCD_ST	<=	0;
				end
			endcase
		end
	end
end


always@(posedge iCLK) begin
	case(LUT_INDEX)
	 //	Initial
	 LCD_INTIAL + 0:	LUT_DATA	<=	9'h038;
	 LCD_INTIAL + 1:	LUT_DATA	<=	9'h00C;
	 LCD_INTIAL + 2:	LUT_DATA	<=	9'h001;
	 LCD_INTIAL + 3:	LUT_DATA	<=	9'h006;
	 LCD_INTIAL + 4:	LUT_DATA	<=	9'h080;
	 // LINE 1
	LCD_LINE1+ 0:	LUT_DATA	<=	{1'b1,txt00};// 
	LCD_LINE1+ 1:	LUT_DATA	<=	{1'b1,txt01};//F
	LCD_LINE1+ 2:	LUT_DATA	<=	{1'b1,txt02};//L
	LCD_LINE1+ 3:	LUT_DATA	<=	{1'b1,txt03};//A
	LCD_LINE1+ 4:	LUT_DATA	<=	{1'b1,txt04};//S
    LCD_LINE1+ 5:	LUT_DATA	<=	{1'b1,txt05};//H
    LCD_LINE1+ 6:	LUT_DATA	<=	{1'b1,txt06};// 
	LCD_LINE1+ 7:	LUT_DATA	<=	{1'b1,txt07};// 
	LCD_LINE1+ 8:	LUT_DATA	<=	{1'b1,txt08};// 
	LCD_LINE1+ 9:	LUT_DATA	<=	{1'b1,txt09};//W
	LCD_LINE1+10:	LUT_DATA	<=	{1'b1,txt0A};//R
	LCD_LINE1+11:	LUT_DATA	<=	{1'b1,txt0B};//I
	LCD_LINE1+12:	LUT_DATA	<=	{1'b1,txt0C};//T
	LCD_LINE1+13:	LUT_DATA	<=	{1'b1,txt0D};//E
	LCD_LINE1+14:	LUT_DATA	<=	{1'b1,txt0E};//R
	LCD_LINE1+15:	LUT_DATA	<=	{1'b1,txt0F};// 
	// Change line
    LCD_CH_LINE:	LUT_DATA	<=	9'h0C0;
	
	LCD_LINE2+ 0:	LUT_DATA	<=	{1'b1,txt10};
	LCD_LINE2+ 1:	LUT_DATA	<=	{1'b1,txt11};
	LCD_LINE2+ 2:	LUT_DATA	<=	{1'b1,txt12}; 
	LCD_LINE2+ 3:	LUT_DATA	<=	{1'b1,txt13}; 
	LCD_LINE2+ 4:	LUT_DATA	<=	{1'b1,txt14}; 
	LCD_LINE2+ 5:	LUT_DATA	<=	{1'b1,txt15}; 
	LCD_LINE2+ 6:	LUT_DATA	<=	{1'b1,txt16}; 
	LCD_LINE2+ 7:	LUT_DATA	<=	{1'b1,txt17}; 
	LCD_LINE2+ 8:	LUT_DATA	<=	{1'b1,txt18};// 
	LCD_LINE2+ 9:	LUT_DATA	<=	{1'b1,txt19};// 
	LCD_LINE2+10:	LUT_DATA	<=	{1'b1,txt1A};// 
	LCD_LINE2+11:	LUT_DATA	<=	{1'b1,txt1B};// 
	LCD_LINE2+12:	LUT_DATA	<=	{1'b1,txt1C};// 
	LCD_LINE2+13:	LUT_DATA	<=	{1'b1,txt1D};// 
	LCD_LINE2+14:	LUT_DATA	<=	{1'b1,txt1E};// 
	LCD_LINE2+15:	LUT_DATA	<=	{1'b1,txt1F};// 
	default:		   LUT_DATA	<=	9'h120;
	endcase	
end

LCD_Controller 		u0	(	//	Host Side
							.iDATA(mLCD_DATA),
							.iRS(mLCD_RS),
							.iStart(mLCD_Start),
							.oDone(mLCD_Done),
							.iCLK(iCLK),
							.iRST_N(iRST_N),
							//	LCD Interface
							.LCD_DATA(LCD_DATA),
							.LCD_RW(LCD_RW),
							.LCD_EN(LCD_EN),
							.LCD_RS(LCD_RS)	);

endmodule