within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block SideHot "Control block for hot side"
  extends BaseClasses.PartialSideHotCold(
    final reverseActing=false);

  parameter Real kCol(min=0) = 1
    "Gain of controller for cold side";

  Buildings.Controls.OBC.CDL.Continuous.Min min "Minimum tank temperature"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  LimPIDEnable conColRej(
    final k=kCol,
    final Ti=Ti,
    final controllerType=controllerType,
    final yMin=0,
    final yMax=nSouAmb + 1,
    final reverseActing=true)
    "Controller for cold rejection"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCol(final unit="1")
    "Control signal for cold side" annotation (Placement(transformation(extent={
            {180,-180},{220,-140}}), iconTransformation(extent={{100,-100},{140,
            -60}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=Modelica.Constants.eps,
    final h=0.5*Modelica.Constants.eps)
    "At least one signal is non zero"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{130,-130},{150,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conHeaRej(
    final k=k,
    final Ti=Ti,
    final controllerType=controllerType,
    final yMin=0,
    final yMax=nSouAmb,
    final reverseActing=false) "Controller for heat rejection"
    annotation (Placement(transformation(extent={{-70,-170},{-50,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(final p=if
        reverseActing then -abs(dTDea) else abs(dTDea), final k=1)
    "Add dead band to set point"
    annotation (Placement(transformation(extent={{-150,-170},{-130,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun[nSouAmb]
    "Mapping functions for controlled systems"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x1[nSouAmb](final k={(
        i - 1) for i in 1:nSouAmb})
    "x1"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator rep(
    final nout=nSouAmb)
    "Replicate control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-80})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f1[nSouAmb](
    each final k=0) "f1"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f2[nSouAmb](
    each final k=1)
    "f2"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x2[nSouAmb](final k={(
        i) for i in 1:nSouAmb})                "x2"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Condenser loop isolation valve commanded closed"
                                              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-180})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Tank in demand and condenser loop isolation valve commanded closed"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-220})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=300,
      falseHoldDuration=0)
    "Holding the valve command signal to avoid short cycling"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
equation
  connect(min.u1, TTop) annotation (Line(points={{-92,-54},{-120,-54},{-120,-40},
          {-200,-40}},color={0,0,127}));
  connect(min.u2, TBot) annotation (Line(points={{-92,-66},{-100,-66},{-100,
          -140},{-200,-140}},
                       color={0,0,127}));

  connect(min.y, errDis.u2) annotation (Line(points={{-68,-60},{-60,-60},{-60,
          -12}}, color={0,0,127}));
  connect(TTop, errEna.u2) annotation (Line(points={{-200,-40},{-120,-40},{-120,
          20},{-80,20},{-80,28}},   color={0,0,127}));
  connect(TBot, conHeaRej.u_m) annotation (Line(points={{-200,-140},{-100,-140},
          {-100,-180},{-60,-180},{-60,-172}}, color={0,0,127}));
  connect(mapFun.y, yAmb)
    annotation (Line(points={{112,-80},{200,-80}}, color={0,0,127}));
  connect(TSet, conColRej.u_s) annotation (Line(points={{-200,40},{-160,40},{
          -160,-200},{-12,-200}},
                             color={0,0,127}));
  connect(TTop, conColRej.u_m) annotation (Line(points={{-200,-40},{-120,-40},{
          -120,-220},{0,-220},{0,-212}},color={0,0,127}));
  connect(conColRej.y, yCol) annotation (Line(points={{12,-200},{140,-200},{140,
          -160},{200,-160}}, color={0,0,127}));
  connect(TSet,addPar. u) annotation (Line(points={{-200,40},{-160,40},{-160,
          -160},{-152,-160}},
                        color={0,0,127}));
  connect(addPar.y, conHeaRej.u_s)
    annotation (Line(points={{-128,-160},{-72,-160}},color={0,0,127}));
  connect(conHeaRej.y, greThr.u) annotation (Line(points={{-48,-160},{-12,-160}},
                               color={0,0,127}));
  connect(x1.y,mapFun. x1) annotation (Line(points={{72,-60},{80,-60},{80,-72},
          {88,-72}}, color={0,0,127}));
  connect(conHeaRej.y, rep.u) annotation (Line(points={{-48,-160},{-40,-160},{
          -40,-80},{-22,-80}},
                           color={0,0,127}));
  connect(rep.y,mapFun. u) annotation (Line(points={{2,-80},{88,-80}},
                     color={0,0,127}));
  connect(f1.y,mapFun. f1) annotation (Line(points={{32,-60},{40,-60},{40,-76},
          {88,-76}},                  color={0,0,127}));
  connect(f2.y,mapFun. f2) annotation (Line(points={{72,-100},{80,-100},{80,-88},
          {88,-88}},
                 color={0,0,127}));
  connect(x2.y,mapFun. x2) annotation (Line(points={{32,-100},{40,-100},{40,-84},
          {88,-84}}, color={0,0,127}));
  connect(booToRea.y, yIsoAmb) annotation (Line(points={{152,-120},{200,-120}},
                                 color={0,0,127}));
  connect(and1.y, conColRej.uEna) annotation (Line(points={{38,-220},{-4,-220},
          {-4,-212}},  color={255,0,255}));
  connect(greThr.y, truFalHol.u)
    annotation (Line(points={{12,-160},{38,-160}}, color={255,0,255}));
  connect(truFalHol.y, booToRea.u)
    annotation (Line(points={{62,-160},{100,-160},{100,-120},{128,-120}},
                                                     color={255,0,255}));
  connect(truFalHol.y, not1.u) annotation (Line(points={{62,-160},{100,-160},{
          100,-168}},                   color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{100,-192},{100,-212},{62,
          -212}}, color={255,0,255}));
  connect(and2.y, and1.u1) annotation (Line(points={{132,100},{160,100},{160,
          -220},{62,-220}}, color={255,0,255}));
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
</html>", info="<html>
<p>
This block serves as the controller for the hot side of the ETS in
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory</a>.
See
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold</a>
for the computation of the demand signal <code>yDem</code>.
The other control signals are computed as follows.
</p>
<ul>
<li>
Control signals for ambient sources <code>yAmb</code> (array)<br/>

The controller for heat rejection is always enabled.
It maintains the temperature at the bottom of the heating water tank
at the heating water supply temperature set point plus a dead band
<code>dTDea</code>.
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
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold</a>.
</li>
<li>
Control signal for the condenser loop isolation valve <code>yIsoAmb</code><br/>
The valve is commanded to be fully open whenever the controller
for heat rejection yields an output signal greater than zero
(with a true hold of 300s to avoid short cycling).
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-240},{180,240}})));
end SideHot;
