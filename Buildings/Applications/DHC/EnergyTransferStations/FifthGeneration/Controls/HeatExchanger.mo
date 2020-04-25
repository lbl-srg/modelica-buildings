within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls;
model HeatExchanger
  "Controller for district heat exchanger secondary loop"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_valDis
    "Set to true in case of control valve on district side, false in case of a pump"
    annotation(Evaluate=true);
  parameter Real spePum1HexMin(final unit="1") = 0.1
    "Heat exchanger primary pump minimum speed (fractional)";
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
      Placement(transformation(extent={{-260,-80},{-220,-40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatLvg(final unit="K",
      displayUnit="degc")
    "District heat exchanger secondary water leaving temperature" annotation (
      Placement(transformation(extent={{-260,-120},{-220,-80}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y2Hex(final unit="1")
    "District heat exchanger secondary control signal" annotation (Placement(
        transformation(extent={{220,-80},{260,-40}}), iconTransformation(extent=
           {{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uColRej
    "Control signal enabling full cold rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,40},{-220,80}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaRej
    "Control signal enabling full heat rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,80},{-220,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.Continuous.LimPID conPum2(
    final k=k,
    final Ti=Ti,
    final reset=Buildings.Types.Reset.Parameter,
    final reverseAction=true,
    final yMin=0,
    final yMax=1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Secondary pump controller"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT2(k2=-1) "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs2 "Absolute value"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant delT2HexWatSet(k=abs(
        dT2HexSet)) "District heat exchanger secondary water deltaT set-point"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff2
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or  enaHex
    "District heat exchanger enabled signal"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe2(final k=
        spePum2HexMin) "Minimum pump speed"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(final k=0)
     "Zero pump speed representing off command"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax2(nin=2)
    "Maximize pump control signal"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1HexWatEnt(
    final unit="K", displayUnit="degc")
    "District heat exchanger primary water entering temperature" annotation (
      Placement(transformation(extent={{-260,0},{-220,40}}), iconTransformation(
        extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1HexWatLvg(final unit="K",
      displayUnit="degc")
    "District heat exchanger primary water leaving temperature" annotation (
      Placement(transformation(extent={{-260,-40},{-220,0}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1Hex(final unit="1")
    "District heat exchanger primary control signal" annotation (Placement(
      transformation(extent={{220,0},{260,40}}), iconTransformation(extent={{
        100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT1(k2=-1) "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1 "Absolute value"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant delT1HexWatSet(k=abs(
        dT1HexSet)) "District heat exchanger primary water deltaT set-point"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.Continuous.LimPID conPum1(
    final k=k,
    final Ti=Ti,
    final reset=Buildings.Types.Reset.Parameter,
    final reverseAction=true,
    final yMin=0,
    final yMax=1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Primary pump controller"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax1(nin=2)
    "Maximize pump control signal"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff1
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{160,10},{180,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe1(final k=if
        have_valDis then 0 else spePum1HexMin)
    "Minimum pump speed or actuator opening"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(delT2.y, abs2.u)
    annotation (Line(points={{-138,-80},{-122,-80}}, color={0,0,127}));
  connect(abs2.y, conPum2.u_m)
    annotation (Line(points={{-98,-80},{0,-80},{0,-72}}, color={0,0,127}));
  connect(delT2HexWatSet.y, conPum2.u_s)
    annotation (Line(points={{-58,-60},{-12,-60}}, color={0,0,127}));
  connect(T2HexWatEnt, delT2.u1) annotation (Line(points={{-240,-60},{-180,-60},
          {-180,-74},{-162,-74}}, color={0,0,127}));
  connect(T2HexWatLvg, delT2.u2) annotation (Line(points={{-240,-100},{-180,
          -100},{-180,-86},{-162,-86}}, color={0,0,127}));
  connect(swiOff2.y, y2Hex)
    annotation (Line(points={{182,-60},{240,-60}}, color={0,0,127}));
  connect(uHeaRej,enaHex. u1) annotation (Line(points={{-240,100},{-20,100},{-20,
          80},{-12,80}}, color={255,0,255}));
  connect(uColRej,enaHex. u2) annotation (Line(points={{-240,60},{-20,60},{-20,72},
          {-12,72}}, color={255,0,255}));
  connect(enaHex.y, swiOff2.u2) annotation (Line(points={{12,80},{150,80},{150,
          -60},{158,-60}}, color={255,0,255}));

  connect(enaHex.y, conPum2.trigger) annotation (Line(points={{12,80},{20,80},{
          20,60},{-20,60},{-20,-76},{-8,-76},{-8,-72}}, color={255,0,255}));
  connect(conPum2.y, multiMax2.u[1]) annotation (Line(points={{11,-60},{30,-60},
          {30,-59},{48,-59}}, color={0,0,127}));
  connect(T1HexWatEnt, delT1.u1) annotation (Line(points={{-240,20},{-180,20},{
          -180,6},{-162,6}}, color={0,0,127}));
  connect(T1HexWatLvg, delT1.u2) annotation (Line(points={{-240,-20},{-180,-20},
          {-180,-6},{-162,-6}}, color={0,0,127}));
  connect(delT1.y, abs1.u)
    annotation (Line(points={{-138,0},{-122,0}}, color={0,0,127}));
  connect(abs1.y, conPum1.u_m)
    annotation (Line(points={{-98,0},{0,0},{0,8}}, color={0,0,127}));
  connect(delT1HexWatSet.y, conPum1.u_s)
    annotation (Line(points={{-58,20},{-12,20}}, color={0,0,127}));
  connect(swiOff1.y, y1Hex)
    annotation (Line(points={{182,20},{240,20}}, color={0,0,127}));
  connect(enaHex.y, swiOff1.u2) annotation (Line(points={{12,80},{150,80},{150,
          20},{158,20}}, color={255,0,255}));
  connect(off.y, swiOff1.u3) annotation (Line(points={{122,-20},{140,-20},{140,
          12},{158,12}}, color={0,0,127}));
  connect(off.y, swiOff2.u1) annotation (Line(points={{122,-20},{140,-20},{140,
          -52},{158,-52}}, color={0,0,127}));
  connect(multiMax2.y, swiOff2.u3) annotation (Line(points={{72,-60},{140,-60},
          {140,-68},{158,-68}}, color={0,0,127}));
  connect(multiMax1.y, swiOff1.u1) annotation (Line(points={{72,20},{140,20},{
          140,28},{158,28}}, color={0,0,127}));
  connect(minSpe2.y, multiMax2.u[2]) annotation (Line(points={{12,-100},{32,-100},
          {32,-61},{48,-61}}, color={0,0,127}));
  connect(conPum1.y, multiMax1.u[1]) annotation (Line(points={{11,20},{30,20},{
          30,21},{48,21}}, color={0,0,127}));
  connect(minSpe1.y, multiMax1.u[2]) annotation (Line(points={{12,-20},{30,-20},
          {30,19},{48,19}}, color={0,0,127}));
  connect(enaHex.y, conPum1.trigger) annotation (Line(points={{12,80},{20,80},{
          20,60},{-20,60},{-20,4},{-8,4},{-8,8}}, color={255,0,255}));
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
