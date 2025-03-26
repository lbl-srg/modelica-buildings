within Buildings.DHC.ETS.Combined.Controls;
model SideCold
  "Control block for cold side"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nSouAmb=1
    "Number of ambient sources to control"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Temperature TChiWatSupSetMin(displayUnit="degC")
    "Minimum value of chilled water supply temperature set point";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (choices(choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real k(
    min=0)=0.1
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small)=120
    "Time constant of integrator block"
    annotation (Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                           or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCol
    "Cold rejection control signal"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
    iconTransformation(extent={{-140,-22},{-100,18}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{180,60},{220,100}}),
    iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Line mapFun[nSouAmb]
    "Mapping functions for ambient source control"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant x1[nSouAmb](
    final k={(i-1) for i in 1:nSouAmb})
    "x1"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    final nout=nSouAmb)
    "Replicate control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0)));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant f1[nSouAmb](
    each final k=0)
    "f1"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant f2[nSouAmb](
    each final k=1)
    "f2"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant x2[nSouAmb](
    final k={(i) for i in 1:nSouAmb})
    "x2"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Combined.Controls.PIDWithEnable conTChiWatSup(
    final k=k,
    final Ti=Ti,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final yMin=0,
    final yMax=1,
    final reverseActing=false)
    "Controller for CHWST"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Line mapFunTChiSupSet
    "Mapping function for CHWST reset"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTChiWatSup(
    y(final unit="K",
      displayUnit="degC"),
    final k=TChiWatSupSetMin)
    "Minimum value of chilled water supply temperature"
    annotation (Placement(transformation(extent={{62,50},{82,70}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    p=nSouAmb)
    "One minus control loop output"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    k=-nSouAmb)
    "Gain factor"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "CHWST reset signal"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    k=0)
    "Zero"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subNumSou(
    p=-nSouAmb)
    "Control signal minus nSouAmb"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Ambient source control signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.LimitSlewRate ramLimHea(
    raisingSlewRate=0.1) "Limit the rate of change"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaCoo
    "Enable signal for heating or cooling"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
    iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point (heating or chilled water)"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
    iconTransformation(extent={{-140,-62},{-100,-22}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBot(
    final unit="K",
    displayUnit="degC")
    "Temperature at bottom of tank"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
    iconTransformation(extent={{-140,-104},{-100,-64}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAmb[nSouAmb](
    each final unit="1")
    "Control signal for ambient sources"
    annotation (Placement(transformation(extent={{180,20},{220,60}}),
    iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValIso(
    final unit="1")
    "Ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    t=0.01)
    "Control signal is non zero (with 1% tolerance)"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold(
    samplePeriod=60)
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
equation
  connect(x1.y,mapFun.x1)
    annotation (Line(points={{62,20},{80,20},{80,8},{98,8}},color={0,0,127}));
  connect(rep.y,mapFun.u)
    annotation (Line(points={{12,0},{98,0}},color={0,0,127}));
  connect(f1.y,mapFun.f1)
    annotation (Line(points={{62,-30},{80,-30},{80,4},{98,4}},color={0,0,127}));
  connect(f2.y,mapFun.f2)
    annotation (Line(points={{12,120},{30,120},{30,-8},{98,-8}},color={0,0,127}));
  connect(x2.y,mapFun.x2)
    annotation (Line(points={{62,-60},{90,-60},{90,-4},{98,-4}},color={0,0,127}));
  connect(TSet,conTChiWatSup.u_s)
    annotation (Line(points={{-200,40},{-172,40},{-172,-20},{-152,-20}},color={0,0,127}));
  connect(TBot,conTChiWatSup.u_m)
    annotation (Line(points={{-200,-80},{-140,-80},{-140,-32}},color={0,0,127}));
  connect(f2[1].y,mapFunTChiSupSet.x2)
    annotation (Line(points={{12,120},{30,120},{30,76},{98,76}},color={0,0,127}));
  connect(minTChiWatSup.y,mapFunTChiSupSet.f2)
    annotation (Line(points={{84,60},{90,60},{90,72},{98,72}},color={0,0,127}));
  connect(TSet,mapFunTChiSupSet.f1)
    annotation (Line(points={{-200,40},{20,40},{20,84},{98,84}},color={0,0,127}));
  connect(uCol,subNumSou.u)
    annotation (Line(points={{-200,0},{-160,0},{-160,100},{-82,100}},color={0,0,127}));
  connect(max1.y,mapFunTChiSupSet.u)
    annotation (Line(points={{-8,80},{98,80}},color={0,0,127}));
  connect(uCol,min1.u1)
    annotation (Line(points={{-200,0},{-80,0},{-80,6},{-42,6}},color={0,0,127}));
  connect(addPar.y,min1.u2)
    annotation (Line(points={{-58,-20},{-50,-20},{-50,-6},{-42,-6}},color={0,0,127}));
  connect(min1.y,rep.u)
    annotation (Line(points={{-18,0},{-12,0}},color={0,0,127}));
  connect(mapFun.y,yAmb)
    annotation (Line(points={{122,0},{140,0},{140,40},{200,40}},color={0,0,127}));
  connect(ramLimHea.y,TChiWatSupSet)
    annotation (Line(points={{162,80},{200,80}},color={0,0,127}));
  connect(uHeaCoo,conTChiWatSup.uEna)
    annotation (Line(points={{-200,120},{-166,120},{-166,-40},{-144,-40},{-144,-32}},color={255,0,255}));
  connect(zer.y,mapFunTChiSupSet.x1)
    annotation (Line(points={{-58,60},{0,60},{0,88},{98,88}},color={0,0,127}));
  connect(uCol,greThr.u)
    annotation (Line(points={{-200,0},{-160,0},{-160,-100},{-2,-100}},color={0,0,127}));
  connect(greThr.y,booToRea.u)
    annotation (Line(points={{22,-100},{38,-100}},color={255,0,255}));
  connect(booToRea.y,zeroOrderHold.u)
    annotation (Line(points={{62,-100},{78,-100}},color={0,0,127}));
  connect(zeroOrderHold.y,yValIso)
    annotation (Line(points={{101,-100},{160,-100},{160,0},{200,0}},color={0,0,127}));
  connect(mapFunTChiSupSet.y,ramLimHea.u)
    annotation (Line(points={{122,80},{138,80}},color={0,0,127}));
  connect(zer.y,max1.u2)
    annotation (Line(points={{-58,60},{-40,60},{-40,74},{-32,74}},color={0,0,127}));
  connect(subNumSou.y,max1.u1)
    annotation (Line(points={{-58,100},{-40,100},{-40,86},{-32,86}},color={0,0,127}));
  connect(conTChiWatSup.y, gai.u)
    annotation (Line(points={{-128,-20},{-122,-20}}, color={0,0,127}));
  connect(gai.y, addPar.u)
    annotation (Line(points={{-98,-20},{-82,-20}}, color={0,0,127}));
  annotation (
    defaultComponentName="conCol",
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This block serves as the controller for the cold side of the ETS in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Controls.Supervisory\">
Buildings.DHC.ETS.Combined.Controls.Supervisory</a>.
It computes the following control signals.
</p>
<ul>
<li>
Control signals for ambient sources <code>yAmb</code> (array)<br/>

The cold rejection control signal yielded by the hot side controller
is processed as follows.
<ul>
<li>
A controller is used to track the chilled water
supply temperature (CHWST) set point.
This controller is enabled when cooling is enabled.
It yields a control signal value between
<code>0</code> and <code>nSouAmb</code>.
</li>
<li>
The systems serving as ambient sources are then controlled in sequence
by mapping the minimum between the CHWST control loop output and the
part of the cold rejection signal between <code>0</code>
and <code>nSouAmb</code> to a <code>nSouAmb</code>-array
of signals between <code>0</code> and <code>1</code>.
</li>
</ul>
</li>
<li>
Chilled water supply temperature set point <code>TChiWatSupSet</code><br/>

The remaining part of the cold rejection signal between
<code>nSouAmb</code> and <code>nSouAmb+1</code> is used
to reset the CHWST set point between a maximum value provided
as an input variable, and a minimum value provided as a
parameter.
</li>
<li>
Control signal for the evaporator loop isolation valve <code>yIsoAmb</code><br/>

The valve is commanded to be fully open whenever the cold rejection control signal
is greater than zero.
The command signal is held for 60s to avoid short cycling.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-180,-140},{180,140}})));
end SideCold;
