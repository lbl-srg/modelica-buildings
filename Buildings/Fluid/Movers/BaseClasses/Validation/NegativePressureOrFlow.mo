within Buildings.Fluid.Movers.BaseClasses.Validation;
model NegativePressureOrFlow
  "A validation model that tests the mover behaviour when the pressure rise or flow is negative"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=10000
    "Nominal pressure difference";
  parameter Modelica.Units.SI.Density rho_default=1.2
    "Fluid density at medium default state";

  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff(
    per(pressure(V_flow=m_flow_nominal/rho_default*{0,2},
                 dp=dp_nominal*{2,0}),
        etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided,
        etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided),
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.PressureDifference,
    computePowerUsingSimilarityLaws=true,
    rho_default=rho_default,
    nOri=2)
    "FlowMachineInterface model with prescribed pressure"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Sources.Constant rho(k=rho_default) "Density"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    height=2*m_flow_nominal,
    duration=3600,
    offset=-0.5*m_flow_nominal) "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Ramp dp(
    height=-2*dp_nominal,
    duration=3600,
    offset=1.5*dp_nominal) "Pressure rise"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation

  connect(eff.m_flow, m_flow.y) annotation (Line(points={{-22,-6},{-52,-6},{-52,
          -10},{-59,-10}}, color={0,0,127}));
  connect(rho.y, eff.rho) annotation (Line(points={{-59,-50},{-28,-50},{-28,-16},
          {-22,-16}}, color={0,0,127}));
  connect(dp.y, eff.dp_in)
    annotation (Line(points={{-59,30},{-6,30},{-6,2}}, color={0,0,127}));
annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/NegativePressureOrFlow.mos"
        "Simulate and plot"),
   experiment(
      StopTime=3600,
      Tolerance=1e-06),
   Documentation(info="<html>
<p>
Without the constraint that
<i>W<sub>flo</sub> = V&#775; &Delta;p &ge; 0</i>,
this validation model would produce negative computed mover power
when the pressure rise or the flow rate is forced to be negative,
as shown below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/BaseClasses/Validation/NegativePressureOrFlow.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
October 5, 2022, by Hongxiang Fu:<br/>
<ul>
<li>
Remade this model with
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>
instead of using a full mover model so that forcing a flow rate and a pressure rise
is more straightforward.
</li>
<li>
Changed parameterisation so that the result curve is clearer.
</li>
</ul>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
<li>
June 6, 2022, by Hongxiang Fu:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1621\">IBPSA, #1621</a>.
</li>
</ul>
</html>"));
end NegativePressureOrFlow;
