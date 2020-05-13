within Buildings.ThermalZones.EnergyPlus;
model OutputVariable
  "Block to read an EnergyPlus output variable for use in Modelica"
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.PartialEnergyPlusObject;

  parameter String key
    "EnergyPlus key of the output variable";
  parameter String name
    "EnergyPlus name of the output variable as in the EnergyPlus .rdd or .mdd file";

  discrete Modelica.Blocks.Interfaces.RealOutput y "Output received from EnergyPlus" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

protected
  final parameter Boolean printUnit = building.printUnits
    "Set to true to print unit of OutputVariable objects to log file"
      annotation(Dialog(group="Diagnostics"));

  Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUOutputVariableClass adapter=
      Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUOutputVariableClass(
      modelicaNameBuilding=modelicaNameBuilding,
      modelicaNameOutputVariable=modelicaNameOutputVariable,
      idfName=idfName,
      weaName=epWeaName,
      outputKey=key,
      outputName=name,
      usePrecompiledFMU=usePrecompiledFMU,
      fmuName=fmuName,
      buildingsLibraryRoot=Buildings.ThermalZones.EnergyPlus.BaseClasses.buildingsLibraryRoot,
      verbosity=verbosity,
      printUnit=printUnit) "Class to communicate with EnergyPlus";

  Modelica.SIunits.Time tNext(start=startTime, fixed=true) "Next sampling time";

  Integer counter "Counter for number of calls to EnergyPlus during time steps";

initial equation
  assert(not usePrecompiledFMU, "Use of pre-compiled FMU is not supported for block OutputVariable.");

  Buildings.ThermalZones.EnergyPlus.BaseClasses.outputVariableInitialize(
    adapter = adapter,
    startTime = time);
  counter = 0;
equation
  // The 'not initial()' triggers one sample when the continuous time simulation starts.
  // This is required for the correct event handling. Otherwise the regression tests will fail.
 // when {initial(), not initial(), time >= pre(tNext)} then
  when {initial(), time >= pre(tNext), not initial()} then
    (y, tNext) = Buildings.ThermalZones.EnergyPlus.BaseClasses.outputVariableExchange(
      adapter,
      initial(),
      round(time, 1E-3));
    counter = pre(counter) + 1;
  end when;

  annotation (
  defaultComponentName="out",
  Icon(graphics={
        Text(
          extent={{-88,84},{80,50}},
          lineColor={0,0,255},
          textString="%key"),
        Text(
          extent={{-86,36},{80,2}},
          lineColor={0,0,255},
          textString="%name"),
      Text(extent={{-90,-96},{100,-28}},
        textString=DynamicSelect("0.0", String(y, significantDigits=2)))}),
    Documentation(info="<html>
<p>
Block that retrieves an output variable from EnergyPlus.
</p>
<p>
This model instantiates an FMU with the name <code>idfName</code> and
reads at every EnergyPlus zone time step the output variable specified
by the parameters <code>outputKey</code> and <code>outputName</code>.
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
</html>", revisions="<html>
<ul>
<li>
January 28, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutputVariable;
