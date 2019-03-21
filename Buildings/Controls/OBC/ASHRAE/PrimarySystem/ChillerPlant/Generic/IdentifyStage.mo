within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block IdentifyStage "Sequence for identifying current plant stage"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nSta=3 "Total number of stages, zero stage should be seen as one stage";
  parameter Boolean haveWSE=true "Flag to indicate if there is waterside economizer";
  parameter Boolean havePony=false "Flag to indicate if there is pony chiller";
  parameter Boolean ponChiFlg[nChi]={false, false}
    "Flag to indicate which chiller is pony chiller"
    annotation (Dialog(enable=havePony));
  parameter Integer ponChiCou[nSta]={0,0,0}
    "Total number of operating pony chillers at each stage"
    annotation (Dialog(enable=havePony));
  parameter Integer regChiCou[nSta]={0,1,2}
    "Total number of operating regular chillers at each stage"
    annotation (Dialog(enable=havePony));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if haveWSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Current plant enabling status"
    annotation (Placement(transformation(extent={{160,170},{180,190}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta
    "Current chiller plant stage index"
    annotation (Placement(transformation(extent={{160,80},{180,100}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

protected
  final parameter Integer staIndVec[nSta]={i-1 for i in 1:nSta}
    "Stage index, {0,1,...,nSta-1}"
    annotation (Dialog(enable=havePony));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=havePony)
    "Indicate if the plant has pony chiller"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChi]
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(final nin=nChi)
    "Total number of operating chillers"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not noPon "Logical not"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer ouput"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0) if not havePony
    "Zero constant"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nChi] if havePony "Logical not"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And enaPonChi[nChi] if havePony
    "Enabled pony chillers"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Logical.And enaRegChi[nChi] if havePony
    "Enabled regular chillers"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChi] if havePony
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nChi] if havePony
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totEnaPonChi(final nin=nChi) if havePony
    "Total number of enabled pony chillers"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totEnaRegChi(final nin=nChi) if havePony
    "Total number of enabled regular chillers"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta] if havePony
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nSta](
    final k=0) if havePony "Zero constant"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nSta] if havePony
    "Check integer inputs equality"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nSta] if havePony
    "Logical switch"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nSta) if havePony
    "Replicate integer input"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1(final nout=nSta) if havePony
    "Replicate integer input"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nSta] if havePony
    "Check integer inputs equality"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nSta] if havePony
    "Logical switch"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nSta] if havePony
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nSta] if havePony
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nSta] if havePony
    "Check integer inputs equality"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nSta] if havePony "Logical switch"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum if havePony
    "Current stage"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ponChi[nPonChi](
    final k=ponChiFlg) if havePony "Pony chiller flag"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant ponChiNum[nSta](
    final k=ponChiCou) if havePony "Number of pony chiller at each stage"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant regChiNum[nSta](
    final k=regChiCou) if havePony "Number of regular chiller at each stage"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staInd[nSta](
    final k=staIndVec) if havePony "Stage index"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr
    "Check if there is any enabled chiller"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logicla or"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false) if not haveWSE  "Constant false"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));

