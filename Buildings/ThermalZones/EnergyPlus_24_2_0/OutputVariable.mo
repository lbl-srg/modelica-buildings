within Buildings.ThermalZones.EnergyPlus_24_2_0;
model OutputVariable
  "Block to read an EnergyPlus output variable"
  extends Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.PartialEnergyPlusObject;
  extends Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.Synchronize.ObjectSynchronizer;
  parameter String name
    "EnergyPlus name of the output variable as in the EnergyPlus .rdd or .mdd file";
  parameter String key
    "EnergyPlus key of the output variable";
  parameter Boolean isDirectDependent=false
    "Set to false for states or weather variables, or true for algebraic variables with direct dependency on input variables";
  Modelica.Blocks.Interfaces.RealInput directDependency if isDirectDependent
    "Set to algebraic variable on which this output directly depends on"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  discrete Modelica.Blocks.Interfaces.RealOutput y
    "Output received from EnergyPlus"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  final parameter Boolean printUnit=building.printUnits
    "Set to true to print unit of OutputVariable objects to log file"
    annotation (Dialog(group="Diagnostics"));
  Modelica.Blocks.Interfaces.RealInput directDependency_in_internal
    "Needed to connect to conditional connector";
  constant Integer nParOut=0
    "Number of parameter values retrieved from EnergyPlus";
  constant Integer nInp=0
    "Number of inputs";
  constant Integer nOut=1
    "Number of outputs";
  constant Integer nDer=0
    "Number of derivatives";
  constant Integer nY=nOut+nDer+1
    "Size of output vector of exchange function";
  parameter Integer nObj(
    fixed=false,
    start=0)
    "Total number of Spawn objects in building";
  Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.SpawnExternalObject adapter=Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.SpawnExternalObject(
    objectType=4,
    startTime=startTime,
    modelicaNameBuilding=modelicaNameBuilding,
    modelicaInstanceName=modelicaInstanceName,
    spawnExe=spawnExe,
    idfVersion=idfVersion,
    idfName=idfName,
    epwName=epwName,
    runPeriod=runPeriod,
    relativeSurfaceTolerance=relativeSurfaceTolerance,
    epName=name,
    usePrecompiledFMU=usePrecompiledFMU,
    fmuName=fmuName,
    buildingsRootFileLocation=Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.buildingsRootFileLocation,
    logLevel=logLevel,
    printUnit=printUnit,
    jsonName="outputVariables",
    jsonKeysValues="        \"name\": \""+name+"\",
        \"key\": \""+key+"\",
        \"fmiName\": \""+name+"_"+key+"\"",
    parOutNames=fill("",nParOut),
    parOutUnits=fill("",nParOut),
    nParOut=nParOut,
    inpNames=fill("",nInp),
    inpUnits=fill("",nInp),
    nInp=0,
    outNames={key},
    outUnits=fill("",nOut),
    nOut=nOut,
    derivatives_structure=fill(fill(nDer,2),nDer),
    nDer=nDer,
    derivatives_delta=fill(0,nDer))
    "Class to communicate with EnergyPlus";
  Real yEP[nY]
    "Output of exchange function";
  Modelica.Units.SI.Time tNext(start=startTime, fixed=true)
    "Next sampling time";

initial equation
  assert(
    not usePrecompiledFMU,
    "Use of pre-compiled FMU is not supported for block OutputVariable.");
  nObj=Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.initialize(
    adapter=adapter,
    isSynchronized=building.isSynchronized);

