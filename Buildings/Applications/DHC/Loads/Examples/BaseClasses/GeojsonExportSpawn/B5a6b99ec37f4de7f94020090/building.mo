within Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonExportSpawn.B5a6b99ec37f4de7f94020090;
model building
  "FMU Template for Spawn"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://spawn_two_building/Loads/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://spawn_two_building/Loads/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";

  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-74,-50},{-54,-30}})));

  Buildings.Experimental.EnergyPlus.ThermalZone znAttic(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Attic") "Thermal zone"
     annotation (Placement(transformation(extent={{20,40},{60,80}})));

  Buildings.Experimental.EnergyPlus.ThermalZone znCore_ZN(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Core_ZN") "Thermal zone"
     annotation (Placement(transformation(extent={{20,40},{60,80}})));

  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_1(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Perimeter_ZN_1") "Thermal zone"
     annotation (Placement(transformation(extent={{20,40},{60,80}})));

  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_2(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Perimeter_ZN_2") "Thermal zone"
     annotation (Placement(transformation(extent={{20,40},{60,80}})));

  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_3(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Perimeter_ZN_3") "Thermal zone"
     annotation (Placement(transformation(extent={{20,40},{60,80}})));

  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_4(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    usePrecompiledFMU=false,
    fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    zoneName="Perimeter_ZN_4") "Thermal zone"
     annotation (Placement(transformation(extent={{20,40},{60,80}})));


equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-53,40},{-40,40},{-40,7},{-30,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-53,0},{-30,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow. y)
    annotation (Line(points={{-30,-7},{-40,-7},{-40,-40},{-53,-40}},color={0,0,127}));

  connect(multiplex3_1.y, znAttic.qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

  connect(multiplex3_1.y, znCore_ZN.qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

  connect(multiplex3_1.y, znPerimeter_ZN_1.qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

  connect(multiplex3_1.y, znPerimeter_ZN_2.qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

  connect(multiplex3_1.y, znPerimeter_ZN_3.qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

  connect(multiplex3_1.y, znPerimeter_ZN_4.qGai_flow)
      annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

  // TODO: determine how to handle the "lines"

  annotation (Documentation(info="<html>
<p>
Template to connect n-thermal zones using GeoJSON to Modelica Translator
</p>
</html>", revisions="<html>
<ul><li>
March 24, 2019: Nicholas Long<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Validation/RefBldgSmallOffice.mos"
        "Simulate and plot"),
experiment(
      StopTime=604800,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-160},{160,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end building;
