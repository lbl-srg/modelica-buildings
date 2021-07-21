within Buildings.ThermalZones.EnergyPlus.BaseClasses.Validation;
model FMUZoneAdapterZones1
  "Validation model for the class and functions that instantiate and communicate with an FMU for Model Exchange"
  extends Modelica.Icons.Example;
  constant String modelicaNameBuilding=getInstanceName()
    "Name of the building";
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Examples/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String weaName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of the weather file";
  parameter Modelica.SIunits.HeatCapacity CZon=6*6*2.7*1.2*1006
    "Heat capacity of zone air";
  inner Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance.idf"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    usePrecompiledFMU=false,
    showWeatherData=false)
    "Building model"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.ThermalZones.EnergyPlus.BaseClasses.ThermalZoneAdapter fmuZonCor(
    modelicaNameBuilding=modelicaNameBuilding,
    final idfName=idfName,
    final weaName=weaName,
    relativeSurfaceTolerance=building.relativeSurfaceTolerance,
    final zoneName="Core_ZN",
    usePrecompiledFMU=true,
    final fmuName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/src/ThermalZones/EnergyPlus/FMUs/Zones1.fmu"),
    logLevel=building.logLevel,
    final nFluPor=2)
    "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.RealExpression X_w(
    y=0.01)
    "Zone absolute humidity"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Modelica.Blocks.Sources.RealExpression mIn_flow(
    y=0)
    "Inlet mass flow rate"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Modelica.Blocks.Math.Gain mOut_flow(
    k=-1)
    "Outlet mass flow rate"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.RealExpression TIn[2](
    each y=293.15)
    "Inlet temperature"
    annotation (Placement(transformation(extent={{-90,-28},{-70,-8}})));
  Modelica.Blocks.Sources.RealExpression QGaiRad_flow(
    y=0)
    "Radiative heat gain for the zone"
    annotation (Placement(transformation(extent={{-88,-50},{-68,-30}})));
  Modelica.Blocks.Continuous.Integrator TZonCor(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K",
      displayUnit="degC"))
    "Zone air temperature"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

equation
  connect(X_w.y,fmuZonCor.X_w)
    annotation (Line(points={{-69,50},{0,50},{0,34},{18,34}},color={0,0,127}));
  connect(fmuZonCor.m_flow[1],mIn_flow.y)
    annotation (Line(points={{18,29},{-4,29},{-4,10},{-69,10}},color={0,0,127}));
  connect(mOut_flow.u,mIn_flow.y)
    annotation (Line(points={{-42,30},{-60,30},{-60,10},{-69,10}},color={0,0,127}));
  connect(mOut_flow.y,fmuZonCor.m_flow[2])
    annotation (Line(points={{-19,30},{-10,30},{-10,31},{18,31}},color={0,0,127}));
  connect(TIn.y,fmuZonCor.TInlet)
    annotation (Line(points={{-69,-18},{6,-18},{6,26},{18,26}},color={0,0,127}));
  connect(fmuZonCor.QGaiRad_flow,QGaiRad_flow.y)
    annotation (Line(points={{18,22},{10,22},{10,-40},{-67,-40}},color={0,0,127}));
  connect(TZonCor.y,fmuZonCor.T)
    annotation (Line(points={{81,30},{88,30},{88,60},{8,60},{8,38},{18,38}},color={0,0,127}));
  connect(fmuZonCor.QCon_flow,TZonCor.u)
    annotation (Line(points={{41,32},{48,32},{48,30},{58,30}},color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
Validation model that communicates with an FMU that emulates simple thermal zones.
All thermal zones are identical.
</p>
<p>
This test is done to validate the FMI API, using an FMU 2.0 for Model Exchange, compiled
for Linux 64 bit by JModelica.
</p>
</html>",
      revisions="<html>
<ul><li>
March 19, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/BaseClasses/Validation/FMUZoneAdapterZones1.mos" "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end FMUZoneAdapterZones1;
