within Buildings.Fluid.Movers;
model FlowControlled_dp
  "Fan or pump with ideally controlled head dp as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.ControlledFlowMachine(
  final control_m_flow = false,
  preSou(dp_start=dp_start));

  parameter Boolean useOnIn = false
    "Set to true to switch device on/off using external signal";

  parameter Boolean onOff=true "Set to true if device is on"
  annotation (Dialog(enable= not useOnIn), evaluate = true);

  parameter Boolean useDpIn = true
    "Set to false for setting a constant pressure head using parameter dpSet";
  parameter Modelica.SIunits.Pressure dpSet(min=0)=100000
    "Pressure heat set point when useDpInput is false"
    annotation(Dialog(enable=not useDpIn));
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
  Modelica.Blocks.Interfaces.RealInput dp_in(min=0, final unit="Pa") if useDpIn
    "Prescribed pressure rise"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,120})));
  Modelica.Blocks.Interfaces.BooleanInput on_in if useOnIn
    "Prescribed on/off status"                             annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-20,120})));
  Modelica.Blocks.Interfaces.RealOutput dp_actual(min=0, final unit="Pa")
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

protected
  Modelica.Blocks.Math.Gain gain(final k=-1)
    annotation (Placement(transformation(extent={{72,40},{92,60}})));
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
public
  Modelica.Blocks.Math.Product dpSetProd
    "Set point taking into account mover on/off status" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,50})));
  Modelica.Blocks.Math.BooleanToReal onToReal(realTrue=-1)
    "Conversion to real for on/off signal"
    annotation (Placement(transformation(extent={{-56,36},{-40,52}})));

  Modelica.Blocks.Sources.Constant dpConst(k=dpSet) if
                                              not useDpIn
    "Constant set point for dp when not using input"
    annotation (Placement(transformation(extent={{-40,60},{-26,74}})));
  Modelica.Blocks.Sources.BooleanConstant onConst(k=onOff) if not useOnIn
    "Constant on/off value when not using input"
    annotation (Placement(transformation(extent={{-80,36},{-64,52}})));
equation
  assert(dp_actual >= -Modelica.Constants.eps,
    "dp_in cannot be negative. Obtained dp_in = " + String(dp_actual));

  if filteredSpeed then
    connect(dpSetProd.y, filter.u) annotation (Line(
        points={{1,50},{10,50},{10,88},{18.6,88}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(filter.y, gain.u) annotation (Line(
      points={{34.7,88},{38,88},{38,50},{70,50}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, dp_filtered) annotation (Line(
      points={{34.7,88},{50,88}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  else
    connect(dpSetProd.y, gain.u) annotation (Line(
        points={{1,50},{70,50}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  connect(dp_actual, gain.y) annotation (Line(
      points={{110,50},{93,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, preSou.dp_in) annotation (Line(
      points={{70,50},{60,50},{60,40},{36,40},{36,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dpSetProd.u1, dp_in) annotation (Line(
      points={{-22,56},{-22,68},{0,68},{0,120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onToReal.y, dpSetProd.u2) annotation (Line(
      points={{-39.2,44},{-22,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dpConst.y, dpSetProd.u1) annotation (Line(
      points={{-25.3,67},{-22,67},{-22,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on_in, onToReal.u) annotation (Line(
      points={{-20,120},{-20,96},{-57.6,96},{-57.6,44}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onConst.y, onToReal.u) annotation (Line(
      points={{-63.2,44},{-57.6,44}},
      color={255,0,255},
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
            100}}),
            graphics));
end FlowControlled_dp;
