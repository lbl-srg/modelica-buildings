within Buildings.Fluid.Movers;
model SpeedControlled_Nrpm
  "Fan or pump with ideally controlled speed Nrpm as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.SpeedControlled(
    _per_y(hydraulicEfficiency=per.hydraulicEfficiency,
            motorEfficiency=per.motorEfficiency,
            power=per.power,
            pressure(
              V_flow = per.pressure.V_flow,
              dp =     per.pressure.dp),
            motorCooledByFluid=per.motorCooledByFluid,
            use_powerCharacteristic=per.use_powerCharacteristic),
    final stageInputs(each final unit="1/min") = speeds,
    final constInput(final unit="1/min") = speed);

  parameter Real speed(final unit="1/min") = 0
    "Speed set point when using constant set point"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Constant));
  parameter Real[:] speeds(each final unit="1/min") = {0}
    "Vector of speed set points when using stages"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Stages));
  replaceable parameter Data.SpeedControlled_Nrpm per
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Interfaces.RealInput Nrpm(final unit="1/min") if
    inputType == Buildings.Fluid.Types.InputType.Continuous
    "Prescribed rotational speed"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
protected
  Modelica.Blocks.Math.Gain gaiSpe(
    u(min=0,
      final quantity="AngularVelocity",
      final unit="1/min",
      nominal=3000),
    y(final unit="1",
      nominal=1),
    final k=1/per.N_nominal) "Gain for speed input signal"
    annotation (Placement(transformation(extent={{6,44},{18,56}})));

equation
  if filteredSpeed then
    connect(gaiSpe.y, filter.u) annotation (Line(
      points={{18.6,50},{18,50},{18,88},{18.6,88}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, y_actual) annotation (Line(
      points={{34.7,88},{60.35,88},{60.35,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, y_filtered) annotation (Line(
      points={{34.7,88},{50,88}},
      color={0,0,127},
      smooth=Smooth.None));

  else
    connect(gaiSpe.y, y_actual) annotation (Line(
      points={{18.6,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  connect(inputSwitch.y, gaiSpe.u) annotation (Line(
      points={{1,50},{4.8,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inputSwitch.u, Nrpm) annotation (Line(
      points={{-22,50},{-26,50},{-26,80},{0,80},{0,120}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
            Text(
              visible = inputType == Buildings.Fluid.Types.InputType.Continuous,
              extent={{20,126},{118,104}},
              textString="Nrpm [rpm]"),
            Text(
          visible=inputType == Buildings.Fluid.Types.InputType.Constant,
          extent={{-80,136},{78,102}},
          lineColor={0,0,255},
          textString="%speed")}),
    Documentation(info="<html>
This model describes a fan or pump with prescribed speed in revolutions per minute.
The head is computed based on the performance curve that take as an argument
the actual volume flow rate divided by the maximum flow rate and the relative
speed of the fan.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate, or
based on the motor performance curves.
<br/>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 2, 2015, by Filip Jorissen:<br/>
Added code for supporting stage input and constant input.
</li>
<li>
March 6, 2015, by Michael Wetter<br/>
Made performance record <code>per</code> replaceable
as for the other models.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
April 17, 2014, by Filip Jorissen:<br/>
Implemented records for supplying pump/fan parameters
</li>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24, 2010, by Michael Wetter:<br/>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009,
    by Michael Wetter:<br/>
       Model added to the Buildings library.
</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br/>
       Model added to the Fluid library</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end SpeedControlled_Nrpm;
