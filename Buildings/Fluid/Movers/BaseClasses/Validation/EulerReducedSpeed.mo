within Buildings.Fluid.Movers.BaseClasses.Validation;
model EulerReducedSpeed
  "Validates the Euler number method at reduced mover speed"
  extends Modelica.Icons.Example;

  parameter Integer nOri(min=1)=size(per1.power.V_flow,1)
    "Number of data points for pressure curve"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.Density rhoCon=1.2
    "Constant density";

  parameter Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW13 per1(
    final etaHydMet=
            Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
    final etaMotMet=
            Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided)
    "Mover performance curves with flow rate, pressure rise, and power";
  parameter Buildings.Fluid.Movers.Data.Generic per2(
    power(V_flow={0.939939939939939,1.88588588588588,2.83183183183181,
         3.77177177177175,4.46546546546544}, P={4332.517,5801.546,6651.644,
         6800.784,6502.504}),
    pressure(V_flow={0.939939939939939,1.88588588588588,2.83183183183181,
            3.77177177177175,4.46546546546544}, dp={2081.78137651821,
            2008.90688259109,1474.4939271255,704.453441295546,0}))
    "Mover performance curves at reduced speed N=3400";
  parameter Buildings.Fluid.Movers.Data.Generic per3(
    power(V_flow={0.939939939939939,1.88588588588588,2.83183183183181,
         3.28228228228228}, P={1998.476,2535.38,2714.348,2550.294}),
    pressure(V_flow={0.939939939939939,1.88588588588588,2.83183183183181,
            3.28228228228228}, dp={1127.12550607287,903.643724696356,
            340.080971659919,0}))
    "Mover performance curves at reduced speed N=2500";

  Modelica.Units.SI.Power pow1=
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x=m1_flow.y/rhoCon,
      xSup=per1.power.V_flow,
      ySup=per1.power.P,
      ensureMonotonicity=false) "Measured power";
  Modelica.Units.SI.Power pow2=
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x=m2_flow.y/rhoCon,
      xSup=per2.power.V_flow,
      ySup=per2.power.P,
      ensureMonotonicity=false) "Measured power";
  Modelica.Units.SI.Power pow3=
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x=m3_flow.y/rhoCon,
      xSup=per3.power.V_flow,
      ySup=per3.power.P,
      ensureMonotonicity=false) "Measured power";

  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff1(
    per=per1,
    rho_default=rhoCon,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power characteristic"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff2(
    per=per1,
    rho_default=rhoCon,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power Euler correlation"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff3(
    per=per1,
    rho_default=rhoCon,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power Euler correlation"
    annotation (Placement(transformation(extent={{20,-68},{40,-48}})));

  Modelica.Blocks.Sources.Constant y1(k=1) "Control signal"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Constant rho(k=rhoCon) "Density"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Sources.Constant y2(k=3400/4100)
    "Reduced speed y = 3400/4100 = 0.829"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.Constant y3(k=2500/4100)
    "Reduced speed y = 2500/4100 = 0.610"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Modelica.Blocks.Sources.Ramp m1_flow(
    height=0.98*max(per1.pressure.V_flow)*rhoCon,
    duration=1,
    offset=0.01*max(per1.pressure.V_flow)*rhoCon)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Ramp m2_flow(
    height=0.98*max(per2.pressure.V_flow)*rhoCon,
    duration=1,
    offset=0.01*max(per2.pressure.V_flow)*rhoCon) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Ramp m3_flow(
    height=0.98*max(per3.pressure.V_flow)*rhoCon,
    duration=1,
    offset=0.01*max(per3.pressure.V_flow)*rhoCon) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

equation
  connect(eff1.rho, rho.y)
    annotation (Line(points={{18,44},{10,44},{10,-70},{1,-70}},
                                               color={0,0,127}));
  connect(y1.y, eff1.y_in)
    annotation (Line(points={{-39,80},{26,80},{26,62}}, color={0,0,127}));
  connect(m1_flow.y, eff1.m_flow) annotation (Line(points={{-39,50},{-20,50},{-20,
          54},{18,54}}, color={0,0,127}));
  connect(rho.y, eff2.rho) annotation (Line(points={{1,-70},{10,-70},{10,-16},{
          18,-16}},                 color={0,0,127}));
  connect(y2.y, eff2.y_in)
    annotation (Line(points={{-39,20},{26,20},{26,2}}, color={0,0,127}));
  connect(m2_flow.y, eff2.m_flow) annotation (Line(points={{-39,-10},{-20,-10},{
          -20,-6},{18,-6}}, color={0,0,127}));
  connect(y3.y, eff3.y_in)
    annotation (Line(points={{-39,-40},{26,-40},{26,-46}}, color={0,0,127}));
  connect(m3_flow.y, eff3.m_flow) annotation (Line(points={{-39,-70},{-30,-70},
          {-30,-54},{18,-54}},color={0,0,127}));
  connect(rho.y, eff3.rho) annotation (Line(points={{1,-70},{10,-70},{10,-64},{
          18,-64}},
                 color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/EulerReducedSpeed.mos"
 "Simulate and plot"),
Documentation(
info="<html>
<p>
Similar to
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Validation.EulerComparison\">
Buildings.Fluid.Movers.BaseClasses.Validation.EulerComparison</a>,
this model compares the power computed from the Euler number method with measured
values. The power data at speeds N=4100, 3400, and 2500 RPM from the power map of
<a href=\"modelica://Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW13\">
Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW13</a>
(shown below) was used.
Note that the pressure curves in the figure do not seem to be independently
measured but rather simply scaled from the nominal curve.
However, because the Euler number method also does not account for the efficiency
degradation along any curve <i>&Delta;p=kV&#775;<sup>2</sup></i>,
using the Euler number method has equivalent accuracy to using such power maps.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/BaseClasses/Validation/BIDW13.png\"
width=\"1000\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
March 18, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end EulerReducedSpeed;
