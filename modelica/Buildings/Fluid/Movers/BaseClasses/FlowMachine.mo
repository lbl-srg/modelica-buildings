within Buildings.Fluid.Movers.BaseClasses;
model FlowMachine
  "Fan or pump with ideally controlled mass flow rate or pressure difference"
  import Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm;
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    N_nominal=1500,
    N(start=N_nominal),
    redeclare replaceable function flowCharacteristic = 
        Characteristics.quadraticFlow (V_flow_nominal={0,V_flow_op,1.5*
            V_flow_op}, dp_nominal={2*dp_op,dp_op,0}));

  // nominal values
  parameter Medium.AbsolutePressure p_a_nominal(displayUnit="Pa") = system.p_start
    "Nominal inlet pressure for predefined fan or pump characteristics";
  parameter Medium.AbsolutePressure dp_set_nominal(displayUnit="Pa") = 1000
    "Nominal total pressure difference, fixed if not control_m_flow and not use_dp_set";
  parameter Medium.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, fixed if control_m_flow and not use_m_flow_set";

  // what to control
  parameter Boolean control_m_flow = true
    "= false to control outlet pressure port_b.p instead of m_flow" 
    annotation(Evaluate = true);
  parameter Boolean use_m_flow_set = false
    "= true to use input signal m_flow_set instead of m_flow_nominal" 
    annotation (Dialog(enable = control_m_flow));
  parameter Boolean use_dp_set = false
    "= true to use input signal dp_set instead of dp_set_nominal" 
    annotation (Dialog(enable = not control_m_flow));

  // exemplary characteristics
  final parameter Modelica.SIunits.VolumeFlowRate V_flow_op=m_flow_nominal/
      rho_nominal "operational volume flow rate according to nominal values";
  final parameter Modelica.SIunits.AbsolutePressure dp_op=dp_set_nominal
    "operational fan or pump total pressure according to nominal values";

  Modelica.Blocks.Interfaces.RealInput m_flow_set if use_m_flow_set
    "Prescribed mass flow rate" 
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-50,82})));
  Modelica.Blocks.Interfaces.RealInput dp_set if use_dp_set
    "Prescribed outlet pressure" 
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,82})));

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_set_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput dp_set_internal
    "Needed to connect to conditional connector";
equation
  // Ideal control
  if control_m_flow then
    m_flow = m_flow_set_internal;
  else
    dp = dp_set_internal;
  end if;

  // Internal connector value when use_m_flow_set = false
  if not use_m_flow_set then
    m_flow_set_internal = m_flow_nominal;
  end if;
  if not use_dp_set then
    dp_set_internal = dp_set_nominal;
  end if;
  connect(m_flow_set, m_flow_set_internal);
  connect(dp_set, dp_set_internal);
  assert(dp_set_internal >= 0, "dp_set cannot be negative. Obtained dp_set = " + realString(dp_set_internal));

  annotation (defaultComponentName="fan",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(
          visible=use_dp_set,
          extent={{82,108},{176,92}},
          textString="dp_set"), Text(
          visible=use_m_flow_set,
          extent={{-20,108},{170,92}},
          textString="m_flow_set")}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<HTML>
<p>
This model describes a fan or pump (or a group of <tt>nParallel</tt> fans/pumps)
with ideally controlled mass flow rate or pressure.
</p>
<p>
Nominal values are used to predefine an exemplary fan or pump characteristics and to define the operation of the fan/pump.
The input connectors <tt>m_flow_set</tt> or <tt>dp_set</tt> can optionally be enabled to provide time varying set points.
</p>
<p>
Use this model if the fan or pump characteristics is of secondary interest.
The actual characteristics can be configured later on for the appropriate rotational speed N.
Then the model can be replaced with 
<a href=\"Buildings.Fluid.Movers.FlowMachine_y\">
Buildings.Fluid.Movers.FlowMachine_y</a> or
<a href=\"Buildings.Fluid.Movers.FlowMachine_N_rpm\">
Buildings.Fluid.Movers.FlowMachine_N_rpm</a> or
</p>
</HTML>",
      revisions="<html>
<ul>
<li><i>October 1 2009</i>
    by Michael Wetter</a>:<br>
       Changed model to use total pressure in Pascals instead of head in meters H2O.</li>
<li><i>15 Dec 2008</i>
    by Ruediger Franke</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));
end FlowMachine;
