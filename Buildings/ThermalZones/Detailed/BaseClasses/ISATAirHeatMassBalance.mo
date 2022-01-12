within Buildings.ThermalZones.Detailed.BaseClasses;
model ISATAirHeatMassBalance
  "Heat and mass balance of the air based on ISAT"
  extends Buildings.ThermalZones.Detailed.BaseClasses.CFDAirHeatMassBalance;

  redeclare ISATExchange cfd(
    final cfdFilNam=cfdFilNam,
    final startTime=startTime,
    final activateInterface=useCFD,
    final samplePeriod=if useCFD then samplePeriod else Modelica.Constants.inf,
    final nWri=kFluIntC_inflow + Medium.nC*nPorts,
    final nRea=kSen + nSen,
    final nSur=nSur,
    final surIde=surIde,
    final haveShade=haveShade,
    final haveSensor=haveSensor,
    final sensorName=sensorName,
    final portName=portName,
    final yFixed=yFixed,
    final nXi=Medium.nXi,
    final nC=Medium.nC,
    final haveSource=haveSource,
    final nSou=nSou,
    final sourceName=sourceName,
    final rho_start=rho_start,
    final nConExtWin=NConExtWin) "Block that exchanges data with the ISAT simulation"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));

  annotation (Documentation(info="<html>
<p>
Block derived from <a href=\"modelica://Buildings.ThermalZones.Detailed.
BaseClasses.CFDAirHeatMassBalance\"> Buildings.ThermalZones.Detailed.
BaseClasses.CFDAirHeatMassBalance</a> to compute the heat and 
mass balance of the air using ISAT.
</html>",   revisions="<html>
<ul>
<li>
January 5, 2022, by Xu Han, Cary Faulkner, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ISATAirHeatMassBalance;
