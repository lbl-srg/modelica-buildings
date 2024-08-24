within Buildings.ThermalZones.EnergyPlus_24_1_0;
block Actuator
  "Block to write to an EnergyPlus actuator"
  extends Buildings.ThermalZones.EnergyPlus_24_1_0.BaseClasses.PartialEnergyPlusObject;
  extends Buildings.ThermalZones.EnergyPlus_24_1_0.BaseClasses.Synchronize.ObjectSynchronizer;
  parameter String variableName
    "Actuated component unique name in the EnergyPlus idf file";
  parameter String componentType
    "Actuated component type";
  parameter String controlType
    "Actuated component control type";
  parameter Buildings.ThermalZones.EnergyPlus_24_1_0.Types.Units unit
    "Unit of variable as used in Modelica"
    annotation (choicesAllMatching=true);
  Modelica.Blocks.Interfaces.RealInput u
    "Continuous input signal to be written to EnergyPlus"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Value written to EnergyPlus (use for direct dependency of Actuators and Schedules)"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},{140,20}})));

protected
  constant Integer nParOut=0
    "Number of parameter values retrieved from EnergyPlus";
  constant Integer nInp=1
    "Number of inputs";
  constant Integer nOut=0
    "Number of outputs";
  constant Integer nDer=0
    "Number of derivatives";
  constant Integer nY=nOut+nDer+1
    "Size of output vector of exchange function";
  parameter Integer nObj(
    fixed=false,
    start=0)
    "Total number of Spawn objects in building";
  final parameter String unitString=Buildings.ThermalZones.EnergyPlus_24_1_0.BaseClasses.getUnitAsString(unit)
    "Unit as a string";
  Buildings.ThermalZones.EnergyPlus_24_1_0.BaseClasses.SpawnExternalObject adapter=Buildings.ThermalZones.EnergyPlus_24_1_0.BaseClasses.SpawnExternalObject(
    objectType=3,
    startTime=startTime,
    modelicaNameBuilding=modelicaNameBuilding,
    modelicaInstanceName=modelicaInstanceName,
    spawnExe=spawnExe,
    idfVersion=idfVersion,
    idfName=idfName,
    epwName=epwName,
    runPeriod=runPeriod,
    relativeSurfaceTolerance=relativeSurfaceTolerance,
    epName=variableName,
    usePrecompiledFMU=usePrecompiledFMU,
    fmuName=fmuName,
    buildingsRootFileLocation=Buildings.ThermalZones.EnergyPlus_24_1_0.BaseClasses.buildingsRootFileLocation,
    logLevel=logLevel,
    printUnit=false,
    jsonName="emsActuators",
    jsonKeysValues="        \"variableName\": \""+variableName+"\",
        \"componentType\": \""+componentType+"\",
        \"controlType\": \""+controlType+"\",
        \"unit\": \""+unitString+"\",
        \"fmiName\": \""+variableName+"_"+componentType+"\"",
    parOutNames=fill("",nParOut),
    parOutUnits=fill("",nParOut),
    nParOut=nParOut,
    inpNames={componentType},
    inpUnits={unitString},
    nInp=nInp,
    outNames=fill("",nOut),
    outUnits=fill("",nOut),
    nOut=nOut,
    derivatives_structure=fill(fill(nDer,2),nDer),
    nDer=nDer,
    derivatives_delta=fill(0,nDer))
    "Class to communicate with EnergyPlus";
  Real yEP[nY]
    "Output of exchange function";

initial equation
  assert(
    not usePrecompiledFMU,
    "Use of pre-compiled FMU is not supported for block Actuator.");
  nObj=Buildings.ThermalZones.EnergyPlus_24_1_0.BaseClasses.initialize(
    adapter=adapter,
    isSynchronized=building.isSynchronized);

