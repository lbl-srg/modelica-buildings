within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Supervisory
  "Supervisory controller"
  extends BaseClasses.PartialSupervisory;
  parameter Modelica.SIunits.TemperatureDifference dTDea(
    min=0)=0.5
    "Temperature dead band (absolute value)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real kHot(
    min=0)=0.1
    "Gain of controller on hot side";
  parameter Real kCol(
    min=0)=0.2
    "Gain of controller on cold side";
  parameter Modelica.SIunits.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small)=300
    "Time constant of integrator block (hot and cold side)"
    annotation (Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Temperature THeaWatSupSetMin(
    displayUnit="degC")
    "Minimum value of heating water supply temperature set point";
  parameter Modelica.SIunits.Temperature TChiWatSupSetMin(
    displayUnit="degC")
    "Minimum value of chilled water supply temperature set point";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoCon_actual(final unit=
       "1") "Return position of condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoEva_actual(final unit=
       "1") "Return position of evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  SideHot conHot(
    final k=kHot,
    final Ti=Ti,
    final nSouAmb=nSouAmb,
    final controllerType=controllerType)
    "Hot side controller"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  SideCold conCol(
    final k=kCol,
    final Ti=Ti,
    final nSouAmb=nSouAmb,
    final controllerType=controllerType,
    final TChiWatSupSetMin=TChiWatSupSetMin)
    "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-42},{10,-22}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nSouAmb]
    "Maximum of output control signals"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Reset resTSup(
    final THeaWatSupSetMin=THeaWatSupSetMin)
    "Supply temperature reset"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
equation
  connect(conHot.yAmb,max1.u1)
    annotation (Line(points={{12,34},{40,34},{40,6},{48,6}},color={0,0,127}));
  connect(conCol.yAmb,max1.u2)
    annotation (Line(points={{12,-28},{40,-28},{40,-6},{48,-6}},color={0,0,127}));
  connect(conHot.yCol,conCol.uCol)
    annotation (Line(points={{12,26},{16,26},{16,-16},{-20,-16},{-20,-32.2},{
          -12,-32.2}},                                                               color={0,0,127}));
  connect(resTSup.THeaWatSupSet,conHot.TSet)
    annotation (Line(points={{-48,20},{-30,20},{-30,34.2},{-12,34.2}},
                                                                    color={0,0,127}));
  connect(THeaWatTop,conHot.TTop)
    annotation (Line(points={{-140,0},{-20,0},{-20,30},{-12,30}},color={0,0,127}));
  connect(max1.y,yAmb)
    annotation (Line(points={{72,0},{90,0},{90,-20},{140,-20}},  color={0,0,127}));
  connect(TChiWatBot,conCol.TBot)
    annotation (Line(points={{-140,-60},{-20,-60},{-20,-40.4},{-12,-40.4}},  color={0,0,127}));
  connect(THeaWatSupPreSet,resTSup.THeaWatSupPreSet)
    annotation (Line(points={{-140,20},{-100,20},{-100,15},{-72,15}},  color={0,0,127}));
  connect(conHot.yValIso, yValIsoCon) annotation (Line(points={{12,30},{60,30},{
          60,20},{140,20}}, color={0,0,127}));
  connect(conCol.yValIso, yValIsoEva) annotation (Line(points={{12,-32},{100,-32},
          {100,0},{140,0}}, color={0,0,127}));
  connect(resTSup.THeaWatSupSet,THeaWatSupSet)
    annotation (Line(points={{-48,20},{-30,20},{-30,-60},{140,-60}},  color={0,0,127}));
  connect(conCol.TChiWatSupSet,TChiWatSupSet)
    annotation (Line(points={{12,-36},{20,-36},{20,-80},{140,-80}},color={0,0,127}));
  connect(TChiWatSupPreSet,conCol.TSet)
    annotation (Line(points={{-140,-40},{-40,-40},{-40,-36.2},{-12,-36.2}},
                                                                       color={0,0,127}));
  connect(uHeaHol.y,conHot.uHeaCoo)
    annotation (Line(points={{-88,100},{-20,100},{-20,38},{-12,38}},color={255,0,255}));
  connect(uCooHol.y,conCol.uHeaCoo)
    annotation (Line(points={{-88,60},{-40,60},{-40,-24},{-12,-24}},color={255,0,255}));
  connect(uHeaHol.y,resTSup.uHea)
    annotation (Line(points={{-88,100},{-80,100},{-80,26},{-72,26}},  color={255,0,255}));
  connect(uHeaHol.y,yHea)
    annotation (Line(points={{-88,100},{140,100}},color={255,0,255}));
  connect(uCooHol.y,yCoo)
    annotation (Line(points={{-88,60},{140,60}},color={255,0,255}));
  connect(yValIsoCon_actual, conHot.yValIsoCon_actual) annotation (Line(points=
          {{-140,-80},{-28,-80},{-28,26},{-12,26}}, color={0,0,127}));
  connect(yValIsoEva_actual, conHot.yValIsoEva_actual) annotation (Line(points=
          {{-140,-100},{-26,-100},{-26,22},{-12,22}}, color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}})),
    defaultComponentName="conSup",
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
This block implements the supervisory control functions of the ETS model
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield</a>.
</p>
<ul>
<li>
It provides the tank demand signals to enable the chiller system,
based on the logic described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold</a>.
</li>
<li>
It resets the heating water supply temperature based on the logic described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset</a>.
Note that this resetting logic is meant to operate the chiller at low lift.
The chilled water supply temperature may be also reset down by
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideHot\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideHot</a>
to maintain the heating water supply temperature set point.
This second resetting logic is required for the heating function of the unit,
but it has a negative impact on the lift.
</li>
<li>
It controls the systems serving as ambient sources based on the logic described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold</a>
and
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideHot\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideHot</a>.
The systems are controlled based on the
maximum of the control signals yielded by the hot side and cold side controllers.
</li>
</ul>
</html>"));
end Supervisory;
