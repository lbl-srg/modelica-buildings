within Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks.BaseClasses;
model PipeAutosize "Pipe model parameterized with pressure drop per pipe length"
  extends Buildings.Fluid.FixedResistances.PressureDrop(
    final deltaM =  eta_default*dh/4*Modelica.Constants.pi*ReC/m_flow_nominal_pos,
    final dp_nominal=dp_length_nominal*length);

  parameter Modelica.SIunits.Length dh
    "Hydraulic diameter (assuming a round cross section area)";

  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";

  parameter Modelica.SIunits.Length length "Length of the pipe";

  parameter Real ReC(min=0)=4000
    "Reynolds number where transition to turbulent starts";

  parameter Modelica.SIunits.Velocity v_nominal=m_flow_nominal / (rho_default * ARound)
    "Velocity at m_flow_nominal (used to compute default value for hydraulic diameter dh)"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe (PE100: 7E-6)";

  parameter Real fac(min=1) = 2
    "Factor to take into account resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal";

  final parameter Modelica.SIunits.PressureDifference dpStraightPipe_nominal(displayUnit="Pa")=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=dh,
      roughness=roughness,
      m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";

  Modelica.SIunits.Velocity v = m_flow/(rho_default*ARound)
    "Flow velocity (assuming a round cross section area)";

protected
  parameter Modelica.SIunits.Area ARound = dh^2*Modelica.Constants.pi/4
     "Cross sectional area (assuming a round cross section area)";

  parameter Medium.ThermodynamicState state_default=
    Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";

  parameter Modelica.SIunits.Density rho_default = Medium.density(state_default)
    "Density at nominal condition";

  parameter Modelica.SIunits.DynamicViscosity mu_default = Medium.dynamicViscosity(
      state_default)
    "Dynamic viscosity at nominal condition";
initial equation
  dp_nominal = fac*dpStraightPipe_nominal;
equation
  when terminal() then
    if length > Modelica.Constants.eps then
      Modelica.Utilities.Streams.print(
       "Pipe nominal pressure drop for '" + getInstanceName() + "': " +
        String(integer(floor(dp_nominal / length + 0.5))) +
        " Pa/m, pipe diameter: " + String(integer(floor(dh * 100))/100) + " m.");
    else
      Modelica.Utilities.Streams.print(
        "Pipe nominal pressure drop for '" + getInstanceName() +
         "' as the pipe length is set to zero.");
    end if;
  end when;
annotation (
    DefaultComponentName="pipCon",
    Icon(graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,140,72})}),
    Documentation(info="<html>
<p>
This model is similar to
<a href=\"Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a>
except for the modifications below which allow to use this model for computing the 
hydraulic diameter at initialization, based on the pressure drop per pipe length 
at nominal flow rate, and in a configuration where the model is not
instantiated directly but rather used in a redeclare statement within
a top-level component (such as 
<a href=\"Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks.UnidirectionalSeries\">
Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks.UnidirectionalSeries</a>).
</p>
<ul>
<li>
The parameter <code>v_nominal</code> is computed based on the nominal flow rate.
</li>
<li>
An initial equation is used to compute the hydraulic diameter <code>dh</code>.
However, <code>dh</code> is not declared with <code>fixed=false</code> 
because this class is intended to be used in redeclare statements
that would not allow a parameter without a default value or a binding.
The attribute <code>fixed=false</code> is only introduced at the top level.
</li>
<li>
The parameter <code>dp_nominal</code> is assigned a value that does not need
to be computed at initialization.
This is required per Modelica specification because 
the structural parameter <code>computeFlowResistance</code>
depends on <code>dp_nominal</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PipeAutosize;
