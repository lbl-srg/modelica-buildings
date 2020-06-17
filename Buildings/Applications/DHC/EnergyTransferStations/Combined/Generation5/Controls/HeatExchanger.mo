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
  parameter Modelica.SIunits.TemperatureDifference dT2HexHeaSet
    "Heat exchanger secondary side deltaT set-point in heat rejection";
  parameter Modelica.SIunits.TemperatureDifference dT2HexCooSet
    "Heat exchanger secondary side deltaT set-point in cold rejection";
  parameter Real k(final unit="1/K")=0.1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=0)=60
    "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatEnt(
    final unit="K", displayUnit="degC")
    "District heat exchanger secondary water entering temperature" annotation (
      Placement(transformation(extent={{-260,-40},{-220,0}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatLvg(
    final unit="K", displayUnit="degC")
    "District heat exchanger secondary water leaving temperature" annotation (
      Placement(transformation(extent={{-260,-80},{-220,-40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1Hex(final unit="1")
    "District heat exchanger primary control signal" annotation (Placement(
      transformation(extent={{220,-20},{260,20}}), iconTransformation(extent={{
        100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (index 1 for condenser)"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT2(k2=-1) "Compute deltaT"
    annotation (Placement(transformation(extent={{-170,-50},{-150,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs absDelT2 "Absolute value"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(final k=0)
    "Zero pump speed representing off command"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.Continuous.LimPID con1Hex(
    final k=k,
    final Ti=Ti,
    final reset=Buildings.Types.Reset.Parameter,
    final reverseActing=true,
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y2Hex(final unit="1")
    "District heat exchanger secondary pump control signal" annotation (
      Placement(transformation(extent={{220,-60},{260,-20}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y2Sup
    "Control signal for secondary side (from supervisory)" annotation (
      Placement(transformation(extent={{-260,80},{-220,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold      greThr(threshold=
        Modelica.Constants.eps) "Check if secondary side is enabled"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold heaRej(threshold=0.9)
    "Heat rejection if condenser isolation valve is open"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold cooRej(threshold=0.9)
    "Cold rejection if evaporator isolation valve is open"
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 "At least one valve is open "
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant delT2HexHeaSet(final k=
        abs(dT2HexHeaSet))
    "Heat exchanger secondary side deltaT set-point in heat rejection"
    annotation (Placement(transformation(extent={{-170,-90},{-150,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant delT2HexCooSet(final k=
        abs(dT2HexCooSet))
    "Heat exchanger secondary side deltaT set-point in cold rejection"
    annotation (Placement(transformation(extent={{-170,-130},{-150,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff2
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
equation
  connect(delT2.y, absDelT2.u)
    annotation (Line(points={{-148,-40},{-92,-40}},    color={0,0,127}));
  connect(T2HexWatEnt, delT2.u1) annotation (Line(points={{-240,-20},{-180,-20},
          {-180,-34},{-172,-34}}, color={0,0,127}));
  connect(T2HexWatLvg, delT2.u2) annotation (Line(points={{-240,-60},{-180,-60},
          {-180,-46},{-172,-46}}, color={0,0,127}));
  connect(swiOff1.y, y1Hex)
    annotation (Line(points={{182,0},{240,0}},   color={0,0,127}));
  connect(off.y, swiOff1.u3) annotation (Line(points={{122,-20},{140,-20},{140,-8},
          {158,-8}}, color={0,0,127}));
  connect(multiMax1.y, swiOff1.u1) annotation (Line(points={{72,0},{120,0},{120,
          8},{158,8}}, color={0,0,127}));
  connect(con1Hex.y, multiMax1.u[1])
    annotation (Line(points={{11,0},{30,0},{30,1},{48,1}}, color={0,0,127}));
  connect(min1.y, multiMax1.u[2]) annotation (Line(points={{12,-40},{30,-40},{30,
          -1},{48,-1}}, color={0,0,127}));
  connect(absDelT2.y, con1Hex.u_m)
    annotation (Line(points={{-68,-40},{0,-40},{0,-12}}, color={0,0,127}));
  connect(y2Sup, greThr.u)
    annotation (Line(points={{-240,100},{-112,100}}, color={0,0,127}));
  connect(greThr.y, and2.u1) annotation (Line(points={{-88,100},{-20,100},{-20,40},
          {-12,40}}, color={255,0,255}));
  connect(and2.y, swiOff1.u2) annotation (Line(points={{12,40},{140,40},{140,0},
          {158,0}}, color={255,0,255}));
  connect(y2Sup, y2Hex) annotation (Line(points={{-240,100},{-180,100},{-180,120},
          {200,120},{200,-40},{240,-40}}, color={0,0,127}));
  connect(cooRej.y, or1.u2) annotation (Line(points={{-148,20},{-100,20},{-100,32},
          {-92,32}}, color={255,0,255}));
  connect(heaRej.y, or1.u1) annotation (Line(points={{-148,60},{-100,60},{-100,40},
          {-92,40}}, color={255,0,255}));
  connect(or1.y, and2.u2) annotation (Line(points={{-68,40},{-30,40},{-30,32},{-12,
          32}}, color={255,0,255}));
  connect(yValIso[1], heaRej.u) annotation (Line(points={{-240,30},{-240,40},{-200,
          40},{-200,60},{-172,60}}, color={0,0,127}));
  connect(yValIso[2], cooRej.u) annotation (Line(points={{-240,50},{-240,40},{-200,
          40},{-200,20},{-172,20}}, color={0,0,127}));
  connect(heaRej.y, swiOff2.u2) annotation (Line(points={{-148,60},{-140,60},{-140,
          -100},{-92,-100}}, color={255,0,255}));
  connect(delT2HexHeaSet.y, swiOff2.u1) annotation (Line(points={{-148,-80},{-100,
          -80},{-100,-92},{-92,-92}}, color={0,0,127}));
  connect(delT2HexCooSet.y, swiOff2.u3) annotation (Line(points={{-148,-120},{-100,
          -120},{-100,-108},{-92,-108}}, color={0,0,127}));
  connect(swiOff2.y, con1Hex.u_s) annotation (Line(points={{-68,-100},{-40,-100},
          {-40,0},{-12,0}}, color={0,0,127}));
  connect(or1.y, con1Hex.trigger) annotation (Line(points={{-68,40},{-60,40},{-60,
          -20},{-8,-20},{-8,-12}}, color={255,0,255}));
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
