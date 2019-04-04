within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block IdentifyStage "Sequence for identifying current plant stage"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Boolean haveWSE=true "Flag to indicate if there is waterside economizer";
  parameter Boolean havePony=false "Flag to indicate if there is pony chiller";
  parameter Integer nSta=3
    "Total number of stages, zero stage should be seen as one stage"
    annotation (Dialog(enable=havePony));
  parameter Boolean ponChiFlg[nChi]={false for i in 1:nChi}
    "Array of flags indicating which chiller is pony chiller, array size equals to total number of chiller"
    annotation (Dialog(enable=havePony));
  parameter Integer ponChiCou[nSta]={0 for i in 1:nSta}
    "Array of number of operating pony chillers at each stage, array size equals to total number of stage"
    annotation (Dialog(enable=havePony));
  parameter Integer regChiCou[nSta]={i-1 for i in 1:nSta}
    "Array of number of operating regular chillers at each stage, array size equals to total number of stage"
    annotation (Dialog(enable=havePony));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if haveWSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-200,180},{-160,220}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Current plant enabling status"
    annotation (Placement(transformation(extent={{160,190},{180,210}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta
    "Current chiller plant stage index"
    annotation (Placement(transformation(extent={{160,110},{180,130}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

protected
  final parameter Integer staIndVec[nSta]={i-1 for i in 1:nSta}
    "Stage index, {0,1,...,nSta-1}"
    annotation (Dialog(enable=havePony));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=havePony)
    "Indicate if the plant has pony chiller"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChi]
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(final nin=nChi)
    "Total number of operating chillers"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Logical.Not noPon "Logical not"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer ouput"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0) if not havePony
    "Zero constant"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nChi] if havePony "Logical not"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.And enaPonChi[nChi] if havePony
    "Enabled pony chillers"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.And enaRegChi[nChi] if havePony
    "Enabled regular chillers"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChi] if havePony
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nChi] if havePony
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totEnaPonChi(final nin=nChi) if havePony
    "Total number of enabled pony chillers"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totEnaRegChi(final nin=nChi) if havePony
    "Total number of enabled regular chillers"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta] if havePony
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nSta](
    each final k=0) if havePony "Zero constant"
    annotation (Placement(transformation(extent={{-100,-210},{-80,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nSta] if havePony
    "Check equality of integer inputs"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nSta] if havePony
    "Logical switch"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nSta) if havePony
    "Replicate integer input"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1(final nout=nSta) if havePony
    "Replicate integer input"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nSta] if havePony
    "Check equality of integer inputs"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nSta] if havePony
    "Logical switch"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nSta] if havePony
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nSta] if havePony
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nSta] if havePony
    "Check equality of integer inputs"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nSta] if havePony "Logical switch"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final nin=nSta) if havePony
    "Current stage"
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ponChi[nChi](
    final k=ponChiFlg) if havePony "Pony chiller flag"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant ponChiNum[nSta](
    final k=ponChiCou) if havePony "Number of pony chiller at each stage"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant regChiNum[nSta](
    final k=regChiCou) if havePony "Number of regular chiller at each stage"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staInd[nSta](
    final k=staIndVec) if havePony "Stage index"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr
    "Check if there is any enabled chiller"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logicla or"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false) if not haveWSE  "Constant false"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1[nSta] if havePony
    "Check if it is not zero"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nSta] if havePony "Logical and"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and1[nSta] if havePony "Logical and"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[nSta] if havePony
    "Check integer equality"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nSta](
    each final k=0) if havePony "Constant zero"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1[nSta] if havePony "Logical or"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4[nSta] if havePony
    "Check integer equality"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));

