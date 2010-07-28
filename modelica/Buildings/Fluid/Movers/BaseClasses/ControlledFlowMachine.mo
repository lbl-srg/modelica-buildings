within Buildings.Fluid.Movers.BaseClasses;
model ControlledFlowMachine
  "Partial model for fan or pump with ideally controlled mass flow rate or head as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
   final show_V_flow = true,
   souSta(final control_m_flow=control_m_flow),
   souDyn(final control_m_flow=control_m_flow));

  extends Buildings.Fluid.Movers.BaseClasses.PowerInterface(
     final use_powerCharacteristic = false,
     final rho_nominal = Medium.density(sta_nominal));

  parameter Medium.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used as flow rate if control_m_flow";
  parameter Modelica.SIunits.MassFlowRate m_flow_max = m_flow_nominal
    "Maximum mass flow rate (at zero head)";
  // what to control
  constant Boolean control_m_flow "= false to control head instead of m_flow"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput m_flow_in if control_m_flow
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-50,82})));
  Modelica.Blocks.Interfaces.RealInput dp_in if not control_m_flow
    "Prescribed outlet pressure"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,82})));

protected
  final parameter Medium.AbsolutePressure p_a_nominal(displayUnit="Pa") = Medium.p_default
    "Nominal inlet pressure for predefined fan or pump characteristics";
  parameter Medium.ThermodynamicState sta_nominal = Medium.setState_pTX(T=T_start,
     p=p_a_nominal, X=X_start[1:Medium.nXi]);

public
  Modelica.Blocks.Sources.RealExpression PToMedium_flow(y=Q_flow + dpMachine*
        V_in_flow) "Heat and work input into medium"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
protected
  Modelica.Blocks.Math.Gain gain(final k=-1) if not control_m_flow
    annotation (Placement(transformation(extent={{20,50},{0,70}})));
initial equation
  V_flow_max=m_flow_nominal/rho_nominal;
equation
  etaHyd = hydraulicEfficiency(r_V=r_V);
  etaMot = motorEfficiency(r_V=r_V);
  dpMachine = -dp;
  VMachine_flow = V_flow;

  connect(m_flow_in, souDyn.m_flow_in) annotation (Line(
      points={{-50,82},{-50,40},{4,40},{4,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_in, souSta.m_flow_in) annotation (Line(
      points={{-50,82},{-50,40},{54,40},{54,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, dp_in) annotation (Line(
      points={{22,60},{50,60},{50,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, souDyn.dp_in) annotation (Line(
      points={{-1,60},{-10,60},{-10,44},{16,44},{16,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, souSta.dp_in) annotation (Line(
      points={{-1,60},{-10,60},{-10,44},{66,44},{66,-52}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(PToMedium_flow.y, prePow.Q_flow) annotation (Line(
      points={{-79,30},{-74,30},{-74,10},{-68,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PToMedium_flow.y, souSta.P_in) annotation (Line(
      points={{-79,30},{60,30},{60,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="fan",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<HTML>
<p>
This model describes a fan or pump that takes as an input
the head or the mass flow rate.
</p>
</HTML>",
      revisions="<html>
<ul>
<li>
July 27, 2010, by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>
March 24, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ControlledFlowMachine;
