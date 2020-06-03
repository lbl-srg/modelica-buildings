within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatEnt(
    final unit="K", displayUnit="degC")
    "District heat exchanger secondary water entering temperature" annotation (
      Placement(transformation(extent={{-260,-20},{-220,20}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatLvg(
    final unit="K", displayUnit="degC")
    "District heat exchanger secondary water leaving temperature" annotation (
      Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1Hex(final unit="1")
    "District heat exchanger primary control signal" annotation (Placement(
      transformation(extent={{220,-20},{260,20}}), iconTransformation(extent={{
        100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaHex
    "Control signal enabling heat exchanger operation" annotation (Placement(
        transformation(extent={{-260,80},{-220,120}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (index 1 for condenser)"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT2(k2=-1) "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs absDelT2 "Absolute value"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant delT2HexWatSet(k=abs(
        dT2HexSet)) "District heat exchanger secondary water deltaT set-point"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(final k=0)
    "Zero pump speed representing off command"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.Continuous.LimPID con1(
    final k=k,
    final Ti=Ti,
    final reset=Buildings.Types.Reset.Parameter,
    final reverseAction=false,
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
    annotation (Placement(transformation(extent={{-170,30},{-150,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
      threshold=0.9) "Check if isolation valves are open"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y2Hex(final unit="1")
    "District heat exchanger secondary pump control signal" annotation (
      Placement(transformation(extent={{220,-60},{260,-20}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff2
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{158,-50},{178,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speMax(final k=1)
    "Maximum pump speed"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
equation
  connect(delT2.y, absDelT2.u)
    annotation (Line(points={{-138,-20},{-122,-20}},   color={0,0,127}));
  connect(T2HexWatEnt, delT2.u1) annotation (Line(points={{-240,0},{-180,0},{-180,
          -14},{-162,-14}},       color={0,0,127}));
  connect(T2HexWatLvg, delT2.u2) annotation (Line(points={{-240,-40},{-180,-40},
          {-180,-26},{-162,-26}},       color={0,0,127}));

  connect(swiOff1.y, y1Hex)
    annotation (Line(points={{182,0},{240,0}},   color={0,0,127}));
  connect(off.y, swiOff1.u3) annotation (Line(points={{122,-20},{130,-20},{130,
          -8},{158,-8}}, color={0,0,127}));
  connect(multiMax1.y, swiOff1.u1) annotation (Line(points={{72,0},{110,0},{110,
          8},{158,8}},       color={0,0,127}));
  connect(con1.y, multiMax1.u[1]) annotation (Line(points={{11,0},{30,0},{30,1},
          {48,1}},  color={0,0,127}));
  connect(min1.y, multiMax1.u[2]) annotation (Line(points={{12,-40},{30,-40},{30,
          -1},{48,-1}}, color={0,0,127}));
  connect(multiMax.y, greEquThr.u)
    annotation (Line(points={{-148,40},{-132,40}}, color={0,0,127}));
  connect(greEquThr.y, and2.u2) annotation (Line(points={{-108,40},{-100,40},{-100,
          32},{-62,32}}, color={255,0,255}));
  connect(yValIso, multiMax.u[1:2])
    annotation (Line(points={{-240,40},{-172,40},{-172,39}}, color={0,0,127}));
  connect(uEnaHex, and2.u1) annotation (Line(points={{-240,100},{-80,100},{-80,40},
          {-62,40}},          color={255,0,255}));
  connect(and2.y, con1.trigger) annotation (Line(points={{-38,40},{-20,40},{-20,
          -16},{-8,-16},{-8,-12}}, color={255,0,255}));
  connect(and2.y, swiOff1.u2) annotation (Line(points={{-38,40},{140,40},{140,0},
          {158,0}}, color={255,0,255}));
  connect(delT2HexWatSet.y, con1.u_s)
    annotation (Line(points={{-58,0},{-12,0}}, color={0,0,127}));
  connect(absDelT2.y, con1.u_m)
    annotation (Line(points={{-98,-20},{0,-20},{0,-12}}, color={0,0,127}));
  connect(off.y, swiOff2.u3) annotation (Line(points={{122,-20},{130,-20},{130,
          -48},{156,-48}},
                      color={0,0,127}));
  connect(and2.y, swiOff2.u2) annotation (Line(points={{-38,40},{140,40},{140,
          -40},{156,-40}},
                      color={255,0,255}));
  connect(speMax.y, swiOff2.u1) annotation (Line(points={{122,-80},{150,-80},{
          150,-32},{156,-32}}, color={0,0,127}));
  connect(swiOff2.y, y2Hex)
    annotation (Line(points={{180,-40},{240,-40}}, color={0,0,127}));
annotation (Diagram(
  coordinateSystem(preserveAspectRatio=false,
  extent={{-220,-180},{220,180}})),
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
