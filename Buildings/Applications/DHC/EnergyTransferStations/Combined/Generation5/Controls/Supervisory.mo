within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Supervisory "Supervisory controller"
  extends BaseClasses.PartialSupervisory;

  parameter Integer nSouAmb
    "Number of ambient sources to control"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dTDea = 0
    "Temperature dead band (absolute value)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real kHot(min=0)=0.1
    "Gain of controller on hot side";
  parameter Real kCol(min=0)=0.2
    "Gain of controller on cold side";
  parameter Modelica.SIunits.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small)=300
    "Time constant of integrator block (hot and cold side)"
    annotation (Dialog(enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Temperature THeaWatSupSetMin=THeaWatSupSetMin(
      displayUnit="degC")
    "Minimum value of heating water supply temperature set-point";
  parameter Modelica.SIunits.Temperature TChiWatSupSetMax=TChiWatSupSetMax(
      displayUnit="degC")
    "Maximum value of chilled water supply temperature set-point";

  SideHot conHot(
    final k=kHot,
    final kCol=kCol,
    final Ti=Ti,
    final nSouAmb=nSouAmb,
    final dTDea=dTDea,
    final controllerType=controllerType)
    "Hot side controller"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  SideCold conCol(
    final k=kCol,
    final Ti=Ti,
    final nSouAmb=nSouAmb,
    final dTDea=dTDea,
    final controllerType=controllerType) "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nSouAmb]
    "Maximum of output control signals"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Reset resTSup(final THeaWatSupSetMin=THeaWatSupSetMin, final TChiWatSupSetMax=
       TChiWatSupSetMax) "Supply temperature reset"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRes(final unit="1")
    "Reset signal for chiller" annotation (Placement(transformation(extent={{120,
            -128},{160,-88}}),iconTransformation(extent={{100,-130},{140,-90}})));
equation
  connect(conHot.yAmb, max1.u1)
    annotation (Line(points={{12,49},{28,49},{28,6},{48,6}}, color={0,0,127}));
  connect(conCol.yAmb, max1.u2) annotation (Line(points={{12,-51},{28,-51},{28,-6},
          {48,-6}},     color={0,0,127}));
  connect(conCol.yRes, yRes) annotation (Line(points={{12,-58},{20,-58},{20,-108},
          {140,-108}}, color={0,0,127}));
  connect(conHot.yCol, conCol.uCol) annotation (Line(points={{12,42},{20,42},{
          20,-20},{-20,-20},{-20,-46},{-12,-46}},
                                               color={0,0,127}));
  connect(resTSup.THeaWatSupSet, conHot.TSet) annotation (Line(points={{-58,-95},
          {-50,-95},{-50,50},{-12,50}}, color={0,0,127}));
  connect(resTSup.TChiWatSupSet, conCol.TSet) annotation (Line(points={{-58,
          -105},{-36,-105},{-36,-50},{-12,-50}}, color={0,0,127}));
  connect(conHot.yDem, yHea) annotation (Line(points={{12,56},{20,56},{20,100},
          {140,100}}, color={255,0,255}));
  connect(conCol.yDem, yCoo) annotation (Line(points={{12,-44},{40,-44},{40,80},
          {140,80}}, color={255,0,255}));
  connect(uHea, conHot.uHeaCoo) annotation (Line(points={{-140,110},{-40,110},{
          -40,58},{-12,58}}, color={255,0,255}));
  connect(THeaWatTop, conHot.TTop) annotation (Line(points={{-140,20},{-20,20},
          {-20,46},{-12,46}}, color={0,0,127}));
  connect(THeaWatBot, conHot.TBot) annotation (Line(points={{-140,0},{-16,0},{
          -16,42},{-12,42}}, color={0,0,127}));
  connect(uCoo, conCol.uHeaCoo) annotation (Line(points={{-140,90},{-60,90},{
          -60,-42},{-12,-42}}, color={255,0,255}));
  connect(max1.y, yAmb) annotation (Line(points={{72,0},{100,0},{100,0},{140,0}},
        color={0,0,127}));
  connect(TChiWatTop, conCol.TTop) annotation (Line(points={{-140,-60},{-20,-60},
          {-20,-54},{-12,-54}}, color={0,0,127}));
  connect(TChiWatBot, conCol.TBot) annotation (Line(points={{-140,-80},{-16,-80},
          {-16,-58},{-12,-58}}, color={0,0,127}));
  connect(TChiWatSupPreSet, resTSup.TChiWatSupPreSet) annotation (Line(points={
          {-140,-40},{-112,-40},{-112,-108},{-82,-108}}, color={0,0,127}));
  connect(THeaWatSupPreSet, resTSup.THeaWatSupPreSet) annotation (Line(points={
          {-140,40},{-108,40},{-108,-103},{-82,-103}}, color={0,0,127}));
  connect(uHea, resTSup.uHea) annotation (Line(points={{-140,110},{-100,110},{
          -100,-92},{-82,-92}}, color={255,0,255}));
  connect(uCoo, resTSup.uCoo) annotation (Line(points={{-140,90},{-104,90},{
          -104,-97},{-82,-97}}, color={255,0,255}));
  connect(conHot.yIsoAmb, yIsoCon) annotation (Line(points={{12,44},{60,44},{60,
          40},{140,40}}, color={0,0,127}));
  connect(conCol.yIsoAmb, yIsoEva) annotation (Line(points={{12,-56},{48,-56},{
          48,-56},{100,-56},{100,20},{140,20}}, color={0,0,127}));
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
