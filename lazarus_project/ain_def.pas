unit ain_def;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DateTimePicker, dateutils, hydr_files, hydr_utils, imginf;

TYPE

  TAinDef=record
	id:integer;
	name:STRING;
	signal:integer;
	val4:REAL;
	val20:REAL;
	units:STRING;
	lo_alert:REAL;
	lo_warn:REAL;
	hi_warn:REAL;
	hi_alert:REAL;
	coil_byte:integer;
	coil_bit:integer;
	display_factor:REAL;
	trm_factor:real;
        present_value :Double;
  END;



const
NAN=-1e6      ;

AIN_DEFS_ : ARRAY [1..21] OF TAinDef = (

 (id:1;	name:'концентрация о2 в н2';											signal:-420;	val4:0;	val20:1*2;	units:'%';			lo_alert:NAN;	lo_warn:0.1;	hi_warn:0.75;	hi_alert:0.95;	coil_byte:2;	coil_bit:5; display_factor:1000; trm_factor:1.0 )                // 22      was hi_warn:0.5
,(id:2;	name:'концентрация н2 в о2 ';											signal:-420;	val4:0;	val20:2;	units:'% ';		lo_alert:NAN;	lo_warn:0.2;	hi_warn:1;		hi_alert:1.85;	coil_byte:2;	coil_bit:6; display_factor:1000  )                // 23
,(id:3;	name:'давление Н2 в регуляторе-промывателе ';							signal:-420;	val4:0;	val20:16;	units:'кгс/см2 ';	lo_alert:NAN;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:10;	coil_byte:2;	coil_bit:7; display_factor:100  )                // 24
,(id:4;	name:'перепад давления в регуляторе-промывателе ';						signal:-420;	val4:-31.5;	val20:31.5;	units:'cм в. ст. ';lo_alert:NAN;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:20.0;	coil_byte:3;	coil_bit:0; display_factor:100  )                // 25
,(id:5;	name:'вел выпр тока 01-пт : 0..75 mV на вхлде в шкаф - далее 4..20мА ';signal:-420;	val4:0;	val20:1500;units:'A ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:3;	coil_bit:1; display_factor:10000  )                // 26
,(id:6;	name:'вел выпр тока 02-пт : 0..75 mV на вхлде в шкаф - далее 4..20мА ';signal:-420;	val4:0;	val20:1500;units:'A ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:3;	coil_bit:2; display_factor:10000  )                // 27
,(id:7;	name:'нарушение изоляции между монополярной плит и земл электр 1 ';	signal:-420;	val4:-1;	val20:100;	units:'V ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:2;		hi_alert:NAN;	coil_byte:3;	coil_bit:3; display_factor:10  )                // 28
,(id:8;	name:'нарушение изоляции между монополярной плит и земл электр 2 ';	signal:-420;	val4:-1;	val20:100;	units:'V ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:2;		hi_alert:NAN;	coil_byte:3;	coil_bit:4; display_factor:10  )                // 29
,(id:9;	name:'температура электролита 1 ';										signal:3;		val4:0;	val20:105;	units:'*C ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:75;	hi_alert:NAN;	coil_byte:3;	coil_bit:5; display_factor:10  )                // 30
,(id:10;	name:'темп н2 после электролизера 1 ';									signal:3;		val4:0;	val20:105;	units:'*C ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:3;	coil_bit:6; display_factor:10  )                // 31
,(id:11;	name:'темп о2 после эл-ра 1 ';											signal:3;		val4:0;	val20:105;	units:'*C ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:3;	coil_bit:7; display_factor:10  )                // 32
,(id:12;	name:'температура электролита 2 ';										signal:3;		val4:0;	val20:105;	units:'*C ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:75;	hi_alert:NAN;	coil_byte:4;	coil_bit:0; display_factor:10  )                // 33
,(id:13;	name:'темп н2 после эл-ра2 ';											signal:3;		val4:0;	val20:105;	units:'*C ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:4;	coil_bit:1; display_factor:10  )                // 34
,(id:14;	name:'темп о2 после эл-ра 2 ';											signal:3;		val4:0;	val20:105;	units:'C ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:4;	coil_bit:2; display_factor:10  )  //*             // 35
,(id:15;	name:'конц н2 в возд помещ/ канал 1 ';									signal:420;	val4:0;	val20:2;	units:'% ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:3; display_factor:10  )                // 36
,(id:16;	name:'конц н2 в возд помещ/ канал 2 ';									signal:420;	val4:0;	val20:2;	units:'% ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:4; display_factor:10  )                // 37
,(id:17;	name:'конц н2 в возд помещ/ канал 3 ';									signal:420;	val4:0;	val20:2;	units:'% ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:5; display_factor:10  )                // 38
,(id:18;	name:'конц н2 в возд помещ/ канал 4 ';									signal:420;	val4:0;	val20:2;	units:'% ';		lo_alert:NAN;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:6; display_factor:10  )                // 39
,(id:19;	name:'содержание о2 в возд помещения ';								signal:420;	val4:0;	val20:30;	units:'% ';		lo_alert:NAN;	lo_warn:19;	hi_warn:23;	hi_alert:23;	coil_byte:4;	coil_bit:7; display_factor:10  )                // 40
,(id:20;	name:'вел-на выпр. напр 01-пт ';										signal:420;	val4:-1;	val20:200*6.5*2.5*0.9345794;	units:'V ';		lo_alert:NAN;	lo_warn:30;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:5;	coil_bit:0; display_factor:0.1  )                //  41
,(id:21;	name:'вел-на выпр напр 02-пт ';										signal:420;	val4:-1;	val20:200*12.5;	units:'V ';		lo_alert:NAN;	lo_warn:30;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:5;	coil_bit:1; display_factor:0.1  )                // 42

);




AIN_DEFS : ARRAY [1..21] OF TAinDef = (

 (id:1;	name:'концентрация O2 в н2';											signal:-420;	val4:0;	        val20:1;	units:'%';		lo_alert:0.5;	lo_warn:0.1;	hi_warn:0.75;	hi_alert:0.95;	coil_byte:2;	coil_bit:5; display_factor:1000; trm_factor:1.0 )                // 22      was hi_warn:0.5
,(id:2;	name:'концентрация H2 в о2 ';											signal:-420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:0.2;	hi_warn:1;		hi_alert:1.85;	coil_byte:2;	coil_bit:6; display_factor:1000  )                // 23
,(id:3;	name:'давление Н2 в регуляторе-промывателе ';							                signal:-420;	val4:0;	        val20:16;	units:'кгс/см2 ';	lo_alert:8;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:10;	coil_byte:2;	coil_bit:7; display_factor:100  )                // 24
,(id:4;	name:'перепад давления в регуляторе-промывателе ';						                signal:-420;	val4:-315;	val20:315;	units:'мм в. ст. ';     lo_alert:0;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:20.0;	coil_byte:3;	coil_bit:0; display_factor:100  )                // 25
,(id:5;	name:'вел выпр тока 01-пт';                                                                                     signal:-420;	val4:0;	        val20:1500;     units:'A ';		lo_alert:700;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:3;	coil_bit:1; display_factor:10000  )                // 26
,(id:6;	name:'вел выпр тока 02-пт';                                                                                     signal:-420;	val4:0;	        val20:1500;     units:'A ';		lo_alert:700;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:3;	coil_bit:2; display_factor:10000  )                // 27
,(id:7;	name:'нарушение изоляции 1 ';	                                                                                signal:-420;	val4:-1;	val20:100;	units:'B ';		lo_alert:50;	lo_warn:NAN;	hi_warn:2;		hi_alert:NAN;	coil_byte:3;	coil_bit:3; display_factor:10  )                // 28
,(id:8;	name:'нарушение изоляции 2 ';	                                                                                signal:-420;	val4:-1;	val20:100;	units:'B ';		lo_alert:50;	lo_warn:NAN;	hi_warn:2;		hi_alert:NAN;	coil_byte:3;	coil_bit:4; display_factor:10  )                // 29
,(id:9;	name:'температура электролита 1 ';										signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:75;	hi_alert:NAN;	coil_byte:3;	coil_bit:5; display_factor:10  )                // 30
,(id:10;name:'темп H2 после электролизера 1 ';									        signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:3;	coil_bit:6; display_factor:10  )                // 31
,(id:11;name:'темп O2 после электролизера 1 ';										signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:3;	coil_bit:7; display_factor:10  )                // 32
,(id:12;name:'температура электролита 2 ';										signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:75;	hi_alert:NAN;	coil_byte:4;	coil_bit:0; display_factor:10  )                // 33
,(id:13;name:'температура H2 после электролизера 2 ';									signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:4;	coil_bit:1; display_factor:10  )                // 34
,(id:14;name:'температура O2 после электролизера 2 ';									signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:4;	coil_bit:2; display_factor:10  )  //*             // 35
,(id:15;name:'концентрация H2 в возд помещ/ канал 1 ';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:3; display_factor:10  )                // 36
,(id:16;name:'концентрация H2 в возд помещ/ канал 2 ';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:4; display_factor:10  )                // 37
,(id:17;name:'концентрация H2 в возд помещ/ канал 3 ';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:5; display_factor:10  )                // 38
,(id:18;name:'концентрация H2 в возд помещ/ канал 4 ';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:6; display_factor:10  )                // 39
,(id:19;name:'содержание O2 в возд помещения ';								                signal:420;	val4:0;	        val20:30;	units:'% ';		lo_alert:10;	lo_warn:19;	hi_warn:23;	hi_alert:23;	coil_byte:4;	coil_bit:7; display_factor:10  )                // 40
,(id:20;name:'величина выпр. напр 01-пт ';										signal:420;	val4:-1;	val20:200 ;     units:'V ';             lo_alert:100;	lo_warn:30;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:5;	coil_bit:0; display_factor:0.1  )                //  41
,(id:21;name:'величина выпр. напр 02-пт ';										signal:420;	val4:-1;	val20:200 ;	units:'V ';		lo_alert:100;	lo_warn:30;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:5;	coil_bit:1; display_factor:0.1  )                // 42

);




AIN_DEFS_SHORT : ARRAY [1..21] OF TAinDef = (

 (id:1;	name:'конц O2/н2';											signal:-420;	val4:0;	        val20:1;	units:'%';		lo_alert:0.5;	lo_warn:0.1;	hi_warn:0.75;	hi_alert:0.95;	coil_byte:2;	coil_bit:5; display_factor:1000; trm_factor:1.0 )                // 22      was hi_warn:0.5
,(id:2;	name:'конц H2/о2 ';											signal:-420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:0.2;	hi_warn:1;		hi_alert:1.85;	coil_byte:2;	coil_bit:6; display_factor:1000  )                // 23
,(id:3;	name:'давл Н2 рег';							                signal:-420;	val4:0;	        val20:16;	units:'кгс/см2 ';	lo_alert:8;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:10;	coil_byte:2;	coil_bit:7; display_factor:100  )                // 24
,(id:4;	name:'перen P рег';						                signal:-420;	val4:-315;	val20:315;	units:'мм в. ст. ';     lo_alert:0;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:20.0;	coil_byte:3;	coil_bit:0; display_factor:100  )                // 25
,(id:5;	name:'выпр ток 01';                                                                                     signal:-420;	val4:0;	        val20:1500;     units:'A ';		lo_alert:700;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:3;	coil_bit:1; display_factor:10000  )                // 26
,(id:6;	name:'выпр ток 02';                                                                                     signal:-420;	val4:0;	        val20:1500;     units:'A ';		lo_alert:700;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:3;	coil_bit:2; display_factor:10000  )                // 27
,(id:7;	name:'нар изо 1 ';	                                                                                signal:-420;	val4:-1;	val20:100;	units:'B ';		lo_alert:50;	lo_warn:NAN;	hi_warn:2;		hi_alert:NAN;	coil_byte:3;	coil_bit:3; display_factor:10  )                // 28
,(id:8;	name:'нар изо 2 ';	                                                                                signal:-420;	val4:-1;	val20:100;	units:'B ';		lo_alert:50;	lo_warn:NAN;	hi_warn:2;		hi_alert:NAN;	coil_byte:3;	coil_bit:4; display_factor:10  )                // 29
,(id:9;	name:'T электр 1 ';										signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:75;	hi_alert:NAN;	coil_byte:3;	coil_bit:5; display_factor:10  )                // 30
,(id:10;name:'T H2 эл 1 ';									        signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:3;	coil_bit:6; display_factor:10  )                // 31
,(id:11;name:'T O2 эл 1 ';										signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:3;	coil_bit:7; display_factor:10  )                // 32
,(id:12;name:'T электр 2 ';										signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:75;	hi_alert:NAN;	coil_byte:4;	coil_bit:0; display_factor:10  )                // 33
,(id:13;name:'T H2 эл 2 ';									signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:4;	coil_bit:1; display_factor:10  )                // 34
,(id:14;name:'T O2 эл 2 ';									signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:4;	coil_bit:2; display_factor:10  )  //*             // 35
,(id:15;name:'конц H2 возд 1';	 								signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:3; display_factor:10  )                // 36
,(id:16;name:'конц H2 возд 2';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:4; display_factor:10  )                // 37
,(id:17;name:'конц H2 возд 3';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:5; display_factor:10  )                // 38
,(id:18;name:'конц H2 возд 4';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:6; display_factor:10  )                // 39
,(id:19;name:'сод O2 возд';								                signal:420;	val4:0;	        val20:30;	units:'% ';		lo_alert:10;	lo_warn:19;	hi_warn:23;	hi_alert:23;	coil_byte:4;	coil_bit:7; display_factor:10  )                // 40
,(id:20;name:'выпр напр 01';										signal:420;	val4:-1;	val20:200 ;     units:'V ';             lo_alert:100;	lo_warn:30;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:5;	coil_bit:0; display_factor:0.1  )                //  41
,(id:21;name:'выпр напр 02';										signal:420;	val4:-1;	val20:200 ;	units:'V ';		lo_alert:100;	lo_warn:30;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:5;	coil_bit:1; display_factor:0.1  )                // 42

);




AIN_DEFS_NOW : ARRAY [1..21] OF TAinDef = (

 (id:1;	name:'конц O2/н2';											signal:-420;	val4:0;	        val20:1;	units:'%';		lo_alert:0.5;	lo_warn:0.1;	hi_warn:0.75;	hi_alert:0.95;	coil_byte:2;	coil_bit:5; display_factor:1000; trm_factor:1.0 )                // 22      was hi_warn:0.5
,(id:2;	name:'конц H2/о2 ';											signal:-420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:0.2;	hi_warn:1;		hi_alert:1.85;	coil_byte:2;	coil_bit:6; display_factor:1000  )                // 23
,(id:3;	name:'давл Н2 рег';							                signal:-420;	val4:0;	        val20:16;	units:'кгс/см2 ';	lo_alert:8;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:10;	coil_byte:2;	coil_bit:7; display_factor:100  )                // 24
,(id:4;	name:'перen P рег';						                signal:-420;	val4:-315;	val20:315;	units:'мм в. ст. ';     lo_alert:0;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:20.0;	coil_byte:3;	coil_bit:0; display_factor:100  )                // 25
,(id:5;	name:'выпр ток 01';                                                                                     signal:-420;	val4:0;	        val20:1500;     units:'A ';		lo_alert:700;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:3;	coil_bit:1; display_factor:10000  )                // 26
,(id:6;	name:'выпр ток 02';                                                                                     signal:-420;	val4:0;	        val20:1500;     units:'A ';		lo_alert:700;	lo_warn:NAN;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:3;	coil_bit:2; display_factor:10000  )                // 27
,(id:7;	name:'нар изо 1 ';	                                                                                signal:-420;	val4:-1;	val20:100;	units:'B ';		lo_alert:50;	lo_warn:NAN;	hi_warn:2;		hi_alert:NAN;	coil_byte:3;	coil_bit:3; display_factor:10  )                // 28
,(id:8;	name:'нар изо 2 ';	                                                                                signal:-420;	val4:-1;	val20:100;	units:'B ';		lo_alert:50;	lo_warn:NAN;	hi_warn:2;		hi_alert:NAN;	coil_byte:3;	coil_bit:4; display_factor:10  )                // 29
,(id:9;	name:'T электр 1 ';										signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:75;	hi_alert:NAN;	coil_byte:3;	coil_bit:5; display_factor:10  )                // 30
,(id:10;name:'T H2 эл 1 ';									        signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:3;	coil_bit:6; display_factor:10  )                // 31
,(id:11;name:'T O2 эл 1 ';										signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:3;	coil_bit:7; display_factor:10  )                // 32
,(id:12;name:'T электр 2 ';										signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:75;	hi_alert:NAN;	coil_byte:4;	coil_bit:0; display_factor:10  )                // 33
,(id:13;name:'T H2 эл 2 ';									signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:4;	coil_bit:1; display_factor:10  )                // 34
,(id:14;name:'T O2 эл 2 ';									signal:3;	val4:0;	        val20:105;	units:'*C ';		lo_alert:50;	lo_warn:NAN;	hi_warn:85;	hi_alert:NAN;	coil_byte:4;	coil_bit:2; display_factor:10  )  //*             // 35
,(id:15;name:'конц H2 возд 1';	 								signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:3; display_factor:10  )                // 36
,(id:16;name:'конц H2 возд 2';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:4; display_factor:10  )                // 37
,(id:17;name:'конц H2 возд 3';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:5; display_factor:10  )                // 38
,(id:18;name:'конц H2 возд 4';									signal:420;	val4:0;	        val20:2;	units:'% ';		lo_alert:1;	lo_warn:NAN;	hi_warn:0.4;	hi_alert:1;	coil_byte:4;	coil_bit:6; display_factor:10  )                // 39
,(id:19;name:'сод O2 возд';								                signal:420;	val4:0;	        val20:30;	units:'% ';		lo_alert:10;	lo_warn:19;	hi_warn:23;	hi_alert:23;	coil_byte:4;	coil_bit:7; display_factor:10  )                // 40
,(id:20;name:'выпр напр 01';										signal:420;	val4:-1;	val20:200 ;     units:'V ';             lo_alert:100;	lo_warn:30;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:5;	coil_bit:0; display_factor:0.1  )                //  41
,(id:21;name:'выпр напр 02';										signal:420;	val4:-1;	val20:200 ;	units:'V ';		lo_alert:100;	lo_warn:30;	hi_warn:NAN;	hi_alert:NAN;	coil_byte:5;	coil_bit:1; display_factor:0.1  )                // 42

);

var
AINS_FROM_0_NOW_written:Boolean=false;
AINS_FROM_0_NOW : ARRAY [0..20] OF Double ;


implementation




end.

