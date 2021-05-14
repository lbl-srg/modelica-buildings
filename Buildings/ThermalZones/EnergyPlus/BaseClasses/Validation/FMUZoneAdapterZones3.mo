within Buildings.ThermalZones.EnergyPlus.BaseClasses.Validation;
model FMUZoneAdapterZones3
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
      "modelica://Buildings/Resources/src/ThermalZones/EnergyPlus/FMUs/Zones3.fmu"),
    logLevel=building.logLevel,
    final nFluPor=2)
    "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.RealExpression X_w(
    y=0.01)
    "Zone absolute humidity"
    annotation (Placement(transformation(extent={{-88,44},{-68,64}})));
  Modelica.Blocks.Sources.RealExpression mIn_flow(
    y=0)
    "Inlet mass flow rate"
    annotation (Placement(transformation(extent={{-88,0},{-68,20}})));
  Modelica.Blocks.Math.Gain mOut_flow(
    k=-1)
    "Outlet mass flow rate"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Blocks.Sources.RealExpression TIn[2](
    each y=293.15)
    "Inlet temperature"
    annotation (Placement(transformation(extent={{-88,-24},{-68,-4}})));
  Modelica.Blocks.Sources.RealExpression QGaiRad_flow(
    y=0)
    "Radiative heat gain for the zone"
    annotation (Placement(transformation(extent={{-88,-46},{-68,-26}})));
  Modelica.Blocks.Continuous.Integrator TZonCor(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K",
      displayUnit="degC"))
    "Zone air temperature"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.ThermalZones.EnergyPlus.BaseClasses.ThermalZoneAdapter fmuZonSou(
    modelicaNameBuilding=modelicaNameBuilding,
    final idfName=idfName,
    final weaName=weaName,
    relativeSurfaceTolerance=building.relativeSurfaceTolerance,
    final zoneName="South_ZN",
    usePrecompiledFMU=true,
    final fmuName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/src/ThermalZones/EnergyPlus/FMUs/Zones3.fmu"),
    logLevel=building.logLevel,
    final nFluPor=2)
    "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Continuous.Integrator TZonSou(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K",
      displayUnit="degC"))
    "Zone air temperature"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.ThermalZones.EnergyPlus.BaseClasses.ThermalZoneAdapter fmuZonNor(
    modelicaNameBuilding=modelicaNameBuilding,
    final idfName=idfName,
    final weaName=weaName,
    relativeSurfaceTolerance=building.relativeSurfaceTolerance,
    final zoneName="North_ZN",
    usePrecompiledFMU=true,
    final fmuName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/src/ThermalZones/EnergyPlus/FMUs/Zones3.fmu"),
    logLevel=building.logLevel,
    final nFluPor=2)
    "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Continuous.Integrator TZonNor(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K",
      displayUnit="degC"))
    "Zone air temperature"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

equation
  connect(X_w.y,fmuZonCor.X_w)
    annotation (Line(points={{-67,54},{-14,54},{-14,34},{18,34}},color={0,0,127}));
  connect(fmuZonCor.m_flow[1],mIn_flow.y)
    annotation (Line(points={{18,29},{-8,29},{-8,10},{-67,10}},color={0,0,127}));
  connect(mOut_flow.u,mIn_flow.y)
    annotation (Line(points={{-52,30},{-60,30},{-60,10},{-67,10}},color={0,0,127}));
  connect(mOut_flow.y,fmuZonCor.m_flow[2])
    annotation (Line(points={{-29,30},{-10,30},{-10,31},{18,31}},color={0,0,127}));
  connect(TIn.y,fmuZonCor.TInlet)
    annotation (Line(points={{-67,-14},{0,-14},{0,26},{18,26}},color={0,0,127}));
  connect(fmuZonCor.QGaiRad_flow,QGaiRad_flow.y)
    annotation (Line(points={{18,22},{-4,22},{-4,-36},{-67,-36}},color={0,0,127}));
  connect(X_w.y,fmuZonSou.X_w)
    annotation (Line(points={{-67,54},{-14,54},{-14,-6},{18,-6}},color={0,0,127}));
  connect(fmuZonSou.m_flow[1],mIn_flow.y)
    annotation (Line(points={{18,-11},{-8,-11},{-8,10},{-67,10}},color={0,0,127}));
  connect(mOut_flow.y,fmuZonSou.m_flow[2])
    annotation (Line(points={{-29,30},{-10,30},{-10,-9},{18,-9}},color={0,0,127}));
  connect(TIn.y,fmuZonSou.TInlet)
    annotation (Line(points={{-67,-14},{18,-14}},color={0,0,127}));
  connect(fmuZonSou.QGaiRad_flow,QGaiRad_flow.y)
    annotation (Line(points={{18,-18},{-4,-18},{-4,-36},{-67,-36}},color={0,0,127}));
  connect(TZonCor.y,fmuZonCor.T)
    annotation (Line(points={{81,30},{88,30},{88,60},{8,60},{8,38},{18,38}},color={0,0,127}));
  connect(X_w.y,fmuZonNor.X_w)
    annotation (Line(points={{-67,54},{-14,54},{-14,-46},{18,-46}},color={0,0,127}));
  connect(fmuZonNor.m_flow[1],mIn_flow.y)
    annotation (Line(points={{18,-51},{-8,-51},{-8,10},{-67,10}},color={0,0,127}));
  connect(mOut_flow.y,fmuZonNor.m_flow[2])
    annotation (Line(points={{-29,30},{-10,30},{-10,-49},{18,-49}},color={0,0,127}));
  connect(TIn.y,fmuZonNor.TInlet)
    annotation (Line(points={{-67,-14},{0,-14},{0,-54},{18,-54}},color={0,0,127}));
  connect(fmuZonNor.QGaiRad_flow,QGaiRad_flow.y)
    annotation (Line(points={{18,-58},{-4,-58},{-4,-36},{-67,-36}},color={0,0,127}));
  connect(fmuZonCor.QCon_flow,TZonCor.u)
    annotation (Line(points={{41,32},{50,32},{50,30},{58,30}},color={0,0,127}));
  connect(fmuZonSou.QCon_flow,TZonSou.u)
    annotation (Line(points={{41,-8},{50,-8},{50,-10},{58,-10}},color={0,0,127}));
  connect(TZonSou.y,fmuZonSou.T)
    annotation (Line(points={{81,-10},{86,-10},{86,10},{10,10},{10,-2},{18,-2}},color={0,0,127}));
  connect(fmuZonNor.QCon_flow,TZonNor.u)
    annotation (Line(points={{41,-48},{50,-48},{50,-50},{58,-50}},color={0,0,127}));
  connect(TZonNor.y,fmuZonNor.T)
    annotation (Line(points={{81,-50},{86,-50},{86,-32},{10,-32},{10,-42},{18,-42}},color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
Validation model that communicates with an FMU that emulates three simple thermal zones.
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
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/BaseClasses/Validation/FMUZoneAdapterZones3.mos" "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end FMUZoneAdapterZones3;
