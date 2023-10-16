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
  parameter Real iniPlaTim(final quantity="Time", final unit="s")= 600
    "Time to hold return temperature to initial setpoint after plant being enabled"
    annotation (Dialog(tab="Advanced"));
  parameter Real ramTim(final quantity="Time", final unit="s") = 600
    "Time to ramp return water temperature setpoint from initial value to calculated one"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chillers proven on status: true=ON"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpeParLoaRat(
    final unit="1",
    final min=0,
    final max=1) "Current plant partial load ratio"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-220,-70},{-180,-30}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatRetSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{180,-130},{220,-90}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Add conWatRet
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.MultiMin lifMax(
    final nin=nChi) "Maximum chiller LIFT"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLifMin[nChi](
    final k=LIFT_min)
    "Minimum LIFT of chillers"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zeoCon[nChi](
    final k=fill(0, nChi)) "Zero constant"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax lifMin(
    final nin=nChi) "Minimum enabled chiller LIFT"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract coeA
    "Coefficient A"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract coeB "Coefficient B"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro "Product of inputs"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Controls.OBC.CDL.Reals.Min min "Minimum value of two inputs"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Reals.Max tarLif "Target chiller LIFT"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zeoTim(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxRamTim(
    final k=ramTim)
    "Time to change the return water temperature from initial value to setpoint"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delPlaEna(
    final delayTime=iniPlaTim)
    "Delay plant enabling status"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer chaTim
    "Count the time after starting to ramp condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant desConWatRet[nChi](
    final k=TConWatRet_nominal)
    "Design condenser water return (condenser leaving) temperature of each chiller"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minChiWatSup[nChi](
    final k=TChiWatSupMin)
    "Lowest chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract maxLif[nChi]
    "Maximum LIFT of each chiller"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=-10*5/9)
    "Output sum of input and a parameter"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin lowDesConWatRet(
    final nin=nChi)
    "Lowest design condenser water return temperature"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1.1) "Gain factor"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));

equation
  connect(uChi, swi.u2)
    annotation (Line(points={{-200,80},{-82,80}},  color={255,0,255}));
  connect(zeoCon.y, swi.u3)
    annotation (Line(points={{-98,60},{-90,60},{-90,72},{-82,72}},
      color={0,0,127}));
  connect(chiLifMin.y, swi.u1)
    annotation (Line(points={{-98,100},{-90,100},{-90,88},{-82,88}},
      color={0,0,127}));
  connect(lifMax.y, coeA.u1)
    annotation (Line(points={{-58,140},{-10,140},{-10,106},{-2,106}}, color={0,0,127}));
  connect(lifMin.y, coeA.u2)
    annotation (Line(points={{-18,80},{-10,80},{-10,94},{-2,94}}, color={0,0,127}));
  connect(lifMax.y, coeB.u1)
    annotation (Line(points={{-58,140},{-10,140},{-10,146},{78,146}}, color={0,0,127}));
  connect(coeB.y, add2.u1)
    annotation (Line(points={{102,140},{110,140},{110,56},{118,56}}, color={0,0,127}));
  connect(pro.y, add2.u2)
    annotation (Line(points={{102,50},{110,50},{110,44},{118,44}}, color={0,0,127}));
  connect(lifMax.y, min.u2)
    annotation (Line(points={{-58,140},{-50,140},{-50,-16},{-22,-16}},
      color={0,0,127}));
  connect(add2.y, min.u1)
    annotation (Line(points={{142,50},{160,50},{160,20},{-40,20},{-40,-4},{-22,-4}},
      color={0,0,127}));
  connect(min.y, tarLif.u2)
    annotation (Line(points={{2,-10},{10,-10},{10,-16},{18,-16}},
      color={0,0,127}));
  connect(lifMin.y, tarLif.u1)
    annotation (Line(points={{-18,80},{10,80},{10,-4},{18,-4}}, color={0,0,127}));
  connect(tarLif.y, conWatRet.u1)
    annotation (Line(points={{42,-10},{60,-10},{60,-24},{78,-24}},
      color={0,0,127}));
  connect(TChiWatSupSet, conWatRet.u2)
    annotation (Line(points={{-200,-50},{60,-50},{60,-36},{78,-36}},
      color={0,0,127}));
  connect(swi.y, lifMin.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={0,0,127}));
  connect(uPla, delPlaEna.u)
    annotation (Line(points={{-200,-110},{-142,-110}},
      color={255,0,255}));
  connect(delPlaEna.y, chaTim.u)
    annotation (Line(points={{-118,-110},{-82,-110}}, color={255,0,255}));
  connect(zeoTim.y, lin.x1)
    annotation (Line(points={{62,-80},{80,-80},{80,-102},{138,-102}},
      color={0,0,127}));
  connect(chaTim.y, lin.u)
    annotation (Line(points={{-58,-110},{138,-110}}, color={0,0,127}));
  connect(maxRamTim.y, lin.x2)
    annotation (Line(points={{2,-140},{20,-140},{20,-114},{138,-114}},
      color={0,0,127}));
  connect(conWatRet.y, lin.f2)
    annotation (Line(points={{102,-30},{120,-30},{120,-118},{138,-118}},
      color={0,0,127}));
  connect(lin.y, TConWatRetSet)
    annotation (Line(points={{162,-110},{200,-110}}, color={0,0,127}));
  connect(uOpeParLoaRat, pro.u2)
    annotation (Line(points={{-200,20},{-60,20},{-60,44},{78,44}}, color={0,0,127}));
  connect(desConWatRet.y, maxLif.u1)
    annotation (Line(points={{-138,140},{-130,140},{-130,146},{-122,146}}, color={0,0,127}));
  connect(maxLif.y,lifMax.u)
    annotation (Line(points={{-98,140},{-82,140}}, color={0,0,127}));
  connect(lowDesConWatRet.y, addPar.u)
    annotation (Line(points={{-58,-80},{-22,-80}}, color={0,0,127}));
  connect(addPar.y, lin.f1)
    annotation (Line(points={{2,-80},{20,-80},{20,-106},{138,-106}}, color={0,0,127}));
  connect(desConWatRet.y, lowDesConWatRet.u)
    annotation (Line(points={{-138,140},{-130,140},{-130,-80},{-82,-80}},
      color={0,0,127}));
  connect(minChiWatSup.y, maxLif.u2) annotation (Line(points={{-138,100},{-134,100},
          {-134,134},{-122,134}}, color={0,0,127}));
  connect(coeA.y, gai.u)
    annotation (Line(points={{22,100},{38,100}}, color={0,0,127}));
  connect(gai.y, coeB.u2) annotation (Line(points={{62,100},{70,100},{70,134},{78,
          134}}, color={0,0,127}));
  connect(gai.y, pro.u1) annotation (Line(points={{62,100},{70,100},{70,56},{78,
          56}}, color={0,0,127}));
annotation (
  defaultComponentName="conWatRetSet",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-160},{180,160}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Text(
          extent={{-120,146},{100,108}},
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
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – Central
Plants and Hydronic Systems (Draft on March 23, 2020), section 5.2.12.2, item 2.d and m.
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