equation
  connect(uChi, enaPonChi.u1)
    annotation (Line(points={{-180,-20},{-140,-20},{-140,30},{-22,30}}, color={255,0,255}));
  connect(ponChi.y, not2.u)
    annotation (Line(points={{-99,10},{-80,10},{-80,-30},{-62,-30}}, color={255,0,255}));
  connect(ponChi.y, enaPonChi.u2)
    annotation (Line(points={{-99,10},{-80,10},{-80,22},{-22,22}}, color={255,0,255}));
  connect(uChi, enaRegChi.u1)
    annotation (Line(points={{-180,-20},{-140,-20},{-140,-10},{-22,-10}}, color={255,0,255}));
  connect(not2.y, enaRegChi.u2)
    annotation (Line(points={{-39,-30},{-32,-30},{-32,-18},{-22,-18}}, color={255,0,255}));
  connect(enaPonChi.y, booToInt1.u)
    annotation (Line(points={{1,30},{18,30}}, color={255,0,255}));
  connect(enaRegChi.y, booToInt2.u)
    annotation (Line(points={{1,-10},{18,-10}}, color={255,0,255}));
  connect(staInd.y, intToRea.u)
    annotation (Line(points={{-99,-70},{-62,-70}}, color={255,127,0}));
  connect(totEnaPonChi.y, intRep.u)
    annotation (Line(points={{81.7,30},{98,30}}, color={255,127,0}));
  connect(totEnaRegChi.y, intRep1.u)
    annotation (Line(points={{81.7,-10},{98,-10}}, color={255,127,0}));
  connect(intRep1.y, intEqu1.u2)
    annotation (Line(points={{121,-10},{130,-10},{130,-48},{-80,-48},{-80,-148},
      {-62,-148}}, color={255,127,0}));
  connect(intRep.y, intEqu.u2)
    annotation (Line(points={{121,30},{134,30},{134,-52},{-76,-52},{-76,-108},
      {-62,-108}}, color={255,127,0}));
  connect(ponChiNum.y, intEqu.u1)
    annotation (Line(points={{-99,-100},{-62,-100}}, color={255,127,0}));
  connect(regChiNum.y, intEqu1.u1)
    annotation (Line(points={{-99,-140},{-62,-140}}, color={255,127,0}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{-39,-100},{18,-100}}, color={255,0,255}));
  connect(intToRea.y, swi.u1)
    annotation (Line(points={{-39,-70},{-20,-70},{-20,-92},{18,-92}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-39,-180},{0,-180},{0,-108},{18,-108}}, color={0,0,127}));
  connect(intToRea.y, swi1.u1)
    annotation (Line(points={{-39,-70},{-20,-70},{-20,-132},{18,-132}}, color={0,0,127}));
  connect(intEqu1.y, swi1.u2)
    annotation (Line(points={{-39,-140},{18,-140}}, color={255,0,255}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-39,-180},{0,-180},{0,-148},{18,-148}}, color={0,0,127}));
  connect(swi1.y, reaToInt1.u)
    annotation (Line(points={{41,-140},{58,-140}}, color={0,0,127}));
  connect(swi.y, reaToInt.u)
    annotation (Line(points={{41,-100},{58,-100}}, color={0,0,127}));
  connect(reaToInt.y, intEqu2.u1)
    annotation (Line(points={{81,-100},{98,-100}}, color={255,127,0}));
  connect(reaToInt1.y, intEqu2.u2)
    annotation (Line(points={{81,-140},{90,-140},{90,-108},{98,-108}}, color={255,127,0}));
  connect(intToRea.y, swi2.u1)
    annotation (Line(points={{-39,-70},{-20,-70},{-20,-172},{18,-172}}, color={0,0,127}));
  connect(intEqu2.y, swi2.u2)
    annotation (Line(points={{121,-100},{140,-100},{140,-160},{6,-160},{6,-180},
      {18,-180}}, color={255,0,255}));
  connect(zer.y, swi2.u3)
    annotation (Line(points={{-39,-180},{0,-180},{0,-188},{18,-188}}, color={0,0,127}));
  connect(uChi, booToInt.u)
    annotation (Line(points={{-180,-20},{-140,-20},{-140,130},{-122,130}},
      color={255,0,255}));
  connect(mulSumInt.y, intToRea1.u)
    annotation (Line(points={{-58.3,130},{-22,130}}, color={255,127,0}));
  connect(swi3.y, reaToInt2.u)
    annotation (Line(points={{81,90},{98,90}}, color={0,0,127}));
  connect(reaToInt2.y, ySta)
    annotation (Line(points={{121,90},{170,90}}, color={255,127,0}));
  connect(intToRea1.y, swi3.u1)
    annotation (Line(points={{1,130},{40,130},{40,98},{58,98}}, color={0,0,127}));
  connect(mulSum.y, swi3.u3)
    annotation (Line(points={{81,-180},{150,-180},{150,60},{40,60},{40,82},{58,82}},
      color={0,0,127}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-99,130},{-82,130}}, color={255,127,0}));
  connect(booToInt1.y, totEnaPonChi.u)
    annotation (Line(points={{41,30},{58,30}}, color={255,127,0}));
  connect(booToInt2.y, totEnaRegChi.u)
    annotation (Line(points={{41,-10},{58,-10}}, color={255,127,0}));
  connect(swi2.y, mulSum.u)
    annotation (Line(points={{41,-180},{58,-180}}, color={0,0,127}));
  connect(con.y, noPon.u)
    annotation (Line(points={{-59,90},{-22,90}}, color={255,0,255}));
  connect(noPon.y, swi3.u2)
    annotation (Line(points={{1,90},{58,90}},   color={255,0,255}));
  connect(zer1.y, swi3.u3)
    annotation (Line(points={{-99,60},{40,60},{40,82},{58,82}}, color={0,0,127}));
  connect(mulSumInt.y, intGreThr.u)
    annotation (Line(points={{-58.3,130},{-40,130},{-40,160},{-22,160}},
      color={255,127,0}));
  connect(intGreThr.y, or2.u2)
    annotation (Line(points={{1,160},{20,160},{20,172},{38,172}}, color={255,0,255}));
  connect(uWSE, or2.u1)
    annotation (Line(points={{-180,180},{38,180}}, color={255,0,255}));
  connect(fal.y, or2.u1)
    annotation (Line(points={{-99,160},{-80,160},{-80,180},{38,180}}, color={255,0,255}));
  connect(or2.y, yPla)
    annotation (Line(points={{61,180},{170,180}}, color={255,0,255}));

annotation (
  defaultComponentName="ideSta",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-200},{160,200}})),
  Documentation(info="<html>
<p>
This sequence identifies current chiller plant stage according to chiller operating 
status.
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
