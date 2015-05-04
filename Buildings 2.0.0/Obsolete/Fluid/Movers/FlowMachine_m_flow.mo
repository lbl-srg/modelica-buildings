within Buildings.Obsolete.Fluid.Movers;
model FlowMachine_m_flow
  "Fan or pump with ideally controlled mass flow rate as input signal"
  extends Buildings.Obsolete.Fluid.Movers.BaseClasses.ControlledFlowMachine(
  final control_m_flow=true, preSou(m_flow_start=m_flow_start));
  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s",
                                                 nominal=m_flow_nominal)
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,120})));

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
  parameter Modelica.SIunits.MassFlowRate m_flow_start(min=0)=0
    "Initial value of mass flow rate"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));

  Modelica.Blocks.Interfaces.RealOutput m_flow_actual(final unit="kg/s",
                                                       nominal=m_flow_nominal)
    "Actual mass flow rate"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

protected
  Modelica.Blocks.Continuous.Filter filter(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     final init=init,
     final y_start=m_flow_start,
     u_nominal=m_flow_nominal,
     x(each stateSelect=StateSelect.always),
     u(final unit="kg/s"),
     y(final unit="kg/s"),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
        filteredSpeed
    "Second order filter to approximate transient of rotor, and to improve numerics"
    annotation (Placement(transformation(extent={{20,81},{34,95}})));

  Modelica.Blocks.Interfaces.RealOutput m_flow_filtered(final unit="kg/s") if
     filteredSpeed "Filtered mass flow rate"
    annotation (Placement(transformation(extent={{40,78},{60,98}}),
        iconTransformation(extent={{60,50},{80,70}})));

equation
  if filteredSpeed then
    connect(m_flow_in, filter.u) annotation (Line(
      points={{1.11022e-15,120},{0,120},{0,88},{18.6,88}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, m_flow_actual) annotation (Line(
      points={{34.7,88},{38,88},{38,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(m_flow_in, m_flow_actual) annotation (Line(
      points={{1.11022e-15,120},{0,120},{0,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;
    connect(filter.y, m_flow_filtered) annotation (Line(
      points={{34.7,88},{50,88}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(m_flow_actual, preSou.m_flow_in) annotation (Line(
      points={{110,50},{60,50},{60,40},{24,40},{24,8}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (defaultComponentName="fan",
  Documentation(
   info="<html>
<p>
This model describes a fan or pump with prescribed mass flow rate.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate.
</p>
<p>
See the
<a href=\"modelica://Buildings.Obsolete.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>",
      revisions="<html>
<ul>
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
<li>October 1, 2009
    by Michael Wetter:<br/>
       Model added to the Buildings library.
</ul>
</html>"),
    Icon(graphics={Text(extent={{22,146},{114,102}},textString="m_flow_in"),
        Line(
          points={{32,50},{100,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(extent={{50,68},{100,54}},
          lineColor={0,0,127},
          textString="m_flow")}));
end FlowMachine_m_flow;
