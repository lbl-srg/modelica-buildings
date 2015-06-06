within Buildings.Fluid.Movers;
model SpeedControlled_y
  "Fan or pump with ideally controlled normalized speed y as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.SpeedControlled(
    _per_y(hydraulicEfficiency=per.hydraulicEfficiency,
            motorEfficiency=per.motorEfficiency,
            power=per.power,
            pressure(
              V_flow = per.pressure.V_flow,
              dp =     per.pressure.dp),
            motorCooledByFluid=per.motorCooledByFluid,
            use_powerCharacteristic=per.use_powerCharacteristic));

  replaceable parameter Data.SpeedControlled_y per
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,-80},{80,-60}})));

  Modelica.Blocks.Interfaces.RealInput y(min=0, unit="1")
    "Constant normalized rotational speed"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));

  // We set the nominal value to 3000 as this is the
  // right order of magnitude. Using per.N_nominal
  // would yield to a translation warning
  // Non-literal value.
  // In nominal attribute for fan.filter.u.
equation
  connect(filter.y, y_filtered) annotation (Line(
      points={{34.7,88},{50,88}},
      color={0,0,127},
      smooth=Smooth.None));

  if filteredSpeed then
    connect(y, filter.u) annotation (Line(
      points={{0,120},{0,88},{18.6,88}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, y_actual) annotation (Line(
      points={{34.7,88},{38,88},{38,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(y, y_actual) annotation (Line(
      points={{0,120},{0,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  annotation (defaultComponentName="fan",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{10,124},{102,102}},textString=
              "y_in [0, 1]")}),
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
<li>October 1, 2009,
    by Michael Wetter:<br/>
       Model added to the Buildings library. Changed control signal from rpm to normalized value between 0 and 1</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br/>
       Model added to the Fluid library</li>
</ul>
</html>"));
end SpeedControlled_y;