equation
  connect(uChi, enaPonChi.u1)
    annotation (Line(points={{-180,20},{-140,20},{-140,60},{-22,60}},
      color={255,0,255}));
  connect(ponChi.y, not2.u)
    annotation (Line(points={{-99,40},{-80,40},{-80,0},{-62,0}},
      color={255,0,255}));
  connect(ponChi.y, enaPonChi.u2)
    annotation (Line(points={{-99,40},{-80,40},{-80,52},{-22,52}},
      color={255,0,255}));
  connect(uChi, enaRegChi.u1)
    annotation (Line(points={{-180,20},{-22,20}}, color={255,0,255}));
  connect(not2.y, enaRegChi.u2)
    annotation (Line(points={{-39,0},{-32,0},{-32,12},{-22,12}},
      color={255,0,255}));
  connect(enaPonChi.y, booToInt1.u)
    annotation (Line(points={{1,60},{18,60}}, color={255,0,255}));
  connect(enaRegChi.y, booToInt2.u)
    annotation (Line(points={{1,20},{18,20}}, color={255,0,255}));
  connect(staInd.y, intToRea.u)
    annotation (Line(points={{-119,-40},{-102,-40}}, color={255,127,0}));
  connect(totEnaPonChi.y, intRep.u)
    annotation (Line(points={{81.7,60},{98,60}}, color={255,127,0}));
  connect(totEnaRegChi.y, intRep1.u)
    annotation (Line(points={{81.7,20},{98,20}}, color={255,127,0}));
  connect(intRep1.y, intEqu1.u2)
    annotation (Line(points={{121,20},{136,20},{136,-16},{-110,-16},{-110,-128},
      {-102,-128}}, color={255,127,0}));
  connect(intRep.y, intEqu.u2)
    annotation (Line(points={{121,60},{140,60},{140,-20},{-106,-20},{-106,-88},
      {-102,-88}}, color={255,127,0}));
  connect(ponChiNum.y, intEqu.u1)
    annotation (Line(points={{-119,-80},{-102,-80}}, color={255,127,0}));
  connect(regChiNum.y, intEqu1.u1)
    annotation (Line(points={{-119,-120},{-102,-120}}, color={255,127,0}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{-79,-80},{-62,-80}},  color={255,0,255}));
  connect(intToRea.y, swi.u1)
    annotation (Line(points={{-79,-40},{-72,-40},{-72,-72},{-62,-72}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-79,-200},{-68,-200},{-68,-88},{-62,-88}},
      color={0,0,127}));
  connect(intToRea.y, swi1.u1)
    annotation (Line(points={{-79,-40},{-72,-40},{-72,-112},{-62,-112}},
      color={0,0,127}));
  connect(intEqu1.y, swi1.u2)
    annotation (Line(points={{-79,-120},{-62,-120}},color={255,0,255}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-79,-200},{-68,-200},{-68,-128},{-62,-128}},
      color={0,0,127}));
  connect(swi1.y, reaToInt1.u)
    annotation (Line(points={{-39,-120},{-22,-120}}, color={0,0,127}));
  connect(swi.y, reaToInt.u)
    annotation (Line(points={{-39,-80},{-22,-80}}, color={0,0,127}));
  connect(reaToInt.y, intEqu2.u1)
    annotation (Line(points={{1,-80},{18,-80}}, color={255,127,0}));
  connect(reaToInt1.y, intEqu2.u2)
    annotation (Line(points={{1,-120},{10,-120},{10,-88},{18,-88}},
      color={255,127,0}));
  connect(intToRea.y, swi2.u1)
    annotation (Line(points={{-79,-40},{-72,-40},{-72,-192},{78,-192}},
      color={0,0,127}));
  connect(uChi, booToInt.u)
    annotation (Line(points={{-180,20},{-140,20},{-140,150},{-122,150}},
      color={255,0,255}));
  connect(mulSumInt.y, intToRea1.u)
    annotation (Line(points={{-58.3,150},{-22,150}}, color={255,127,0}));
  connect(swi3.y, reaToInt2.u)
    annotation (Line(points={{81,120},{98,120}}, color={0,0,127}));
  connect(reaToInt2.y, ySta)
    annotation (Line(points={{121,120},{170,120}}, color={255,127,0}));
  connect(intToRea1.y, swi3.u1)
    annotation (Line(points={{1,150},{40,150},{40,128},{58,128}}, color={0,0,127}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-99,150},{-82,150}}, color={255,127,0}));
  connect(booToInt1.y, totEnaPonChi.u)
    annotation (Line(points={{41,60},{58,60}}, color={255,127,0}));
  connect(booToInt2.y, totEnaRegChi.u)
    annotation (Line(points={{41,20},{58,20}}, color={255,127,0}));
  connect(swi2.y, mulSum.u)
    annotation (Line(points={{101,-200},{118,-200}}, color={0,0,127}));
  connect(con.y, noPon.u)
    annotation (Line(points={{-59,120},{-22,120}}, color={255,0,255}));
  connect(noPon.y, swi3.u2)
    annotation (Line(points={{1,120},{58,120}}, color={255,0,255}));
  connect(zer1.y, swi3.u3)
    annotation (Line(points={{-99,90},{40,90},{40,112},{58,112}}, color={0,0,127}));
  connect(mulSumInt.y, intGreThr.u)
    annotation (Line(points={{-58.3,150},{-40,150},{-40,180},{-22,180}},
      color={255,127,0}));
  connect(intGreThr.y, or2.u2)
    annotation (Line(points={{1,180},{20,180},{20,192},{38,192}}, color={255,0,255}));
  connect(uWSE, or2.u1)
    annotation (Line(points={{-180,200},{38,200}}, color={255,0,255}));
  connect(fal.y, or2.u1)
    annotation (Line(points={{-99,180},{-80,180},{-80,200},{38,200}},
      color={255,0,255}));
  connect(or2.y, yPla)
    annotation (Line(points={{61,200},{170,200}}, color={255,0,255}));
  connect(reaToInt.y, intGreThr1.u)
    annotation (Line(points={{1,-80},{10,-80},{10,-50},{18,-50}}, color={255,127,0}));
  connect(intGreThr1.y, and2.u1)
    annotation (Line(points={{41,-50},{50,-50},{50,-60},{58,-60}},
      color={255,0,255}));
  connect(intEqu2.y, and2.u2)
    annotation (Line(points={{41,-80},{50,-80},{50,-68},{58,-68}},
      color={255,0,255}));
  connect(zer.y, swi2.u3)
    annotation (Line(points={{-79,-200},{-68,-200},{-68,-208},{78,-208}},
      color={0,0,127}));
  connect(intRep1.y, intEqu3.u1)
    annotation (Line(points={{121,20},{136,20},{136,-16},{-110,-16},{-110,-170},
      {18,-170}}, color={255,127,0}));
  connect(conInt.y, intEqu3.u2)
    annotation (Line(points={{-119,-160},{0,-160},{0,-178},{18,-178}},
      color={255,127,0}));
  connect(and2.y, or1.u1)
    annotation (Line(points={{81,-60},{98,-60}}, color={255,0,255}));
  connect(or1.y, swi2.u2)
    annotation (Line(points={{121,-60},{140,-60},{140,-180},{60,-180},{60,-200},
      {78,-200}}, color={255,0,255}));
  connect(mulSum.y, swi3.u3)
    annotation (Line(points={{141,-200},{150,-200},{150,90},{40,90},{40,112},
      {58,112}}, color={0,0,127}));
  connect(intEqu2.y, and1.u1)
    annotation (Line(points={{41,-80},{50,-80},{50,-102},{58,-102}},
      color={255,0,255}));
  connect(conInt.y, intEqu4.u2)
    annotation (Line(points={{-119,-160},{0,-160},{0,-148},{18,-148}},
      color={255,127,0}));
  connect(intEqu4.y, and1.u2)
    annotation (Line(points={{41,-140},{46,-140},{46,-110},{58,-110}},
      color={255,0,255}));
  connect(intEqu3.y, and1.u3)
    annotation (Line(points={{41,-170},{50,-170},{50,-118},{58,-118}},
      color={255,0,255}));
  connect(and1.y, or1.u2)
    annotation (Line(points={{81,-110},{90,-110},{90,-68},{98,-68}},
      color={255,0,255}));
  connect(intRep.y, intEqu4.u1)
    annotation (Line(points={{121,60},{140,60},{140,-20},{-106,-20},{-106,-140},
      {18,-140}}, color={255,127,0}));

