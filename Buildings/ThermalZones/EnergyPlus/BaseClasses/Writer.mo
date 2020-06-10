within Buildings.ThermalZones.EnergyPlus.BaseClasses;
partial model Writer "Block to write to an EnergyPlus actuator or schedule"
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.PartialEnergyPlusObject;

  parameter String name
    "Name of an EnergyPlus variable (need not be present in the idf file)";

  parameter Buildings.ThermalZones.EnergyPlus.Types.Units unit
    "Unit of variable as used in Modelica"
    annotation(choicesAllMatching = true);

  parameter String componentName
    "Actuated component unique name in the EnergyPlus idf file";

  parameter String componentType
    "Actuated component type";

  parameter String controlType
    "Actuated component control type";

//  parameter Boolean useSamplePeriod = true
//    "If true, sample at zone time step and at samplePeriod"
//   annotation (
//      Evaluate=true,
//      Dialog(group="Sampling"));

//  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
//    "Sample period of component, used only if useSamplePeriod=true"
//    annotation (
//      Evaluate=true,
//      Dialog(group="Sampling"));

  Modelica.Blocks.Interfaces.RealInput u "Continuous input signal to be written to EnergyPlus"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput y "Value written to EnergyPlus (use for direct dependency of Actuators and Schedules"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  constant String modelicaNameInputVariable = getInstanceName()
    "Name of this instance"
    annotation(HideResult=true);
  constant Integer objectType "Set to 1 for Actuator and 2 for Schedule";

  parameter String unitAsString=
  if unit==Types.Units.Normalized then
    "1"
  elseif unit == Types.Units.AngleRad then
    "rad"
  elseif unit == Types.Units.AngleDeg then
    "deg"
  elseif unit == Types.Units.Energy then
    "J"
  elseif unit == Types.Units.Illuminance then
    "lm/m2"
  elseif unit == Types.Units.HumidityAbsolute then
    "kg/kg"
  elseif unit == Types.Units.HumidityRelative then
    "1"
  elseif unit == Types.Units.LuminousFlux then
    "cd.sr"
  elseif unit == Types.Units.MassFlowRate then
    "kg/s"
  elseif unit == Types.Units.Power then
    "W"
  elseif unit == Types.Units.Pressure then
    "Pa"
  elseif unit == Types.Units.Status then
    "1"
  elseif unit == Types.Units.Temperature then
    "K"
  elseif unit == Types.Units.Time then
    "s"
  elseif unit == Types.Units.VolumeFlowRate then
    "m3/s"
  else
    "error";


  Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUInputVariableClass adapter=
      Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUInputVariableClass(
      objectType=objectType,
      modelicaNameBuilding=modelicaNameBuilding,
      modelicaNameInputVariable=modelicaNameInputVariable,
      idfName=idfName,
      weaName=epWeaName,
      writerName=name,
      componentName=componentName,
      componentType=componentType,
      controlType=controlType,
      unit=unitAsString,
      usePrecompiledFMU=usePrecompiledFMU,
      fmuName=fmuName,
      buildingsLibraryRoot=Buildings.ThermalZones.EnergyPlus.BaseClasses.buildingsLibraryRoot,
      verbosity=verbosity) "Class to communicate with EnergyPlus";

  //output Boolean sampleTrigger "True, if sample time instant";

  //Integer counter "Counter for number of calls to EnergyPlus during time steps";

initial equation
  Buildings.ThermalZones.EnergyPlus.BaseClasses.inputVariableInitialize(
    adapter = adapter,
    startTime = time);
  //counter = 0;
/*
  if unit==Types.Units.Normalized then
    unitAsString = "1";
  elseif unit == Types.Units.AngleRad then
    unitAsString = "rad";
  elseif unit == Types.Units.AngleDeg then
    unitAsString = "deg";
  elseif unit == Types.Units.Energy then
    unitAsString = "J";
  elseif unit == Types.Units.Illuminance then
    unitAsString = "lm/m2";
  elseif unit == Types.Units.HumidityAbsolute then
    unitAsString = "kg/kg";
  elseif unit == Types.Units.HumidityRelative then
    unitAsString = "1";
  elseif unit == Types.Units.LuminousFlux then
    unitAsString = "cd.sr";
  elseif unit == Types.Units.MassFlowRate then
    unitAsString = "kg/s";
  elseif unit == Types.Units.Power then
    unitAsString = "W";
  elseif unit == Types.Units.Pressure then
    unitAsString = "Pa";
  elseif unit == Types.Units.Status then
    unitAsString = "1";
  elseif unit == Types.Units.Temperature then
    unitAsString = "K";
  elseif unit == Types.Units.Time then
    unitAsString = "s";
  elseif unit == Types.Units.VolumeFlowRate then
    unitAsString = "m3/s";
  end if;
  */
equation
  //sampleTrigger = if useSamplePeriod then sample(startTime, samplePeriod) else false;

  // The 'not initial()' triggers one sample when the continuous time simulation starts.
  // This is required for the correct event handling. Otherwise the regression tests will fail.
 // when {initial(), not initial()} then
  //when {initial(), sampleTrigger, not initial()} then
    y = Buildings.ThermalZones.EnergyPlus.BaseClasses.inputVariableExchange(
      adapter,
      initial(),
      u,
      round(time, 1E-3));
    //counter = pre(counter) + 1;
  //end when;

  annotation (
    Documentation(info="<html>
<p>
Partial block that writes to an EMS actuator or to a schedule object in EnergyPlus.
</p>
<p>
This model instantiates an FMU with the name <code>idfName</code> and
writes at every EnergyPlus zone time step the value of the input <code>u</code>
to an EnergyPlus EMS actuator with name <code>name</code>.
If <code>useSamplePeriod = true</code>, then the value <code>u</code> is
written at each multiple of <code>samplePeriod</code>, in addition to the EnergyPlus zone time step.
</p>
<p>
The parameter <code>unit</code> specifies the unit of the signal <code>u</code>.
This unit is then converted internally to the units required by EnergyPlus before
the value is sent to EnergyPlus.
See <a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Types.Units\">Buildings.ThermalZones.EnergyPlus.Types.Units</a>
for the supported units.
If the value of the parameter <code>unit</code> is left at its default value of
<code>Buildings.ThermalZones.EnergyPlus.Types.Units.unspecified</code>, then
the simulation will stop with an error.
</p>
</html>", revisions="<html>
<ul>
<li>
November 13, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Writer;
