within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model SideCold "Control block for cold side"
  extends BaseClasses.PartialSideHotCold(
    final reverseActing=true);

  parameter Modelica.SIunits.Temperature TChiWatSupSetMin(
    displayUnit="degC")
    "Minimum value of chilled water supply temperature set point";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCol
    "Cold rejection control signal"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
                    iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum tank temperature"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun[nSouAmb]
    "Mapping functions for ambient source control"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x1[nSouAmb](
    final k={(i - 1) for i in 1:nSouAmb}) "x1"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator rep(
    final nout=nSouAmb)
    "Replicate control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0, origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f1[nSouAmb](
    each final k=0) "f1"
    annotation (Placement(transformation(extent={{10,-150},{30,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f2[nSouAmb](
    each final k=1) "f2"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x2[nSouAmb](
    final k={(i) for i in 1:nSouAmb}) "x2"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{120,-170},{140,-150}})));
  LimPIDEnable conTChiWatSup(
    final k=k*5,
    final Ti=Ti/2,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final yMin=-1,
    final yMax=0,
    final reverseActing=true) "Controller for CHWST"
    annotation (Placement(transformation(extent={{-110,-170},{-90,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFunTChiSupSet
    "Mapping function for CHWST reset"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTChiWatSup(
    y(final unit="K", displayUnit="degC"), final k=TChiWatSupSetMin)
    "Minimum value of chilled water supply temperature"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=nSouAmb, k=
        nSouAmb) "One minus control loop output"
    annotation (Placement(transformation(extent={{-70,-170},{-50,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 "CHWST reset signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(k=0) "Zero"
    annotation (Placement(transformation(extent={{-150,-70},{-130,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(p=-nSouAmb, k=1)
    "Control signal minus nSouAmb"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1
    "Ambient source control signal"
    annotation (Placement(transformation(extent={{-90,-130},{-70,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(
    final nin=nSouAmb)
    "Maximum value"
    annotation (Placement(transformation(extent={{90,-130},{110,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=Modelica.Constants.eps,
    final h=0.5*Modelica.Constants.eps)
    "At least one signal is non zero"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
equation
  connect(max.u2, TBot) annotation (Line(points={{-92,-46},{-120,-46},{-120,
          -140},{-200,-140}}, color={0,0,127}));
  connect(max.y, errDis.u2) annotation (Line(points={{-68,-40},{-60,-40},{-60,
          -12}}, color={0,0,127}));
  connect(TBot, errEna.u2) annotation (Line(points={{-200,-140},{-120,-140},{
          -120,20},{-80,20},{-80,28}},   color={0,0,127}));
  connect(TTop, max.u1) annotation (Line(points={{-200,-40},{-100,-40},{-100,
          -34},{-92,-34}},  color={0,0,127}));
  connect(x1.y,mapFun. x1) annotation (Line(points={{2,-100},{10,-100},{10,-92},
          {48,-92}}, color={0,0,127}));
  connect(rep.y,mapFun. u) annotation (Line(points={{-28,-120},{20,-120},{20,
          -100},{48,-100}},
                     color={0,0,127}));
  connect(f1.y,mapFun. f1) annotation (Line(points={{32,-140},{36,-140},{36,-96},
          {48,-96}},                  color={0,0,127}));
  connect(f2.y,mapFun. f2) annotation (Line(points={{32,-60},{40,-60},{40,-108},
          {48,-108}},
                 color={0,0,127}));
  connect(x2.y,mapFun. x2) annotation (Line(points={{2,-160},{44,-160},{44,-104},
          {48,-104}},color={0,0,127}));
  connect(and2.y, conTChiWatSup.uEna) annotation (Line(points={{132,100},{160,
          100},{160,-180},{-104,-180},{-104,-172}},
                                             color={255,0,255}));
  connect(TSet, conTChiWatSup.u_s) annotation (Line(points={{-200,40},{-160,40},
          {-160,-160},{-112,-160}},color={0,0,127}));
  connect(TBot, conTChiWatSup.u_m) annotation (Line(points={{-200,-140},{-120,
          -140},{-120,-176},{-100,-176},{-100,-172}},
                                              color={0,0,127}));
  connect(zer.y, mapFunTChiSupSet.x1) annotation (Line(points={{2,-40},{20,-40},
          {20,-32},{98,-32}}, color={0,0,127}));
  connect(f2[1].y, mapFunTChiSupSet.x2) annotation (Line(points={{32,-60},{40,
          -60},{40,-44},{98,-44}},
                              color={0,0,127}));
  connect(minTChiWatSup.y, mapFunTChiSupSet.f2) annotation (Line(points={{72,-60},
          {90,-60},{90,-48},{98,-48}}, color={0,0,127}));
  connect(TSet, mapFunTChiSupSet.f1) annotation (Line(points={{-200,40},{-158,40},
          {-158,38},{-160,38},{-160,-20},{6,-20},{6,-36},{98,-36}}, color={0,0,127}));
  connect(mapFunTChiSupSet.y, TChiWatSupSet)
    annotation (Line(points={{122,-40},{200,-40}}, color={0,0,127}));
  connect(conTChiWatSup.y, addPar.u)
    annotation (Line(points={{-88,-160},{-72,-160}}, color={0,0,127}));
  connect(zer1.y, max1.u1) annotation (Line(points={{-128,-60},{-100,-60},{-100,
          -74},{-92,-74}},  color={0,0,127}));
  connect(uCol, addPar1.u)
    annotation (Line(points={{-200,-100},{-152,-100}}, color={0,0,127}));
  connect(addPar1.y, max1.u2) annotation (Line(points={{-128,-100},{-100,-100},
          {-100,-86},{-92,-86}}, color={0,0,127}));
  connect(max1.y, mapFunTChiSupSet.u) annotation (Line(points={{-68,-80},{80,
          -80},{80,-40},{98,-40}},
                               color={0,0,127}));
  connect(uCol, min1.u1) annotation (Line(points={{-200,-100},{-170,-100},{-170,
          -114},{-92,-114}}, color={0,0,127}));
  connect(addPar.y, min1.u2) annotation (Line(points={{-48,-160},{-40,-160},{
          -40,-140},{-100,-140},{-100,-126},{-92,-126}}, color={0,0,127}));
  connect(min1.y, rep.u)
    annotation (Line(points={{-68,-120},{-52,-120}}, color={0,0,127}));
  connect(mapFun.y, yAmb) annotation (Line(points={{72,-100},{140,-100},{140,
          -80},{200,-80}}, color={0,0,127}));
  connect(mapFun.y, mulMax.u) annotation (Line(points={{72,-100},{80,-100},{80,-120},
          {88,-120}}, color={0,0,127}));
  connect(mulMax.y, greThr.u)
    annotation (Line(points={{112,-120},{118,-120}}, color={0,0,127}));
  connect(greThr.y, booToRea.u) annotation (Line(points={{142,-120},{150,-120},{
          150,-140},{110,-140},{110,-160},{118,-160}}, color={255,0,255}));
  connect(booToRea.y, yIsoAmb) annotation (Line(points={{142,-160},{168,-160},{168,
          -120},{200,-120}}, color={0,0,127}));
  annotation (
  defaultComponentName="conCol",
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
This block serves as the controller for the cold side of the ETS in 
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

The cold rejection control signal yielded by the hot side controller
is processed as follows.
<ul>
<li>
A controller is used to track the chilled water
supply temperature (CHWST) set point.
This controller is enabled if the chilled water
tank is in demand. It yields a control signal value between
<code>0</code> and <code>nSouAmb</code>.
Note that a proportional-only controller is required
as the chiller model includes an idealized control of the CHWST.
Therefore, an integral term cannot numerically decrease as
the chilled water supply temperature never drops below its set point.
</li>
<li>
The systems serving as ambient sources are then controlled in sequence
by mapping the minimum between the CHWST control loop output and the
part of the cold rejection signal between <code>0</code>
and <code>nSouAmb</code> to a <code>nSouAmb</code>-array
of signals between <code>0</code> and <code>1</code>.
</li>
</ul>
<li>
Chilled water supply temperature set point <code>TChiWatSupSet</code><br/>

The remaining part of the cold rejection signal between
<code>nSouAmb</code> and <code>nSouAmb+1</code> is used
to reset the CHWST set point between a maximum value provided
as a block input variable, and a minimum value provided as a
parameter.
</li>
<li>
Control signal for the evaporator loop isolation valve <code>yIsoAmb</code><br/>

The valve is commanded to be fully open whenever the control signal
for the first ambient source is greater than zero.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-200},{180,200}})));
end SideCold;