equation
  yEP=Buildings.ThermalZones.EnergyPlus_24_1_0.BaseClasses.exchange(
    adapter=adapter,
    nY=nY,
    u={u,round(time,1E-3)},
    dummy=nObj);
  y=yEP[1];
  nObj=synBui.synchronize.done;
  annotation (
    defaultComponentName="act",
    Documentation(
      info="<html>
<p>
Block that writes to an EMS actuator object in EnergyPlus.
</p>
<p>
This model writes at every EnergyPlus zone time step the value of the input <code>u</code>
to an EnergyPlus EMS actuator with name <code>variableName</code>.
For example, if EnergyPlus has 6 time steps per hour, as specified in the idf-file with
the entry <code>Timestep,6;</code> and the input <code>u</code> to this block is
</p>
<table summary=\"example for input\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th>Model time (min)</th>       <th>Input u</th>   </tr>
<tr><td>0...5</td>                  <td>0</td>         </tr>
<tr><td>5...15</td>                 <td>1</td>         </tr>
<tr><td>15...20</td>                <td>2</td>         </tr>
<tr><td>20</td>                     <td>3</td>         </tr>
</table>
<p>
then EnergyPlus will receive the inputs
</p>
<table summary=\"example for input\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th>Model time (min)</th>  <th>Input u</th>  </tr>
<tr><td> 0</td>                <td>0</td>        </tr>
<tr><td>10</td>                <td>1</td>        </tr>
<tr><td>20</td>                <td>3</td>        </tr>
</table>
<p>
The parameter <code>unit</code> specifies the unit of the signal <code>u</code>.
This unit is then converted internally to the units required by EnergyPlus before
the value is sent to EnergyPlus.
See <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_1_0.Types.Units\">Buildings.ThermalZones.EnergyPlus_24_1_0.Types.Units</a>
for the supported units.
If the value of the parameter <code>unit</code> is left at its default value of
<code>Buildings.ThermalZones.EnergyPlus_24_1_0.Types.Units.unspecified</code>, then
the simulation will stop with an error.
</p>
<h4>Usage</h4>
<p>
This section explain how to use actuators for different EnergyPlus objects.
For other actuators, please see the EnergyPlus EMS Application Guide.
</p>
<!-- Actuator for lights -->
<h5>Configuring an actuator for lights</h5>
<p>
Consider the example
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SingleFamilyHouse.LightsControl\">
Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SingleFamilyHouse.LightsControl</a>.
In this example, Modelica overwrites the EnergyPlus <code>Lights</code> object.
The idf-file
has the following entry:
</p>
<pre>
  Lights,
    LIVING ZONE Lights,      !- Name
    LIVING ZONE,             !- Zone or ZoneList Name
    HOUSE LIGHTING,          !- Schedule Name
    LightingLevel,           !- Design Level Calculation Method
    1000,                    !- Lighting Level {W}
    ,                        !- Watts per Zone Floor Area {W/m2}
    ,                        !- Watts per Person {W/person}
    0,                       !- Return Air Fraction
    0.2000000,               !- Fraction Radiant
    0.2000000,               !- Fraction Visible
    0,                       !- Fraction Replaceable
    GeneralLights;           !- End-Use Subcategory
</pre>
<p>
and the EnergyPlus EMS Application Guide specifies
<em>An actuator called \"Lights\" is available with a control type called
\"Electric Power Level\" (in W).
This allows you to set the lighting power associated with each Lights input object.
The unique identifier is the name of the Lights input object.</em>
</p>
<p>
Therefore, the <code>Lights</code> object can be overwritten
by specifying the Modelica instance
</p>
<pre>
  Buildings.ThermalZones.EnergyPlus_24_1_0.Actuator actLig(
    variableName=\"LIVING ZONE Lights\",
    componentType=\"Lights\",
    controlType=\"Electric Power Level\",
    unit=Buildings.ThermalZones.EnergyPlus_24_1_0.Types.Units.Power)
      \"Actuator for lights\";
</pre>
<p>
and setting its input to the required power in Watts.
</p>
<!-- Actuator for a shade -->
<h5>Configuring an actuator for a shade</h5>
<p>
Consider the example
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SingleFamilyHouse.ShadeControl\">
Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SingleFamilyHouse.ShadeControl</a>.
In this example, the idf-file
has the following entry:
</p>
<pre>
  EnergyManagementSystem:Actuator,
    Zn001_Wall001_Win001_Shading_Deploy_Status,  !- Name
    Zn001:Wall001:Win001,    !- Actuated Component Unique Name
    Window Shading Control,  !- Actuated Component Type
    Control Status;          !- Actuated Component Control Type
</pre>
<p>
This causes EnergyPlus to overwrite the shade of the
<code>FenestrationSurface:Detailed</code> with name
<code>Zn001:Wall001:Win001</code>.
According to the EnergyPlus EMS Application Guide,
the EnergyPlus <code>Control Status</code> can be set
to <i>0</i> to remove the shade, or
to <i>6</i> to activate the interior blind.
</p>
<p>
Therefore, in Modelica, the instantiation
</p>
<pre>
  Buildings.ThermalZones.EnergyPlus_24_1_0.Actuator actSha(
    variableName=\"Zn001:Wall001:Win001\",
    componentType=\"Window Shading Control\",
    controlType=\"Control Status\",
    unit=Buildings.ThermalZones.EnergyPlus_24_1_0.Types.Units.Normalized)
      \"Actuator for window shade\"
</pre>
<p>
will write to the <code>Window Shading Control</code> of the EnergyPlus object
<code>FenestrationSurface:Detailed</code> with name <code>Zn001:Wall001:Win001</code>.
The entry <code>units=Buildings.ThermalZones.EnergyPlus_24_1_0.Types.Units.Normalized</code>
will cause the input value of the Modelica instance <code>actSha</code>
to be sent to EnergyPlus without any unit conversion. Hence,
in the example, the input <code>actSha.u</code> is set to <i>0</i> or <i>6</i>.
</p>
<p>
Note that the entry <code>EnergyManagementSystem:Actuator</code> in the idf-file is optional.
If specified, it will be ignored and the Modelica object be used instead.
</p>
<h4>Supported Actuators</h4>
<p>
The table below shows all EMS actuator objects supported by Spawn.
Which of these are available for a particular model depends on the EnergyPlus
idf-file. To list the EMS actuator objects that are available in your model, add the line
</p>
<pre>
Output:EnergyManagementSystem,
  Verbose,                 !- Actuator Availability Dictionary Reporting
  Verbose,                 !- Internal Variable Availability Dictionary Reporting
  Verbose;                 !- EMS Runtime Language Debug Output Level
</pre>
<p>
to the EnergyPlus idf-file. This will produce an EnergyPlus EMS data dictionary (<code>*.edd</code>) file that lists
the actuators for this model. Those that are listed in the <code>*.edd</code> file and in the table below are supported.
</p>
<p>
In the table below, the name in the first column
must be used as the value for the parameter <code>componentType</code>
and the name of the second column
must be used as the value for the parameter <code>controlType</code>.
</p>
<!-- Start of table of actuators generated by install.py. Do not edit. -->
<table summary=\"Supported EMS actuators\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr><th><code>componentType</code></th>
    <th><code>controlType</code></th>
    <th>Unit as received in Modelica</th>
    <th>Unit used by EnergyPlus</th>
  </tr>
  <tr>
    <td>ElectricEquipment</td>
    <td>Electricity Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
    <tr>
    <td>ExteriorLights</td>
    <td>Electricity Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
    <tr>
    <td>Lights</td>
    <td>Electricity Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
    <tr>
    <td>Material</td>
    <td>Surface Property Solar Absorptance</td>
    <td>1</td>
    <td>1</td>
  </tr>
    <tr>
    <td>Material</td>
    <td>Surface Property Thermal Absorptance</td>
    <td>1</td>
    <td>1</td>
  </tr>
    <tr>
    <td>Material</td>
    <td>Surface Property Visible Absorptance</td>
    <td>1</td>
    <td>1</td>
  </tr>
    <tr>
    <td>People</td>
    <td>Number of People</td>
    <td>1</td>
    <td>1</td>
  </tr>
    <tr>
    <td>Schedule:Compact</td>
    <td>Schedule Value</td>
    <td>1</td>
    <td>1</td>
  </tr>
    <tr>
    <td>Schedule:Constant</td>
    <td>Schedule Value</td>
    <td>1</td>
    <td>1</td>
  </tr>
    <tr>
    <td>Surface</td>
    <td>Construction State</td>
    <td>1</td>
    <td>1</td>
  </tr>
    <tr>
    <td>Surface</td>
    <td>Exterior Surface Convection Heat Transfer Coefficient</td>
    <td>W/m2.K</td>
    <td>W/m2.K</td>
  </tr>
    <tr>
    <td>Surface</td>
    <td>Interior Surface Convection Heat Transfer Coefficient</td>
    <td>W/m2.K</td>
    <td>W/m2.K</td>
  </tr>
    <tr>
    <td>Surface</td>
    <td>Outdoor Air Wind Direction</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
    <tr>
    <td>Surface</td>
    <td>Outdoor Air Wind Speed</td>
    <td>m/s</td>
    <td>m/s</td>
  </tr>
    <tr>
    <td>Surface</td>
    <td>Surface Inside Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
    <tr>
    <td>Surface</td>
    <td>Surface Outside Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
    <tr>
    <td>Surface</td>
    <td>View Factor To Ground</td>
    <td>1</td>
    <td>1</td>
  </tr>
    <tr>
    <td>Weather Data</td>
    <td>Diffuse Solar</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
    <tr>
    <td>Weather Data</td>
    <td>Direct Solar</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
    <tr>
    <td>Weather Data</td>
    <td>Outdoor Dew Point</td>
    <td>K</td>
    <td>degC</td>
  </tr>
    <tr>
    <td>Weather Data</td>
    <td>Outdoor Dry Bulb</td>
    <td>K</td>
    <td>degC</td>
  </tr>
    <tr>
    <td>Weather Data</td>
    <td>Outdoor Relative Humidity</td>
    <td>1</td>
    <td>%</td>
  </tr>
    <tr>
    <td>Weather Data</td>
    <td>Wind Direction</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
    <tr>
    <td>Weather Data</td>
    <td>Wind Speed</td>
    <td>m/s</td>
    <td>m/s</td>
  </tr>
    <tr>
    <td>Zone</td>
    <td>Outdoor Air Drybulb Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
    <tr>
    <td>Zone</td>
    <td>Outdoor Air Wetbulb Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
    <tr>
    <td>Zone Infiltration</td>
    <td>Air Exchange Flow Rate</td>
    <td>m3/s</td>
    <td>m3/s</td>
  </tr>
  </table>
<!-- End of table of actuators generated by install.py. Do not edit. -->
</html>",
      revisions="<html>
<ul>
<li>
February 18, 2021, by Michael Wetter:<br/>
Refactor synchronization of constructors.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2360\">#2360</a>.
</li>
<li>
November 13, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Polygon(
          points={{-42,28},{38,-28},{38,30},{-42,-28},{-42,28}},
          lineColor={0,0,0}),
        Line(
          points={{-62,0},{-42,0}},
          color={0,0,0}),
        Line(
          points={{38,0},{58,0}},
          color={0,0,0}),
        Line(
          points={{-10,0},{24,1.60689e-15}},
          color={0,0,0},
          origin={-2,10},
          rotation=90),
        Rectangle(
          extent={{-22,34},{20,70}},
          lineColor={0,0,0})}));
end Actuator;