equation
  if isDirectDependent then
    connect(directDependency,directDependency_in_internal);
  else
    directDependency_in_internal=0;
  end if;
  when {initial(),time >= pre(tNext)} then
    yEP=Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.exchange(
      adapter=adapter,
      nY=nY,
      u={round(time,1E-3),directDependency_in_internal},
      dummy=nObj);
    y=yEP[1];
    tNext=yEP[2];
  end when;
  nObj=synBui.synchronize.done;
  annotation (
    defaultComponentName="out",
    Icon(
      graphics={
        Text(
          extent={{-88,84},{80,50}},
          textColor={0,0,255},
          textString="%key"),
        Text(
          extent={{-86,36},{80,2}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-90,-96},{100,-28}},
          textString=DynamicSelect("0.0",String(y,
            significantDigits=2)))}),
    Documentation(
      info="<html>
<p>
Block that retrieves an output variable from EnergyPlus.
</p>
<p>
This model reads at every EnergyPlus zone time step the output variable specified
by the parameters <code>componentKey</code> and <code>variableName</code>.
These parameters are the values for the EnergyPlus variable key and name,
which can be found in the EnergyPlus result dictionary file (<code>.rdd</code> file)
or the EnergyPlus meter dictionary file (<code>.mdd</code> file).
</p>
<p>
The variable of the output <code>y</code> has Modelica SI units, as declared in
<a href=\"modelica://Modelica.Units.SI\">Modelica.Units.SI</a>.
For example, temperatures will be in Kelvin, and mass flow rates will be in
<code>kg/s</code>.
</p>
<p>
The output signal <code>y</code> gets updated at each EnergyPlus time step.
</p>

<h4>Usage</h4>
<p>
To use an output variable, it is best to add in the EnergyPlus idf file the entry
</p>
<pre>
Output:VariableDictionary, Regular;
</pre>
<p>
and then simulate the model. This will create the file
<code>eplusout.rdd</code> that contains all output variables. The file has lines such as
</p>
<pre>
Zone,Average,Zone Electric Equipment Electricity Rate [W]
Zone,Average,Site Outdoor Air Drybulb Temperature [C]
</pre>
<p>
Next, instantiate the output variable in Modelica. To obtain the value of
<code>Zone,Average,Zone Electric Equipment Electricity Rate [W]</code>
for the zone <code>LIVING ZONE</code>,
the Modelica instantiation would be
</p>
<pre>
Buildings.ThermalZones.EnergyPlus_24_2_0.OutputVariable equEle(
  name=\"Zone Electric Equipment Electricity Rate\",
  key=\"LIVING ZONE\")
  \"Block that reads output from EnergyPlus\";
</pre>
<p>
To obtain the value of
<code>Site Outdoor Air Drybulb Temperature [C]</code> from EnergyPlus,
the Modelica instantiation would be
</p>
<pre>
Buildings.ThermalZones.EnergyPlus_24_2_0.OutputVariable TOut(
  name=\"Site Outdoor Air Drybulb Temperature\",
  key=\"Environment\")
  \"Block that reads output from EnergyPlus\";
</pre>
<p>
(Note that this variable could be read directly from the Modelica weather data bus,
which can be accessed from
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Building\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Building</a>.)
</p>
<p>
By default, the Modelica log file will display the unit in the form
</p>
<pre>
Output OneZoneOneOutputVariable.equEle.y has in Modelica the unit W.
</pre>
<p>
For this diagnostic message, Modelica knows that the unit is Watts because EnergyPlus
wrote the unit for this output when it instantiated the model.
(The output signal <code>y</code> of this block will <i>not</i> have a unit attribute set
because it is not possible to automatically set the unit attribute of the output <code>y</code>
based on the information that EnergyPlus provides.)
</p>
<h4>Direct dependency of output</h4>
<p>
Some output variables <i>directly</i> depend on input variables, i.e.,
if an input variable changes, the output changes immediately.
Examples are
the illuminance in a room that changes instantaneously when the window blind is changed, or
the output variable <code>Zone Electric Equipment Electricity Rate</code> which changes instantaneously
when a schedule value switches it on
(see
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.Schedule.EquipmentScheduleOutputVariable\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.Schedule.EquipmentScheduleOutputVariable</a>).
For such variables, users should set <code>isDirectDependent=true</code>.
Output variables that do not depend directly on an input variable include
continuous time states such as the inside temperature of a wall
and variables that only depend on time such as weather data.
For these variables, users should leave <code>isDirectDependent=false</code>.
</p>
<p>
If a user sets <code>isDirectDependent=true</code>, then the model enables
the input connector <code>directDependency</code>.
Users then need to connect this input to the output(s) of these instance of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Actuator\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Actuator</a>
or
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Schedule\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Schedule</a>
on which this output directly depends on.
See for example
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.Schedule.EquipmentScheduleOutputVariable\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.Schedule.EquipmentScheduleOutputVariable</a>.
If the output depends on multiple inputs, just multiply these inputs and connect their product
to the connector <code>directDependency</code>. What the value is is irrelevant,
but a Modelica code generator will then understand that first the input needs to be sent
to EnergyPlus before the output is requested.
</p>
<h4>Supported output variables</h4>
<p>
The table below shows all output variables supported by Spawn.
Which of these are available for a particular model depends on the EnergyPlus
idf-file. To list the output variables that are available in your model, add the line
</p>
<pre>
Output:VariableDictionary, IDF;
</pre>
<p>
to the EnergyPlus idf-file. This will produce an EnergyPlus result data dictionary (rdd) file.
</p>
<p>
In the table below, the name in the first column
must be used as the value for the parameter <code>name</code>
in instances of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.OutputVariable\">
Buildings.ThermalZones.EnergyPlus_24_2_0.OutputVariable</a>.
</p>
<!-- Start of table of output variables generated by install.py. Do not edit. -->
<table summary=\"Supported output variables\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr><th><code>name</code></th>
    <th>Unit as received in Modelica</th>
    <th>Unit used by EnergyPlus</th>
  </tr>
  <tr>
    <td>Debug Surface Solar Shading Model DifShdgRatioHoriz</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Debug Surface Solar Shading Model DifShdgRatioIsoSky</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Debug Surface Solar Shading Model WithShdgIsoSky</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Debug Surface Solar Shading Model WoShdgIsoSky</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Electric Equipment Convective Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Electric Equipment Convective Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Electric Equipment Electric Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Electric Equipment Electric Power</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Electric Equipment Latent Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Electric Equipment Latent Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Electric Equipment Lost Heat Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Electric Equipment Lost Heat Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Electric Equipment Radiant Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Electric Equipment Radiant Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Electric Equipment Total Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Electric Equipment Total Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity CH4 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity CO Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity CO2 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity Hg Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity N2O Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity NH3 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity NMVOC Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity NOx Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity Nuclear High Level Waste Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity Nuclear Low Level Waste Volume</td>
    <td>m3</td>
    <td>m3</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity PM Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity PM10 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity PM2.5 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity Pb Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity SO2 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity Source Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Environmental Impact Electricity Water Consumption Volume</td>
    <td>m3</td>
    <td>L</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas CH4 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas CO Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas CO2 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas Hg Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas N2O Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas NH3 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas NMVOC Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas NOx Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas Nuclear High Level Waste Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas Nuclear Low Level Waste Volume</td>
    <td>m3</td>
    <td>m3</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas PM Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas PM10 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas PM2.5 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas Pb Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas SO2 Emissions Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas Source Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Environmental Impact Natural Gas Water Consumption Volume</td>
    <td>m3</td>
    <td>L</td>
  </tr>
  <tr>
    <td>Environmental Impact Purchased Electricity Source Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Environmental Impact Surplus Sold Electricity Source</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Environmental Impact Total CH4 Emissions Carbon Equivalent Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Total CO2 Emissions Carbon Equivalent Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Environmental Impact Total N2O Emissions Carbon Equivalent Mass</td>
    <td>kg</td>
    <td>kg</td>
  </tr>
  <tr>
    <td>Exterior Lights Electric Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Exterior Lights Electric Power</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Facility Cooling Setpoint Not Met Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Facility Cooling Setpoint Not Met While Occupied Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Facility Heating Setpoint Not Met Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Facility Heating Setpoint Not Met While Occupied Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Facility Thermal Comfort ASHRAE 55 Simple Model Summer Clothes Not Comfortable Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Facility Thermal Comfort ASHRAE 55 Simple Model Summer or Winter Clothes Not Comfortable Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Facility Thermal Comfort ASHRAE 55 Simple Model Winter Clothes Not Comfortable Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Lights Convective Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Lights Convective Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Lights Electric Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Lights Electric Power</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Lights Radiant Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Lights Radiant Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Lights Return Air Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Lights Return Air Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Lights Total Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Lights Total Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Lights Visible Radiation Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Lights Visible Radiation Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>People Air Relative Humidity</td>
    <td>1</td>
    <td>%</td>
  </tr>
  <tr>
    <td>People Air Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>People Convective Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>People Convective Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>People Latent Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>People Latent Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>People Occupant Count</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>People Radiant Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>People Radiant Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>People Sensible Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>People Sensible Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>People Total Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>People Total Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Schedule Value</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Site Beam Solar Radiation Luminous Efficacy</td>
    <td>lm/W</td>
    <td>lm/W</td>
  </tr>
  <tr>
    <td>Site Day Type Index</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Site Daylight Saving Time Status</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Site Daylighting Model Sky Brightness</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Site Daylighting Model Sky Clearness</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Site Deep Ground Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Site Diffuse Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Site Direct Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Site Exterior Beam Normal Illuminance</td>
    <td>lm/m2</td>
    <td>lux</td>
  </tr>
  <tr>
    <td>Site Exterior Horizontal Beam Illuminance</td>
    <td>lm/m2</td>
    <td>lux</td>
  </tr>
  <tr>
    <td>Site Exterior Horizontal Sky Illuminance</td>
    <td>lm/m2</td>
    <td>lux</td>
  </tr>
  <tr>
    <td>Site Ground Reflected Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Site Ground Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Site Horizontal Infrared Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Site Mains Water Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Site Outdoor Air Barometric Pressure</td>
    <td>Pa</td>
    <td>Pa</td>
  </tr>
  <tr>
    <td>Site Outdoor Air Density</td>
    <td>kg/m3</td>
    <td>kg/m3</td>
  </tr>
  <tr>
    <td>Site Outdoor Air Dewpoint Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Site Outdoor Air Drybulb Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Site Outdoor Air Enthalpy</td>
    <td>J/kg</td>
    <td>J/kg</td>
  </tr>
  <tr>
    <td>Site Outdoor Air Humidity Ratio</td>
    <td>1</td>
    <td>kgWater/kgDryAir</td>
  </tr>
  <tr>
    <td>Site Outdoor Air Relative Humidity</td>
    <td>1</td>
    <td>%</td>
  </tr>
  <tr>
    <td>Site Outdoor Air Wetbulb Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Site Precipitation Depth</td>
    <td>m</td>
    <td>m</td>
  </tr>
  <tr>
    <td>Site Rain Status</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Site Simple Factor Model Ground Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Site Sky Diffuse Solar Radiation Luminous Efficacy</td>
    <td>lm/W</td>
    <td>lm/W</td>
  </tr>
  <tr>
    <td>Site Sky Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Site Snow on Ground Status</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Site Solar Altitude Angle</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Site Solar Azimuth Angle</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Site Solar Hour Angle</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Site Surface Ground Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Site Total Surface Heat Emission to Air</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Site Total Zone Exfiltration Heat Loss</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Site Total Zone Exhaust Air Heat Loss</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Site Wind Direction</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Site Wind Speed</td>
    <td>m/s</td>
    <td>m/s</td>
  </tr>
  <tr>
    <td>Surface Anisotropic Sky Multiplier</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Average Face Conduction Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Average Face Conduction Heat Loss Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Average Face Conduction Heat Transfer Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Average Face Conduction Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Average Face Conduction Heat Transfer Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Heat Storage Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Heat Storage Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Heat Storage Loss Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Heat Storage Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Heat Storage Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Absorbed Shortwave Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Adjacent Air Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Surface Inside Face Beam Solar Radiation Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Conduction Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Conduction Heat Loss Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Conduction Heat Transfer Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Inside Face Conduction Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Conduction Heat Transfer Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Convection Classification Index</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Inside Face Convection Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Inside Face Convection Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Convection Heat Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Convection Heat Transfer Coefficient</td>
    <td>W/m2.K</td>
    <td>W/m2.K</td>
  </tr>
  <tr>
    <td>Surface Inside Face Convection Model Equation Index</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Inside Face Convection Reference Air Index</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Inside Face Exterior Windows Incident Beam Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Inside Face Exterior Windows Incident Beam Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Exterior Windows Incident Beam Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Heat Source Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Initial Transmitted Diffuse Absorbed Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Initial Transmitted Diffuse Transmitted Out Window Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Interior Movable Insulation Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Surface Inside Face Interior Windows Incident Beam Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Inside Face Interior Windows Incident Beam Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Interior Windows Incident Beam Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Internal Gains Radiation Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Inside Face Internal Gains Radiation Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Internal Gains Radiation Heat Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Lights Radiation Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Inside Face Lights Radiation Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Lights Radiation Heat Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Net Surface Thermal Radiation Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Inside Face Net Surface Thermal Radiation Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Net Surface Thermal Radiation Heat Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Solar Radiation Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Inside Face Solar Radiation Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face Solar Radiation Heat Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face System Radiation Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Inside Face System Radiation Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Inside Face System Radiation Heat Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Inside Face Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Surface Outside Face Beam Solar Incident Angle Cosine Value</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Outside Face Conduction Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Outside Face Conduction Heat Loss Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Outside Face Conduction Heat Transfer Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Outside Face Conduction Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Outside Face Conduction Heat Transfer Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Convection Classification Index</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Outside Face Convection Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Outside Face Convection Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Outside Face Convection Heat Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Convection Heat Transfer Coefficient</td>
    <td>W/m2.K</td>
    <td>W/m2.K</td>
  </tr>
  <tr>
    <td>Surface Outside Face Forced Convection Model Equation Index</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Outside Face Heat Emission to Air Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Outside Face Heat Source Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Incident Beam Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Incident Beam To Beam Surface Reflected Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Incident Beam To Diffuse Ground Reflected Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Incident Beam To Diffuse Surface Reflected Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Incident Ground Diffuse Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Incident Sky Diffuse Ground Reflected Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Incident Sky Diffuse Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Incident Sky Diffuse Surface Reflected Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Incident Solar Radiation Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Natural Convection Model Equation Index</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Outside Face Net Thermal Radiation Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Outside Face Net Thermal Radiation Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Outside Face Net Thermal Radiation Heat Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Outdoor Air Drybulb Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Surface Outside Face Outdoor Air Wetbulb Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Surface Outside Face Outdoor Air Wind Direction</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Surface Outside Face Outdoor Air Wind Speed</td>
    <td>m/s</td>
    <td>m/s</td>
  </tr>
  <tr>
    <td>Surface Outside Face Solar Radiation Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Outside Face Solar Radiation Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Outside Face Solar Radiation Heat Gain Rate per Area</td>
    <td>W/m2</td>
    <td>W/m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Sunlit Area</td>
    <td>m2</td>
    <td>m2</td>
  </tr>
  <tr>
    <td>Surface Outside Face Sunlit Fraction</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Outside Face Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Surface Outside Face Thermal Radiation to Air Heat Transfer Coefficient</td>
    <td>W/m2.K</td>
    <td>W/m2.K</td>
  </tr>
  <tr>
    <td>Surface Outside Face Thermal Radiation to Air Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Outside Face Thermal Radiation to Ground Heat Transfer Coefficient</td>
    <td>W/m2.K</td>
    <td>W/m2.K</td>
  </tr>
  <tr>
    <td>Surface Outside Face Thermal Radiation to Sky Heat Transfer Coefficient</td>
    <td>W/m2.K</td>
    <td>W/m2.K</td>
  </tr>
  <tr>
    <td>Surface Outside Normal Azimuth Angle</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Surface Shading Device Is On Time Fraction</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Storm Window On Off Status</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window BSDF Beam Direction Number</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window BSDF Beam Phi Angle</td>
    <td>rad</td>
    <td>rad</td>
  </tr>
  <tr>
    <td>Surface Window BSDF Beam Theta Angle</td>
    <td>rad</td>
    <td>rad</td>
  </tr>
  <tr>
    <td>Surface Window Back Face Temperature Layer 1</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Surface Window Blind Slat Angle</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Surface Window Front Face Temperature Layer 1</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Surface Window Gap Convective Heat Transfer Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Gap Convective Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Glazing Beam to Beam Solar Transmittance</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window Glazing Beam to Diffuse Solar Transmittance</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window Glazing Diffuse to Diffuse Solar Transmittance</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Heat Loss Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Heat Loss Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Inside Face Divider Condensation Status</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window Inside Face Frame Condensation Status</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window Inside Face Glazing Condensation Status</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window Model Solver Iteration Count</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window Net Heat Transfer Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Net Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Outside Reveal Reflected Beam Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Outside Reveal Reflected Beam Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Shading Device Absorbed Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Shading Device Absorbed Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Solar Horizontal Profile Angle</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Surface Window Solar Vertical Profile Angle</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Surface Window System Solar Absorptance</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window System Solar Reflectance</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window System Solar Transmittance</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Surface Window Total Glazing Layers Absorbed Shortwave Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Total Glazing Layers Absorbed Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Total Glazing Layers Absorbed Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Beam Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Beam Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Beam To Beam Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Beam To Beam Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Beam To Diffuse Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Beam To Diffuse Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Diffuse Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Diffuse Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Surface Window Transmitted Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Air Heat Balance Air Energy Storage Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Air Heat Balance Internal Convective Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Air Heat Balance Interzone Air Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Air Heat Balance Outdoor Air Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Air Heat Balance Surface Convection Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Air Heat Balance System Air Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Air Heat Balance System Convective Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Cooling Setpoint Not Met Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Zone Cooling Setpoint Not Met While Occupied Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Convective Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Convective Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Electric Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Electric Power</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Latent Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Latent Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Lost Heat Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Lost Heat Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Radiant Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Radiant Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Total Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Electric Equipment Total Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Exfiltration Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Exfiltration Latent Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Exfiltration Sensible Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Exhaust Air Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Exhaust Air Latent Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Exhaust Air Sensible Heat Transfer Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Exterior Windows Total Transmitted Beam Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Exterior Windows Total Transmitted Beam Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Exterior Windows Total Transmitted Diffuse Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Exterior Windows Total Transmitted Diffuse Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Heating Setpoint Not Met Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Zone Heating Setpoint Not Met While Occupied Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Zone Interior Windows Total Transmitted Beam Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Interior Windows Total Transmitted Beam Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Interior Windows Total Transmitted Diffuse Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Interior Windows Total Transmitted Diffuse Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Lights Convective Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Lights Convective Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Lights Electric Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Lights Electric Power</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Lights Radiant Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Lights Radiant Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Lights Return Air Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Lights Return Air Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Lights Total Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Lights Total Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Lights Visible Radiation Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Lights Visible Radiation Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Mean Air Dewpoint Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Zone Mean Air Humidity Ratio</td>
    <td>1</td>
    <td>kgWater/kgDryAir</td>
  </tr>
  <tr>
    <td>Zone Mean Air Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Zone Mean Radiant Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Zone Operative Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Zone Outdoor Air Drybulb Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Zone Outdoor Air Wetbulb Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Zone Outdoor Air Wind Direction</td>
    <td>rad</td>
    <td>deg</td>
  </tr>
  <tr>
    <td>Zone Outdoor Air Wind Speed</td>
    <td>m/s</td>
    <td>m/s</td>
  </tr>
  <tr>
    <td>Zone People Convective Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone People Convective Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone People Latent Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone People Latent Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone People Occupant Count</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Zone People Radiant Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone People Radiant Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone People Sensible Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone People Sensible Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone People Total Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone People Total Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Thermal Comfort ASHRAE 55 Simple Model Summer Clothes Not Comfortable Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Zone Thermal Comfort ASHRAE 55 Simple Model Summer or Winter Clothes Not Comfortable Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Zone Thermal Comfort ASHRAE 55 Simple Model Winter Clothes Not Comfortable Time</td>
    <td>s</td>
    <td>hr</td>
  </tr>
  <tr>
    <td>Zone Thermal Comfort Clothing Surface Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Zone Thermal Comfort Fanger Model PMV</td>
    <td>1</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Zone Thermal Comfort Fanger Model PPD</td>
    <td>1</td>
    <td>%</td>
  </tr>
  <tr>
    <td>Zone Thermal Comfort Mean Radiant Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Zone Thermal Comfort Operative Temperature</td>
    <td>K</td>
    <td>degC</td>
  </tr>
  <tr>
    <td>Zone Total Internal Convective Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Total Internal Convective Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Total Internal Latent Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Total Internal Latent Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Total Internal Radiant Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Total Internal Radiant Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Total Internal Total Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Total Internal Total Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Total Internal Visible Radiation Heating Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Total Internal Visible Radiation Heating Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Windows Total Heat Gain Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Windows Total Heat Gain Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Windows Total Heat Loss Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Windows Total Heat Loss Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
  <tr>
    <td>Zone Windows Total Transmitted Solar Radiation Energy</td>
    <td>J</td>
    <td>J</td>
  </tr>
  <tr>
    <td>Zone Windows Total Transmitted Solar Radiation Rate</td>
    <td>W</td>
    <td>W</td>
  </tr>
</table>
<!-- End of table of output variables generated by install.py. Do not edit. -->
</html>",
      revisions="<html>
<ul>
<li>
February 18, 2021, by Michael Wetter:<br/>
Refactor synchronization of constructors.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2360\">#2360</a>.
</li>
<li>
December 6, 2020, by Michael Wetter:<br/>
Reformulated <code>when</code> condition to avoid using <code>not initial()</code>.
Per the Modelica language definition, <code>when</code> clauses are not meant to contain
<code>not initial()</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2068\">#2068</a>.
</li>
<li>
June 5, 2020, by Michael Wetter:<br/>
Added option for declaring direct dependencies.
</li>
<li>
January 28, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutputVariable;
