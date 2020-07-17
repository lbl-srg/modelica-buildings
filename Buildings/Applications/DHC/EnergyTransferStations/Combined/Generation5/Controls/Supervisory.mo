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
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  SideCold conColSid(
    final nSouAmb=nSouAmb,
    final dTHys=dTHys,
    final dTDea=dTDea,
    final controllerType=controllerType,
    final k=kCol,
    final Ti=Ti)
    "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nSouAmb]
    "Maximum of output control signals"
    annotation (Placement(transformation(extent={{34,-10},{54,10}})));
  Reset resTSup(final THeaWatSupSetMin=THeaWatSupSetMin, final TChiWatSupSetMax=
       TChiWatSupSetMax) "Supply temperature reset"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  RejectionMode rejectionMode
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
equation
  connect(THeaWatTop, conHotSid.TTop) annotation (Line(points={{-140,20},{-24,
          20},{-24,46},{-12,46}}, color={0,0,127}));
  connect(THeaWatBot, conHotSid.TBot) annotation (Line(points={{-140,0},{-20,0},
          {-20,42},{-12,42}},     color={0,0,127}));
  connect(TChiWatBot, conColSid.TBot) annotation (Line(points={{-140,-80},{-60,
          -80},{-60,-58},{-12,-58}}, color={0,0,127}));
  connect(conHotSid.yAmb, max1.u1)
    annotation (Line(points={{12,49},{28,49},{28,6},{32,6}}, color={0,0,127}));
  connect(conColSid.yAmb, max1.u2) annotation (Line(points={{12,-51},{28,-51},{28,
          -6},{32,-6}}, color={0,0,127}));
  connect(uHea, conHotSid.uHeaCoo) annotation (Line(points={{-140,110},{-56,110},
          {-56,58},{-12,58}}, color={255,0,255}));
  connect(uCoo, conColSid.uHeaCoo) annotation (Line(points={{-140,90},{-60,90},{
          -60,-42},{-12,-42}}, color={255,0,255}));
  connect(TChiWatTop, conColSid.TTop) annotation (Line(points={{-140,-60},{-64,
          -60},{-64,-54},{-12,-54}}, color={0,0,127}));
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
          {40,-95},{40,-40},{140,-40}}, color={0,0,127}));
  connect(conColSid.yIsoAmb, yIsoEva) annotation (Line(points={{12,-56},{64,-56},
          {64,40},{140,40}},    color={0,0,127}));
  connect(max1.y, yAmb) annotation (Line(points={{56,0},{140,0}},
        color={0,0,127}));
  connect(resTSup.THeaWatSupSet, conHotSid.TSet) annotation (Line(points={{-58,-95},
          {-28,-95},{-28,50},{-12,50}}, color={0,0,127}));
  connect(resTSup.TChiWatSupSet, conColSid.TSet) annotation (Line(points={{-58,
          -105},{-20,-105},{-20,-50},{-12,-50}},
                                           color={0,0,127}));
  connect(conHotSid.yIsoAmb, yIsoCon) annotation (Line(points={{12,44},{84,44},{
          84,80},{140,80}},  color={0,0,127}));
  connect(conHotSid.e, rejectionMode.dTHeaWat) annotation (Line(points={{12,52},
          {16,52},{16,87},{38,87}}, color={0,0,127}));
  connect(conColSid.e, rejectionMode.dTChiWat) annotation (Line(points={{12,-48},
          {20,-48},{20,83},{38,83}}, color={0,0,127}));
  connect(rejectionMode.yHeaRej, conHotSid.uRej) annotation (Line(points={{62,
          95},{70,95},{70,68},{-20,68},{-20,54},{-12,54}}, color={255,0,255}));
  connect(rejectionMode.yColRej, conColSid.uRej) annotation (Line(points={{62,
          85},{80,85},{80,-20},{-20,-20},{-20,-46},{-12,-46}}, color={255,0,255}));
  connect(uHea, rejectionMode.uHea) annotation (Line(points={{-140,110},{20,110},
          {20,96.8},{38,96.8}}, color={255,0,255}));
  connect(uCoo, rejectionMode.uCoo) annotation (Line(points={{-140,90},{0,90},{
          0,93},{38,93}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
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
