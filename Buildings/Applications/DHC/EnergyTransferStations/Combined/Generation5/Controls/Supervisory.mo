within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Supervisory "Supervisory controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nSouAmb
    "Number of ambient sources to control"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dTHys = 2
    "Temperature hysteresis (absolute value)";
  parameter Modelica.SIunits.TemperatureDifference dTDea = 0
    "Temperature dead band (absolute value)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real kHot[nSouAmb](each min=0)=fill(0.1, nSouAmb)
    "Gain of controller on hot side";
  parameter Real kCol[nSouAmb](each min=0)=fill(0.2, nSouAmb)
    "Gain of controller on cold side";
  parameter Modelica.SIunits.Time Ti[nSouAmb](
    each min=Buildings.Controls.OBC.CDL.Constants.small)=fill(300, nSouAmb)
    "Time constant of integrator block (hot and cold side)"
    annotation (Dialog(enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Temperature THeaWatSupSetMin(
    displayUnit="degC")
    "Minimum value of heating water supply temperature set-point";
  parameter Modelica.SIunits.Temperature TChiWatSupSetMax(
    displayUnit="degC")
    "Maximum value of chilled water supply temperature set-point";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal" annotation (Placement(transformation(extent={{-160,90},
            {-120,130}}), iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal" annotation (Placement(transformation(extent={{-160,70},
            {-120,110}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupPreSet(final unit="K",
      displayUnit="degC") "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatTop(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank top"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatBot(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
       iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatTop(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank top"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatBot(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupPreSet(
    final unit="K", displayUnit="degC") "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point after reset" annotation (
      Placement(transformation(extent={{120,-60},{160,-20}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point after reset" annotation (
      Placement(transformation(extent={{120,-100},{160,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoEva(
    final unit="1")
    "Evaporator to ambient loop isolation valve control signal" annotation (
      Placement(transformation(extent={{120,20},{160,60}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoCon(
    final unit="1") "Condenser to ambient loop isolation valve control signal"
    annotation (
      Placement(transformation(extent={{120,60},{160,100}}), iconTransformation(
          extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAmb[nSouAmb](
    each final unit="1") "Control output for ambient sources" annotation (
      Placement(transformation(extent={{120,-20},{160,20}}),iconTransformation(
          extent={{100,60},{140,100}})));

  SideHot conHotSid(
    final nSouAmb=nSouAmb,
    final dTHys=dTHys,
    final dTDea=dTDea,
    final controllerType=controllerType,
    final k=kHot,
    final Ti=Ti)
    "Hot side controller"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  SideCold conColSid(
    final nSouAmb=nSouAmb,
    final dTHys=dTHys,
    final dTDea=dTDea,
    final controllerType=controllerType,
    final k=kCol,
    final Ti=Ti)
    "Cold side controller"
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nSouAmb]
    "Maximum of output control signals"
    annotation (Placement(transformation(extent={{74,-10},{94,10}})));
  Reset resTSup(final THeaWatSupSetMin=THeaWatSupSetMin, final TChiWatSupSetMax=
       TChiWatSupSetMax) "Supply temperature reset"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater heaRejDemDom
    annotation (Placement(transformation(extent={{80,230},{100,250}})));
  Buildings.Controls.OBC.CDL.Logical.Not noHeaDem
    annotation (Placement(transformation(extent={{120,170},{140,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not noCooDem
    annotation (Placement(transformation(extent={{120,130},{140,150}})));
  Buildings.Controls.OBC.CDL.Logical.And cooOnl
    annotation (Placement(transformation(extent={{160,170},{180,190}})));
  Buildings.Controls.OBC.CDL.Logical.And heaOnl
    annotation (Placement(transformation(extent={{160,130},{180,150}})));
  Buildings.Controls.OBC.CDL.Logical.And heaCoo
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Controls.OBC.CDL.Logical.And heaCoo1
    annotation (Placement(transformation(extent={{200,210},{220,230}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaRejRaw
    annotation (Placement(transformation(extent={{230,210},{250,230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold heaRej(trueHoldDuration=300)
    annotation (Placement(transformation(extent={{260,210},{280,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHeaRej
    annotation (Placement(transformation(extent={{300,210},{320,230}})));
  Buildings.Controls.OBC.CDL.Logical.Or cooRejRaw
    annotation (Placement(transformation(extent={{230,130},{250,150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold cooRejHol(trueHoldDuration=
        300)
    annotation (Placement(transformation(extent={{260,130},{280,150}})));
  Buildings.Controls.OBC.CDL.Logical.And heaCoo2
    annotation (Placement(transformation(extent={{200,150},{220,170}})));
  Buildings.Controls.OBC.CDL.Logical.And colRej
    annotation (Placement(transformation(extent={{320,130},{340,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not noCooDem1
    annotation (Placement(transformation(extent={{120,250},{140,270}})));
equation
  connect(THeaWatTop, conHotSid.TTop) annotation (Line(points={{-140,20},{16,20},
          {16,46},{28,46}},       color={0,0,127}));
  connect(THeaWatBot, conHotSid.TBot) annotation (Line(points={{-140,0},{20,0},
          {20,42},{28,42}},       color={0,0,127}));
  connect(TChiWatBot, conColSid.TBot) annotation (Line(points={{-140,-80},{-20,
          -80},{-20,-58},{28,-58}},  color={0,0,127}));
  connect(conHotSid.yAmb, max1.u1)
    annotation (Line(points={{52,49},{68,49},{68,6},{72,6}}, color={0,0,127}));
  connect(conColSid.yAmb, max1.u2) annotation (Line(points={{52,-51},{68,-51},{
          68,-6},{72,-6}},
                        color={0,0,127}));
  connect(uHea, conHotSid.uHeaCoo) annotation (Line(points={{-140,110},{-16,110},
          {-16,58},{28,58}},  color={255,0,255}));
  connect(uCoo, conColSid.uHeaCoo) annotation (Line(points={{-140,90},{-20,90},
          {-20,-42},{28,-42}}, color={255,0,255}));
  connect(TChiWatTop, conColSid.TTop) annotation (Line(points={{-140,-60},{-24,
          -60},{-24,-54},{28,-54}},  color={0,0,127}));
  connect(uHea, resTSup.uHea) annotation (Line(points={{-140,110},{-100,110},{-100,
          -92},{-82,-92}}, color={255,0,255}));
  connect(uCoo, resTSup.uCoo) annotation (Line(points={{-140,90},{-104,90},{-104,
          -97},{-82,-97}}, color={255,0,255}));
  connect(THeaWatSupPreSet, resTSup.THeaWatSupPreSet) annotation (Line(points={{-140,40},
          {-112,40},{-112,-103},{-82,-103}},          color={0,0,127}));
  connect(TChiWatSupPreSet, resTSup.TChiWatSupPreSet) annotation (Line(points={{-140,
          -40},{-116,-40},{-116,-108},{-82,-108}},      color={0,0,127}));
  connect(resTSup.TChiWatSupSet, TChiWatSupSet) annotation (Line(points={{-58,-105},
          {100,-105},{100,-80},{140,-80}}, color={0,0,127}));
  connect(resTSup.THeaWatSupSet, THeaWatSupSet) annotation (Line(points={{-58,-95},
          {80,-95},{80,-40},{140,-40}}, color={0,0,127}));
  connect(conColSid.yIsoAmb, yIsoEva) annotation (Line(points={{52,-57},{104,
          -57},{104,40},{140,40}},
                                color={0,0,127}));
  connect(max1.y, yAmb) annotation (Line(points={{96,0},{140,0}},
        color={0,0,127}));
  connect(resTSup.THeaWatSupSet, conHotSid.TSet) annotation (Line(points={{-58,-95},
          {12,-95},{12,50},{28,50}},    color={0,0,127}));
  connect(resTSup.TChiWatSupSet, conColSid.TSet) annotation (Line(points={{-58,
          -105},{-32,-105},{-32,-50},{28,-50}},
                                           color={0,0,127}));
  connect(conHotSid.yIsoAmb, yIsoCon) annotation (Line(points={{52,43},{84,43},
          {84,80},{140,80}}, color={0,0,127}));
  connect(noHeaDem.y, cooOnl.u1)
    annotation (Line(points={{142,180},{158,180}}, color={255,0,255}));
  connect(noCooDem.y, heaOnl.u2) annotation (Line(points={{142,140},{144,140},{
          144,132},{158,132}}, color={255,0,255}));
  connect(heaRejDemDom.y, heaCoo1.u1) annotation (Line(points={{102,240},{192,
          240},{192,220},{198,220}}, color={255,0,255}));
  connect(heaCoo.y, heaCoo1.u2) annotation (Line(points={{182,220},{188,220},{
          188,212},{198,212}}, color={255,0,255}));
  connect(heaCoo1.y, heaRejRaw.u1)
    annotation (Line(points={{222,220},{228,220}}, color={255,0,255}));
  connect(cooOnl.y, heaRejRaw.u2) annotation (Line(points={{182,180},{224,180},
          {224,212},{228,212}}, color={255,0,255}));
  connect(uHea, noHeaDem.u) annotation (Line(points={{-140,110},{0,110},{0,180},
          {118,180}}, color={255,0,255}));
  connect(uCoo, noCooDem.u) annotation (Line(points={{-140,90},{80,90},{80,140},
          {118,140}}, color={255,0,255}));
  connect(uHea, heaOnl.u1) annotation (Line(points={{-140,110},{0,110},{0,
          180.588},{80,180.588},{80,160},{150,160},{150,140},{158,140}}, color=
          {255,0,255}));
  connect(uCoo, cooOnl.u2) annotation (Line(points={{-140,90},{80,90},{80,140},
          {90,140},{90,166},{150,166},{150,172},{158,172}}, color={255,0,255}));
  connect(conHotSid.e, heaRejDemDom.u2) annotation (Line(points={{52,52},{56,52},
          {56,232},{78,232}}, color={0,0,127}));
  connect(conColSid.e, heaRejDemDom.u1) annotation (Line(points={{52,-48},{58,
          -48},{58,240},{78,240}}, color={0,0,127}));
  connect(heaRejRaw.y, heaRej.u)
    annotation (Line(points={{252,220},{258,220}}, color={255,0,255}));
  connect(heaRej.y, notHeaRej.u)
    annotation (Line(points={{282,220},{298,220}}, color={255,0,255}));
  connect(heaRej.y, conHotSid.uMod) annotation (Line(points={{282,220},{294,220},
          {294,72},{20,72},{20,54},{28,54}}, color={255,0,255}));
  connect(uHea, heaCoo.u1) annotation (Line(points={{-140,110},{0,110},{0,180},
          {80,180},{80,220},{158,220}}, color={255,0,255}));
  connect(uCoo, heaCoo.u2) annotation (Line(points={{-140,90},{80,90},{80,140},
          {90,140},{90,212},{158,212}}, color={255,0,255}));
  connect(cooRejRaw.y, cooRejHol.u)
    annotation (Line(points={{252,140},{258,140}}, color={255,0,255}));
  connect(heaCoo2.y, cooRejRaw.u1) annotation (Line(points={{222,160},{224,160},
          {224,140},{228,140}}, color={255,0,255}));
  connect(heaOnl.y, cooRejRaw.u2) annotation (Line(points={{182,140},{220,140},
          {220,132},{228,132}}, color={255,0,255}));
  connect(cooRejHol.y, colRej.u2) annotation (Line(points={{282,140},{300,140},
          {300,132},{318,132}}, color={255,0,255}));
  connect(notHeaRej.y, colRej.u1) annotation (Line(points={{322,220},{328,220},
          {328,160},{312,160},{312,140},{318,140}}, color={255,0,255}));
  connect(heaCoo.y, heaCoo2.u1) annotation (Line(points={{182,220},{188,220},{
          188,160},{198,160}}, color={255,0,255}));
  connect(heaRejDemDom.y, noCooDem1.u) annotation (Line(points={{102,240},{110,
          240},{110,260},{118,260}}, color={255,0,255}));
  connect(noCooDem1.y, heaCoo2.u2) annotation (Line(points={{142,260},{156,260},
          {156,152},{198,152}}, color={255,0,255}));
  connect(colRej.y, conColSid.uMod) annotation (Line(points={{342,140},{358,140},
          {358,-20},{20,-20},{20,-46},{28,-46}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            220}})),
        defaultComponentName="conSup",
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
This block implements the supervisory control functions of the ETS.
</p>
<ul>
<li>
It controls the hot and cold sides based on the logic described in 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold</a>.
The systems serving as ambient sources for the ETS are controlled based on the 
maximum of the control signals yielded by the hot and cold side controllers.
</li>
<li>
It resets the heating water and chilled water supply temperature 
based on the logic described in 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset</a>.
Note that this resetting logic is meant to optimize the lift of the chiller. 
The heating water temperature may be reset up by 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Chiller\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Chiller</a> 
to maintain the chilled water supply temperature. This second resetting logic
is required for the heating function of the unit, but it has a negative impact on the lift.
</li>
</ul>
</html>"));
end Supervisory;
