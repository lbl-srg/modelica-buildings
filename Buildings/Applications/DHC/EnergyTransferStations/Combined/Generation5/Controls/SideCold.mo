within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model SideCold "Control block for cold side"
  extends BaseClasses.PartialSideHotCold(
    final reverseActing=true);

  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum tank temperature"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCol
    "Cold rejection control signal"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
                    iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRes(final unit="1")
    "Reset signal for chiller" annotation (Placement(transformation(extent={{180,
            -60},{220,-20}}), iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extSig(
    final nin=nSouAmb + 1,
    final nout=nSouAmb,
    final extract=1:nSouAmb)
    "Extract outputs from the first (nCon - 1) controller"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=
        Modelica.Constants.eps) "At least one signal is non zero"
    annotation (Placement(transformation(extent={{90,-150},{110,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun[nSouAmb + 1]
    "Mapping functions for controlled systems"
    annotation (Placement(transformation(extent={{52,-110},{72,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x1[nSouAmb + 1](
    final k={(i - 1) for i in 1:nSouAmb + 1})
    "x1"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator rep(
    final nout=nSouAmb + 1)
    "Replicate control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-100})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f1[nSouAmb + 1](
    each final k=0)
    "f1"
    annotation (Placement(transformation(extent={{-90,-130},{-70,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f2[nSouAmb + 1](
    each final k=1)
    "f2"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x2[nSouAmb + 1](
    final k={(i - sigDea) for i in 1:nSouAmb + 1})
    "x2"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  LimPIDEnable conColRej(
    final k=k*10,
    final Ti=Ti/2,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final yMin=0,
    final yMax=1,
    final reverseActing=false) "Controller for chilled water set point"
    annotation (Placement(transformation(extent={{-130,-170},{-110,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapAmbSou
    "Mapping functions for ambient sources"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1[nSouAmb]
    annotation (Placement(transformation(extent={{134,-90},{154,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator rep1(final nout=nSouAmb)
    "Replicate control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-160})));
equation
  connect(max.u2, TBot) annotation (Line(points={{-92,-66},{-120,-66},{-120,
          -140},{-200,-140}},
                            color={0,0,127}));
  connect(max.y, errDis.u2) annotation (Line(points={{-68,-60},{-60,-60},{-60,
          -12}}, color={0,0,127}));
  connect(TBot, errEna.u2) annotation (Line(points={{-200,-140},{-120,-140},{
          -120,20},{-80,20},{-80,28}},   color={0,0,127}));
  connect(TTop, max.u1) annotation (Line(points={{-200,-60},{-100,-60},{-100,
          -54},{-92,-54}},  color={0,0,127}));
  connect(mapFun.y, extSig.u)
    annotation (Line(points={{74,-100},{90,-100},{90,-80},{98,-80}},
                                                   color={0,0,127}));
  connect(mapFun[nSouAmb + 1].y, yRes) annotation (Line(points={{74,-100},{80,
          -100},{80,-40},{200,-40}},
                      color={0,0,127}));
  connect(x1.y,mapFun. x1) annotation (Line(points={{22,-80},{40,-80},{40,-92},
          {50,-92}}, color={0,0,127}));
  connect(rep.y,mapFun. u) annotation (Line(points={{-18,-100},{50,-100}},
                     color={0,0,127}));
  connect(f1.y,mapFun. f1) annotation (Line(points={{-68,-120},{36,-120},{36,
          -96},{50,-96}},             color={0,0,127}));
  connect(f2.y,mapFun. f2) annotation (Line(points={{22,-180},{40,-180},{40,
          -108},{50,-108}},
                 color={0,0,127}));
  connect(x2.y,mapFun. x2) annotation (Line(points={{22,-140},{38,-140},{38,
          -104},{50,-104}},
                     color={0,0,127}));
  connect(booToRea.y, yIsoAmb) annotation (Line(points={{142,-140},{160,-140},{160,
          -120},{200,-120}}, color={0,0,127}));
  connect(greThr.y, booToRea.u) annotation (Line(points={{112,-140},{118,-140}},
                  color={255,0,255}));
  connect(and2.y, conColRej.uEna) annotation (Line(points={{132,100},{160,100},
          {160,-200},{-124,-200},{-124,-172}},color={255,0,255}));
  connect(TSet, conColRej.u_s) annotation (Line(points={{-200,40},{-160,40},{
          -160,-160},{-132,-160}},
                              color={0,0,127}));
  connect(TBot, conColRej.u_m) annotation (Line(points={{-200,-140},{-168,-140},
          {-168,-180},{-120,-180},{-120,-172}}, color={0,0,127}));
  connect(conColRej.y, mapAmbSou.u)
    annotation (Line(points={{-108,-160},{-82,-160}},  color={0,0,127}));
  connect(f1[1].y, mapAmbSou.x1) annotation (Line(points={{-68,-120},{-60,-120},
          {-60,-140},{-94,-140},{-94,-152},{-82,-152}},  color={0,0,127}));
  connect(f2[1].y, mapAmbSou.f1) annotation (Line(points={{22,-180},{40,-180},{
          40,-196},{-90,-196},{-90,-156},{-82,-156}},    color={0,0,127}));
  connect(f2[1].y, mapAmbSou.x2) annotation (Line(points={{22,-180},{40,-180},{
          40,-196},{-90,-196},{-90,-164},{-82,-164}},    color={0,0,127}));
  connect(f1[1].y, mapAmbSou.f2) annotation (Line(points={{-68,-120},{-60,-120},
          {-60,-140},{-94,-140},{-94,-168},{-82,-168}},  color={0,0,127}));
  connect(uCol, rep.u) annotation (Line(points={{-200,-110},{-100,-110},{-100,
          -100},{-42,-100}},
                       color={0,0,127}));
  connect(min1.y, yAmb)
    annotation (Line(points={{156,-80},{200,-80}}, color={0,0,127}));
  connect(extSig.y, min1.u1) annotation (Line(points={{122,-80},{124,-80},{124,-74},
          {132,-74}}, color={0,0,127}));
  connect(mapAmbSou.y, rep1.u)
    annotation (Line(points={{-58,-160},{-42,-160}}, color={0,0,127}));
  connect(rep1.y, min1.u2) annotation (Line(points={{-18,-160},{122,-160},{122,
          -100},{132,-100},{132,-86}},
                                 color={0,0,127}));
  connect(mapFun[1].y, greThr.u) annotation (Line(points={{74,-100},{80,-100},{
          80,-140},{88,-140}},
                            color={0,0,127}));
  annotation (
  defaultComponentName="conCol",
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
This block serves as the controller for the cold side of the ETS.
See 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold</a>
for the description of the control logic.
</p>
<p>
Proportional only controller because of idealized control in chiller model.
The gain is increased by a factor 10 so that set point tracking dominates
cold rejection.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-220},{180,220}})));
end SideCold;
