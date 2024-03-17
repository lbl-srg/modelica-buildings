within Buildings.ThermalZones.EnergyPlus_9_6_0;
model Building
  "Model that declares a building to which EnergyPlus objects belong to"
  extends Modelica.Blocks.Icons.Block;

  constant String spawnExe="spawn-0.4.3-7048a72798"
      "Name of the spawn executable, without extension, such as spawn-0.4.3-7048a72798aaa"
    annotation (HideResult=true);

  constant String idfVersion = "9_6_0"
    "IDF version with underscore, used for error report";

  final constant String modelicaNameBuilding=getInstanceName()
    "Name of this instance"
    annotation (HideResult=true);

  constant Boolean usePrecompiledFMU=false
    "Set to true to use pre-compiled FMU with name specified by fmuName";
  constant String fmuName=""
    "Specify if a pre-compiled FMU should be used instead of EnergyPlus (for development)";

  parameter String idfName
    "Name of the IDF file"
    annotation(Evaluate=false);

  parameter String epwName
    "Name of the EPW file"
    annotation(Evaluate=false);

  parameter String weaName
    "Name of the weather file, in .mos format and with .mos extension"
    annotation(Evaluate=false);

  parameter Buildings.ThermalZones.EnergyPlus_9_6_0.Types.LogLevels logLevel=Buildings.ThermalZones.EnergyPlus_9_6_0.Types.LogLevels.Warning
    "Log level of EnergyPlus output"
    annotation (Dialog(tab="Debug"));

  parameter Boolean computeWetBulbTemperature=true
    "If true, then this model computes the wet bulb temperature"
    annotation (Dialog(tab="Advanced"));

  parameter Real relativeSurfaceTolerance(min=1E-20) = 1E-7
    "Relative tolerance of surface temperature calculations"
    annotation (Dialog(tab="Advanced"));

  parameter Boolean printUnits=true
    "Set to true to print units of OutputVariable instances to log file"
    annotation (Dialog(group="Diagnostics"));

  BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  BaseClasses.Synchronize.SynchronizeConnector synchronize
    "Connector that synchronizes all Spawn objects of this buildings"
    annotation (HideResult=true);
  Real isSynchronized
    "Flag used to synchronize Spawn objects"
    annotation (HideResult=true);

protected
  Real synchronization_done=synchronize.done
    "Intermediate variable as acausal connectors cannot be used in the algorithm section";
/*
  final parameter String idf=Modelica.Utilities.Files.loadResource(idfName)
      "idf file to be loaded into the FMU";
  final parameter String epw=Modelica.Utilities.Files.loadResource(epwName)
      "idf file to be loaded into the FMU";
*/

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=weaName,
    final computeWetBulbTemperature=computeWetBulbTemperature)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  synchronize.do=0;
  connect(weaDat.weaBus,weaBus)
    annotation (Line(points={{10,0},{100,0}},color={255,204,51},thickness=0.5),Text(string="%second",index=1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));

algorithm
  isSynchronized := synchronization_done;
  annotation (
    defaultComponentName="building",
    defaultComponentPrefixes="inner",
    missingInnerMessage="
Your model is using an outer \"building\" component to declare building-level parameters, but
an inner \"building\" component is not defined.
Drag one instance of Buildings.ThermalZones.EnergyPlus_9_6_0.Building into your model,
above all declarations of Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone,
to specify building-level parameters. This instance must have the name \"building\".",
    Icon(
      graphics={
        Bitmap(
          extent={{-44,-144},{94,-6}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/spawn_icon_darkbluetxmedres.png",
          visible=not usePrecompiledFMU),
        Rectangle(
          extent={{-64,54},{64,-48}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Solid,
          fillColor={150,150,150}),
        Polygon(
          points={{0,96},{-78,54},{80,54},{0,96}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Rectangle(
          extent={{16,12},{44,40}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,12},{-14,40}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,-32},{-14,-4}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-32},{44,-4}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
Model that declares building-level specifications for Spawn of EnergyPlus.
</p>
<p>
This model is used to configure EnergyPlus.
Each EnergyPlus idf file must have one instance of this model, and the
instance name must be <code>building</code>.
The instance must be placed in the model hierarchy at the same or at a higher level
than the EnergyPlus objects that are related to the EnergyPlus idf file specified in
this model through the parameter <code>idfName</code>.
</p>
<p>
For the parameter <code>weaName</code>, the name of the Modelica weather file must be
provided. This is the file that can be read, for example, with
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>.
However, both weather files <code>.mos</code> and <code>.epw</code>
must be provided. When starting the simulation, EnergyPlus will
be run with the weather file whose name is identical to <code>epwName</code>,
while Modelica will use the file specified by <code>weaName</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 16, 2024, by Michael Wetter:<br/>
Increased the default value for <code>relativeSurfaceTolerance</code>.
This is required for
<a href=\"modelica:Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Radiator\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Radiator</a>
with OpenModelica. This model forms a nonlinear equation between the radiator temperature,
which is used to compute the radiative heat flow rate between radiator and room radiative temperature, and the
room surface temperature. The radiator temperature is computed in Modelica and the room surface
temperature is computed in EnergyPlus. The latter requires the iterative solution of the
radiative heat balance equation. Hence, evaluating the residuals for this nonlinear equation
requires an iteration in EnergyPlus.
As a rule of thumb, such nested solvers require one order of magnitude higher precision for the inner
solver. As Modelica models are often solved for a tolerance of <code>1E-6</code>, the default value
for <code>relativeSurfaceTolerance</code> has been set to 1E-8.<br/>
This was required for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3707\">#3707</a>.
</li>
<li>
November 18, 2021, by Michael Wetter:<br/>
Removed parameters <code>showWeatherData</code> and <code>generatePortableFMU</code>.
Now, the weather data bus is always enabled as it is used in almost all simulations.<br/>
Converted <code>usePrecompiledFMU</code> and the associated <code>fmuName</code> from
parameter to a constant as these are only used for debugging by developers.<br/>
Set annotation <code>Evaluate=false</code> for weather data files and idf files.
The previous version had <code>Evaluate=true</code> for the <code>.mos</code>,
and then OCT did not include it in the fmu.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2759\">#2759</a>.
</li>
<li>
November 11, 2021, by Michael Wetter:<br/>
Added constant <code>spawnExe</code> to allow different installation of Spawn.
</li>
<li>
August 19, 2021, by Michael Wetter:<br/>
Introduced parameter <code>epwName</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2054\">#2054</a>.
</li>
<li>
February 18, 2021, by Michael Wetter:<br/>
Refactor synchronization of constructors.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2360\">#2360</a>.
</li>
<li>
January 28, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Building;
