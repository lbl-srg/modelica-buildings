within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block SideHot
  "Control block for hot side"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nSouAmb=1
    "Number of ambient sources to control"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dTDea(min=0)=1
    "Temperature dead band between set point tracking and heat rejection (absolute value)";
  parameter Modelica.SIunits.TemperatureDifference dTLoc(min=0)=3
    "Temperature difference for cold rejection lockout (absolute value)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.P
    "Type of controller"
    annotation (choices(
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small)=0.5
    "Time constant of integrator block"
    annotation (Dialog(
      enable=controllerType ==
        Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
        controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  LimPIDEnable conColRej(
    final k=k,
    final Ti=Ti,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final yMin=0,
    final yMax=nSouAmb+1,
    final reverseActing=true)
    "Controller for cold rejection"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCol(
    final unit="1")
    "Control signal for cold side"
    annotation (Placement(transformation(extent={{180,-80},{220,-40}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(final t=0.01)
    "Control signal is non zero (with 1% tolerance)"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  LimPIDEnable conHeaRej(
    final k=k,
    final Ti=Ti,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final yMin=0,
    final yMax=nSouAmb,
    final reverseActing=false)
    "Controller for heat rejection"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun[nSouAmb]
    "Mapping functions for controlled systems"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x1[nSouAmb](
    final k={(i-1) for i in 1:nSouAmb})
    "x1"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator rep(
    final nout=nSouAmb)
    "Replicate control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,origin={0,40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f1[nSouAmb](
    each final k=0)
    "f1"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f2[nSouAmb](
    each final k=1)
    "f2"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x2[nSouAmb](
    final k={(i) for i in 1:nSouAmb})
    "x2"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaCoo
    "Enable signal for heating or cooling"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point (heating or chilled water)"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
                                                                      iconTransformation(extent={{-140,22},
            {-100,62}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTop(
    final unit="K",
    displayUnit="degC")
    "Temperature at top of tank"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),iconTransformation(extent={{-140,
            -20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAmb[nSouAmb](
    each final unit="1")
    "Control signal for ambient sources"
    annotation (Placement(transformation(extent={{180,20},{220,60}}),iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValIso(
    final unit="1")
    "Ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{180,-40},{220,0}}), iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoCon_actual(final unit="1")
            "Return position of condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoEva_actual(final unit="1")
            "Return position of evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValIsoConClo(final t=1E-6,
      h=0.5E-6) "Check if isolation valve is closed"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValIsoEvaClo(final t=1E-6,
      h=0.5E-6) "At least one signal is non zero"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd
                                         mulAnd(nu=3)
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addDea(p=dTDea, k=1)
    "Add dead band"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold(samplePeriod=60)
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addLoc(p=dTLoc, k=1)
    "Add temperature difference for lockout"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Less          isValIsoConClo1(h=0.1)
                "Check if isolation valve is closed"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
equation
  connect(mapFun.y,yAmb)
    annotation (Line(points={{122,40},{200,40}},
                                               color={0,0,127}));
  connect(TSet,conColRej.u_s)
    annotation (Line(points={{-200,0},{-140,0},{-140,-60},{-12,-60}},   color={0,0,127}));
  connect(TTop,conColRej.u_m)
    annotation (Line(points={{-200,-40},{-40,-40},{-40,-76},{0,-76},{0,-72}},          color={0,0,127}));
  connect(conHeaRej.y,greThr.u)
    annotation (Line(points={{-28,-20},{38,-20}}, color={0,0,127}));
  connect(x1.y,mapFun.x1)
    annotation (Line(points={{82,60},{90,60},{90,48},{98,48}},color={0,0,127}));
  connect(conHeaRej.y,rep.u)
    annotation (Line(points={{-28,-20},{-20,-20},{-20,40},{-12,40}},color={0,0,127}));
  connect(rep.y,mapFun.u)
    annotation (Line(points={{12,40},{98,40}}, color={0,0,127}));
  connect(f1.y,mapFun.f1)
    annotation (Line(points={{42,60},{50,60},{50,44},{98,44}},
                                                            color={0,0,127}));
  connect(f2.y,mapFun.f2)
    annotation (Line(points={{82,20},{90,20},{90,32},{98,32}},color={0,0,127}));
  connect(x2.y,mapFun.x2)
    annotation (Line(points={{42,20},{50,20},{50,36},{98,36}},
                                                            color={0,0,127}));
  connect(conColRej.y, yCol)
    annotation (Line(points={{12,-60},{200,-60}}, color={0,0,127}));
  connect(TTop, conHeaRej.u_m) annotation (Line(points={{-200,-40},{-40,-40},{-40,
          -32}}, color={0,0,127}));
  connect(yValIsoCon_actual, isValIsoConClo.u)
    annotation (Line(points={{-200,-80},{-162,-80}}, color={0,0,127}));
  connect(yValIsoEva_actual, isValIsoEvaClo.u)
    annotation (Line(points={{-200,-120},{-162,-120}}, color={0,0,127}));
  connect(mulAnd.y, conColRej.uEna) annotation (Line(points={{-8,-100},{-4,-100},
          {-4,-72}}, color={255,0,255}));
  connect(isValIsoEvaClo.y, conHeaRej.uEna) annotation (Line(points={{-138,-120},
          {-44,-120},{-44,-32}}, color={255,0,255}));
  connect(TSet, addDea.u)
    annotation (Line(points={{-200,0},{-140,0},{-140,-20},{-102,-20}},
                                                     color={0,0,127}));
  connect(addDea.y, conHeaRej.u_s)
    annotation (Line(points={{-78,-20},{-52,-20}}, color={0,0,127}));
  connect(greThr.y, booToRea.u)
    annotation (Line(points={{62,-20},{78,-20}}, color={255,0,255}));
  connect(booToRea.y, zeroOrderHold.u)
    annotation (Line(points={{102,-20},{118,-20}}, color={0,0,127}));
  connect(zeroOrderHold.y, yValIso)
    annotation (Line(points={{141,-20},{200,-20}}, color={0,0,127}));
  connect(TSet, addLoc.u) annotation (Line(points={{-200,0},{-140,0},{-140,20},
          {-102,20}}, color={0,0,127}));
  connect(TTop, isValIsoConClo1.u1) annotation (Line(points={{-200,-40},{-160,
          -40},{-160,60},{-102,60}}, color={0,0,127}));
  connect(addLoc.y, isValIsoConClo1.u2) annotation (Line(points={{-78,20},{-70,
          20},{-70,40},{-110,40},{-110,52},{-102,52}}, color={0,0,127}));
  connect(uHeaCoo, mulAnd.u[1]) annotation (Line(points={{-200,100},{-120,100},
          {-120,-95.3333},{-32,-95.3333}}, color={255,0,255}));
  connect(isValIsoConClo.y, mulAnd.u[2]) annotation (Line(points={{-138,-80},{
          -124,-80},{-124,-100},{-32,-100}}, color={255,0,255}));
  connect(isValIsoConClo1.y, mulAnd.u[3]) annotation (Line(points={{-78,60},{
          -60,60},{-60,-104.667},{-32,-104.667}}, color={255,0,255}));
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
        extent={{-180,-140},{180,140}}), graphics={Text(
          extent={{48,-26},{132,-56}},
          lineColor={28,108,200},
          textString="Using MSL hold due to bug in Dymola")}));
end SideHot;
