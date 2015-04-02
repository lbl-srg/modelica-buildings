within Buildings.Fluid.Movers.BaseClasses;
model FlowControlled
  "Partial model for fan or pump with ideally controlled mass flow rate or head as input signal"

  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
   preSou(final control_m_flow=control_m_flow));

  extends Buildings.Fluid.Movers.BaseClasses.PowerInterface(
   _perPow(hydraulicEfficiency=per.hydraulicEfficiency,
            motorEfficiency=per.motorEfficiency,
            power=per.power,
            motorCooledByFluid=per.motorCooledByFluid,
            use_powerCharacteristic = per.use_powerCharacteristic),
            delta_V_flow = 1E-3*V_flow_max,
     final rho_default = Medium.density(sta_default));

  import cha = Buildings.Fluid.Movers.BaseClasses.Characteristics;

  // what to control
  constant Boolean control_m_flow "= false to control head instead of m_flow"
    annotation(Evaluate=true);

  replaceable parameter Data.FlowControlled per "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,-80},{80,-60}})));

  Real r_V(start=1)
    "Ratio V_flow/V_flow_max = V_flow/V_flow(dp=0, N=N_nominal)";

protected
  final parameter Medium.AbsolutePressure p_a_default(displayUnit="Pa") = Medium.p_default
    "Nominal inlet pressure for predefined fan or pump characteristics";

 parameter Modelica.SIunits.VolumeFlowRate V_flow_max=m_flow_nominal/rho_default
    "Maximum volume flow rate";

  parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
     T=Medium.T_default,
     p=Medium.p_default,
     X=Medium.X_default[1:Medium.nXi]) "Default medium state";

  Modelica.Blocks.Sources.RealExpression PToMedium_flow(y=Q_flow + WFlo) if  addPowerToMedium
    "Heat and work input into medium"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

equation
  r_V = VMachine_flow/V_flow_max;
  etaHyd = cha.efficiency(per=per.hydraulicEfficiency, V_flow=VMachine_flow, d=hydDer, r_N=1, delta=1E-4);
  etaMot = cha.efficiency(per=per.motorEfficiency,     V_flow=VMachine_flow, d=motDer, r_N=1, delta=1E-4);
  dpMachine = -dp;
  VMachine_flow = port_a.m_flow/rho_in;
  // To compute the electrical power, we set a lower bound for eta to avoid
  // a division by zero.
  P = WFlo / Buildings.Utilities.Math.Functions.smoothMax(x1=eta, x2=1E-5, deltaX=1E-6);

  connect(PToMedium_flow.y, prePow.Q_flow) annotation (Line(
      points={{-79,20},{-70,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="fan",
    Documentation(info="<html>
<p>
This model describes a fan or pump that takes as an input
the head or the mass flow rate.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
April 19, 2014, by Filip Jorissen:<br/>
Set default values for new parameters in <code>efficiency()</code>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
September 13, 2013 by Michael Wetter:<br/>
Corrected computation of <code>sta_default</code> to use medium default
values instead of medium start values.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
October 11, 2012, by Michael Wetter:<br/>
Added implementation of <code>WFlo = eta * P</code> with
guard against division by zero.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
November 11, 2010, by Michael Wetter:<br/>
Changed <code>V_flow_max=m_flow_nominal/rho_nominal;</code> to <code>V_flow_max=m_flow_max/rho_nominal;</code>
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>
March 24, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowControlled;
