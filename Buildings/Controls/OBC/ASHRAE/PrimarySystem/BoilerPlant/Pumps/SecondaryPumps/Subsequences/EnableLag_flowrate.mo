within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences;
block EnableLag_flowrate
  "Sequence for enabling and disabling lag pumps for variable-speed secondary pumps with secondary loop flowrate sensor"

  parameter Integer nPum = 2
    "Total number of pumps";

  parameter Integer nPum_nominal(
    final max = nPum,
    final min = 1) = nPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Nominal conditions"));

  parameter Real timPer(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 600
    "Delay time period for enabling and disabling lag pumps";

  parameter Real staCon(
    final unit="1",
    displayUnit="1") = -0.03
    "Constant used in the staging equation"
    annotation (Dialog(tab="Advanced"));

  parameter Real relFloHys(
    final unit="1",
    displayUnit="1") = 0.01
    "Constant value used in hysteresis for checking relative flow rate"
    annotation (Dialog(tab="Advanced"));

  parameter Real VHotWat_flow_nominal(
    final min=1e-6,
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")=0.5
    "Total plant design hot water flow rate"
    annotation (Dialog(group="Nominal conditions"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-58},{-100,-18}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot water flow rate"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "Next lag pump status"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDown
    "Last lag pump status"
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

  Buildings.Controls.OBC.CDL.Continuous.Gain hotWatFloRat(
    final k=1/VHotWat_flow_nominal)
    "Boiler hot water flow ratio"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=staCon,
    final k=1/nPum_nominal)
    "Add parameter"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=timPer)
    "Count time for which stage-up condition is satisfied"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=timPer)
    "Count time for which stage-down condition is satisfied"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=staCon,
    final k=1/nPum_nominal)
    "Add parameter"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    "Convert boolean input to integer number"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum numOpePum(
    final nin=nPum)
    "Total number of operating pumps"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert Integer to Real"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-1,
    final k=1)
    "Add real inputs"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1)
    "Add real inputs"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k2=-1)
    "Add real inputs"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical Not"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

equation
  connect(VHotWat_flow,hotWatFloRat. u)
    annotation (Line(points={{-160,80},{-122,80}}, color={0,0,127}));

  connect(uHotWatPum,booToInt. u)
    annotation (Line(points={{-160,0},{-82,0}},  color={255,0,255}));

  connect(booToInt.y,numOpePum. u)
    annotation (Line(points={{-58,0},{-42,0}},
      color={255,127,0}));

  connect(numOpePum.y,intToRea. u)
    annotation (Line(points={{-18,0},{-2,0}}, color={255,127,0}));

  connect(intToRea.y,addPar. u)
    annotation (Line(points={{22,0},{38,0}}, color={0,0,127}));

  connect(add2.y,hys. u)
    annotation (Line(points={{-58,40},{-42,40}}, color={0,0,127}));

  connect(add1.y,hys1. u)
    annotation (Line(points={{-58,-80},{-42,-80}}, color={0,0,127}));

  connect(addPar1.y, addPar2.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={0,0,127}));

  connect(addPar.y, add2.u2)
    annotation (Line(points={{62,0},{70,0},{70,20},{-90,20},{-90,34},{-82,34}},
      color={0,0,127}));

  connect(intToRea.y, addPar1.u)
    annotation (Line(points={{22,0},{30,0},{30,-20},{-90,-20},{-90,-40},{-82,-40}},
      color={0,0,127}));

  connect(addPar2.y, add1.u1)
    annotation (Line(points={{-18,-40},{-10,-40},{-10,-60},{-90,-60},{-90,-74},
      {-82,-74}}, color={0,0,127}));

  connect(hotWatFloRat.y, add2.u1)
    annotation (Line(points={{-98,80},{-90,80},{-90,46},{-82,46}}, color={0,0,127}));

  connect(hotWatFloRat.y, add1.u2)
    annotation (Line(points={{-98,80},{-90,80},{-90,60},{-100,60},{-100,-86},
      {-82,-86}}, color={0,0,127}));

  connect(edg.y, not1.u)
    annotation (Line(points={{-18,-140},{-2,-140}}, color={255,0,255}));

  connect(edg.u, pre2.y)
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

  connect(not3.y, yDown)
    annotation (Line(points={{122,-80},{160,-80}}, color={255,0,255}));

  connect(tim.passed, yUp) annotation (Line(points={{22,32},{40,32},{40,40},{
          160,40},{160,40}}, color={255,0,255}));
  connect(tim.passed, pre1.u) annotation (Line(points={{22,32},{40,32},{40,60},
          {-80,60},{-80,84},{-90,84},{-90,100},{-82,100}}, color={255,0,255}));
  connect(tim1.passed, not3.u) annotation (Line(points={{22,-88},{40,-88},{40,
          -80},{98,-80}}, color={255,0,255}));
  connect(tim1.passed, pre2.u) annotation (Line(points={{22,-88},{40,-88},{40,
          -100},{-90,-100},{-90,-140},{-82,-140}}, color={255,0,255}));
annotation (
  defaultComponentName="enaLagSecPum",
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
    graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,150},{100,110}},
        lineColor={0,0,255},
        textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}})),
  Documentation(info="<html>
  <p>
  Block that enables and disables lag secondary hot water pump, for plants with 
  variable-speed secondary pumps and flowrate sensor in secondary loop, according
  to ASHRAE RP-1711, March, 2020 draft, section 5.3.7.3.
  </p>
  <p>
  Hot water pump shall be staged as a function of secondary hot water flow ratio (SHWFR), 
  i.e. the ratio of current hot water flow <code>VHotWat_flow</code> to design
  flow <code>VHotWat_flow_nominal</code>, and the number of pumps <code>num_nominal</code>
  that operate at design conditions. Pumps are assumed to be equally sized.
  </p>
  <pre>
                     VHotWat_flow
        SHWFR = ---------------------- 
                 VHotWat_flow_nominal
  </pre>
  <p>
  1. Start the next lag pump <code>yNexLagPum</code> whenever the following is 
  true for time <code>timPer</code>:
  </p>
  <pre>        
        SHWFR &gt; Number_of_operating_pumps/num_nominal - 0.03                  
  </pre>
  <p>
  2. Shut off the last lag pump whenever the following is true for <code>timPer</code>:
  </p>
  <pre>           
        SHWFR &le; (Number_of_operating_pumps - 1)/num_nominal - 0.03
  </pre>
  </html>", revisions="<html>
  <ul>
  <li>
  August 25, 2020, by Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end EnableLag_flowrate;
