within Buildings.Fluid.Movers.BaseClasses.Validation;
model MotorEfficiencyMethods
  "FlowMachineInterface with motor efficiency vs. motor PLR as input"
  extends Modelica.Icons.Example;

  Buildings.Fluid.Movers.Data.Generic per(
    final pressure(V_flow={0,1}, dp={1000,0}),
    final etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided)
    "Performance record";

  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff1(
    per(
      pressure=per.pressure,
      etaHydMet=per.etaHydMet,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided),
    rho_default=1.2,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with per.etaMotMet=.NotProvided"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff2(
    per(
      pressure=per.pressure,
      etaHydMet=per.etaHydMet,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      motorEfficiency(V_flow={0,0.3,0.6,1}, eta={0,0.4,0.6,0.7})),
    rho_default=1.2,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with per.etaMotMet=.Efficiency_VolumeFlowRate"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff3(
    per(
      pressure=per.pressure,
      etaHydMet=per.etaHydMet,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_MotorPartLoadRatio,
      motorEfficiency_yMot(y={0,0.25,0.5,1}, eta={0,0.56,0.7,0.7}),
      PEle_nominal=600),
    rho_default=1.2,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with per.etaMotMet=.Efficiency_MotorPartLoadRatio"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff4(
    per(
      pressure=per.pressure,
      etaHydMet=per.etaHydMet,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve,
      etaMot_max=0.7,
      PEle_nominal=600),
    rho_default=1.2,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with per.etaMotMet=.GenericCurve"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Modelica.Blocks.Sources.Constant rho(k=1.2) "Density"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Ramp y(height=1, duration=1) "Input signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Ramp m_flow(height=0.8, duration=1) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  connect(eff3.rho, rho.y) annotation (Line(points={{38,-36},{-20,-36},{-20,-30},
          {-39,-30}},
                 color={0,0,127}));
  connect(y.y,eff3. y_in)
    annotation (Line(points={{-39,70},{20,70},{20,-10},{46,-10},{46,-18}},
                                                      color={0,0,127}));
  connect(y.y,eff4. y_in) annotation (Line(points={{-39,70},{20,70},{20,-50},{46,
          -50},{46,-58}},color={0,0,127}));
  connect(rho.y,eff4. rho) annotation (Line(points={{-39,-30},{-20,-30},{-20,-76},
          {38,-76}}, color={0,0,127}));
  connect(m_flow.y,eff3. m_flow) annotation (Line(points={{-39,30},{0,30},{0,-26},
          {38,-26}},color={0,0,127}));
  connect(m_flow.y,eff4. m_flow) annotation (Line(points={{-39,30},{0,30},{0,-66},
          {38,-66}}, color={0,0,127}));
  connect(y.y, eff1.y_in)
    annotation (Line(points={{-39,70},{46,70},{46,62}}, color={0,0,127}));
  connect(y.y, eff2.y_in) annotation (Line(points={{-39,70},{20,70},{20,30},{46,
          30},{46,22}}, color={0,0,127}));
  connect(m_flow.y, eff1.m_flow) annotation (Line(points={{-39,30},{0,30},{0,54},
          {38,54}}, color={0,0,127}));
  connect(m_flow.y, eff2.m_flow) annotation (Line(points={{-39,30},{0,30},{0,14},
          {38,14}}, color={0,0,127}));
  connect(rho.y, eff2.rho) annotation (Line(points={{-39,-30},{-20,-30},{-20,4},
          {38,4}}, color={0,0,127}));
  connect(rho.y, eff1.rho) annotation (Line(points={{-39,-30},{-20,-30},{-20,44},
          {38,44}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
This is a simple validation model for the flow machine interface model where its
motor efficiency <i>&eta;<sub>mot</sub></i> is specified with different methods.
The instance <code>eff4</code> specifies <i>&eta;<sub>mot</sub></i> as a function
of motor PLR by finding a generic curve with the maximum motor efficiency and
rated motor input power. The generic curve is generated by
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>
</p>
</html>", revisions="<html>
<ul>
<li>
Apr 6, 2022, by Hongxiang Fu:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/MotorEfficiencyMethods.mos"
        "Simulate and plot"));
end MotorEfficiencyMethods;
