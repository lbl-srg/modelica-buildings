within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model HADryCoil "Test model for dry coil convection coefficient"
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil  hADryCoi(
    m_flow_nominal_w=0.1,
    UA_nominal=10000,
    m_flow_nominal_a=2.5) "Calculates an hA value for a dry coil"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.Ramp TWat(
    offset=293.15,
    duration=20,
    startTime=40,
    height=40) "Temperature of the water"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp TAir(
    height=-20,
    offset=293.15,
    duration=20,
    startTime=60) "Temperature of the air"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Ramp mWat_flow(
    height=0.1,
    duration=20,
    offset=0) "Water mass flow rate"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp mAir_flow(
    duration=20,
    offset=0,
    height=2.5,
    startTime=20) "Air mass flow rate"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil hADryCoiAir(
    m_flow_nominal_w=0.1,
    UA_nominal=10000,
    m_flow_nominal_a=2.5,
    waterSideFlowDependent=false,
    waterSideTemperatureDependent=false)
    "Calculates an hA value for a dry coil"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil hADryCoiWat(
    m_flow_nominal_w=0.1,
    UA_nominal=10000,
    m_flow_nominal_a=2.5,
    airSideFlowDependent=false,
    airSideTemperatureDependent=false) "Calculates an hA value for a dry coil"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
equation
  connect(TWat.y, hADryCoi.T_1) annotation (Line(points={{-59,30},{-30,30},{-30,
          43},{-1,43}}, color={0,0,127}));
  connect(hADryCoi.T_2, TAir.y) annotation (Line(points={{-1,37},{-30,37},{-30,
          -30},{-59,-30}},
                      color={0,0,127}));
  connect(mAir_flow.y, hADryCoi.m2_flow) annotation (Line(points={{-59,-70},{
          -20,-70},{-20,33},{-1,33}},
                                color={0,0,127}));
  connect(mWat_flow.y, hADryCoi.m1_flow) annotation (Line(points={{-59,70},{-20,
          70},{-20,47},{-1,47}}, color={0,0,127}));
  connect(TWat.y, hADryCoiAir.T_1) annotation (Line(points={{-59,30},{-30,30},{
          -30,3},{-1,3}}, color={0,0,127}));
  connect(hADryCoiAir.T_2, TAir.y) annotation (Line(points={{-1,-3},{-30,-3},{
          -30,-30},{-59,-30}}, color={0,0,127}));
  connect(mAir_flow.y, hADryCoiAir.m2_flow) annotation (Line(points={{-59,-70},
          {-20,-70},{-20,-7},{-1,-7}}, color={0,0,127}));
  connect(mWat_flow.y, hADryCoiAir.m1_flow) annotation (Line(points={{-59,70},{
          -20,70},{-20,7},{-1,7}}, color={0,0,127}));
  connect(TWat.y, hADryCoiWat.T_1) annotation (Line(points={{-59,30},{-30,30},{
          -30,-37},{-1,-37}}, color={0,0,127}));
  connect(hADryCoiWat.T_2, TAir.y) annotation (Line(points={{-1,-43},{-30,-43},
          {-30,-30},{-59,-30}}, color={0,0,127}));
  connect(mAir_flow.y, hADryCoiWat.m2_flow) annotation (Line(points={{-59,-70},
          {-20,-70},{-20,-47},{-1,-47}}, color={0,0,127}));
  connect(mWat_flow.y, hADryCoiWat.m1_flow) annotation (Line(points={{-59,70},{
          -20,70},{-20,-33},{-1,-33}}, color={0,0,127}));
  annotation ( __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/HADryCoil.mos"
  "Simulate and plot"),
  experiment(StopTime=80.0,
             Tolerance=1E-6),
  Documentation(info="<html>
<p>
Test model for <a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil\">
Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 9, 2017, by Michael Wetter:<br/>
First version.
</li>
</ul>
</html>"));
end HADryCoil;
