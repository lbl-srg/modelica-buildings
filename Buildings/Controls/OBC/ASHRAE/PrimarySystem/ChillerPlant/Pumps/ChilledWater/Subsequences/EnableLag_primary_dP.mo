within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block EnableLag_primary_dP
  "Sequences for enabling and disabling lag pumps for primary-only plants using differential pressure pump speed control"
  parameter Integer nPum = 2 "Total number of pumps";
  parameter Real timPer(
    final unit="s",
    final quantity="Time")=600
      "Delay time period for enabling and disabling lag pumps";
  parameter Real staCon = -0.03 "Constant used in the staging equation"
    annotation (Dialog(tab="Advanced"));
  parameter Real relFloHys = 0.01
    "Constant value used in hysteresis for checking relative flow rate"
    annotation (Dialog(tab="Advanced"));
  parameter Integer nPum_nominal(
    final max = nPum,
    final min = 1) = nPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real VChiWat_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1e-6)=0.5
    "Total plant design chilled water flow rate"
    annotation (Dialog(group="Nominal conditions"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Chilled water flow"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-58},{-100,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "Next lag pump status, a rising edge indicates that next lag pump should be enabled"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDown
    "Last lag pump status, a falling edge indicates that last lag pump should be disabled"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=(-1)*relFloHys,
    final uHigh=relFloHys)
    "Check if condition for enabling next lag pump is satisfied"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=(-1)*relFloHys,
    final uHigh=relFloHys)
    "Check if condition for disabling last lag pump is satisfied"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter chiWatFloRat(
    final k=1/VChiWat_flow_nominal) "Chiller water flow ratio"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=staCon) "Add parameter"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=staCon) "Add parameter"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=timPer)
    "Check if the time is greater than delay time period"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=timPer)
    "Check if the time is greater than delay time period"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    "Convert boolean input to integer number"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numOpePum(final nin=nPum)
    "Total number of operating pumps"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer to real"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-1) "Add real inputs"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Find inputs difference"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Find inputs difference"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaNexLag
    "Enabling next lag pump"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch shuLasLag
    "Shut off last lag pump"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Logical true"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "Rising edge"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1 "Rising edge"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter nomPum(
    final k=1/nPum_nominal)
    "Pump number ratio"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter nomPum1(
    final k=1/nPum_nominal)
    "Pump number ratio"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(VChiWat_flow,chiWatFloRat. u)
    annotation (Line(points={{-160,80},{-122,80}}, color={0,0,127}));
  connect(uChiWatPum,booToInt. u)
    annotation (Line(points={{-160,0},{-132,0}}, color={255,0,255}));
  connect(booToInt.y,numOpePum. u)
    annotation (Line(points={{-108,0},{-92,0}},
      color={255,127,0}));
  connect(numOpePum.y,intToRea. u)
    annotation (Line(points={{-68,0},{-52,0}},color={255,127,0}));
  connect(sub2.y,hys. u)
    annotation (Line(points={{-58,40},{-42,40}}, color={0,0,127}));
  connect(sub1.y,hys1. u)
    annotation (Line(points={{-58,-80},{-42,-80}}, color={0,0,127}));
  connect(addPar.y, sub2.u2)
    annotation (Line(points={{62,0},{70,0},{70,20},{-90,20},{-90,34},{-82,34}},
      color={0,0,127}));
  connect(intToRea.y, addPar1.u)
    annotation (Line(points={{-28,0},{-10,0},{-10,-20},{-90,-20},{-90,-40},{-82,
          -40}},
      color={0,0,127}));
  connect(addPar2.y, sub1.u1)
    annotation (Line(points={{22,-40},{30,-40},{30,-60},{-90,-60},{-90,-74},{-82,
          -74}},  color={0,0,127}));
  connect(chiWatFloRat.y, sub2.u1)
    annotation (Line(points={{-98,80},{-90,80},{-90,46},{-82,46}}, color={0,0,127}));
  connect(chiWatFloRat.y, sub1.u2)
    annotation (Line(points={{-98,80},{-90,80},{-90,60},{-100,60},{-100,-86},
      {-82,-86}}, color={0,0,127}));
  connect(con.y, enaNexLag.u1)
    annotation (Line(points={{62,120},{90,120},{90,48},{98,48}}, color={255,0,255}));
  connect(con.y, shuLasLag.u3)
    annotation (Line(points={{62,120},{90,120},{90,-88},{98,-88}}, color={255,0,255}));
  connect(shuLasLag.y, yDown)
    annotation (Line(points={{122,-80},{160,-80}}, color={255,0,255}));
  connect(enaNexLag.y, yUp)
    annotation (Line(points={{122,40},{160,40}}, color={255,0,255}));
  connect(con1.y, enaNexLag.u3)
    annotation (Line(points={{62,-40},{80,-40},{80,32},{98,32}},
      color={255,0,255}));
  connect(con1.y, shuLasLag.u1)
    annotation (Line(points={{62,-40},{80,-40},{80,-72},{98,-72}},
      color={255,0,255}));
  connect(edg.y, not1.u)
    annotation (Line(points={{-18,-140},{-2,-140}}, color={255,0,255}));
  connect(edg.u, pre.y)
    annotation (Line(points={{-42,-140},{-58,-140}}, color={255,0,255}));
  connect(hys1.y, and2.u1)
    annotation (Line(points={{-18,-80},{-14,-80},{-14,-120},{38,-120}},
      color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{22,-140},{30,-140},{30,-128},{38,-128}},
      color={255,0,255}));
  connect(and2.y, tim1.u)
    annotation (Line(points={{62,-120},{80,-120},{80,-104},{-6,-104},{-6,-80},
      {-2,-80}}, color={255,0,255}));
  connect(edg1.y, not2.u)
    annotation (Line(points={{-18,100},{-2,100}}, color={255,0,255}));
  connect(edg1.u, pre1.y)
    annotation (Line(points={{-42,100},{-58,100}}, color={255,0,255}));
  connect(not2.y, and1.u1)
    annotation (Line(points={{22,100},{30,100},{30,80},{38,80}}, color={255,0,255}));
  connect(hys.y, and1.u2)
    annotation (Line(points={{-18,40},{-12,40},{-12,72},{38,72}}, color={255,0,255}));
  connect(and1.y, tim.u)
    annotation (Line(points={{62,80},{70,80},{70,66},{-6,66},{-6,40},{-2,40}},
      color={255,0,255}));
  connect(tim.passed, enaNexLag.u2) annotation (Line(points={{22,32},{60,32},{60,
          40},{98,40}}, color={255,0,255}));
  connect(tim.passed, pre1.u) annotation (Line(points={{22,32},{60,32},{60,60},{
          -86,60},{-86,100},{-82,100}}, color={255,0,255}));
  connect(tim1.passed, shuLasLag.u2) annotation (Line(points={{22,-88},{60,-88},
          {60,-80},{98,-80}}, color={255,0,255}));
  connect(tim1.passed, pre.u) annotation (Line(points={{22,-88},{60,-88},{60,-100},
          {-100,-100},{-100,-140},{-82,-140}}, color={255,0,255}));
  connect(intToRea.y, nomPum.u)
    annotation (Line(points={{-28,0},{-2,0}}, color={0,0,127}));
  connect(nomPum.y, addPar.u)
    annotation (Line(points={{22,0},{38,0}}, color={0,0,127}));
  connect(addPar1.y, nomPum1.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={0,0,127}));
  connect(nomPum1.y, addPar2.u)
    annotation (Line(points={{-18,-40},{-2,-40}}, color={0,0,127}));

