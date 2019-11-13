within Buildings.Experimental.EnergyPlus.BaseClasses;
partial model Writer "Block to write to an EnergyPlus actuator or schedule"
  extends Buildings.Experimental.EnergyPlus.BaseClasses.PartialEnergyPlusObject;

  parameter String name
    "Name of an EnergyPlus variable (need not be present in the idf file)";

  parameter Buildings.Experimental.EnergyPlus.Types.Units unit=
    Buildings.Experimental.EnergyPlus.Types.Units.unspecified
    "Unit of variable as used in Modelica"
    annotation(Evaluate=true);

  parameter String componentName
    "Actuated component unique name in the EnergyPlus idf file";

  parameter String componentType
    "Actuated component type";

  parameter String controlType
    "Actuated component control type";

  parameter Boolean useSamplePeriod = true
    "If true, sample at zone time step and at samplePeriod"
    annotation (
      Evaluate=true,
      Dialog(group="Sampling"));

  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
    "Sample period of component, used only if useSamplePeriod=true"
    annotation (
      Evaluate=true,
      Dialog(group="Sampling"));

  Modelica.Blocks.Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

protected
  constant String modelicaNameWriter = getInstanceName()
    "Name of this instance"
    annotation(HideResult=true);
  constant Integer objectType "Set to 1 for Actuator and 2 for Schedule";

  Buildings.Experimental.EnergyPlus.BaseClasses.FMUWriterClass adapter=
      Buildings.Experimental.EnergyPlus.BaseClasses.FMUWriterClass(
      objectType=objectType,
      modelicaNameBuilding=modelicaNameBuilding,
      modelicaNameWriter=modelicaNameWriter,
      idfName=idfName,
      weaName=weaName,
      iddName=Buildings.Experimental.EnergyPlus.BaseClasses.iddName,
      writerName=name,
      unit=unit,
      componentName=componentName,
      componentType=componentType,
      controlType=controlType,
      usePrecompiledFMU=usePrecompiledFMU,
      fmuName=fmuName,
      buildingsLibraryRoot=Buildings.Experimental.EnergyPlus.BaseClasses.buildingsLibraryRoot,
      verbosity=verbosity) "Class to communicate with EnergyPlus";

  output Boolean sampleTrigger "True, if sample time instant";

  Integer counter "Counter for number of calls to EnergyPlus during time steps";

initial equation
  Buildings.Experimental.EnergyPlus.BaseClasses.writerInitialize(
    adapter = adapter,
    startTime = time);
  counter = 0;

equation
  sampleTrigger = if useSamplePeriod then sample(startTime, samplePeriod) else false;

  // The 'not initial()' triggers one sample when the continuous time simulation starts.
  // This is required for the correct event handling. Otherwise the regression tests will fail.
 // when {initial(), not initial(), time >= pre(tNext)} then
  when {initial(), time >= pre(tNext), sampleTrigger, not initial()} then
    tNext = Buildings.Experimental.EnergyPlus.BaseClasses.writerExchange(
      adapter,
      initial(),
      round(time, 1E-3),
      u);
    counter = pre(counter) + 1;
  end when;

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
See <a href=\"modelica://Buildings.Experimental.EnergyPlus.Types.Units\">Buildings.Experimental.EnergyPlus.Types.Units</a>
for the supported units.
If the value of the parameter <code>unit</code> is left at its default value of
<code>Buildings.Experimental.EnergyPlus.Types.Units.unspecified</code>, then
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
