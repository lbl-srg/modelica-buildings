within Buildings.ThermalZones.EnergyPlus;
model Building
  "Model that declares a building to which thermal zones belong to"
  extends Modelica.Blocks.Icons.Block;
  final constant String modelicaNameBuilding=getInstanceName()
    "Name of this instance"
    annotation (HideResult=true);
  parameter String idfName
    "Name of the IDF file"
    annotation (Evaluate=true);
  parameter String weaName
    "Name of the weather file, in .mos format and with .mos extension (see info section)"
    annotation (Evaluate=true);
  parameter Boolean usePrecompiledFMU=false
    "Set to true to use pre-compiled FMU with name specified by fmuName"
    annotation (Dialog(tab="Debug"));
  parameter String fmuName=""
    "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)"
    annotation (Dialog(tab="Debug",enable=usePrecompiledFMU));
  parameter Buildings.ThermalZones.EnergyPlus.Types.LogLevels logLevel=Buildings.ThermalZones.EnergyPlus.Types.LogLevels.Warning
    "Log level of EnergyPlus output"
    annotation (Dialog(tab="Debug"));
  parameter Boolean showWeatherData=true
    "Set to true to enable a connector with the weather data"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean computeWetBulbTemperature=true
    "If true, then this model computes the wet bulb temperature"
    annotation (Dialog(tab="Advanced",enable=showWeatherData));
  parameter Boolean printUnits=true
    "Set to true to print units of OutputVariable instances to log file"
    annotation (Dialog(group="Diagnostics"));
  parameter Boolean generatePortableFMU=false
    "Set to true to include all binaries in the EnergyPlus FMU to allow simulation of without a Buildings library installation (increases translation time)"
    annotation (Dialog(tab="Advanced"));
  BoundaryConditions.WeatherData.Bus weaBus if showWeatherData
    "Weather data bus"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  Linux64Binaries linux64Binaries if generatePortableFMU
    "Record with binaries";
  record Linux64Binaries
    final parameter String spawnLinuxExecutable=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/bin/spawn-linux64/bin/spawn")
      "Binary for Linux 64, specified so it is packed into the FMU";
    final parameter String spawnLinuxLibrary=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/bin/spawn-linux64/lib/epfmi.so")
      "Library for Linux 64, specified so it is packed into the FMU";
    final parameter String fmiLinuxLibrary=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Library/linux64/libfmilib_shared.so")
      "Library for Linux 64, specified so it is packed into the FMU";
  end Linux64Binaries;
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=weaName,
    final computeWetBulbTemperature=computeWetBulbTemperature) if showWeatherData
    "Weather data reader"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(weaDat.weaBus,weaBus)
    annotation (Line(points={{10,0},{100,0}},color={255,204,51},thickness=0.5),Text(string="%second",index=1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  annotation (
    defaultComponentName="building",
    defaultComponentPrefixes="inner",
    missingInnerMessage="
Your model is using an outer \"building\" component to declare building-level parameters, but
an inner \"building\" component is not defined.
Drag one instance of Buildings.ThermalZones.EnergyPlus.Building into your model,
above all declarations of Buildings.ThermalZones.EnergyPlus.ThermalZone,
to specify building-level parameters.",
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
Each EnergyPlus idf file must have one instance of this model, which
is used to configure EnergyPlus.
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
must be provided in the same directory. When starting the simulation, EnergyPlus will
be run with the weather file whose name is identical to <code>weaName</code>, but with the
extension <code>.mos</code> replaced with <code>.epw</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 28, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Building;
