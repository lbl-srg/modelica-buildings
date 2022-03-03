within Buildings.Fluid.Movers.BaseClasses.Validation;
model FlowMachineInterface_y
  "FlowMachineInterface with motor efficiency vs. PLR as input"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff1(
    per(
      pressure(V_flow={0,1}, dp={1000,0}),
      etaMotMet=
        Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.Values_y,
      motorEfficiency_y(y={0,0.25,0.5,1}, eta={0,0.56,0.7,0.7})),
    rho_default=1.2,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with input of motor efficiency vs. PLR"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff2(
    per(
      pressure(V_flow={0,1}, dp={1000,0}),
      etaHydMet=
        Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.EulerNumber,
      peak(V_flow=0.5, dp=500, eta=0.7),
      etaMotMet=
        Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.Values_y,
      motorEfficiency_y(y={0,0.25,0.5,1}, eta={0,0.56,0.7,0.7})),
    rho_default=1.2,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with mixed input"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Modelica.Blocks.Sources.Constant rho(k=1.2) "Density"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Ramp y(height=1, duration=1) "Input signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Ramp m_flow(height=0.8, duration=1) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(eff1.rho, rho.y) annotation (Line(points={{-2,4},{-10,4},{-10,-30},{-39,
          -30}}, color={0,0,127}));
  connect(y.y, eff1.y_in)
    annotation (Line(points={{-39,30},{6,30},{6,22}}, color={0,0,127}));
  connect(y.y, eff2.y_in) annotation (Line(points={{-39,30},{28,30},{28,-10},{6,
          -10},{6,-18}}, color={0,0,127}));
  connect(rho.y, eff2.rho) annotation (Line(points={{-39,-30},{-10,-30},{-10,-36},
          {-2,-36}}, color={0,0,127}));
  connect(m_flow.y, eff1.m_flow) annotation (Line(points={{-39,0},{-14,0},{-14,14},
          {-2,14}}, color={0,0,127}));
  connect(m_flow.y, eff2.m_flow) annotation (Line(points={{-39,0},{-14,0},{-14,-26},
          {-2,-26}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Simple validation model for the flow machine interface model.
The instance <code>eff1</code> uses motor efficiency <i>&eta;<sub>mot</sub></i>
for input as a function of part load ratio <i>y</i>.
The instance <code>eff2</code> uses a mixed input with <i>&eta;<sub>hyd</sub></i>
with the Euler number and <i>&eta;<sub>mot</sub></i> with PLR.
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
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/FlowMachineInterface_y.mos"
        "Simulate and plot"));
end FlowMachineInterface_y;