annotation (
  defaultComponentName="enaLagChiPum",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,52},{-38,30}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-98,-24},{-34,-48}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{64,48},{98,34}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUp"),
        Text(
          extent={{62,-26},{96,-50}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yDown")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}})),
  Documentation(info="<html>
<p>
Block that enable and disable lag primary chilled water pump, for plants
with headered primary chilled water pumps,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020),
section 5.2.6 Primary chilled water pumps, part 5.2.6.6.
</p>
<p>
Chilled water pump shall be staged as a function of chilled water flow ratio (CHWFR),
i.e. the ratio of current chilled water flow <code>VChiWat_flow</code> to design
flow <code>VChiWat_flow_nominal</code>, and the number of pumps <code>num_nominal</code>
that operate at design conditions. Pumps are assumed to be equally sized.
</p>
<pre>
                  VChiWat_flow
     CHWFR = ----------------------
              VChiWat_flow_nominal
</pre>
<p>
1. Start the next lag pump <code>yNexLagPum</code> whenever the following is
true for 10 minutes:
</p>
<pre>
              Number_of_operating_pumps
     CHWFR &gt; ---------------------------  - 0.03
                       num_nominal
</pre>
<p>
2. Shut off the last lag pump whenever the following is true for 10 minutes:
</p>
<pre>
              Number_of_operating_pumps - 1
     CHWFR &le; -------------------------------  - 0.03
                       num_nominal
</pre>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLag_primary_dP;
