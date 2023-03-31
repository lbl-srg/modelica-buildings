within Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.Validation;
model FMUZoneAdapterZones1
  "Validation model for the class and functions that instantiate and communicate with an FMU for Model Exchange"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.HeatCapacity CZon=6*6*2.7*1.2*1006
    "Heat capacity of zone air";
  inner Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Examples/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf"),
    epwName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=false,
    usePrecompiledFMU=false)
    "Building model"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.ThermalZoneAdapter fmuZonCor(
    modelicaNameBuilding=building.modelicaNameBuilding,
    final spawnExe=building.spawnExe,
    final idfVersion=building.idfVersion,
    final idfName=building.idfName,
    final epwName=building.epwName,
    final relativeSurfaceTolerance=building.relativeSurfaceTolerance,
    final zoneName="Core_ZN",
    usePrecompiledFMU=true,
    final fmuName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/src/ThermalZones/EnergyPlus_9_6_0/FMUs/Zones1.fmu"),
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
    annotation (Placement(visible = true, transformation(                 extent={{-90,0},
            {-70,20}},                                                                                    rotation = 0)));
  Modelica.Blocks.Math.Gain mOut_flow(
    k=-1)
    "Outlet mass flow rate"
    annotation (Placement(visible = true, transformation(origin = {0, 0}, extent = {{-40, 20}, {-20, 40}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression TIn[2](
    each y=293.15) "Inlet temperature"
    annotation (Placement(visible = true, transformation(origin={0,-22},   extent = {{-90, -28}, {-70, -8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression QGaiRad_flow(
    y=0)
    "Radiative heat gain for the zone"
    annotation (Placement(visible = true, transformation(origin={-2,-20},  extent = {{-88, -50}, {-68, -30}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator TZonCor(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K",
      displayUnit="degC"))
    "Zone air temperature"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Modelica.Blocks.Sources.RealExpression p(each y=101325) "Fluid pressure"
    annotation (Placement(visible=true, transformation(extent={{-90,-30},{-70,
            -10}}, rotation=0)));
equation
  connect(X_w.y,fmuZonCor.X_w)
    annotation (Line(points={{-69,50},{0,50},{0,36},{18,36}},color={0,0,127}));
  connect(fmuZonCor.m_flow[1],mIn_flow.y)
    annotation (Line(points={{18,31.5},{2,31.5},{2,10},{-69,10}},
                                                               color={0,0,127}, pattern = LinePattern.Solid));
  connect(mOut_flow.u,mIn_flow.y)
    annotation (Line(points={{-42,30},{-60,30},{-60,10},{-69,10}},         color={0,0,127}, pattern = LinePattern.Solid));
  connect(mOut_flow.y,fmuZonCor.m_flow[2])
    annotation (Line(points={{-19,30},{0.5,30},{0.5,32.5},{18,32.5}},
                                                                 color={0,0,127}, pattern = LinePattern.Solid));
  connect(TIn.y,fmuZonCor.TInlet)
    annotation (Line(points={{-69,-40},{6,-40},{6,28},{18,28}},         color={0,0,127}, pattern = LinePattern.Solid));
  connect(fmuZonCor.QGaiRad_flow,QGaiRad_flow.y)
    annotation (Line(points={{18,20},{10,20},{10,-60},{-69,-60}},         color={0,0,127}, pattern = LinePattern.Solid));
  connect(TZonCor.y,fmuZonCor.T)
    annotation (Line(points={{81,30},{88,30},{88,60},{8,60},{8,40},{18,40}},color={0,0,127}));
  connect(fmuZonCor.QCon_flow,TZonCor.u)
    annotation (Line(points={{41,32},{48,32},{48,30},{58,30}},color={0,0,127}));
  connect(p.y, fmuZonCor.p) annotation (Line(points={{-69,-20},{8,-20},{8,24},{
          18,24}}, color={0,0,127}));
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
<ul>
<li>
March 30, 2023, by Michael Wetter:<br/>
Added check for air pressure to be within reasonable limits.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3319\">#3319</a>.
</li>
<li>
March 23, 2022, by Michael Wetter:<br/>
Changed model to use the instance name of the <code>building</code> instance as is done for the other Spawn models.
</li>
<li>
March 19, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/BaseClasses/Validation/FMUZoneAdapterZones1.mos" "Simulate and plot"),
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
