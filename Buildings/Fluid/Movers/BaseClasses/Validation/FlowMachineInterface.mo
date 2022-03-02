within Buildings.Fluid.Movers.BaseClasses.Validation;
model FlowMachineInterface "Simple model to validate FlowMachineInterface"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff(
    per(pressure(V_flow={0,1}, dp={1000,0})),
    rho_default=1.2,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true) "Flow machine interface model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant y(k=1) "Control signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant rho(k=1.2) "Density"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Ramp m_flow(height=1.2, duration=1) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(eff.rho, rho.y)
    annotation (Line(points={{-12,-6},{-20,-6},{-20,-30},{-39,-30}},
                                               color={0,0,127}));
  connect(m_flow.y, eff.m_flow) annotation (Line(points={{-39,0},{-20,0},{-20,4},
          {-12,4}},      color={0,0,127}));
  connect(y.y, eff.y_in)
    annotation (Line(points={{-39,30},{-4,30},{-4,12}},   color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Simple validation model for the flow machine interface model.
</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2021, by Hongxiang Fu:<br/>
Removed assignments for <code>eff.haveVMax</code> 
and <code>eff.V_flow_max</code> as they are now assigned inside 
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>.<br/>
This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
<li>
February 19, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/FlowMachineInterface.mos"
        "Simulate and plot"));
end FlowMachineInterface;
