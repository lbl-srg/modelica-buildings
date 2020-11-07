within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block SideHot
  "Control block for hot side"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nSouAmb=1
    "Number of ambient sources to control"
    annotation (Evaluate=true);
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P
    "Type of controller"
    annotation (choices(choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small)=0.5
    "Time constant of integrator block"
    annotation (Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  LimPIDEnable conColRej(
    final k=k,
    final Ti=Ti,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final yMin=0,
    final yMax=nSouAmb+1,
    final reverseActing=true)
    "Controller for cold rejection"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCol(
    final unit="1")
    "Control signal for cold side"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=Modelica.Constants.eps,
    final h=0.5*Modelica.Constants.eps)
    "At least one signal is non zero"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  LimPIDEnable conHeaRej(
    final k=k,
    final Ti=Ti,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final yMin=0,
    final yMax=nSouAmb,
    final reverseActing=false)
    "Controller for heat rejection"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun[nSouAmb]
    "Mapping functions for controlled systems"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x1[nSouAmb](
    final k={(i-1) for i in 1:nSouAmb})
    "x1"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator rep(
    final nout=nSouAmb)
    "Replicate control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f1[nSouAmb](
    each final k=0)
    "f1"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f2[nSouAmb](
    each final k=1)
    "f2"
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x2[nSouAmb](
    final k={(i) for i in 1:nSouAmb})
    "x2"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=0.01)
    "At least one signal is non zero"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold uHeaHol(
    trueHoldDuration=120,
    falseHoldDuration=0)
    "Hold heating enabled signal"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold uHeaHol1(
    trueHoldDuration=120,
    falseHoldDuration=0)
    "Hold heating enabled signal"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not hotDom
    "Hot side error dominates"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaCoo
    "Enable signal for heating or cooling"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point (heating or chilled water)"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTop(
    final unit="K",
    displayUnit="degC")
    "Temperature at top of tank"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBot(
    final unit="K",
    displayUnit="degC")
    "Temperature at bottom of tank"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAmb[nSouAmb](
    each final unit="1")
    "Control signal for ambient sources"
    annotation (Placement(transformation(extent={{180,20},{220,60}}),iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoAmb(
    final unit="1")
    "Ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    k=0)
    "Zero"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
equation
  connect(TBot,conHeaRej.u_m)
    annotation (Line(points={{-200,-120},{-140,-120},{-140,-60},{-100,-60},{-100,-32}},color={0,0,127}));
  connect(mapFun.y,yAmb)
    annotation (Line(points={{72,40},{200,40}},color={0,0,127}));
  connect(TSet,conColRej.u_s)
    annotation (Line(points={{-200,20},{-150,20},{-150,-80},{-112,-80}},color={0,0,127}));
  connect(TTop,conColRej.u_m)
    annotation (Line(points={{-200,-40},{-160,-40},{-160,-100},{-100,-100},{-100,-92}},color={0,0,127}));
  connect(conHeaRej.y,greThr.u)
    annotation (Line(points={{-88,-20},{-52,-20}},color={0,0,127}));
  connect(x1.y,mapFun.x1)
    annotation (Line(points={{32,60},{40,60},{40,48},{48,48}},color={0,0,127}));
  connect(conHeaRej.y,rep.u)
    annotation (Line(points={{-88,-20},{-80,-20},{-80,40},{-62,40}},color={0,0,127}));
  connect(rep.y,mapFun.u)
    annotation (Line(points={{-38,40},{48,40}},color={0,0,127}));
  connect(f1.y,mapFun.f1)
    annotation (Line(points={{-8,60},{0,60},{0,44},{48,44}},color={0,0,127}));
  connect(f2.y,mapFun.f2)
    annotation (Line(points={{32,20},{40,20},{40,32},{48,32}},color={0,0,127}));
  connect(x2.y,mapFun.x2)
    annotation (Line(points={{-8,20},{0,20},{0,36},{48,36}},color={0,0,127}));
  connect(booToRea.y,yIsoAmb)
    annotation (Line(points={{142,0},{200,0}},color={0,0,127}));
  connect(TSet,conHeaRej.u_s)
    annotation (Line(points={{-200,20},{-150,20},{-150,-20},{-112,-20}},color={0,0,127}));
  connect(uHeaCoo,conColRej.uEna)
    annotation (Line(points={{-200,100},{-120,100},{-120,-96},{-104,-96},{-104,-92}},color={255,0,255}));
  connect(conColRej.y,greThr1.u)
    annotation (Line(points={{-88,-80},{-80,-80},{-80,-60},{-52,-60}},color={0,0,127}));
  connect(greThr.y,uHeaHol.u)
    annotation (Line(points={{-28,-20},{-2,-20}},color={255,0,255}));
  connect(uHeaHol.y,booToRea.u)
    annotation (Line(points={{22,-20},{100,-20},{100,0},{118,0}},color={255,0,255}));
  connect(greThr1.y,uHeaHol1.u)
    annotation (Line(points={{-28,-60},{-2,-60}},color={255,0,255}));
  connect(uHeaHol1.y,hotDom.u)
    annotation (Line(points={{22,-60},{38,-60}},color={255,0,255}));
  connect(hotDom.y,conHeaRej.uEna)
    annotation (Line(points={{62,-60},{80,-60},{80,-40},{-104,-40},{-104,-32}},color={255,0,255}));
  connect(swi.y,yCol)
    annotation (Line(points={{142,-40},{200,-40}},color={0,0,127}));
  connect(uHeaHol.y,swi.u2)
    annotation (Line(points={{22,-20},{100,-20},{100,-40},{118,-40}},color={255,0,255}));
  connect(conColRej.y,swi.u3)
    annotation (Line(points={{-88,-80},{100,-80},{100,-48},{118,-48}},color={0,0,127}));
  connect(zer.y,swi.u1)
    annotation (Line(points={{-38,100},{86,100},{86,-32},{118,-32}},color={0,0,127}));
  annotation (
    defaultComponentName="conHot",
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>",
      info="<html>
<p>
This block serves as the controller for the hot side of the ETS in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory</a>.
See
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold</a>
for the computation of the demand signal <code>yDem</code>.
The other control signals are computed as follows.
</p>
<ul>
<li>
Control signals for ambient sources <code>yAmb</code> (array)<br/>

The controller for heat rejection is always enabled.
It maintains the temperature at the bottom of the heating water tank
at the heating water supply temperature set point.
The controller yields a control signal value between
<code>0</code> and <code>nSouAmb</code>. The systems serving as
ambient sources are then controlled in sequence by mapping the controller
output to a <code>nSouAmb</code>-array of signals between
<code>0</code> and <code>1</code>.
</li>
<li>
Control signal for cold rejection <code>yCol</code> <br/>

The controller for cold rejection is enabled if the heating water
tank is in demand and the condenser loop isolation valve is commanded
to be closed (see below).
It maintains the temperature at the top of the heating water tank
at the heating water supply temperature set point.
The controller yields a control signal value between
<code>0</code> and <code>nSouAmb+1</code>.
It is used to control in sequence the systems serving as ambient
sources and ultimately to reset the chilled water supply temperature,
see
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold</a>.
</li>
<li>
Control signal for the condenser loop isolation valve <code>yIsoAmb</code><br/>
The valve is commanded to be fully open whenever the controller
for heat rejection yields an output signal greater than zero
(with a true hold of 300s to avoid short cycling).
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-180,-160},{180,160}})));
end SideHot;
