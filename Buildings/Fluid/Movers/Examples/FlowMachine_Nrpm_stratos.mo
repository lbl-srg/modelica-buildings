within Buildings.Fluid.Movers.Examples;
model FlowMachine_Nrpm_stratos "Model test using a Wilo Stratos 80/1-12 pump"
  extends Modelica.Icons.Example;

  parameter Integer numCurves= 5 "The amount of curves that will be plotted";
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_nominal=2610 "Nominal rotational speed for flow characteristic";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters
    pressure(V_flow={8.79043600562e-06,0.00277777777778,0.00556874120956,
          0.00776635021097,0.00978815049226,0.0113484528833,0.0127329465541,
          0.013985583685,0.0154360056259}, dp={78355.8975904,78243.6144578,
          78054.5060241,75596.0963855,70490.1686747,63682.2650602,55361.4939759,
          45527.8554217,30966.5060241})
    "Volume flow rate vs. total pressure rise";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters
    power(V_flow={8.79043600562e-06,0.00277777777778,0.00556874120956,
          0.00776635021097,0.00978815049226,0.0113484528833,0.0127329465541,
          0.013985583685,0.0154360056259}, P={437.425146701,588.954435301,
          792.603370491,931.705429399,1048.15648043,1115.77190985,1154.92222088,
          1171.51603429,1166.47479929})
    "Volume flow rate vs. electrical power consumption";

  Modelica.Blocks.Interfaces.RealOutput[numCurves] outputX "X signal values"
    annotation (Placement(transformation(extent={{94,-70},{114,-50}})));
  Modelica.Blocks.Interfaces.RealOutput[numCurves] outputY "Y signal values"
    annotation (Placement(transformation(extent={{94,-90},{114,-70}})));

    Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    T=313.15,
    nPorts=5)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.Constant const(k=2960)
    annotation (Placement(transformation(extent={{-72,58},{-60,70}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_p_in=false,
    p=101000,
    nPorts=5) annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan(redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{26,34},{46,54}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=100,
    duration=800,
    height=60/3.6,
    offset=0)
    annotation (Placement(transformation(extent={{-16,80},{-4,92}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_1(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  N_nominal=N_nominal,
  pressure=pressure,
  use_powerCharacteristic=true,
  power=power,
    N_start=N_nominal)
    annotation (Placement(transformation(extent={{-42,34},{-22,54}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan1(
                                                redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{26,2},{46,22}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_2(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  N_nominal=N_nominal,
  pressure=pressure,
  use_powerCharacteristic=true,
  power=power,
    N_start=N_nominal)
    annotation (Placement(transformation(extent={{-42,2},{-22,22}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan2(
                                                redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{26,-36},{46,-16}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_3(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  N_nominal=N_nominal,
  pressure=pressure,
  use_powerCharacteristic=true,
  power=power,
    N_start=N_nominal)
    annotation (Placement(transformation(extent={{-42,-36},{-22,-16}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan3(
                                                redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{26,-68},{46,-48}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_4(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  N_nominal=N_nominal,
  pressure=pressure,
  use_powerCharacteristic=true,
  power=power,
    N_start=N_nominal)
    annotation (Placement(transformation(extent={{-42,-76},{-22,-56}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan4(
                                                redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{26,-100},{46,-80}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_5(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  N_nominal=N_nominal,
  pressure=pressure,
  use_powerCharacteristic=true,
  power=power,
    N_start=N_nominal)
    annotation (Placement(transformation(extent={{-42,-108},{-22,-88}})));
  Modelica.Blocks.Sources.Constant const1(k=2610)
    annotation (Placement(transformation(extent={{-72,18},{-60,30}})));
  Modelica.Blocks.Sources.Constant const2(k=1930)
    annotation (Placement(transformation(extent={{-72,-22},{-60,-10}})));
  Modelica.Blocks.Sources.Constant const3(k=3300)
    annotation (Placement(transformation(extent={{-72,-58},{-60,-46}})));
  Modelica.Blocks.Sources.Constant const4(k=900)
    annotation (Placement(transformation(extent={{-72,-86},{-60,-74}})));
  Modelica.Blocks.Math.Min min1 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={25,65})));
  Modelica.Blocks.Math.Min min2 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={25,29})));
  Modelica.Blocks.Math.Min min3 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={23,-11})));
  Modelica.Blocks.Math.Min min4 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={23,-45})));
  Modelica.Blocks.Math.Min min5 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={23,-75})));
  Modelica.Blocks.Sources.Constant const5(k=40/3.6)
    annotation (Placement(transformation(extent={{-8,56},{4,68}})));
  Modelica.Blocks.Sources.Constant const6(k=55/3.6)
    annotation (Placement(transformation(extent={{-8,20},{4,32}})));
  Modelica.Blocks.Sources.Constant const7(k=40/3.6)
    annotation (Placement(transformation(extent={{-8,-20},{4,-8}})));
  Modelica.Blocks.Sources.Constant const8(k=22/3.6)
    annotation (Placement(transformation(extent={{-8,-54},{4,-42}})));
  Modelica.Blocks.Sources.Constant const9(k=16/3.6)
    annotation (Placement(transformation(extent={{-8,-84},{4,-72}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{46,34},{66,54}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo1(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{46,2},{66,22}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo2(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{46,-36},{66,-16}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo3(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{46,-68},{66,-48}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo4(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{46,-100},{66,-80}})));
equation

  connect(bou.ports[1],stratosPump80dash1to12_1. port_a) annotation (Line(
      points={{-80,3.2},{-46,3.2},{-46,44},{-42,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.port_a,stratosPump80dash1to12_1. port_b) annotation (Line(
      points={{26,44},{-22,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_1.Nrpm,const. y) annotation (Line(
      points={{-32,56},{-32,64},{-59.4,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_2.port_a, bou.ports[2]) annotation (Line(
      points={{-42,12},{-64,12},{-64,1.6},{-80,1.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_3.port_a, bou.ports[3]) annotation (Line(
      points={{-42,-26},{-64,-26},{-64,0},{-80,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_4.port_a, bou.ports[4]) annotation (Line(
      points={{-42,-66},{-64,-66},{-64,-1.6},{-80,-1.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_5.port_a, bou.ports[5]) annotation (Line(
      points={{-42,-98},{-64,-98},{-64,-3.2},{-80,-3.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_2.port_b, fan1.port_a) annotation (Line(
      points={{-22,12},{26,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_3.port_b, fan2.port_a) annotation (Line(
      points={{-22,-26},{26,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_4.port_b, fan3.port_a) annotation (Line(
      points={{-22,-66},{8,-66},{8,-58},{26,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_5.port_b, fan4.port_a) annotation (Line(
      points={{-22,-98},{8,-98},{8,-90},{26,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const1.y, stratosPump80dash1to12_2.Nrpm) annotation (Line(
      points={{-59.4,24},{-32,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const2.y, stratosPump80dash1to12_3.Nrpm) annotation (Line(
      points={{-59.4,-16},{-54,-16},{-54,-14},{-32,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const3.y, stratosPump80dash1to12_4.Nrpm) annotation (Line(
      points={{-59.4,-52},{-54,-52},{-54,-54},{-32,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const4.y, stratosPump80dash1to12_5.Nrpm) annotation (Line(
      points={{-59.4,-80},{-54,-80},{-54,-86},{-32,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan.m_flow_in, min1.y) annotation (Line(
      points={{35.8,56},{36,56},{36,65},{30.5,65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min1.u1, ramp.y) annotation (Line(
      points={{19,68},{8,68},{8,86},{-3.4,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min2.y, fan1.m_flow_in) annotation (Line(
      points={{30.5,29},{32.25,29},{32.25,24},{35.8,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min2.u1, ramp.y) annotation (Line(
      points={{19,32},{8,32},{8,86},{-3.4,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min3.y, fan2.m_flow_in) annotation (Line(
      points={{28.5,-11},{32.25,-11},{32.25,-14},{35.8,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min5.y, fan4.m_flow_in) annotation (Line(
      points={{28.5,-75},{32.25,-75},{32.25,-78},{35.8,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min4.y, fan3.m_flow_in) annotation (Line(
      points={{28.5,-45},{32.25,-45},{32.25,-46},{35.8,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min3.u1, ramp.y) annotation (Line(
      points={{17,-8},{8,-8},{8,86},{-3.4,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min4.u1, ramp.y) annotation (Line(
      points={{17,-42},{8,-42},{8,86},{-3.4,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min5.u1, ramp.y) annotation (Line(
      points={{17,-72},{8,-72},{8,86},{-3.4,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const5.y, min1.u2) annotation (Line(
      points={{4.6,62},{19,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const6.y, min2.u2) annotation (Line(
      points={{4.6,26},{19,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min3.u2, const7.y) annotation (Line(
      points={{17,-14},{4.6,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const8.y, min4.u2) annotation (Line(
      points={{4.6,-48},{17,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const9.y, min5.u2) annotation (Line(
      points={{4.6,-78},{17,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan.port_b, senMasFlo.port_a) annotation (Line(
      points={{46,44},{46,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, bou1.ports[1]) annotation (Line(
      points={{66,44},{76,44},{76,3.2},{80,3.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan4.port_b, senMasFlo4.port_a) annotation (Line(
      points={{46,-90},{46,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan3.port_b, senMasFlo3.port_a) annotation (Line(
      points={{46,-58},{46,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan2.port_b, senMasFlo2.port_a) annotation (Line(
      points={{46,-26},{46,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan1.port_b, senMasFlo1.port_a) annotation (Line(
      points={{46,12},{46,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou1.ports[2], senMasFlo1.port_b) annotation (Line(
      points={{80,1.6},{74,1.6},{74,12},{66,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo2.port_b, bou1.ports[3]) annotation (Line(
      points={{66,-26},{72,-26},{72,0},{80,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo3.port_b, bou1.ports[4]) annotation (Line(
      points={{66,-58},{74,-58},{74,-1.6},{80,-1.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo4.port_b, bou1.ports[5]) annotation (Line(
      points={{66,-90},{74,-90},{74,-3.2},{80,-3.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(outputX[1], senMasFlo.m_flow) annotation (Line(
      points={{104,-68},{80,-68},{80,55},{56,55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputX[2], senMasFlo1.m_flow) annotation (Line(
      points={{104,-64},{80,-64},{80,23},{56,23}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputX[3], senMasFlo2.m_flow) annotation (Line(
      points={{104,-60},{80,-60},{80,-15},{56,-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputX[4], senMasFlo3.m_flow) annotation (Line(
      points={{104,-56},{80,-56},{80,-47},{56,-47}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputX[5], senMasFlo4.m_flow) annotation (Line(
      points={{104,-52},{80,-52},{80,-79},{56,-79}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputY[1], stratosPump80dash1to12_1.P) annotation (Line(
      points={{104,-88},{40,-88},{40,52},{-21,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputY[2], stratosPump80dash1to12_2.P) annotation (Line(
      points={{104,-84},{40,-84},{40,20},{-21,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputY[3], stratosPump80dash1to12_3.P) annotation (Line(
      points={{104,-80},{40,-80},{40,-18},{-21,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputY[4], stratosPump80dash1to12_4.P) annotation (Line(
      points={{104,-76},{40,-76},{40,-58},{-21,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputY[5], stratosPump80dash1to12_5.P) annotation (Line(
      points={{104,-72},{40,-72},{40,-90},{-21,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1000), __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Test of a Nrpm pump based on real pump data. Outputs X and Y give the coordinates of a pump power curve P=f (m_flow) which can be compared to the manufacturers data sheet for different rotational speeds.</p>
</html>"));
end FlowMachine_Nrpm_stratos;
