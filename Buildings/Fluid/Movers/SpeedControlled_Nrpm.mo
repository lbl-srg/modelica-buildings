within Buildings.Fluid.Movers;
model SpeedControlled_Nrpm
  "Fan or pump with ideally controlled speed Nrpm as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.SpeedControlled(
    _per_y(final hydraulicEfficiency=per.hydraulicEfficiency,
           final motorEfficiency=per.motorEfficiency,
           final power=per.power,
           final constantSpeed = per.constantSpeed,
           final speeds = per.speeds,
           pressure(
             final V_flow = per.pressure.V_flow,
             final dp =     per.pressure.dp),
           final motorCooledByFluid=per.motorCooledByFluid,
           final use_powerCharacteristic=per.use_powerCharacteristic),
    final stageInputs(each final unit="1") = per.speeds,
    final constInput(final unit="1") =       per.constantSpeed,
    gaiSpe(u(final unit="1/min"),
           final k=1/per.speed_rpm_nominal));

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

equation
  connect(Nrpm, gaiSpe.u)
    annotation (Line(points={{0,120},{0,80},{-2.8,80}}, color={0,0,127}));
  connect(gaiSpe.y, inputSwitch.u) annotation (Line(points={{-16.6,80},{-26,80},
          {-26,50},{-22,50}}, color={0,0,127}));
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
          textString="%speed"),
        Text(extent={{52,70},{102,56}},
          lineColor={0,0,127},
          textString="N_rpm")}),
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
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
</li>
<li>
January 19, 2016, by Filip Jorissen:<br/>
Set default value of parameter: <code>speeds=per.speeds</code>.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
</li>
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
            100}})));
end SpeedControlled_Nrpm;
