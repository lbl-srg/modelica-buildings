within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls;
model HeatExchanger
  "Controller for district heat exchanger secondary loop"
  extends Modelica.Blocks.Icons.Block;

  parameter Real spePum2DisHexMin(final unit="1") = 0.1
    "District heat exchanger secondary pump minimum speed (fractional)";
  parameter Modelica.SIunits.TemperatureDifference dTHex
    "District heat exchanger secondary side deltaT";
  parameter Modelica.Blocks.Types.SimpleController
    controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k(final unit="1/K")=0.1
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.SIunits.Time Ti(min=0)=60
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PI
         or  controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PD
          or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatEnt(final unit="K",
      displayUnit="degc")
    "District heat exchanger secondary water entering temperature" annotation (
      Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2HexWatLvg(final unit="K",
      displayUnit="degc")
    "District heat exchanger secondary water leaving temperature" annotation (
      Placement(transformation(extent={{-258,-100},{-218,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum2Hex(final unit="1")
    "District heat exchanger secondary pump control" annotation (Placement(
        transformation(extent={{220,-20},{260,20}}), iconTransformation(extent={
            {100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uColRej
    "Control signal enabling full cold rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,40},{-220,80}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaRej
    "Control signal enabling full heat rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,80},{-220,120}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.Continuous.LimPID conPum2Hex(
    final k=k,
    final Ti=Ti,
    final Td=Td,
    reset=Buildings.Types.Reset.Parameter,
    reverseAction=true,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType)
    "District heat exchanger secondary pump controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT(k2=-1) "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs "Absolute value"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant delT2HexWatSet(k=dTHex)
    "District heat exchanger secondary water deltaT set-point"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch hexPumConOut
  "District heat exchanger pump control"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or  enaHex
    "District heat exchanger enabled signal"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe(
    final k=spePum2DisHexMin) "Minimum pump speed"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(final k=0)
     "Zero pump speed representing off command"
    annotation (Placement(transformation(extent={{108,-90},{128,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(nin=2)
    "Maximize pump control signal"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
equation
  connect(delT.y, abs.u)
    annotation (Line(points={{-138,-40},{-122,-40}}, color={0,0,127}));
  connect(abs.y, conPum2Hex.u_m)
    annotation (Line(points={{-98,-40},{0,-40},{0,-12}}, color={0,0,127}));
  connect(delT2HexWatSet.y, conPum2Hex.u_s)
    annotation (Line(points={{-98,0},{-12,0}}, color={0,0,127}));
  connect(T2HexWatEnt,delT. u1) annotation (Line(points={{-240,-40},{-180,-40},{
          -180,-34},{-162,-34}}, color={0,0,127}));
  connect(T2HexWatLvg,delT. u2) annotation (Line(points={{-238,-80},{-180,-80},{
          -180,-46},{-162,-46}}, color={0,0,127}));
  connect(hexPumConOut.y, yPum2Hex)
    annotation (Line(points={{182,0},{240,0}}, color={0,0,127}));
  connect(uHeaRej,enaHex. u1) annotation (Line(points={{-240,100},{-20,100},{-20,
          80},{-12,80}}, color={255,0,255}));
  connect(uColRej,enaHex. u2) annotation (Line(points={{-240,60},{-20,60},{-20,72},
          {-12,72}}, color={255,0,255}));
  connect(enaHex.y, hexPumConOut.u2) annotation (Line(points={{12,80},{150,80},{
          150,0},{158,0}},            color={255,0,255}));

  connect(enaHex.y, conPum2Hex.trigger) annotation (Line(points={{12,80},{20,80},
          {20,-20},{-8,-20},{-8,-12}}, color={255,0,255}));
  connect(off.y, hexPumConOut.u3) annotation (Line(points={{130,-80},{140,-80},{
          140,-8},{158,-8}}, color={0,0,127}));
  connect(conPum2Hex.y, multiMax.u[1])
    annotation (Line(points={{11,0},{44,0},{44,1},{48,1}}, color={0,0,127}));
  connect(minSpe.y, multiMax.u[2]) annotation (Line(points={{12,-80},{40,-80},{40,
          -1},{48,-1}}, color={0,0,127}));
  connect(multiMax.y, hexPumConOut.u1) annotation (Line(points={{72,0},{140,0},{
          140,8},{158,8}}, color={0,0,127}));
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
