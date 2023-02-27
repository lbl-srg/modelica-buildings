within Buildings.Fluid.Movers.BaseClasses.Validation;
model MotorEfficiencyMethods
  "Validation model for different motor efficiency options"
  extends Modelica.Icons.Example;

  Buildings.Fluid.Movers.Data.Generic per(
    final pressure(V_flow={0,1}, dp={1000,0}),
    final etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided)
    "Performance record";
  parameter Modelica.Units.SI.Density rhoFlu=1.2 "Fluid density";

  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff1(
    per(
      pressure=per.pressure,
      etaHydMet=per.etaHydMet,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided),
    rho_default=rhoFlu,
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
    rho_default=rhoFlu,
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
      WMot_nominal=500),
    rho_default=rhoFlu,
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
      WMot_nominal=500),
    rho_default=rhoFlu,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with per.etaMotMet=.GenericCurve"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Modelica.Blocks.Sources.Constant y(k=1) "Relative speed"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Ramp m_flow(height=1*rhoFlu, duration=1) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant rho(k=rhoFlu) "Density"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(eff3.rho, rho.y) annotation (Line(points={{38,-36},{-20,-36},{-20,-30},
          {-39,-30}},
                 color={0,0,127}));
  connect(rho.y,eff4. rho) annotation (Line(points={{-39,-30},{-20,-30},{-20,-76},
          {38,-76}}, color={0,0,127}));
  connect(m_flow.y,eff3. m_flow) annotation (Line(points={{-39,30},{0,30},{0,-26},
          {38,-26}},color={0,0,127}));
  connect(m_flow.y,eff4. m_flow) annotation (Line(points={{-39,30},{0,30},{0,-66},
          {38,-66}}, color={0,0,127}));
  connect(m_flow.y, eff1.m_flow) annotation (Line(points={{-39,30},{0,30},{0,54},
          {38,54}}, color={0,0,127}));
  connect(m_flow.y, eff2.m_flow) annotation (Line(points={{-39,30},{0,30},{0,14},
          {38,14}}, color={0,0,127}));
  connect(rho.y, eff2.rho) annotation (Line(points={{-39,-30},{-20,-30},{-20,4},
          {38,4}}, color={0,0,127}));
  connect(rho.y, eff1.rho) annotation (Line(points={{-39,-30},{-20,-30},{-20,44},
          {38,44}}, color={0,0,127}));
  connect(y.y, eff1.y_in) annotation (Line(points={{-39,80},{68,80},{68,70},{46,
          70},{46,62}}, color={0,0,127}));
  connect(y.y, eff2.y_in) annotation (Line(points={{-39,80},{68,80},{68,30},{46,
          30},{46,22}}, color={0,0,127}));
  connect(y.y, eff3.y_in) annotation (Line(points={{-39,80},{68,80},{68,-10},{
          46,-10},{46,-18}},
                          color={0,0,127}));
  connect(y.y, eff4.y_in) annotation (Line(points={{-39,80},{68,80},{68,-50},{
          46,-50},{46,-58}},
                          color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
This is a simple validation model for
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>
where its motor efficiency <i>&eta;<sub>mot</sub></i> is specified with
different methods defined in
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod</a>.
The instance <code>eff4</code> specifies <i>&eta;<sub>mot</sub></i> as
a function of motor PLR by finding a generic curve with the maximum motor
efficiency and rated motor input power. The generic curve is generated by
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>.
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
