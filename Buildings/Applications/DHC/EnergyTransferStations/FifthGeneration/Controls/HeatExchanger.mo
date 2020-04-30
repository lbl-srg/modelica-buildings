within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls;
model HeatExchanger
  "Controller for district heat exchanger secondary loop"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_val1Hex
    "Set to true in case of control valve on district side, false in case of a pump"
    annotation(Evaluate=true);
  parameter Real spePum1HexMin(final unit="1") = 0.1
    "Heat exchanger primary pump minimum speed (fractional)"
    annotation(Dialog(enable=not have_val1Hex));
  parameter Real yVal1HexMin(final unit="1") = 0.1
    "Minimum valve opening for temperature measurement (fractional)"
    annotation(Dialog(enable=have_val1Hex));
  parameter Real spePum2HexMin(final unit="1") = 0.1
    "Heat exchanger secondary pump minimum speed (fractional)";
  parameter Modelica.SIunits.TemperatureDifference dT1HexSet
    "Heat exchanger primary side deltaT set-point";
  parameter Modelica.SIunits.TemperatureDifference dT2HexSet
    "Heat exchanger secondary side deltaT set-point";
  parameter Real k(final unit="1/K")=0.1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=0)=60
    "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatEnt(final unit="K",
      displayUnit="degc")
    "District heat exchanger secondary water entering temperature" annotation (
      Placement(transformation(extent={{-260,-100},{-220,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatLvg(final unit="K",
      displayUnit="degc")
    "District heat exchanger secondary water leaving temperature" annotation (
      Placement(transformation(extent={{-260,-140},{-220,-100}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y2Hex(final unit="1")
    "District heat exchanger secondary control signal" annotation (Placement(
        transformation(extent={{220,-100},{260,-60}}),iconTransformation(extent=
           {{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uColRej
    "Control signal enabling full cold rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaRej
    "Control signal enabling full heat rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (fractional)"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.Continuous.LimPID conPum2(
    final k=k,
    final Ti=Ti,
    final reset=Buildings.Types.Reset.Parameter,
    final reverseAction=true,
    final yMin=0,
    final yMax=1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Secondary pump controller"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT2(k2=-1) "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs2 "Absolute value"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant delT2HexWatSet(k=abs(
        dT2HexSet)) "District heat exchanger secondary water deltaT set-point"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff2
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{160,-90},{180,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or  enaHex
    "District heat exchanger enabled signal"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe2(final k=
        spePum2HexMin) "Minimum pump speed"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(final k=0)
     "Zero pump speed representing off command"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax2(nin=2)
    "Maximize pump control signal"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1HexWatEnt(
    final unit="K", displayUnit="degc")
    "District heat exchanger primary water entering temperature" annotation (
      Placement(transformation(extent={{-260,-20},{-220,20}}), iconTransformation(
        extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1HexWatLvg(final unit="K",
      displayUnit="degc")
    "District heat exchanger primary water leaving temperature" annotation (
      Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1Hex(final unit="1")
    "District heat exchanger primary control signal" annotation (Placement(
      transformation(extent={{220,-20},{260,20}}), iconTransformation(extent={{
        100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT1(k2=-1) "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1 "Absolute value"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant delT1HexWatSet(k=abs(
        dT1HexSet)) "District heat exchanger primary water deltaT set-point"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.Continuous.LimPID con1(
    final k=k,
    final Ti=Ti,
    final reset=Buildings.Types.Reset.Parameter,
    final reverseAction=true,
    final yMin=0,
    final yMax=1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Primary circuit controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax1(nin=2)
    "Maximize pump control signal"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff1
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant min1(final k=if
    have_val1Hex then yVal1HexMin else spePum1HexMin)
    "Minimum pump speed or actuator opening"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(nin=2) "Max"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
      threshold=0.9) "Check if isolation valves are open"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
equation
  connect(delT2.y, abs2.u)
    annotation (Line(points={{-138,-100},{-122,-100}},
                                                     color={0,0,127}));
  connect(abs2.y, conPum2.u_m)
    annotation (Line(points={{-98,-100},{0,-100},{0,-92}},
                                                         color={0,0,127}));
  connect(delT2HexWatSet.y, conPum2.u_s)
    annotation (Line(points={{-58,-80},{-12,-80}}, color={0,0,127}));
  connect(T2HexWatEnt, delT2.u1) annotation (Line(points={{-240,-80},{-180,-80},
          {-180,-94},{-162,-94}}, color={0,0,127}));
  connect(T2HexWatLvg, delT2.u2) annotation (Line(points={{-240,-120},{-180,-120},
          {-180,-106},{-162,-106}},     color={0,0,127}));
  connect(swiOff2.y, y2Hex)
    annotation (Line(points={{182,-80},{240,-80}}, color={0,0,127}));
  connect(uHeaRej,enaHex. u1) annotation (Line(points={{-240,120},{-200,120},{
          -200,100},{-162,100}},
                         color={255,0,255}));
  connect(uColRej,enaHex. u2) annotation (Line(points={{-240,80},{-200,80},{
          -200,92},{-162,92}},
                     color={255,0,255}));

  connect(conPum2.y, multiMax2.u[1]) annotation (Line(points={{11,-80},{30,-80},
          {30,-79},{48,-79}}, color={0,0,127}));
  connect(T1HexWatEnt, delT1.u1) annotation (Line(points={{-240,0},{-180,0},{-180,
          -14},{-162,-14}},  color={0,0,127}));
  connect(T1HexWatLvg, delT1.u2) annotation (Line(points={{-240,-40},{-180,-40},
          {-180,-26},{-162,-26}},
                                color={0,0,127}));
  connect(delT1.y, abs1.u)
    annotation (Line(points={{-138,-20},{-122,-20}},
                                                 color={0,0,127}));
  connect(abs1.y, con1.u_m)
    annotation (Line(points={{-98,-20},{0,-20},{0,-12}},
                                                   color={0,0,127}));
  connect(delT1HexWatSet.y, con1.u_s)
    annotation (Line(points={{-58,0},{-12,0}},   color={0,0,127}));
  connect(swiOff1.y, y1Hex)
    annotation (Line(points={{182,0},{240,0}},   color={0,0,127}));
  connect(off.y, swiOff1.u3) annotation (Line(points={{122,-40},{140,-40},{140,-8},
          {158,-8}},     color={0,0,127}));
  connect(multiMax1.y, swiOff1.u1) annotation (Line(points={{72,0},{140,0},{140,
          8},{158,8}},       color={0,0,127}));
  connect(minSpe2.y, multiMax2.u[2]) annotation (Line(points={{12,-120},{32,-120},
          {32,-81},{48,-81}}, color={0,0,127}));
  connect(con1.y, multiMax1.u[1]) annotation (Line(points={{11,0},{30,0},{30,1},
          {48,1}},  color={0,0,127}));
  connect(min1.y, multiMax1.u[2]) annotation (Line(points={{12,-40},{30,-40},{30,
          -1},{48,-1}}, color={0,0,127}));
  connect(multiMax2.y, swiOff2.u1) annotation (Line(points={{72,-80},{130,-80},{
          130,-72},{158,-72}},  color={0,0,127}));
  connect(off.y, swiOff2.u3) annotation (Line(points={{122,-40},{140,-40},{140,-88},
          {158,-88}},      color={0,0,127}));
  connect(multiMax.y, greEquThr.u)
    annotation (Line(points={{-178,40},{-162,40}}, color={0,0,127}));
  connect(enaHex.y, and2.u1) annotation (Line(points={{-138,100},{-120,100},{
          -120,40},{-102,40}},
                     color={255,0,255}));
  connect(greEquThr.y, and2.u2) annotation (Line(points={{-138,40},{-130,40},{
          -130,32},{-102,32}},
                         color={255,0,255}));
  connect(and2.y, conPum2.trigger) annotation (Line(points={{-78,40},{-20,40},{
          -20,-96},{-8,-96},{-8,-92}},
                                   color={255,0,255}));
  connect(and2.y, swiOff2.u2) annotation (Line(points={{-78,40},{150,40},{150,
          -80},{158,-80}},
                      color={255,0,255}));
  connect(yValIso, multiMax.u[1:2])
    annotation (Line(points={{-240,40},{-202,40},{-202,39}}, color={0,0,127}));
  connect(enaHex.y, con1.trigger) annotation (Line(points={{-138,100},{-16,100},
          {-16,-16},{-8,-16},{-8,-12}}, color={255,0,255}));
  connect(enaHex.y, swiOff1.u2) annotation (Line(points={{-138,100},{154,100},{
          154,0},{158,0}}, color={255,0,255}));
annotation (Diagram(
  coordinateSystem(preserveAspectRatio=false,
  extent={{-220,-140},{220,140}})),
  defaultComponentName="conHex",
Documentation(info="<html>
<p>
This block computes the output integer <code>ModInd</code> which indicates the energy
rejection index, i.e. heating or cooling energy is rejected and the control signals to turn
on/off and modulates the followings.
</p>
<h4>Heat exchanger district pump</h4>
<p>
The exchanger district <code>pumHexDis</code> is a variable speed pump. It turns on if either
the control signal of the isolation valve <code>uIsoCon</code> or <code>uIsoEva</code> and
<code>rejFulLoa</code> are true, and the flow rate is modulated using a reverse acting PI loop
to maintain the absolute measured temperature difference between <code>TDisHexEnt</code> and
<code>TDisHexLvg</code> equals to <code>dTHex</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2020, by Hagar Elarga:<br/>
Updated the heat exchanger pump controller to operate only if reject full load signal
is true.
</li>
<li>
November 2, 2019, by Hagar Elarga:<br/>
Added the three way valve controller and the documentation.
</li>

</ul>
</html>"));
end HeatExchanger;
