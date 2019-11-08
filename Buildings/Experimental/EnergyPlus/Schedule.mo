within Buildings.Experimental.EnergyPlus;
model Schedule "Block to write to an EnergyPlus schedule"
  extends Buildings.Experimental.EnergyPlus.BaseClasses.PartialEnergyPlusObject;

  parameter String name
    "Name of an EnergyPlus schedule (need not be present in the idf file)";

  parameter Buildings.Experimental.EnergyPlus.Types.Units unit=
    Buildings.Experimental.EnergyPlus.Types.Units.unspecified
    "Unit of variable as used in Modelica"
    annotation(Evaluate=true);

  parameter Boolean useSamplePeriod = true
    "If true, sample at zone time step and at samplePeriod"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
    "Sample period of component, used only if useSamplePeriod=true"
    annotation(Dialog(enable=useSamplePeriod));

  Modelica.Blocks.Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

protected
  constant String modelicaNameSchedule = getInstanceName()
    "Name of this instance"
    annotation(HideResult=true);

  Buildings.Experimental.EnergyPlus.BaseClasses.FMUScheduleClass adapter=
      Buildings.Experimental.EnergyPlus.BaseClasses.FMUScheduleClass(
      modelicaNameBuilding=modelicaNameBuilding,
      modelicaNameSchedule=modelicaNameSchedule,
      idfName=idfName,
      weaName=weaName,
      iddName=Buildings.Experimental.EnergyPlus.BaseClasses.iddName,
      scheduleName=name,
      unit=unit,
      usePrecompiledFMU=usePrecompiledFMU,
      fmuName=fmuName,
      buildingsLibraryRoot=Buildings.Experimental.EnergyPlus.BaseClasses.buildingsLibraryRoot,
      verbosity=verbosity) "Class to communicate with EnergyPlus";

  output Boolean sampleTrigger "True, if sample time instant";

  Integer counter "Counter for number of calls to EnergyPlus during time steps";

initial equation
  assert(not usePrecompiledFMU, "Use of pre-compiled FMU is not supported for block Schedule.");
  Buildings.Experimental.EnergyPlus.BaseClasses.scheduleInitialize(
    adapter = adapter,
    startTime = time);
  counter = 0;

equation
  sampleTrigger = if useSamplePeriod then sample(startTime, samplePeriod) else false;

  // The 'not initial()' triggers one sample when the continuous time simulation starts.
  // This is required for the correct event handling. Otherwise the regression tests will fail.
 // when {initial(), not initial(), time >= pre(tNext)} then
  when {initial(), time >= pre(tNext), sampleTrigger, not initial()} then
    tNext = Buildings.Experimental.EnergyPlus.BaseClasses.scheduleExchange(
      adapter,
      initial(),
      round(time, 1E-3),
      u);
    counter = pre(counter) + 1;
  end when;

  annotation (
  defaultComponentName="sch",
  Icon(graphics={
        Text(
          extent={{-84,100},{82,66}},
          lineColor={0,0,255},
          textString="%name"),
    Line(points={{-60,40},{-60,-40},{60,-40},{60,40},{30,40},{30,-40},{-30,-40},
              {-30,40},{-60,40},{-60,20},{60,20},{60,0},{-60,0},{-60,-20},{60,
              -20},{60,-40},{-60,-40},{-60,40},{60,40},{60,-40}}),
    Line(points={{0,40},{0,-40}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60,20},{-30,40}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60,0},{-30,20}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60,-20},{-30,0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60,-40},{-30,-20}})}),
    Documentation(info="<html>
<p>
Block that writes to a schedule object in EnergyPlus.
</p>
<p>
This model instantiates an FMU with the name <code>idfName</code> and
writes at every EnergyPlus zone time step the value of the input <code>u</code>
to an EnergyPlus schedule with name <code>name</code>.
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
November 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Schedule;
