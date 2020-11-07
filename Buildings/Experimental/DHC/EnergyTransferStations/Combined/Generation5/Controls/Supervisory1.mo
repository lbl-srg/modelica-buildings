within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Supervisory1
  "Supervisory controller"
  extends BaseClasses.PartialSupervisory;
  parameter Modelica.SIunits.TemperatureDifference dTHys(
    min=0)=1
    "Temperature hysteresis (absolute value)";
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
  Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideHot1 conHotSid(
    final nSouAmb=nSouAmb,
    final dTHys=dTHys,
    final dTDea=dTDea,
    final controllerType=controllerType,
    final k=kHot,
    final Ti=Ti)
    "Hot side controller"
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));
  Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold1 conColSid(
    final nSouAmb=nSouAmb,
    final dTHys=dTHys,
    final dTDea=dTDea,
    final controllerType=controllerType,
    final k=kCol,
    final Ti=Ti)
    "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nSouAmb]
    "Maximum of output control signals"
    annotation (Placement(transformation(extent={{52,-10},{72,10}})));
  Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset resTSup(
    final THeaWatSupSetMin=THeaWatSupSetMin)
    "Supply temperature reset"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  RejectionMode rejMod(
    final dTDea=dTDea)
    "Rejection mode selection"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
equation
  connect(conHotSid.yAmb,max1.u1)
    annotation (Line(points={{12,41},{28,41},{28,6},{50,6}},color={0,0,127}));
  connect(conColSid.yAmb,max1.u2)
    annotation (Line(points={{12,-41},{28,-41},{28,-6},{50,-6}},color={0,0,127}));
  connect(resTSup.THeaWatSupSet,conHotSid.TSet)
    annotation (Line(points={{-48,20},{-30,20},{-30,42},{-12,42}},color={0,0,127}));
  connect(conHotSid.e,rejMod.dTHeaWat)
    annotation (Line(points={{12,44},{16,44},{16,87},{38,87}},color={0,0,127}));
  connect(conColSid.e,rejMod.dTChiWat)
    annotation (Line(points={{12,-38},{20,-38},{20,83},{38,83}},color={0,0,127}));
  connect(rejMod.yHeaRej,conHotSid.uRej)
    annotation (Line(points={{62,95},{70,95},{70,68},{-20,68},{-20,46},{-12,46}},color={255,0,255}));
  connect(rejMod.yColRej,conColSid.uRej)
    annotation (Line(points={{62,85},{80,85},{80,-26},{-20,-26},{-20,-36},{-12,-36}},color={255,0,255}));
  connect(conHotSid.yDem,rejMod.uHea)
    annotation (Line(points={{12,48},{26,48},{26,96.8},{38,96.8}},color={255,0,255}));
  connect(conColSid.yDem,rejMod.uCoo)
    annotation (Line(points={{12,-34},{32,-34},{32,93},{38,93}},color={255,0,255}));
  connect(max1.y,yAmb)
    annotation (Line(points={{74,0},{96,0},{96,-20},{140,-20}},color={0,0,127}));
  connect(conHotSid.yIsoAmb,yIsoCon)
    annotation (Line(points={{12,36},{114,36},{114,20},{140,20}},color={0,0,127}));
  connect(conColSid.yIsoAmb,yIsoEva)
    annotation (Line(points={{12,-46},{100,-46},{100,0},{140,0}},color={0,0,127}));
  connect(conHotSid.yDem,yHea)
    annotation (Line(points={{12,48},{100,48},{100,100},{140,100}},color={255,0,255}));
  connect(conColSid.yDem,yCoo)
    annotation (Line(points={{12,-34},{90,-34},{90,60},{140,60}},color={255,0,255}));
  connect(THeaWatSupPreSet,resTSup.THeaWatSupPreSet)
    annotation (Line(points={{-140,20},{-80,20},{-80,15},{-72,15}},color={0,0,127}));
  connect(TChiWatTop,conColSid.TTop)
    annotation (Line(points={{-140,-80},{-40,-80},{-40,-44},{-12,-44}},color={0,0,127}));
  connect(TChiWatBot,conColSid.TBot)
    annotation (Line(points={{-140,-100},{-20,-100},{-20,-48},{-12,-48}},color={0,0,127}));
  connect(THeaWatTop,conHotSid.TTop)
    annotation (Line(points={{-140,0},{-20,0},{-20,38},{-12,38}},color={0,0,127}));
  connect(THeaWatBot,conHotSid.TBot)
    annotation (Line(points={{-140,-20},{-16,-20},{-16,34},{-12,34}},color={0,0,127}));
  connect(resTSup.THeaWatSupSet,THeaWatSupSet)
    annotation (Line(points={{-48,20},{108,20},{108,-60},{140,-60}},color={0,0,127}));
  connect(uHeaHol.y,conHotSid.uHeaCoo)
    annotation (Line(points={{-88,100},{-30,100},{-30,50},{-12,50}},color={255,0,255}));
  connect(uCooHol.y,conColSid.uHeaCoo)
    annotation (Line(points={{-88,60},{-40,60},{-40,-32},{-12,-32}},color={255,0,255}));
  connect(TChiWatSupPreSet,conColSid.TSet)
    annotation (Line(points={{-140,-60},{-60,-60},{-60,-40},{-12,-40}},color={0,0,127}));
  connect(uHeaHol.y,resTSup.uHea)
    annotation (Line(points={{-88,100},{-80,100},{-80,26},{-72,26}},color={255,0,255}));
  connect(TChiWatSupPreSet,TChiWatSupSet)
    annotation (Line(points={{-140,-60},{80,-60},{80,-80},{140,-80}},color={0,0,127}));
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
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield1\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield1</a>.
</p>
<ul>
<li>
It provides the tank demand signals to enable the chiller system,
based on the logic described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold</a>.
</li>
<li>
It resets the heating water and chilled water supply temperature
based on the logic described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset</a>.
Note that this resetting logic is meant to operate the chiller at low lift.
The chilled water supply temperature may be also reset down by
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Chiller\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Chiller</a>
to maintain the heating water supply temperature set point.
This second resetting logic is required for the heating function of the unit,
but it has a negative impact on the lift.
</li>
<li>
It controls the systems serving as ambient sources based on the logic described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold1\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold1</a>
and
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideHot1\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideHot1</a>.
The systems are controlled based on the
maximum of the control signals yielded by the hot side and cold side controllers.
</li>
</ul>
</html>"));
end Supervisory1;
