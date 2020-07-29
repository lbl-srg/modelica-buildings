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
    final reverseActing=true) "Controller for cold rejection"
    annotation (Placement(transformation(extent={{-10,-230},{10,-210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCol(final unit="1")
    "Control signal for cold side" annotation (Placement(transformation(extent={
            {180,-180},{220,-140}}), iconTransformation(extent={{100,-100},{140,
            -60}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=
        Modelica.Constants.eps) "At least one signal is non zero"
    annotation (Placement(transformation(extent={{70,-150},{90,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{136,-150},{156,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conHeaRej(
    final k=k,
    final Ti=Ti,
    final controllerType=controllerType,
    final yMin=0,
    final yMax=nSouAmb,
    final reverseActing=false) "Controller for heat rejection"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(final p=if
        reverseActing then -abs(dTDea) else abs(dTDea), final k=1)
    "Add dead band to set point"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun[nSouAmb]
    "Mapping functions for controlled systems"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x1[nSouAmb](
    final k={(i - 1) * 0.9 for i in 1:nSouAmb})
    "x1"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator rep(
    final nout=nSouAmb)
    "Replicate control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-120})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f1[nSouAmb](
    each final k=0) "f1"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f2[nSouAmb](
    each final k=1)
    "f2"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x2[nSouAmb](
    final k={(i - sigDea) for i in 1:nSouAmb}) "x2"
    annotation (Placement(transformation(extent={{30,-190},{50,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,-190})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-260})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=300,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{100,-150},{120,-130}})));
equation
  connect(min.u1, TTop) annotation (Line(points={{-92,-54},{-120,-54},{-120,-60},
          {-200,-60}},color={0,0,127}));
  connect(min.u2, TBot) annotation (Line(points={{-92,-66},{-100,-66},{-100,
          -140},{-200,-140}},
                       color={0,0,127}));

  connect(min.y, errDis.u2) annotation (Line(points={{-68,-60},{-60,-60},{-60,
          -12}}, color={0,0,127}));
  connect(TTop, errEna.u2) annotation (Line(points={{-200,-60},{-120,-60},{-120,
          20},{-80,20},{-80,28}},   color={0,0,127}));
  connect(TBot, conHeaRej.u_m) annotation (Line(points={{-200,-140},{-40,-140},
          {-40,-132}},                        color={0,0,127}));
  connect(mapFun.y, yAmb)
    annotation (Line(points={{112,-100},{120,-100},{120,-80},{200,-80}},
                                                   color={0,0,127}));
  connect(TSet, conColRej.u_s) annotation (Line(points={{-200,40},{-160,40},{
          -160,-220},{-12,-220}},
                             color={0,0,127}));
  connect(TTop, conColRej.u_m) annotation (Line(points={{-200,-60},{-120,-60},{
          -120,-240},{0,-240},{0,-232}},color={0,0,127}));
  connect(conColRej.y, yCol) annotation (Line(points={{12,-220},{140,-220},{140,
          -160},{200,-160}}, color={0,0,127}));
  connect(TSet,addPar. u) annotation (Line(points={{-200,40},{-160,40},{-160,-120},
          {-82,-120}},  color={0,0,127}));
  connect(addPar.y, conHeaRej.u_s)
    annotation (Line(points={{-58,-120},{-52,-120}}, color={0,0,127}));
  connect(conHeaRej.y, greThr.u) annotation (Line(points={{-28,-120},{-20,-120},
          {-20,-140},{68,-140}},
                               color={0,0,127}));
  connect(x1.y,mapFun. x1) annotation (Line(points={{22,-80},{60,-80},{60,-92},{
          88,-92}},  color={0,0,127}));
  connect(conHeaRej.y, rep.u) annotation (Line(points={{-28,-120},{-2,-120}},
                           color={0,0,127}));
  connect(rep.y,mapFun. u) annotation (Line(points={{22,-120},{48,-120},{48,-100},
          {88,-100}},color={0,0,127}));
  connect(f1.y,mapFun. f1) annotation (Line(points={{22,-160},{54,-160},{54,-96},
          {88,-96}},                  color={0,0,127}));
  connect(f2.y,mapFun. f2) annotation (Line(points={{62,-60},{80,-60},{80,-108},
          {88,-108}},
                 color={0,0,127}));
  connect(x2.y,mapFun. x2) annotation (Line(points={{52,-180},{60,-180},{60,-104},
          {88,-104}},color={0,0,127}));
  connect(booToRea.y, yIsoAmb) annotation (Line(points={{158,-140},{168,-140},{168,
          -120},{200,-120}},     color={0,0,127}));
  connect(and1.y, conColRej.uEna) annotation (Line(points={{2.22045e-15,-248},{
          -4,-248},{-4,-232}},
                       color={255,0,255}));
  connect(greThr.y, truFalHol.u)
    annotation (Line(points={{92,-140},{98,-140}}, color={255,0,255}));
  connect(truFalHol.y, booToRea.u)
    annotation (Line(points={{122,-140},{134,-140}}, color={255,0,255}));
  connect(truFalHol.y, not1.u) annotation (Line(points={{122,-140},{126,-140},{126,
          -170},{120,-170},{120,-178}}, color={255,0,255}));
  connect(not1.y, and1.u1) annotation (Line(points={{120,-202},{120,-276},{0,
          -276},{0,-272}}, color={255,0,255}));
  connect(and2.y, and1.u2) annotation (Line(points={{132,100},{160,100},{160,
          -280},{-8,-280},{-8,-272}}, color={255,0,255}));
   annotation (
   defaultComponentName="conHot",
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
This block serves as the controller for the hot side of the ETS.
See 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold</a>
for the description of the control logic.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-340},{180,240}})));
end SideHot;
