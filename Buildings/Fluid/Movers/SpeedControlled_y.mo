within Buildings.Fluid.Movers;
model SpeedControlled_y
  "Fan or pump with ideally controlled normalized speed y as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.SpeedControlled(
    _per_y(final hydraulicEfficiency=per.hydraulicEfficiency,
           final motorEfficiency=per.motorEfficiency,
           final power=per.power,
           pressure(
             final V_flow = per.pressure.V_flow,
             final dp =     per.pressure.dp),
           final motorCooledByFluid=per.motorCooledByFluid,
           final use_powerCharacteristic=per.use_powerCharacteristic),
    final stageInputs(each final unit="1") = normalized_speeds,
    final constInput(final unit="1")=normalized_speed);

  parameter Real normalized_speed(final unit="1") = 0
    "Normalized speed set point when using constant set point"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Constant));
  parameter Real[:] normalized_speeds(each final unit="1") = {0}
    "Vector of normalized speed set points when using stages"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Stages));
  replaceable parameter Data.SpeedControlled_y per
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,-80},{80,-60}})));

  Modelica.Blocks.Interfaces.RealInput y(
    min=0,
    unit="1") if
    inputType == Buildings.Fluid.Types.InputType.Continuous
    "Constant normalized rotational speed"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,120})));

equation
  connect(filter.y, y_filtered) annotation (Line(
      points={{34.7,88},{50,88}},
      color={0,0,127},
      smooth=Smooth.None));

  if filteredSpeed then
    connect(inputSwitch.y, filter.u) annotation (Line(
      points={{1,50},{1,88},{18.6,88}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, y_actual) annotation (Line(
      points={{34.7,88},{38,88},{38,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(inputSwitch.y, y_actual) annotation (Line(
      points={{1,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  connect(inputSwitch.u, y) annotation (Line(
      points={{-22,50},{-22,80},{0,80},{0,120}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="fan",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),
            graphics={
            Text(
              visible = inputType == Buildings.Fluid.Types.InputType.Continuous,
              extent={{10,124},{102,102}},
              textString="y [0, 1]"),
            Text(
          visible=inputType == Buildings.Fluid.Types.InputType.Constant,
          extent={{-80,136},{78,102}},
          lineColor={0,0,255},
          textString="%normalized_speed")}),
    Documentation(info="<html>
<p>
This model describes a fan or pump with prescribed normalized speed.
The input connector provides the normalized rotational speed (between 0 and 1).
The head is computed based on the performance curve that take as an argument
the actual volume flow rate divided by the maximum flow rate and the relative
speed of the fan.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate, or
based on the motor performance curves.
</p>
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
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
November 22, 2014, by Michael Wetter:<br/>
Revised implementation that uses the new performance data as a record.
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
<li>
October 1, 2009, by Michael Wetter:<br/>
Model added to the Buildings library. Changed control signal from rpm to normalized value between 0 and 1</li>
<li>
October 31, 2005 by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br/>
Model added to the Fluid library
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end SpeedControlled_y;