annotation (
  defaultComponentName="ideSta",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        borderPattern=BorderPattern.Raised),
        Rectangle(
          extent={{12,30},{26,-30}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,145},{100,105}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(extent={{-80,80},{-40,60}}, lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,74},{-40,66}},
          lineColor={255,255,255},
          textString="Chiller 1"),
        Rectangle(
          extent={{-40,80},{-22,60}},
          lineColor={28,108,200},
          fillColor={170,255,213},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-40,74},{-22,66}},
          lineColor={28,108,200},
          textString="ON"),
        Rectangle(
          extent={{-22,80},{-6,60}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-80,40},{-40,20}}, lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,34},{-40,26}},
          lineColor={255,255,255},
          textString="Chiller 2"),
        Rectangle(
          extent={{-40,40},{-22,20}},
          lineColor={28,108,200},
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,40},{-4,20}},
          lineColor={28,108,200},
          fillColor={170,255,213},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Rectangle(extent={{-80,-60},{-40,-80}}, lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,-66},{-40,-74}},
          lineColor={255,255,255},
          textString="Chiller N"),
        Rectangle(
          extent={{-40,-60},{-24,-80}},
          lineColor={28,108,200},
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,-60},{-6,-80}},
          lineColor={28,108,200},
          fillColor={170,255,213},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-82,-6},{-46,-22}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="......."),
        Text(
          extent={{-22,34},{-4,26}},
          lineColor={28,108,200},
          textString="OFF"),
        Text(
          extent={{-24,-66},{-6,-74}},
          lineColor={28,108,200},
          textString="OFF"),
        Line(points={{12,30},{12,-30}}, color={28,108,200}),
        Line(points={{12,-30},{64,-30}},color={28,108,200}),
        Line(points={{64,-30},{64,30},{12,30}},color={28,108,200}),
        Line(points={{12,20},{64,20}},color={28,108,200}),
        Line(points={{12,10},{64,10}}, color={28,108,200}),
        Line(points={{12,0},{64,0}},  color={28,108,200}),
        Line(points={{12,-10},{64,-10}},color={28,108,200}),
        Line(points={{12,-20},{64,-20}},color={28,108,200}),
        Line(points={{26,30},{26,-30}}, color={28,108,200}),
        Line(points={{44,30},{44,-30}}, color={28,108,200}),
        Text(
          extent={{12,27},{24,23}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="Stage #"),
        Text(
          extent={{27,27},{43,22}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="Regular chiller #"),
        Text(
          extent={{46,28},{60,23}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="Pony chiller #"),
        Text(
          extent={{16,18},{24,14}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="0"),
        Text(
          extent={{16,8},{24,4}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="1"),
        Text(
          extent={{16,-2},{24,-6}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="2"),
        Text(
          extent={{16,-12},{24,-16}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="..."),
        Text(
          extent={{16,-22},{24,-26}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="nSta"),
        Text(
          extent={{28,18},{36,14}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="0"),
        Text(
          extent={{50,18},{58,14}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="0"),
        Text(
          extent={{28,8},{38,2}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="nRegChi_1"),
        Text(
          extent={{50,8},{60,2}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="nPonChi_1"),
        Text(
          extent={{50,-2},{60,-8}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="nPonChi_2"),
        Text(
          extent={{28,-2},{38,-8}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="nRegChi_2"),
        Text(
          extent={{50,-12},{60,-18}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="nPonChi_"),
        Text(
          extent={{28,-12},{38,-18}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="nRegChi_"),
        Text(
          extent={{50,-22},{60,-28}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="nPonChi_n"),
        Text(
          extent={{28,-22},{38,-28}},
          lineColor={28,108,200},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid,
          textString="nRegChi_n"),
        Line(points={{20,-30},{20,-60}}, color={255,127,0}, thickness=0.5),
        Line(points={{20,-60},{100,-60}},color={255,127,0}, thickness=0.5)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-220},{160,220}})),
  Documentation(info="<html>
<p>
This sequence identifies current chiller plant stage according to chiller operating 
status.
</p>
<ol>
<li>
When there is no pony chiller (<code>havePony</code>=false), the sequence assumes 
that stage number equals to number of enabled chillers, i.e. stage 1 means one enabled 
chiller, stage 2 means 2 enabled chillers. etc.
</li>
<li>
when there is pony chiller (<code>havePony</code>=true), array vector <code>ponChiFlg</code>
flags out which chiller is pony chiller. According to input <code>uChi</code> which 
indicates chiller enabling status, the sequence finds out number of enabled pony 
chillers and regular chillers. It then looks into the array vectors
<code>ponChiCou</code> and <code>regChiCou</code>, to find out current stage 
<code>ySta</code>.
</li>
</ol>
<p>
When there is any enabled chiller or waterside economizer is enabled 
(<code>uWSE</code>=true), it indicates plant is enabled (<code>yPla</code>=true).
</p>
</html>", revisions="<html>
<ul>
<li>
March 18, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IdentifyStage;
