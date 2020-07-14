within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model HeatExchanger
  "Controller for district heat exchanger secondary loop"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_val1Hex
    "Set to true in case of control valve on district side, false in case of a pump"
    annotation(Evaluate=true);
  parameter Boolean have_val2Hex
    "Set to true in case of control valve on secondary side"
    annotation(Evaluate=true);
  parameter Real spePum1HexMin(final unit="1") = 0.1
    "Heat exchanger primary pump minimum speed (fractional)"
    annotation(Dialog(enable=not have_val1Hex));
  parameter Real yVal1HexMin(final unit="1") = 0.1
    "Minimum valve opening for temperature measurement (fractional)"
    annotation(Dialog(enable=have_val1Hex));
  parameter Real spePum2HexMin(final unit="1") = 0.1
    "Heat exchanger secondary pump minimum speed (fractional)";
  parameter Modelica.SIunits.TemperatureDifference dT2HexSet[2]
    "Secondary side deltaT set-point schedule (index 1 for heat rejection)";
  parameter Real k[2]
    "Gain schedule for controller (index 1 for heat rejection)";
  final parameter Real kNor[2] = k ./ k[1]
    "Normalized gain schedule for controller (index 1 for heat rejection)";
  parameter Modelica.SIunits.Time Ti(min=0)
    "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatEnt(
    final unit="K", displayUnit="degC")
    "District heat exchanger secondary water entering temperature" annotation (
      Placement(transformation(extent={{-260,-20},{-220,20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatLvg(
    final unit="K", displayUnit="degC")
    "District heat exchanger secondary water leaving temperature" annotation (
      Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (index 1 for condenser)"
    annotation (Placement(transformation(extent={{-260,40},{-220,80}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1Hex(final unit="1")
    "District heat exchanger primary control signal" annotation (Placement(
      transformation(extent={{220,0},{260,40}}), iconTransformation(extent={{
        100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum2Hex(final unit="1")
    "District heat exchanger secondary pump control signal" annotation (
      Placement(transformation(extent={{220,-40},{260,0}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal2Hex(final unit="1") if
       have_val2Hex
    "District heat exchanger secondary valve control signal"
    annotation (
      Placement(transformation(extent={{220,-80},{260,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT2(k2=-1) "Compute deltaT"
    annotation (Placement(transformation(extent={{-170,-30},{-150,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs absDelT2 "Absolute value"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(final k=0)
    "Zero pump speed representing off command"
    annotation (Placement(transformation(extent={{88,-30},{108,-10}})));
  Buildings.Controls.Continuous.LimPID con1Hex(
    final k=1,
    final Ti=Ti,
    final reset=Buildings.Types.Reset.Parameter,
    final reverseActing=true,
    final yMin=0,
    final yMax=1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Primary circuit controller"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Maximum between control signal and minimum speed or opening"
    annotation (Placement(transformation(extent={{88,10},{108,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff1
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{140,10},{160,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant min1(final k=if
    have_val1Hex then yVal1HexMin else spePum1HexMin)
    "Minimum pump speed or actuator opening"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Control signal for secondary side (from supervisory)" annotation (
      Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold      greThr(threshold=
        Modelica.Constants.eps) "Check if secondary side is enabled"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "At least one valve is open and HX circuit is enabled"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold heaRej(threshold=0.9)
    "Heat rejection if condenser isolation valve is open"
    annotation (Placement(transformation(extent={{-170,70},{-150,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cooRej(threshold=0.9)
    "Cold rejection if evaporator isolation valve is open"
    annotation (Placement(transformation(extent={{-170,30},{-150,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 "At least one valve is open "
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro "Gain scheduling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-40})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1 "Gain scheduling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={36,-20})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger idxSch(integerTrue=2,
      integerFalse=1) "Conversion to integer for gain scheduling" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-140})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant schSet[2](k=dT2HexSet)
    "Set-point schedule"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant schGai[2](k=kNor)
    "Gain schedule"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor setAct(nin=2)
    "Actual set-point"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor gaiAct(nin=2) "Actual gain"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max2
    "Maximum between control signal and minimum speed"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant min2(final k=if
        have_val2Hex then 0 else spePum2HexMin)
                       "Minimum pump speed"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff2
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conInt(k=have_val2Hex)
    "Output true in case of control valve on secondary side"
    annotation (Placement(transformation(extent={{140,-70},{160,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiCst
    "Switch between variable or constant speed pump control signal"
    annotation (Placement(transformation(extent={{188,-30},{208,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Maximum pump speed (representing a constant speed pump)"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
equation
  connect(delT2.y, absDelT2.u)
    annotation (Line(points={{-148,-20},{-92,-20}},    color={0,0,127}));
  connect(T2HexWatEnt, delT2.u1) annotation (Line(points={{-240,0},{-180,0},{-180,
          -14},{-172,-14}},       color={0,0,127}));
  connect(T2HexWatLvg, delT2.u2) annotation (Line(points={{-240,-40},{-180,-40},
          {-180,-26},{-172,-26}}, color={0,0,127}));
  connect(swiOff1.y, y1Hex)
    annotation (Line(points={{162,20},{240,20}}, color={0,0,127}));
  connect(off.y, swiOff1.u3) annotation (Line(points={{110,-20},{120,-20},{120,12},
          {138,12}}, color={0,0,127}));
  connect(max1.y, swiOff1.u1) annotation (Line(points={{110,20},{112,20},{112,28},
          {138,28}}, color={0,0,127}));
  connect(u, greThr.u)
    annotation (Line(points={{-240,120},{-172,120}}, color={0,0,127}));
  connect(greThr.y, and2.u1) annotation (Line(points={{-148,120},{-60,120},{-60,
          80},{-12,80}},
                     color={255,0,255}));
  connect(and2.y, swiOff1.u2) annotation (Line(points={{12,80},{132,80},{132,20},
          {138,20}},color={255,0,255}));
  connect(cooRej.y, or1.u2) annotation (Line(points={{-148,40},{-100,40},{-100,52},
          {-92,52}}, color={255,0,255}));
  connect(heaRej.y, or1.u1) annotation (Line(points={{-148,80},{-100,80},{-100,60},
          {-92,60}}, color={255,0,255}));
  connect(or1.y, and2.u2) annotation (Line(points={{-68,60},{-60,60},{-60,72},{-12,
          72}}, color={255,0,255}));
  connect(yValIso[1], heaRej.u) annotation (Line(points={{-240,50},{-240,60},{-200,
          60},{-200,80},{-172,80}}, color={0,0,127}));
  connect(yValIso[2], cooRej.u) annotation (Line(points={{-240,70},{-240,60},{-200,
          60},{-200,40},{-172,40}}, color={0,0,127}));
  connect(and2.y, con1Hex.trigger) annotation (Line(points={{12,80},{40,80},{40,
          0},{52,0},{52,8}}, color={255,0,255}));
  connect(pro.y, con1Hex.u_s) annotation (Line(points={{8.88178e-16,-28},{8.88178e-16,
          20},{48,20}}, color={0,0,127}));
  connect(pro1.y, con1Hex.u_m)
    annotation (Line(points={{48,-20},{60,-20},{60,8}}, color={0,0,127}));
  connect(absDelT2.y, pro1.u1) annotation (Line(points={{-68,-20},{-20,-20},{-20,
          -14},{24,-14}},color={0,0,127}));
  connect(cooRej.y, idxSch.u) annotation (Line(points={{-148,40},{-140,40},{-140,
          -140},{-92,-140}}, color={255,0,255}));
  connect(schSet.y, setAct.u)
    annotation (Line(points={{-68,-60},{-52,-60}}, color={0,0,127}));
  connect(schGai.y, gaiAct.u)
    annotation (Line(points={{-68,-100},{-52,-100}}, color={0,0,127}));
  connect(setAct.y, pro.u1)
    annotation (Line(points={{-28,-60},{-6,-60},{-6,-52}}, color={0,0,127}));
  connect(gaiAct.y, pro.u2)
    annotation (Line(points={{-28,-100},{6,-100},{6,-52}}, color={0,0,127}));
  connect(gaiAct.y, pro1.u2) annotation (Line(points={{-28,-100},{20,-100},{20,-26},
          {24,-26}}, color={0,0,127}));
  connect(idxSch.y, gaiAct.index) annotation (Line(points={{-68,-140},{-40,-140},
          {-40,-112}}, color={255,127,0}));
  connect(idxSch.y, setAct.index) annotation (Line(points={{-68,-140},{-60,-140},
          {-60,-80},{-40,-80},{-40,-72}}, color={255,127,0}));
  connect(con1Hex.y, max1.u1) annotation (Line(points={{71,20},{80,20},{80,26},{
          86,26}}, color={0,0,127}));
  connect(min1.y, max1.u2) annotation (Line(points={{72,-60},{80,-60},{80,14},{86,
          14}}, color={0,0,127}));
  connect(u, max2.u1) annotation (Line(points={{-240,120},{-180,120},{-180,140},
          {80,140},{80,146},{78,146}}, color={0,0,127}));
  connect(min2.y, max2.u2) annotation (Line(points={{62,100},{70,100},{70,134},{
          78,134}}, color={0,0,127}));
  connect(max2.y, swiOff2.u1) annotation (Line(points={{102,140},{120,140},{120,
          128},{138,128}}, color={0,0,127}));
  connect(greThr.y, swiOff2.u2)
    annotation (Line(points={{-148,120},{138,120}}, color={255,0,255}));
  connect(off.y, swiOff2.u3) annotation (Line(points={{110,-20},{120,-20},{120,112},
          {138,112}},      color={0,0,127}));
  connect(swiCst.y,yPum2Hex)
    annotation (Line(points={{210,-20},{240,-20}}, color={0,0,127}));
  connect(swiOff2.y, swiCst.u3) annotation (Line(points={{162,120},{180,120},{180,
          -28},{186,-28}}, color={0,0,127}));
  connect(one.y, swiCst.u1) annotation (Line(points={{162,-20},{170,-20},{170,-12},
          {186,-12}}, color={0,0,127}));
  connect(conInt.y, swiCst.u2) annotation (Line(points={{162,-60},{172,-60},{172,
          -20},{186,-20}}, color={255,0,255}));
  connect(swiOff2.y,yVal2Hex)  annotation (Line(points={{162,120},{180,120},{180,
          -60},{240,-60}}, color={0,0,127}));
annotation (Diagram(
  coordinateSystem(preserveAspectRatio=false,
  extent={{-220,-160},{220,160}})),
  defaultComponentName="conHex",
  Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This blocks implement the control logic for the district heat exchanger loop,
which realizes the interface between the building and the district systems.
</p>
<p>
The secondary side (the building side) is controlled according to the logic 
described in 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold</a>.
(The input signal <code>u</code> is simply constrained by the minimum secondary
pump speed and propagated to the output signal <code>y2Hex</code>.)
</p>
<p>
The primary side (the district side) is enabled to operate if 
</p>
<ul>
<li>
the secondary side is enabled to operate, and
</li>
<li>
the return position of one ambient loop isolation valve is greater than 90%.
</li>
</ul>
<p>
When enabled, the primary pump speed (or valve opening) is modulated with 
a PI loop controlling the temperature difference on the secondary side.
A set point (and gain) scheduling logic is implemented to allow changing the
control parameters based on the active rejection mode (heat or cold rejection) 
of the ETS.
</p>
</html>"));
end HeatExchanger;
