unit ctrl_organs;

{$mode ObjFPC}{$H+}

interface



const

  BUTTON_CLEAR_ALERT_SENDER = $51;

  BUTTON_PLUS_1_SENDER = $52;
  BUTTON_PLUS_1_SENDER_REL = $53;

  BUTTON_MINUS_1_SENDER = $54;
  BUTTON_MINUS_1_SENDER_REL = $55;

  BUTTON_RESET_1_SENDER = $56;
  BUTTON_RESET_1_SENDER_REL = $5C; //

  BUTTON_PLUS_2_SENDER = $57;
  BUTTON_PLUS_2_SENDER_REL = $58;

  BUTTON_MINUS_2_SENDER = $59;
  BUTTON_MINUS_2_SENDER_REL = $5A;

  BUTTON_RESET_2_SENDER = $5B;
  BUTTON_RESET_2_SENDER_REL = $5d; //



var
  arr_ctrl_organ :array [0..11] of byte ;



procedure prepare_ctrl_organ_array(SENDER: Integer);

implementation

uses extra_defs;

procedure prepare_ctrl_organ_array(SENDER: Integer);
begin

  case SENDER of

  BUTTON_CLEAR_ALERT_SENDER :   arr_ctrl_organ:= button1_pressed        ;

  BUTTON_PLUS_1_SENDER :        arr_ctrl_organ:= button2_pressed        ;
  BUTTON_PLUS_1_SENDER_REL :    arr_ctrl_organ:= button2_released        ;

  BUTTON_MINUS_1_SENDER :       arr_ctrl_organ:= button3_pressed       ;
  BUTTON_MINUS_1_SENDER_REL :   arr_ctrl_organ:= button3_released        ;

  BUTTON_RESET_1_SENDER :       arr_ctrl_organ:= button4_pressed         ;
  BUTTON_RESET_1_SENDER_rel :   arr_ctrl_organ:= button4_pressed         ;

  BUTTON_PLUS_2_SENDER :        arr_ctrl_organ:= button5_released        ;
  BUTTON_PLUS_2_SENDER_REL :    arr_ctrl_organ:= button5_released        ;

  BUTTON_MINUS_2_SENDER :       arr_ctrl_organ:= button6_released       ;
  BUTTON_MINUS_2_SENDER_REL :   arr_ctrl_organ:= button6_released         ;

  BUTTON_RESET_2_SENDER :       arr_ctrl_organ:= button7_pressed         ;
  BUTTON_RESET_2_SENDER_rel :   arr_ctrl_organ:= button7_pressed         ;

  end;

end;

end.

