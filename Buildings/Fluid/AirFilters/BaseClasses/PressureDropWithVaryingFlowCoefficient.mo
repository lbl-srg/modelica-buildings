within Buildings.Fluid.AirFilters.BaseClasses;
model PressureDropWithVaryingFlowCoefficient
  "Flow resistance with a varying flow coefficient"
  extends Buildings.Fluid.BaseClasses.PartialResistance(
    final m_flow_turbulent = if computeFlowResistance then deltaM * m_flow_nominal_pos else 0);

  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation(Evaluate=true, Dialog(group = "Transition to laminar", enable = not linearized));
  Real k "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput kCor(
    final unit = "1",
    final min = 1)
    "Flow coefficient"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
      rotation=-90, origin={0,120})));

protected
  final parameter Boolean computeFlowResistance=(dp_nominal_pos > Modelica.Constants.eps)
    "Flag to enable/disable computation of flow resistance"
    annotation(Evaluate=true);

initial equation
  if computeFlowResistance then
    assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
  end if;

  assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
equation
  // Pressure drop calculation
  if computeFlowResistance then
    k = m_flow_nominal_pos / sqrt(dp_nominal_pos * kCor);
    if linearized then
      if from_dp then
        m_flow = dp*(k^2/ m_flow_nominal_pos);
      else
        dp = m_flow * (m_flow_nominal_pos /k^2);
      end if;
    else
      if homotopyInitialization then
        if from_dp then
          m_flow=homotopy(
            actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
              dp=dp,
              k=k,
              m_flow_turbulent=m_flow_turbulent),
            simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
        else
          dp=homotopy(
            actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
              m_flow=m_flow,
              k=k,
              m_flow_turbulent=m_flow_turbulent),
            simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
         end if;  // from_dp
      else // do not use homotopy
        if from_dp then
          m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
            dp=dp,
            k=k,
            m_flow_turbulent=m_flow_turbulent);
        else
          dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
            m_flow=m_flow,
            k=k,
            m_flow_turbulent=m_flow_turbulent);
        end if;  // from_dp
      end if; // homotopyInitialization
    end if; // linearized
  else // do not compute flow resistance
    k = 0;
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
However, its mass flow rate is calculated differently by
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775; = m_flow_nominal/(&radic;<span style=\"text-decoration:overline;\">dp_nominal*kCor</span>)
&radic;<span style=\"text-decoration:overline;\">&Delta;p</span>,
</p>
<p>
where <code>kCor</code> is a correction factor of the flow coefficient.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PressureDropWithVaryingFlowCoefficient;
