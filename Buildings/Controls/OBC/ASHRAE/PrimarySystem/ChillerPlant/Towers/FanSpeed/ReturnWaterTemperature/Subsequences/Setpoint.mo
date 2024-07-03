within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences;
block Setpoint "Calculate condener return water temperature setpoint"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Real LIFT_min[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("TemperatureDifference",nChi))={12, 12}
      "Minimum LIFT of each chiller"
      annotation (Evaluate=true);
  parameter Real TConWatRet_nominal[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi))= {303.15, 303.15}
    "Design condenser water return temperature (condenser leaving) of each chiller"
    annotation (Evaluate=true);
  parameter Real TChiWatSupMin[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi)) = {278.15, 278.15}
    "Minimum chilled water supply temperature of each chiller"
    annotation (Evaluate=true);
  parameter Real iniPlaTim(
    final quantity="Time",
    final unit="s")= 600
    "Time to hold return temperature to initial setpoint after plant being enabled"
    annotation (Dialog(tab="Advanced"));
  parameter Real ramTim(
    final quantity="Time",
    final unit="s") = 600
    "Time to ramp return water temperature setpoint from initial value to calculated one"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chillers proven on status: true=ON"
    annotation (Placement(transformation(extent={{-340,20},{-300,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeParLoaRat(
    final unit="1",
    final min=0,
    final max=1) "Current plant partial load ratio"
    annotation (Placement(transformation(extent={{-340,-60},{-300,-20}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-340,-110},{-300,-70}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-340,-170},{-300,-130}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatRetSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{300,-170},{340,-130}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Add conWatRet
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{220,18},{240,38}})));

protected
  Buildings.Controls.OBC.CDL.Reals.MultiMin lifMax(
    final nin=nChi) "Maximum chiller LIFT"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLifMin[nChi](
    final k=LIFT_min)
    "Minimum LIFT of chillers"
    annotation (Placement(transformation(extent={{-280,60},{-260,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zeoCon[nChi](
    final k=fill(0, nChi)) "Zero constant"
    annotation (Placement(transformation(extent={{-280,0},{-260,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax lifMin(
    final nin=nChi) "Minimum enabled chiller LIFT"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract coeA
    "Coefficient A"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract coeB "Coefficient B"
    annotation (Placement(transformation(extent={{40,124},{60,144}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro "Product of inputs"
    annotation (Placement(transformation(extent={{40,-44},{60,-24}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Add inputs"
    annotation (Placement(transformation(extent={{80,-38},{100,-18}})));
  Buildings.Controls.OBC.CDL.Reals.Min min "Minimum value of two inputs"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Max tarLif "Target chiller LIFT"
    annotation (Placement(transformation(extent={{180,24},{200,44}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zeoTim(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxRamTim(
    final k=ramTim)
    "Time to change the return water temperature from initial value to setpoint"
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delPlaEna(
    final delayTime=iniPlaTim)
    "Delay plant enabling status"
    annotation (Placement(transformation(extent={{-220,-160},{-200,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Timer chaTim
    "Count the time after starting to ramp condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{260,-160},{280,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant desConWatRet[nChi](
    final k=TConWatRet_nominal)
    "Design condenser water return (condenser leaving) temperature of each chiller"
    annotation (Placement(transformation(extent={{-240,160},{-220,180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minChiWatSup[nChi](
    final k=TChiWatSupMin)
    "Lowest chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-240,100},{-220,120}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract maxLif[nChi]
    "Maximum LIFT of each chiller"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=-10*5/9)
    "Output sum of input and a parameter"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin lowDesConWatRet(
    final nin=nChi)
    "Lowest design condenser water return temperature"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1.1) "Gain factor"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));

equation
  connect(uChi, swi.u2)
    annotation (Line(points={{-320,40},{-162,40}}, color={255,0,255}));
  connect(zeoCon.y, swi.u3)
    annotation (Line(points={{-258,10},{-220,10},{-220,32},{-162,32}},
      color={0,0,127}));
  connect(chiLifMin.y, swi.u1)
    annotation (Line(points={{-258,70},{-220,70},{-220,48},{-162,48}},
      color={0,0,127}));
  connect(lifMax.y, coeA.u1)
    annotation (Line(points={{-98,140},{-80,140},{-80,106},{-62,106}},
      color={0,0,127}));
  connect(lifMin.y, coeA.u2)
    annotation (Line(points={{-98,40},{-70,40},{-70,94},{-62,94}},color={0,0,127}));
  connect(lifMax.y, coeB.u1)
    annotation (Line(points={{-98,140},{38,140}},  color={0,0,127}));
  connect(coeB.y, add2.u1)
    annotation (Line(points={{62,134},{70,134},{70,-22},{78,-22}}, color={0,0,127}));
  connect(pro.y, add2.u2)
    annotation (Line(points={{62,-34},{78,-34}}, color={0,0,127}));
  connect(lifMax.y, min.u2)
    annotation (Line(points={{-98,140},{-80,140},{-80,-66},{118,-66}},
      color={0,0,127}));
  connect(add2.y, min.u1)
    annotation (Line(points={{102,-28},{110,-28},{110,-54},{118,-54}},
      color={0,0,127}));
  connect(min.y, tarLif.u2)
    annotation (Line(points={{142,-60},{160,-60},{160,28},{178,28}},
      color={0,0,127}));
  connect(lifMin.y, tarLif.u1)
    annotation (Line(points={{-98,40},{178,40}}, color={0,0,127}));
  connect(tarLif.y, conWatRet.u1)
    annotation (Line(points={{202,34},{218,34}},
      color={0,0,127}));
  connect(TChiWatSupSet, conWatRet.u2)
    annotation (Line(points={{-320,-90},{210,-90},{210,22},{218,22}},
      color={0,0,127}));
  connect(swi.y, lifMin.u)
    annotation (Line(points={{-138,40},{-122,40}}, color={0,0,127}));
  connect(uPla, delPlaEna.u)
    annotation (Line(points={{-320,-150},{-222,-150}},
      color={255,0,255}));
  connect(delPlaEna.y, chaTim.u)
    annotation (Line(points={{-198,-150},{-162,-150}},color={255,0,255}));
  connect(zeoTim.y, lin.x1)
    annotation (Line(points={{-18,-120},{0,-120},{0,-142},{258,-142}},
      color={0,0,127}));
  connect(chaTim.y, lin.u)
    annotation (Line(points={{-138,-150},{258,-150}},color={0,0,127}));
  connect(maxRamTim.y, lin.x2)
    annotation (Line(points={{-78,-180},{-60,-180},{-60,-154},{258,-154}},
      color={0,0,127}));
  connect(conWatRet.y, lin.f2)
    annotation (Line(points={{242,28},{250,28},{250,-158},{258,-158}},
      color={0,0,127}));
  connect(lin.y, TConWatRetSet)
    annotation (Line(points={{282,-150},{320,-150}}, color={0,0,127}));
  connect(uOpeParLoaRat, pro.u2)
    annotation (Line(points={{-320,-40},{38,-40}}, color={0,0,127}));
  connect(desConWatRet.y, maxLif.u1)
    annotation (Line(points={{-218,170},{-200,170},{-200,146},{-162,146}},
      color={0,0,127}));
  connect(maxLif.y,lifMax.u)
    annotation (Line(points={{-138,140},{-122,140}}, color={0,0,127}));
  connect(lowDesConWatRet.y, addPar.u)
    annotation (Line(points={{-138,-120},{-102,-120}}, color={0,0,127}));
  connect(addPar.y, lin.f1)
    annotation (Line(points={{-78,-120},{-60,-120},{-60,-146},{258,-146}},
      color={0,0,127}));
  connect(desConWatRet.y, lowDesConWatRet.u)
    annotation (Line(points={{-218,170},{-200,170},{-200,-120},{-162,-120}},
      color={0,0,127}));
  connect(minChiWatSup.y, maxLif.u2) annotation (Line(points={{-218,110},{-180,
          110},{-180,134},{-162,134}},
                                  color={0,0,127}));
  connect(coeA.y, gai.u)
    annotation (Line(points={{-38,100},{-22,100}}, color={0,0,127}));
  connect(gai.y, coeB.u2) annotation (Line(points={{2,100},{20,100},{20,128},{38,
          128}}, color={0,0,127}));
  connect(gai.y, pro.u1) annotation (Line(points={{2,100},{20,100},{20,-28},{38,
          -28}},color={0,0,127}));
annotation (
  defaultComponentName="conWatRetSet",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-300,-200},{300,200}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,100},{100,-100}},
        textColor={0,0,0},
        textString="S")}),
Documentation(info="<html>
<p>
Block that ouputs condenser water return temperature setpoint <code>TConWatRetSet</code>
for the tower fan speed control to maintain the return temperature at setpoint. This
implementation is for plants with parallel chiller plants only. It is based on
ASHRAE Guideline36-2021, section 5.20.12.2, item a.5 and a.14.
</p>
<p>
The return water temperature setpoint <code>TConWatRetSet</code> shall be the output
of the following equations.
</p>
<pre>
   <code>TConWatRetSet</code> = <code>TChiWatSupSet</code> + LIFT_target
</pre>
<pre>
   LIFT_target = Max(<code>LIFT_min</code>, Min(LIFT_max, A*<code>plaParLoaRat</code> + B))
</pre>
<pre>
   LIFT_max = <code>TConWatRet_nominal</code> - <code>TChiWatSupMin</code>
</pre>
<pre>
   A = 1.1*(LIFT_max - <code>LIFT_min</code>)
</pre>
<pre>
   B = LIFT_max - A
</pre>
<br/>
<ul>
<li>
Where chillers have different <code>LIFT_min</code> values, the <code>LIFT_min</code>
in the above equation shall reset dynamically to equal the highest <code>LIFT_min</code>
of enabled chillers.
</li>
<li>
For plants with parallel chillers only, where chillers have different design
condenser water return temperature<code>TConWatRet_nominal</code> and minimum
chilled water supply temperature <code>TChiWatSupMin</code> values, the LIFT_max
shall be calculated for each chiller and the lowest value used in the above logic.
</li>
</ul>
<p>
Upon plant startup (<code>uPla</code> becomes true), hold <code>TConWatRetSet</code>
at 10 &deg;F less than the minimum <code>TConWatRet_nominal</code> for 10 minutes
(<code>iniPlaTim</code>) before ramping the setpoint to the calculated value above
over 10 minutes (<code>ramTim</code>).
</p>

</html>", revisions="<html>
<ul>
<li>
August 9, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Setpoint;
