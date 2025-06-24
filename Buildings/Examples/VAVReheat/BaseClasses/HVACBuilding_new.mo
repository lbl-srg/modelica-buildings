within Buildings.Examples.VAVReheat.BaseClasses;
partial model HVACBuilding_new
  "Partial model that contains the HVAC and building model"

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  final parameter Modelica.Units.SI.Volume VRooCor=flo.VRooCor
    "Room volume corridor";
  final parameter Modelica.Units.SI.Volume VRooSou=flo.VRooSou
    "Room volume south";
  final parameter Modelica.Units.SI.Volume VRooNor=flo.VRooNor
    "Room volume north";
  final parameter Modelica.Units.SI.Volume VRooEas=flo.VRooEas
    "Room volume east";
  final parameter Modelica.Units.SI.Volume VRooWes=flo.VRooWes
    "Room volume west";

  final parameter Modelica.Units.SI.Area AFloCor=flo.AFloCor
    "Floor area corridor";
  final parameter Modelica.Units.SI.Area AFloSou=flo.AFloSou "Floor area south";
  final parameter Modelica.Units.SI.Area AFloNor=flo.AFloNor "Floor area north";
  final parameter Modelica.Units.SI.Area AFloEas=flo.AFloEas "Floor area east";
  final parameter Modelica.Units.SI.Area AFloWes=flo.AFloWes "Floor area west";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate mCor_flow_nominal
    "Design mass flow rate core";
  parameter Modelica.Units.SI.MassFlowRate mSou_flow_nominal
    "Design mass flow rate south";
  parameter Modelica.Units.SI.MassFlowRate mEas_flow_nominal
    "Design mass flow rate east";
  parameter Modelica.Units.SI.MassFlowRate mNor_flow_nominal
    "Design mass flow rate north";
  parameter Modelica.Units.SI.MassFlowRate mWes_flow_nominal
    "Design mass flow rate west";

  final parameter Modelica.Units.SI.MassFlowRate mCooVAV_flow_nominal[5]={
      mSou_flow_nominal,mEas_flow_nominal,mNor_flow_nominal,mWes_flow_nominal,
      mCor_flow_nominal} "Design mass flow rate of each zone";

  parameter Modelica.Units.SI.Temperature THeaWatInl_nominal(displayUnit="degC")=
       45 + 273.15 "Reheat coil nominal inlet water temperature";

  replaceable Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC_new hvac
    constrainedby Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC(
    redeclare final package MediumA = MediumA,
    redeclare final package MediumW = MediumW,
    final VRoo={VRooSou,VRooEas,VRooNor,VRooWes,VRooCor},
    final AFlo={AFloSou,AFloEas,AFloNor,AFloWes,AFloCor},
    final mCooVAV_flow_nominal=mCooVAV_flow_nominal,
    final THeaWatInl_nominal=THeaWatInl_nominal) "HVAC system"
    annotation (Placement(transformation(extent={{-46,-28},{42,22}})));
  replaceable
  Buildings.Examples.VAVReheat.BaseClasses.PartialFloor flo
    constrainedby Buildings.Examples.VAVReheat.BaseClasses.PartialFloor(
      redeclare final package Medium = MediumA)
    "Building"
    annotation (Placement(transformation(extent={{20,40},{90,80}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
   filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Templates.Plants.HeatPumps.Validation.HHW_CHW_plant hHW_CHW_plant
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(weaDat.weaBus, hvac.weaBus) annotation (Line(
      points={{-70,10},{-56,10},{-56,11.4444},{-40.225,11.4444}},
      color={255,204,51},
      thickness=0.5));
  connect(flo.TRooAir, hvac.TRoo) annotation (Line(points={{91.5217,60},{96,60},
          {96,92},{-60,92},{-60,16.4444},{-48.75,16.4444}}, color={0,0,127}));
  connect(hvac.port_supAir[1], flo.portsSou[1]) annotation (Line(points={{42.275,
          19.2222},{46.3261,19.2222},{46.3261,48.6154}}, color={0,127,255}));
  connect(hvac.port_supAir[2], flo.portsEas[1]) annotation (Line(points={{42.275,
          19.2222},{81.0217,19.2222},{81.0217,60.9231}}, color={0,127,255}));
  connect(hvac.port_supAir[3], flo.portsNor[1]) annotation (Line(points={{42.275,
          19.2222},{56,19.2222},{56,71.3846},{46.3261,71.3846}}, color={0,127,255}));
  connect(hvac.port_supAir[4], flo.portsWes[1]) annotation (Line(points={{42.275,
          19.2222},{56,19.2222},{56,36},{27.4565,36},{27.4565,60.9231}}, color={
          0,127,255}));
  connect(hvac.port_supAir[5], flo.portsCor[1]) annotation (Line(points={{42.275,
          19.2222},{56,19.2222},{56,60.9231},{46.3261,60.9231}}, color={0,127,255}));
  connect(hvac.port_retAir[1], flo.portsSou[2]) annotation (Line(points={{42.275,
          -4.38889},{47.8478,-4.38889},{47.8478,48.6154}}, color={0,127,255}));
  connect(hvac.port_retAir[2], flo.portsEas[2]) annotation (Line(points={{42.275,
          -4.38889},{82.5435,-4.38889},{82.5435,60.9231}}, color={0,127,255}));
  connect(hvac.port_retAir[3], flo.portsNor[2]) annotation (Line(points={{42.275,
          -4.38889},{58,-4.38889},{58,71.3846},{47.8478,71.3846}}, color={0,127,
          255}));
  connect(hvac.port_retAir[4], flo.portsWes[2]) annotation (Line(points={{42.275,
          -4.38889},{60,-4.38889},{60,34},{28.9783,34},{28.9783,60.9231}},
        color={0,127,255}));
  connect(hvac.port_retAir[5], flo.portsCor[2]) annotation (Line(points={{42.275,
          -4.38889},{60,-4.38889},{60,58},{47.8478,58},{47.8478,60.9231}},
        color={0,127,255}));
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
      points={{-70,10},{-66,10},{-66,86.1538},{64.1304,86.1538}},
      color={255,204,51},
      thickness=0.5));
  connect(hHW_CHW_plant.port_b1, hvac.portCooCoiSup) annotation (Line(points={{
          10,-54},{14,-54},{14,-32},{-2,-32},{-2,-28}}, color={0,127,255}));
  connect(hHW_CHW_plant.port_a1, hvac.portCooCoiRet) annotation (Line(points={{
          -10,-54},{-10,-36},{6.25,-36},{6.25,-28}}, color={0,127,255}));
  connect(hHW_CHW_plant.port_a2, hvac.portHeaTerRet) annotation (Line(points={{
          10,-66},{25.5,-66},{25.5,-28}}, color={0,127,255}));
  connect(hHW_CHW_plant.port_a2, hvac.portHeaCoiRet) annotation (Line(points={{
          10,-66},{14,-66},{14,-78},{-22,-78},{-22,-32},{-13,-32},{-13,-28}},
        color={0,127,255}));
  connect(hHW_CHW_plant.port_b2, hvac.portHeaCoiSup) annotation (Line(points={{
          -10,-66},{-24,-66},{-24,-28},{-21.25,-28}}, color={0,127,255}));
  connect(hHW_CHW_plant.port_b2, hvac.portHeaTerSup) annotation (Line(points={{
          -10,-66},{-24,-66},{-24,-34},{17.25,-34},{17.25,-28}}, color={0,127,
          255}));
  annotation (
    Documentation(info="<html>
<p>
Partial model that contains an HVAC system connected to a building
with five conditioned thermal zones.
</p>
</html>", revisions="<html>
<ul>
<li>
December 20, 2021, by Michael Wetter:<br/>
Changed parameter declarations for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
</li>
<li>
November 17, 2021, by David Blum:<br/>
Changed chilled water supply temperature from 12 C to 6 C.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2763\">issue #2763</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HVACBuilding_new;
