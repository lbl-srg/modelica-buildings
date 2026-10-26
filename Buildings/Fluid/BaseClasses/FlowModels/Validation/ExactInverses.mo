within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model ExactInverses
  "Model that checks that the inverse functions are exact inverses of the flow functions"
  extends Modelica.Icons.Example;

  parameter Real k = 0.5 "Flow coefficient";
  parameter Real n[4](each min=1, each max=2) = {1, 1.25, 1.5, 2}
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent=0.3
    "Mass flow rate where transition to turbulent flow occurs";
  parameter Real tol = 1E-10
    "Tolerance for the relative error of forward function after inverse function";

  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";
  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.MassFlowRate m_flowBas
    "Mass flow rate computed by basicFlowFunction_m_flow_inv for dp";
  Modelica.Units.SI.PressureDifference dpBas(displayUnit="Pa")
    "Pressure difference computed by basicFlowFunction_dp_inv for m_flow";
  Modelica.Units.SI.MassFlowRate m_flowPow[4]
    "Mass flow rate computed by powerLaw_m_flow_inv for dp";
  Modelica.Units.SI.PressureDifference dpPow[4](each displayUnit="Pa")
    "Pressure difference computed by powerLaw_dp_inv for m_flow";
  Real errBas[2](each unit="1")
    "Relative errors of basicFlowFunction_m_flow and basicFlowFunction_dp after their inverses";
  Real errPow[4,2](each unit="1")
    "Relative errors of powerLaw_m_flow and powerLaw_dp after their inverses";

protected
  parameter Modelica.Units.SI.PressureDifference dp_turbulent[4](
    each displayUnit="Pa", each fixed=false)
    "Pressure difference where turbulent flow occurs";
  parameter Real m[4](each fixed=false) "Flow exponent for the pressure drop";
  parameter Real a1[4](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a3[4](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a5[4](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real C[4](each fixed=false)
    "Coefficient 1/k^n, based on the definition k = m_flow / dp^(1/n)";
  parameter Real b1[4](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b3[4](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b5[4](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";

initial equation
  for i in 1:4 loop
    (dp_turbulent[i], m[i], a1[i], a3[i], a5[i], C[i], b1[i], b3[i], b5[i]) =
      Buildings.Fluid.BaseClasses.FlowModels.powerLawData(
        k=k, n=n[i], m_flow_turbulent=m_flow_turbulent);
  end for;
equation
  // Raise to third power so that the inputs stay longer in the laminar region
  dp = 4*(2*time-1)^3;
  m_flow = 1*(2*time-1)^3;

  m_flowBas = FlowModels.basicFlowFunction_m_flow_inv(
    dp=dp, k=k, m_flow_turbulent=m_flow_turbulent);
  dpBas = FlowModels.basicFlowFunction_dp_inv(
    m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent);
  errBas[1] = (FlowModels.basicFlowFunction_m_flow(
    m_flow=m_flowBas, k=k, m_flow_turbulent=m_flow_turbulent) - dp)
    /max(abs(dp), Modelica.Constants.small);
  errBas[2] = (FlowModels.basicFlowFunction_dp(
    dp=dpBas, k=k, m_flow_turbulent=m_flow_turbulent) - m_flow)
    /max(abs(m_flow), Modelica.Constants.small);

  for i in 1:4 loop
    m_flowPow[i] = FlowModels.powerLaw_m_flow_inv(
      dp=dp, k=k, n=n[i], m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent[i], m=m[i], a1=a1[i], a3=a3[i], a5=a5[i],
      C=C[i], b1=b1[i], b3=b3[i], b5=b5[i]);
    dpPow[i] = FlowModels.powerLaw_dp_inv(
      m_flow=m_flow, k=k, n=n[i], m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent[i], m=m[i], a1=a1[i], a3=a3[i], a5=a5[i],
      C=C[i], b1=b1[i], b3=b3[i], b5=b5[i]);
    errPow[i,1] = (FlowModels.powerLaw_m_flow(
      m_flow=m_flowPow[i], k=k, n=n[i], m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent[i], m=m[i], a1=a1[i], a3=a3[i], a5=a5[i],
      C=C[i], b1=b1[i], b3=b3[i], b5=b5[i]) - dp)
      /max(abs(dp), Modelica.Constants.small);
    errPow[i,2] = (FlowModels.powerLaw_dp(
      dp=dpPow[i], k=k, n=n[i], m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent[i], m=m[i], a1=a1[i], a3=a3[i], a5=a5[i],
      C=C[i], b1=b1[i], b3=b3[i], b5=b5[i]) - m_flow)
      /max(abs(m_flow), Modelica.Constants.small);
  end for;

  for j in 1:2 loop
    assert(abs(errBas[j]) < tol, "Inverse of basic flow function is not exact.");
    for i in 1:4 loop
      assert(abs(errPow[i,j]) < tol, "Inverse of power law is not exact.");
    end for;
  end for;
  assert(abs(m_flowPow[4] - m_flowBas) < tol, "Expected m_flowPow[4] == m_flowBas for n=2.");
  assert(abs(dpPow[4] - dpBas) < tol, "Expected dpPow[4] == dpBas for n=2.");
annotation (
experiment(Tolerance=1e-06, StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/ExactInverses.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model checks that the functions
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv</a>,
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv</a>,
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv</a> and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv</a>
are the inverses of the respective flow functions.
The pressure difference and the mass flow rate sweep through the laminar
and the turbulent region.
Applying a flow function to the result of its inverse function needs to give
the input back up to rounding errors.
If the relative error exceeds <code>tol</code>,
the simulation stops with an error.
The power law functions are checked for the flow exponents
<i>n=1</i>, <i>1.25</i>, <i>1.5</i> and <i>2</i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 22, 2026, by Martin Sj&ouml;lund:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4798\">Buildings, #4798</a>.
</li>
</ul>
</html>"));
end ExactInverses;
