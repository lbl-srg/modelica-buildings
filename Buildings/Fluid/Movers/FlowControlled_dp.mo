within Buildings.Fluid.Movers;
model FlowControlled_dp
  "Fan or pump with ideally controlled head dp as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.FlowControlled(
  final control_m_flow = false,
  preSou(dp_start=dp_start));

  // Classes used to implement the filtered speed
  parameter Boolean filteredSpeed=true
    "= true, if speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));
  parameter Modelica.SIunits.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
  parameter Modelica.SIunits.Pressure dp_start(min=0, displayUnit="Pa")=0
    "Initial value of pressure raise"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));
  parameter Modelica.SIunits.Pressure dp_nominal(min=0, displayUnit="Pa")=10000
    "Nominal pressure raise, used to normalize filter"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
  Modelica.Blocks.Interfaces.RealInput dp_in(min=0, final unit="Pa")
    "Prescribed pressure rise"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,120})));

  Modelica.Blocks.Interfaces.RealOutput dp_actual(min=0, final unit="Pa")
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

protected
  Modelica.Blocks.Math.Gain gain(final k=-1)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Continuous.Filter filter(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     final init=init,
     final y_start=dp_start,
     u_nominal=abs(dp_nominal),
     x(each stateSelect=StateSelect.always),
     u(final unit="Pa"),
     y(final unit="Pa"),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass) if filteredSpeed
    "Second order filter to approximate transient of rotor, and to improve numerics"
    annotation (Placement(transformation(extent={{20,81},{34,95}})));

  Modelica.Blocks.Interfaces.RealOutput dp_filtered(min=0, final unit="Pa") if
     filteredSpeed "Filtered pressure"
    annotation (Placement(transformation(extent={{40,78},{60,98}}),
        iconTransformation(extent={{60,50},{80,70}})));
equation
  assert(dp_in >= -1E-3,
    "dp_in cannot be negative. Obtained dp_in = " + String(dp_in));

  if filteredSpeed then
    connect(dp_in, filter.u) annotation (Line(
      points={{0,120},{10,120},{10,88},{18.6,88}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, dp_actual) annotation (Line(
      points={{34.7,88},{38,88},{38,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, dp_filtered) annotation (Line(
      points={{34.7,88},{50,88}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(dp_in, dp_actual) annotation (Line(
      points={{0,120},{18,120},{18,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  connect(gain.y, preSou.dp_in) annotation (Line(
      points={{21,30},{36,30},{36,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, dp_actual) annotation (Line(
      points={{-2,30},{-10,30},{-10,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="fan",
  Documentation(info="<html>
<p>
This model describes a fan or pump with prescribed head.
The input connector provides the difference between
outlet minus inlet pressure.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate.
</p>
<p>
If <code>filteredSpeed=true</code>, then the parameter <code>dp_nominal</code> is
used to normalize the filter. This is used to improve the numerics of the transient response.
The actual pressure raise of the mover at steady-state is independent
of the value of <code>dp_nominal</code>. It is recommended to set
<code>dp_nominal</code> to approximately the pressure raise that the fan has during
full speed.
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
May 1, 2015, by Michael Wetter:<br/>
Changed sign of <code>dp_actual</code>. This addresses
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/226\">
issue 226</a>.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
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
<li>July 5, 2010, by Michael Wetter:<br/>
Changed <code>assert(dp_in >= 0, ...)</code> to <code>assert(dp_in >= -0.1, ...)</code>.
The former implementation triggered the assert if <code>dp_in</code> was solved for
in a nonlinear equation since the solution can be slightly negative while still being
within the solver tolerance.
</li>
<li>March 24, 2010, by Michael Wetter:<br/>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009,
    by Michael Wetter:<br/>
       Added model to the Buildings library.
</ul>
</html>"),
    Icon(graphics={Text(extent={{20,142},{104,108}},textString="dp_in"),
        Line(
          points={{32,50},{100,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(extent={{64,68},{114,54}},
          lineColor={0,0,127},
          textString="dp")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end FlowControlled_dp;
