within Buildings.AirCleaning.BaseClasses;
model InDuctGUVCalc "Inactivation calculation for Duct GUV"
  extends Buildings.AirCleaning.BaseClasses.PartialInDuctGUVCalc(final
      m_flow_turbulent=if computeFlowResistance then deltaM*
        m_flow_nominal_pos else 0);

  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
                  Dialog(group = "Transition to laminar",
                         enable = not linearized));
  final parameter Real k = if computeFlowResistance then
        m_flow_nominal_pos / sqrt(dp_nominal_pos) else 0
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
protected
  final parameter Boolean computeFlowResistance=(dp_nominal_pos > Modelica.Constants.eps)
    "Flag to enable/disable computation of flow resistance"
   annotation(Evaluate=true);
  final parameter Real coeff=
    if linearized and computeFlowResistance
    then if from_dp then k^2/m_flow_nominal_pos else m_flow_nominal_pos/k^2
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
      if from_dp then
        m_flow = dp*coeff;
      else
        dp = m_flow*coeff;
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
    dp = 0;
  end if;  // computeFlowResistance

  annotation (defaultComponentName="res",
Documentation(info="<html>
<p>Duct GUV calculation.</p>
<p><b>Assumptions</b> </p>
<h4>Important parameters</h4>
<h4>Notes</h4>
<h4>Implementation</h4>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024 by Cary Faulkner:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-74,80},{72,62}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,56},{-60,-28}}, color={28,108,200}),
        Line(points={{-40,56},{-40,-28}}, color={28,108,200}),
        Line(points={{0,56},{0,-28}}, color={28,108,200}),
        Line(points={{60,56},{60,-28}}, color={28,108,200}),
        Line(points={{40,56},{40,-28}}, color={28,108,200}),
        Line(points={{20,56},{20,-28}}, color={28,108,200}),
        Line(points={{-20,56},{-20,-28}}, color={28,108,200})}));
end InDuctGUVCalc;
