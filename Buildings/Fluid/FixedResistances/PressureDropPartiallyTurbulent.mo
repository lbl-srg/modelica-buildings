within Buildings.Fluid.FixedResistances;
model PressureDropPartiallyTurbulent
  "Flow resistance allowing flow exponent for not fully turbulent flow"
  extends Buildings.Fluid.BaseClasses.PartialResistance(
    final m_flow_turbulent = if computeFlowResistance then deltaM * m_flow_nominal_pos else 0,
    final from_dp = true "Set to final as this model only allows m_flow computed fromd dp");
  extends Buildings.Fluid.FixedResistances.BaseClasses.PowerLawResistanceParameters(
    n=2);

  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
                  Dialog(group = "Transition to laminar",
                         enable = not linearized));

  final parameter Real k = if computeFlowResistance then
    m_flow_nominal/(dp_nominal^(1/n)) else 0 "Flow coefficient, k = m_flow/ dp^m";

protected
  final parameter Boolean computeFlowResistance = (dp_nominal_pos > Modelica.Constants.eps)
    "Flag to enable/disable computation of flow resistance"
   annotation(Evaluate=true);
  final parameter Modelica.Units.SI.Pressure dp_turbulent(final min=0) =
    if computeFlowResistance then (m_flow_turbulent/k)^n else 0
    "Pressure drop where transition to laminar flow occurs";
  final parameter Real coeff=
    if linearized and computeFlowResistance
    then k^n/m_flow_nominal_pos
    else 0
    "Precomputed coefficient to avoid division by parameter";
initial equation
 if computeFlowResistance then
   assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
 end if;

 assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
equation
  // Pressure drop calculation
  if computeFlowResistance then
    if linearized then
      m_flow = dp*coeff;
    else
      if homotopyInitialization then
          m_flow=homotopy(
            actual=Buildings.Fluid.FixedResistances.BaseClasses.powerLawFixedM(
              k=k,
              dp=dp,
              m=m,
              a=a,
              b=b,
              c=c,
              d=d,
              dp_turbulent=dp_turbulent),
            simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
      else // do not use homotopy
        m_flow=Buildings.Fluid.FixedResistances.BaseClasses.powerLawFixedM(
              k=k,
              dp=dp,
              m=m,
              a=a,
              b=b,
              c=c,
              d=d,
              dp_turbulent=dp_turbulent);
      end if; // homotopyInitialization
    end if; // linearized
  else // do not compute flow resistance
    dp = 0;
  end if;  // computeFlowResistance

annotation (defaultComponentName="res",
Documentation(info="<html>
<p>
Model of a flow resistance with a varying flow coefficient.
</p>
<p>
This block is implemented based on
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>
and inherits most of its configuration.
However, its mass flow rate is calculated differently by using
</p>
<p align=\"center\" style=\"font-style:italic;\">
dp &frasl; dp_nominal = (m_flow  &frasl; m_flow_nominal)<sup>n</sup>,
</p>
<p>
where <i>n</i> is a parameter for the pressure drop exponent.
For turbulent flow, set <i>n=2</i> and for laminar flow, set <i>n=1</i>.
Values of <i>n</i> between <i>1</i> and <i>2</i> are typical for air filters or
microchannel heat exchangers.
</p>
</html>", revisions="<html>
<ul>
<li>
May 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-48,-46},{48,-90}},
          textColor={0,0,255},
          textString="%n=n")}));
end PressureDropPartiallyTurbulent;
