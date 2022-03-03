within Buildings.Fluid.Movers.BaseClasses.Validation;
model MotorEfficiency_y
  "FlowMachineInterface with motor efficiency vs. PLR as input"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff(
    per(
      pressure(V_flow={0,1}, dp={1000,0}),
      etaMotMet=
        Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.Values_y,
      motorEfficiency_y(
        y={0,0.25,0.5,1},
        eta={0,0.56,0.7,0.7})),
    rho_default=1.2,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true) "Flow machine interface model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant m_flow(k=1) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Constant rho(k=1.2) "Density"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Ramp y(height=1, duration=1) "Input signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(eff.rho, rho.y)
    annotation (Line(points={{-12,-6},{-20,-6},{-20,-30},{-39,-30}},
                                               color={0,0,127}));
  connect(m_flow.y, eff.m_flow) annotation (Line(points={{-39,0},{-20,0},{-20,4},
          {-12,4}}, color={0,0,127}));
  connect(y.y, eff.y_in)
    annotation (Line(points={{-39,30},{-4,30},{-4,12}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Simple validation model for the flow machine interface model with the
motor efficiency input as a function of part load ratio <i>y</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2022, by Hongxiang Fu:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0));
end MotorEfficiency_y;
