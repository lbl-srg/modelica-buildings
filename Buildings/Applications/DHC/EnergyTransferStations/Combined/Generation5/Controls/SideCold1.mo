within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model SideCold1 "Control block for cold side"
  extends BaseClasses.PartialSideHotCold(
    final reverseActing=true);
  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum tank temperature"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  LimPlaySequence conPlaSeq(
    have_enaSig=true,
    final nCon=nSouAmb,
    yThr=0.9,
    final hys=dTHys,
    final dea=dTDea,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing)
    annotation (Placement(transformation(extent={{-70,-150},{-50,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=
        Modelica.Constants.eps) "At least one signal is non zero"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(nin=nSouAmb)
    "Maximum of control signals for ambient sources"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-90,-190},{-70,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRej
    "Enable signal for heat or cold rejection" annotation (Placement(
        transformation(extent={{-220,120},{-180,160}}), iconTransformation(
          extent={{-140,20},{-100,60}})));
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
  connect(TTop, swi.u1) annotation (Line(points={{-200,-60},{-100,-60},{-100,
          -172},{-92,-172}}, color={0,0,127}));
  connect(greThr.y,booToRea. u) annotation (Line(points={{102,-140},{118,-140}},
                     color={255,0,255}));
  connect(booToRea.y, yIsoAmb) annotation (Line(points={{142,-140},{160,-140},{
          160,-120},{200,-120}},
                           color={0,0,127}));
  connect(TSet,conPlaSeq. u_s) annotation (Line(points={{-200,40},{-160,40},{
          -160,-140},{-72,-140}},
                              color={0,0,127}));
  connect(mulMax.y,greThr. u)
    annotation (Line(points={{62,-140},{78,-140}}, color={0,0,127}));
  connect(TSet,swi. u3) annotation (Line(points={{-200,40},{-160,40},{-160,-188},
          {-92,-188}}, color={0,0,127}));
  connect(swi.y,conPlaSeq. u_m) annotation (Line(points={{-68,-180},{-60,-180},
          {-60,-152}}, color={0,0,127}));
  connect(conPlaSeq.y,mulMax. u)
    annotation (Line(points={{-48,-140},{38,-140}}, color={0,0,127}));
  connect(conPlaSeq.y, yAmb) annotation (Line(points={{-48,-140},{0,-140},{0,
          -80},{200,-80}}, color={0,0,127}));
  connect(uRej,swi. u2) annotation (Line(points={{-200,140},{-140,140},{-140,
          -180},{-92,-180}}, color={255,0,255}));
  connect(uRej,conPlaSeq. uEna) annotation (Line(points={{-200,140},{-140,140},
          {-140,-160},{-64,-160},{-64,-152}}, color={255,0,255}));
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
</html>"));
end SideCold1;
