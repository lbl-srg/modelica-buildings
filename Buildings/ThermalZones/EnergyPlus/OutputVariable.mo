within Buildings.ThermalZones.EnergyPlus;
model OutputVariable
  "Block to read an EnergyPlus output variable for use in Modelica"
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.PartialEnergyPlusObject;
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
  Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUOutputVariableClass adapter=Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUOutputVariableClass(
    modelicaNameBuilding=modelicaNameBuilding,
    modelicaNameOutputVariable=modelicaNameOutputVariable,
    idfName=idfName,
    weaName=weaName,
    name=name,
    componentKey=key,
    usePrecompiledFMU=usePrecompiledFMU,
    fmuName=fmuName,
    buildingsLibraryRoot=Buildings.ThermalZones.EnergyPlus.BaseClasses.buildingsLibraryRoot,
    logLevel=logLevel,
    printUnit=printUnit)
    "Class to communicate with EnergyPlus";
  Modelica.SIunits.Time tNext(
    start=startTime,
    fixed=true)
    "Next sampling time";
  Integer counter
    "Counter for number of calls to EnergyPlus during time steps";
initial equation
  assert(
    not usePrecompiledFMU,
    "Use of pre-compiled FMU is not supported for block OutputVariable.");
  Buildings.ThermalZones.EnergyPlus.BaseClasses.outputVariableInitialize(
    adapter=adapter,
    startTime=time);
  counter=0;
equation
  if isDirectDependent then
    connect(directDependency,directDependency_in_internal);
  else
    directDependency_in_internal=0;
  end if;
  // The 'not initial()' triggers one sample when the continuous time simulation starts.
  // This is required for the correct event handling. Otherwise the regression tests will fail.
  // when {initial(), not initial(), time >= pre(tNext)} then
  when {initial(),time >= pre(tNext),not initial()} then
    (y,tNext)=Buildings.ThermalZones.EnergyPlus.BaseClasses.outputVariableExchange(
      adapter,
      initial(),
      directDependency_in_internal,
      round(
        time,
        1E-3));
    counter=pre(
      counter)+1;
  end when;
  annotation (
    defaultComponentName="out",
    Icon(
      graphics={
        Text(
          extent={{-88,84},{80,50}},
          lineColor={0,0,255},
          textString="%key"),
        Text(
          extent={{-86,36},{80,2}},
          lineColor={0,0,255},
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
<a href=\"modelica://Modelica.SIunits\">Modelica.SIunits</a>.
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
</pre>
<p>
Next, instantiate the output variable in Modelica. To obtain the value of
<code>Zone,Average,Zone Electric Equipment Electricity Rate [W]</code>
for the zone <code>LIVING ZONE</code>,
the Modelica instantiation would be
</p>
<pre>
Buildings.ThermalZones.EnergyPlus.OutputVariable equEle(
  name=\"Zone Electric Equipment Electricity Rate\",
  key=\"LIVING ZONE\")
  \"Block that reads output from EnergyPlus\";
</pre>
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
Some output variables <i>directly</i> depend on input variable, i.e.,
if an input variable changes, the output changes immediately.
Examples are
the illuminance in a room that changes instantaneously when the window blind is changed, or
the <code>Zone Electric Equipment Electricity Rate</code> which changes instantaneously
when a schedule value switches it on
(see
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Validation.Schedule.EquipmentScheduleOutputVariable\">
Buildings.ThermalZones.EnergyPlus.Validation.Schedule.EquipmentScheduleOutputVariable</a>).
For such variables, set <code>isDirectDependent=true</code>.
In contrast, an output variables does not depend directly on an input variable if
it is a continuous time state, or if it only depends on time such as weather data.
Examples are
the zone air temperature <code>Zone Mean Air Temperature</code> which only changes <i>after</i>
time lapsed, i.e., EnergyPlus made a time step, or
<code>Surface Outside Face Incident Beam Solar Radiation Rate per Area</code> which does of course
not change if an occupancy schedule changes.
For these variables, leave <code>isDirectDependent=false</code>.
</p>
<p>
If <code>isDirectDependent=true</code>, the input connector <code>directDependency</code>
is enabled.
You need to connect this input to the output(s) of these instance of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Actuator\">
Buildings.ThermalZones.EnergyPlus.Actuator</a>
or
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Schedule\">
Buildings.ThermalZones.EnergyPlus.Schedule</a>
on which this output directly depends on.
See for example
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Validation.Schedule.EquipmentScheduleOutputVariable\">
Buildings.ThermalZones.EnergyPlus.Validation.Schedule.EquipmentScheduleOutputVariable</a>.
If the output depends on multiple inputs, just multiply these inputs before connecting their product
to the connector <code>directDependency</code>. What the value is is irrelevant,
but a Modelica code generator will then understand that first the input needs to be sent
to EnergyPlus before the output is requested.
</p>
</html>",
      revisions="<html>
<ul>
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
