within Buildings.DHC.EnergyTransferStations.Combined.Controls;
block SideHot
  "Control block for hot side"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nSouAmb=1
    "Number of ambient sources to control"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.TemperatureDifference dTDea(min=0) = 1
    "Temperature difference band between set point tracking and heat rejection (absolute value)";
  parameter Modelica.Units.SI.TemperatureDifference dTLoc(min=0) = dTDea + 2
    "Temperature difference between set point tracking and cold rejection lockout (absolute value)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (choices(choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real k(
    min=0)=0.1
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Buildings.Controls.OBC.CDL.Constants.small)=
       120 "Time constant of integrator block" annotation (Dialog(enable=
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  PIDWithEnable conColRej(
    final k=k,
    final Ti=Ti,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final yMin=0,
    final yMax=nSouAmb+1,
    final reverseActing=true)
    "Controller for cold rejection"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCol(
    final unit="1")
    "Control signal for cold side"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
    iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0.01)
    "Control signal is non zero (with 1% tolerance)"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  PIDWithEnable conHeaRej(
    final k=k,
    final Ti=Ti,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final yMin=0,
    final yMax=nSouAmb,
    final reverseActing=false)
    "Controller for heat rejection"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Reals.Line mapFun[nSouAmb]
    "Mapping functions for controlled systems"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant x1[nSouAmb](
    final k={(i-1) for i in 1:nSouAmb})
    "x1"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    final nout=nSouAmb)
    "Replicate control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={0,60})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant f1[nSouAmb](
    each final k=0)
    "f1"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant f2[nSouAmb](
    each final k=1)
    "f2"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant x2[nSouAmb](
    final k={(i) for i in 1:nSouAmb})
    "x2"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaCoo
    "Enable signal for heating or cooling"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),
    iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point (heating or chilled water)"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
    iconTransformation(extent={{-140,22},{-100,62}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTop(
    final unit="K",
    displayUnit="degC")
    "Temperature at top of tank"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAmb[nSouAmb](
    each final unit="1")
    "Control signal for ambient sources"
    annotation (Placement(transformation(extent={{180,40},{220,80}}),
    iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValIso(
    final unit="1")
    "Ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoCon_actual(
    final unit="1")
    "Return position of condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoEva_actual(
    final unit="1")
    "Return position of evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
    iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold isValIsoConClo(
    final t=1E-6,
    h=0.5E-6)
    "Check if isolation valve is closed"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold isValIsoEvaClo(
    final t=1E-6,
    h=0.5E-6)
    "At least one signal is non zero"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    nin=3)
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addDea(
    p=dTDea)
    "Add dead band"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold(
    samplePeriod=60)
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addLoc(
    p=dTLoc)
    "Add temperature difference for lockout"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Reals.Less isBelLoc(
    h=0.1)
    "Check if temperature is below cold rejection lockout"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
equation
  connect(mapFun.y,yAmb)
    annotation (Line(points={{122,60},{200,60}},color={0,0,127}));
  connect(TSet,conColRej.u_s)
    annotation (Line(points={{-200,0},{-140,0},{-140,-40},{-12,-40}},color={0,0,127}));
  connect(TTop,conColRej.u_m)
    annotation (Line(points={{-200,-40},{-160,-40},{-160,-58},{0,-58},{0,-52}},color={0,0,127}));
  connect(conHeaRej.y,greThr.u)
    annotation (Line(points={{-68,0},{38,0}},color={0,0,127}));
  connect(x1.y,mapFun.x1)
    annotation (Line(points={{82,80},{90,80},{90,68},{98,68}},color={0,0,127}));
  connect(conHeaRej.y,rep.u)
    annotation (Line(points={{-68,0},{-20,0},{-20,60},{-12,60}},color={0,0,127}));
  connect(rep.y,mapFun.u)
    annotation (Line(points={{12,60},{98,60}},color={0,0,127}));
  connect(f1.y,mapFun.f1)
    annotation (Line(points={{42,80},{50,80},{50,64},{98,64}},color={0,0,127}));
  connect(f2.y,mapFun.f2)
    annotation (Line(points={{82,40},{90,40},{90,52},{98,52}},color={0,0,127}));
  connect(x2.y,mapFun.x2)
    annotation (Line(points={{42,40},{50,40},{50,56},{98,56}},color={0,0,127}));
  connect(conColRej.y,yCol)
    annotation (Line(points={{12,-40},{200,-40}},color={0,0,127}));
  connect(TTop,conHeaRej.u_m)
    annotation (Line(points={{-200,-40},{-160,-40},{-160,-20},{-80,-20},{-80,-12}},color={0,0,127}));
  connect(yValIsoCon_actual,isValIsoConClo.u)
    annotation (Line(points={{-200,-80},{-162,-80}},color={0,0,127}));
  connect(yValIsoEva_actual,isValIsoEvaClo.u)
    annotation (Line(points={{-200,-120},{-162,-120}},color={0,0,127}));
  connect(mulAnd.y,conColRej.uEna)
    annotation (Line(points={{-18,-80},{-4,-80},{-4,-52}},color={255,0,255}));
  connect(isValIsoEvaClo.y,conHeaRej.uEna)
    annotation (Line(points={{-138,-120},{-84,-120},{-84,-12}},color={255,0,255}));
  connect(TSet,addDea.u)
    annotation (Line(points={{-200,0},{-132,0}},color={0,0,127}));
  connect(addDea.y,conHeaRej.u_s)
    annotation (Line(points={{-108,0},{-92,0}},color={0,0,127}));
  connect(greThr.y,booToRea.u)
    annotation (Line(points={{62,0},{78,0}},color={255,0,255}));
  connect(booToRea.y,zeroOrderHold.u)
    annotation (Line(points={{102,0},{118,0}},color={0,0,127}));
  connect(zeroOrderHold.y,yValIso)
    annotation (Line(points={{141,0},{200,0}},color={0,0,127}));
  connect(TSet,addLoc.u)
    annotation (Line(points={{-200,0},{-140,0},{-140,40},{-132,40}},color={0,0,127}));
  connect(TTop,isBelLoc.u1)
    annotation (Line(points={{-200,-40},{-160,-40},{-160,60},{-92,60}},color={0,0,127}));
  connect(addLoc.y,isBelLoc.u2)
    annotation (Line(points={{-108,40},{-100,40},{-100,52},{-92,52}},color={0,0,127}));
  connect(uHeaCoo,mulAnd.u[1])
    annotation (Line(points={{-200,100},{-56,100},{-56,-75.3333},{-42,-75.3333}},color={255,0,255}));
  connect(isValIsoConClo.y,mulAnd.u[2])
    annotation (Line(points={{-138,-80},{-42,-80}},color={255,0,255}));
  connect(isBelLoc.y,mulAnd.u[3])
    annotation (Line(points={{-68,60},{-60,60},{-60,-84.6667},{-42,-84.6667}},color={255,0,255}));
  annotation (
    defaultComponentName="conHot",
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
This block serves as the controller for the hot side of the ETS in
<a href=\"modelica://Buildings.DHC.EnergyTransferStations.Combined.Controls.Supervisory\">
Buildings.DHC.EnergyTransferStations.Combined.Controls.Supervisory</a>.
It computes the following control signals.
</p>
<ul>
<li>
Control signals for ambient sources <code>yAmb</code> (array)<br/>

The controller for heat rejection is enabled when the return position
of the evaporator loop isolation valve is close to zero.
When enabled, it maintains the temperature at the top of the heating water
tank at the heating water supply temperature set point plus a
dead band <code>dTDea</code>.
The controller yields a control signal value between
<code>0</code> and <code>nSouAmb</code>.
The systems serving as ambient sources are then controlled in sequence
by mapping the controller output to a <code>nSouAmb</code>-array of
signals between <code>0</code> and <code>1</code>.
</li>
<li>
Control signal for cold rejection <code>yCol</code><br/>

The controller for cold rejection is enabled if
<ul>
<li>
the return position of the condenser loop isolation valve is close to zero,
and
</li>
<li>
heating is enabled, and
</li>
<li>
the temperature at the top of the heating water tank is below a safety
limit equal to the heating water supply temperature set point plus the
parameter <code>dTLoc</code>. This last condition limits the temperature
overshoot after the warmup periods, without having to finely tune the heat and
cold rejection controller parameters to guard against the disturbing effect
of a varying district water temperature.
</li>
</ul>
When enabled, the controller maintains the temperature at the top of the
heating water tank at the heating water supply temperature set point.
The controller yields a signal between <code>0</code> and <code>nSouAmb+1</code>
which is connected to
<a href=\"modelica://Buildings.DHC.EnergyTransferStations.Combined.Controls.SideCold\">
Buildings.DHC.EnergyTransferStations.Combined.Controls.SideCold</a>
where it is used to control in sequence the systems serving as ambient sources
and ultimately to reset down the chilled water supply temperature.
</li>
<li>
Control signal for the condenser loop isolation valve <code>yIsoAmb</code><br/>

The valve is commanded to be fully open whenever the controller
for heat rejection yields an output signal greater than zero.
The command signal is held for 60s to avoid short cycling.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-180,-140},{180,140}})));
end SideHot;
