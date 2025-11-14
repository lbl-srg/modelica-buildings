within Buildings.Fluid.Movers.Validation;
model ComparePowerInput
  "Compare power estimation with different input signal"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Movers.Validation.BaseClasses.ComparePower(
    redeclare Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW15 per(
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      motorEfficiency(V_flow={0}, eta={0.7})),
    redeclare Buildings.Fluid.Movers.SpeedControlled_y mov1(
      redeclare final package Medium = Medium,
      per=per,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      addPowerToMedium=false,
      use_riseTime=false),
    redeclare Buildings.Fluid.Movers.FlowControlled_dp mov2(
      redeclare final package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      per=per,
      addPowerToMedium=false,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      use_riseTime=false),
    redeclare Buildings.Fluid.Movers.FlowControlled_m_flow mov3(
      redeclare final package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      per=per,
      addPowerToMedium=false,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      use_riseTime=false),
    ramDam(height=-0.5));
  Modelica.Blocks.Sources.RealExpression exp_dp(y=mov1.dpMachine)
    "Expression to impose the same pressure rise"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.RealExpression exp_m_flow(y=mov1.m_flow)
    "Expression to impose the same mass flow rate"
    annotation (Placement(transformation(extent={{-58,-60},{-38,-40}})));
equation
  connect(exp_dp.y, mov2.dp_in)
    annotation (Line(points={{-39,0},{-30,0},{-30,-8}}, color={0,0,127}));
  connect(exp_m_flow.y, mov3.m_flow_in)
    annotation (Line(points={{-37,-50},{-30,-50},{-30,-58}}, color={0,0,127}));
  connect(ramSpe.y, mov1.y)
    annotation (Line(points={{-59,80},{-30,80},{-30,52}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/ComparePowerInput.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
This validation model is similar to
<a href=\"modelica://Buildings.Fluid.Movers.Validation.ComparePowerHydraulic\">
Buildings.Fluid.Movers.Validation.ComparePowerHydraulic</a>.
It demonstrates that the mover models with different input signals
should produce the same power computation results.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1880\">IBPSA, #1880</a>.
</li>
</ul>
</html>"));
end ComparePowerInput;
