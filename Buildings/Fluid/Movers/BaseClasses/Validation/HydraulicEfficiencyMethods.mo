within Buildings.Fluid.Movers.BaseClasses.Validation;
model HydraulicEfficiencyMethods
  "Validation model for different hydraulic efficiency options"
  extends Modelica.Icons.Example;

  Buildings.Fluid.Movers.Data.Generic per(
    powerOrEfficiencyIsHydraulic=true,
    final pressure(V_flow={0,1}, dp={1000,0}),
    final etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided)
    "Performance record";
  parameter Modelica.Units.SI.Density rhoFlu=1.2 "Fluid density";

  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff1(
    per(
      powerOrEfficiencyIsHydraulic=per.powerOrEfficiencyIsHydraulic,
      pressure=per.pressure,
      etaMotMet=per.etaMotMet,
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided),
    rho_default=rhoFlu,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with per.etaHydMet=.NotProvided"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff2(
    per(
      powerOrEfficiencyIsHydraulic=per.powerOrEfficiencyIsHydraulic,
      pressure=per.pressure,
      etaMotMet=per.etaMotMet,
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate,
      efficiency(V_flow={0,0.3,0.6,0.8,1}, eta={0,0.5,0.7,0.5,0})),
    rho_default=rhoFlu,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with per.etaHydMet=.Efficiency_VolumeFlowRate"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff3(
    per(
      powerOrEfficiencyIsHydraulic=per.powerOrEfficiencyIsHydraulic,
      pressure=per.pressure,
      etaMotMet=per.etaMotMet,
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
      power(V_flow={0,0.25,0.5,0.75,1}, P={480,540,510,550,710})),
    rho_default=rhoFlu,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with per.etaHydMet=.Power_VolumeFlowRate"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff4(
    per(
      powerOrEfficiencyIsHydraulic=per.powerOrEfficiencyIsHydraulic,
      pressure=per.pressure,
      etaMotMet=per.etaMotMet,
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
      peak(
        V_flow=0.5,
        dp=500,
        eta=0.7)),
    rho_default=rhoFlu,
    nOri=2,
    preVar=Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
    computePowerUsingSimilarityLaws=true)
    "FlowMachineInterface with per.etaHydMet=.EulerNumber"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Modelica.Blocks.Sources.Constant y(k=1) "Relative speed"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Ramp m_flow(height=rho.k, duration=1) "Mass flow rate"
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
where its hydraulic efficiency <i>&eta;<sub>hyd</sub></i> is specified with
different methods defined in
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Aug 5, 2022, by Hongxiang Fu:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/HydraulicEfficiencyMethods.mos"
        "Simulate and plot"));
end HydraulicEfficiencyMethods;
