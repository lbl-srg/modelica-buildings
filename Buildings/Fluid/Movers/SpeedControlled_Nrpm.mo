within Buildings.Fluid.Movers;
model SpeedControlled_Nrpm
  "Fan or pump with ideally controlled speed Nrpm as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    final preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    final nominalValuesDefineDefaultPressureCurve=false,
    final computePowerUsingSimilarityLaws=true,
    final m_flow_nominal = max(per.pressure.V_flow)*rho_default,
    final stageInputs(each final unit="1") = per.speeds,
    final constInput(final unit="1") =       per.constantSpeed,
    filter(
      final y_start=y_start,
      u_nominal=1,
      u(final unit="1"),
      y(final unit="1")),
    eff(
      per(final pressure = per.pressure,
          final use_powerCharacteristic = per.use_powerCharacteristic)),
    gaiSpe(u(final unit="1/min"),
           final k=1/per.speed_rpm_nominal));

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
  Modelica.Blocks.Math.Gain gain(final k=-1) "Pressure gain"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={10,-20})));
initial equation
  assert(per.havePressureCurve,
   "SpeedControlled_Nrpm model requires to set the pressure vs. flow rate curve in record 'per'.");

equation
  connect(Nrpm, gaiSpe.u)
    annotation (Line(points={{0,120},{0,80},{-2.8,80}}, color={0,0,127}));
  connect(gaiSpe.y, inputSwitch.u) annotation (Line(points={{-16.6,80},{-26,80},
          {-26,50},{-22,50}}, color={0,0,127}));
  connect(eff.dp, gain.u) annotation (Line(points={{-11,-50},{2,-50},{10,-50},{10,
          -32}}, color={0,0,127}));
  connect(gain.y, preSou.dp_in)
    annotation (Line(points={{10,-9},{10,14},{56,14},{56,8},{56,8}},
                                                     color={0,0,127}));
  if use_inputFilter then
    connect(filter.y, eff.y_in) annotation (Line(points={{34.7,88},{38,88},{38,26},
            {-26,26},{-26,-46}},      color={0,0,127}));
  else
    connect(inputSwitch.y, eff.y_in) annotation (Line(points={{1,50},{38,50},{38,
            26},{-26,26},{-26,-46}},
                                   color={0,0,127}));
  end if;
  annotation (defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),
      graphics={
        Text(
          extent={{-40,126},{-160,76}},
          lineColor={0,0,127},
          visible=inputType == Buildings.Fluid.Types.InputType.Continuous or inputType == Buildings.Fluid.Types.InputType.Stages,
          textString=DynamicSelect("Nrpm", if inputType == Buildings.Fluid.Types.InputType.Continuous then String(Nrpm, format=".0f") else String(stage)))}),
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
February 21, 2020, by Michael Wetter:<br/>
Changed icon to display its operating stage.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredSpeed</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
March 2, 2016, by Filip Jorissen:<br/>
Refactored model such that it directly extends <code>PartialFlowMachine</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
<li>
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>
January 19, 2016, by Filip Jorissen:<br/>
Set default value of parameter: <code>speeds=per.speeds</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
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
</html>"));
end SpeedControlled_Nrpm;
