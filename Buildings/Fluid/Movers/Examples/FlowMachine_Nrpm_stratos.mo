within Buildings.Fluid.Movers.Examples;
model FlowMachine_Nrpm_stratos "Model test using a Wilo Stratos 80/1-12 pump"
  extends Modelica.Icons.Example;
  // fixme: use media declaration at pacakge level
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

    Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=5,
    p=100000,
    T=293.15) "Boundary condition with fixed pressure"
    annotation (Placement(transformation(extent={{-120,-32},{-100,-12}})));
  Modelica.Blocks.Sources.Constant rpm1(k=2960) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,84},{-78,96}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_p_in=false,
    nPorts=5,
    p=101000) "Fixed pressure boundary condition"
    annotation (Placement(transformation(extent={{130,-10},{110,10}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan(redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{38,60},{58,80}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    startTime=100,
    duration=800,
    height=60/3.6,
    offset=0) "Ramp signal for forced mass flow rate"
    annotation (Placement(transformation(extent={{-36,88},{-24,100}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_1(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  per(
    pressure=pressure,
    use_powerCharacteristic=true,
    power=power),
  y_start=1) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan1(
                                                redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{38,10},{58,30}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_2(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  per(
    N_nominal=N_nominal,
    pressure=pressure,
    use_powerCharacteristic=true,
    power=power),
  y_start=1) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan2(
                                                redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{38,-36},{58,-16}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_3(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  per(
    N_nominal=N_nominal,
    pressure=pressure,
    use_powerCharacteristic=true,
    power=power),
    y_start=1) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan3(
                                                redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{38,-80},{58,-60}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_4(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  per(
    N_nominal=N_nominal,
    pressure=pressure,
    use_powerCharacteristic=true,
    power=power),
    y_start=1) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan4(redeclare package Medium =
        Modelica.Media.Water.StandardWater, m_flow_nominal=3)
    annotation (Placement(transformation(extent={{38,-130},{58,-110}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm stratosPump80dash1to12_5(
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  per(
    N_nominal=N_nominal,
    pressure=pressure,
    use_powerCharacteristic=true,
    power=power),
    y_start=1) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Modelica.Blocks.Sources.Constant rpm2(k=2610) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,34},{-78,46}})));
  Modelica.Blocks.Sources.Constant rpm3(k=1930) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,-6},{-78,6}})));
  Modelica.Blocks.Sources.Constant rpm4(k=3300) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,-56},{-78,-44}})));
  Modelica.Blocks.Sources.Constant rpm5(k=900) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,-108},{-78,-96}})));
  Modelica.Blocks.Math.Min min1 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={35,91})));
  Modelica.Blocks.Math.Min min2 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={29,45})));
  Modelica.Blocks.Math.Min min3 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={35,-1})));
  Modelica.Blocks.Math.Min min4 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={35,-49})));
  Modelica.Blocks.Math.Min min5 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={35,-97})));
  Modelica.Blocks.Sources.Constant mMax_flow1(k=40/3.6)
    "Maximum flow rate of the pump"
    annotation (Placement(transformation(extent={{2,74},{14,86}})));
  Modelica.Blocks.Sources.Constant mMax_flow2(k=55/3.6)
    "Maximum flow rate of the pump"
    annotation (Placement(transformation(extent={{4,24},{16,36}})));
  Modelica.Blocks.Sources.Constant mMax_flow3(k=40/3.6)
    "Maximum flow rate of the pump"
    annotation (Placement(transformation(extent={{2,-18},{14,-6}})));
  Modelica.Blocks.Sources.Constant mMax_flow4(k=22/3.6)
    "Maximum flow rate of the pump"
    annotation (Placement(transformation(extent={{8,-68},{20,-56}})));
  Modelica.Blocks.Sources.Constant mMax_flow5(k=16/3.6)
    "Maximum flow rate of the pump"
    annotation (Placement(transformation(extent={{4,-116},{16,-104}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{66,60},{86,80}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo1(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{66,10},{86,30}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo2(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{66,-36},{86,-16}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo3(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{66,-80},{86,-60}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo4(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{66,-130},{86,-110}})));
equation

  connect(sou.ports[1],stratosPump80dash1to12_1. port_a) annotation (Line(
      points={{-100,-18.8},{-70,-18.8},{-70,70},{-60,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.port_a,stratosPump80dash1to12_1. port_b) annotation (Line(
      points={{38,70},{-40,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_1.Nrpm, rpm1.y) annotation (Line(
      points={{-50,82},{-50,90},{-77.4,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_2.port_a,sou. ports[2]) annotation (Line(
      points={{-60,20},{-70,20},{-70,-20.4},{-100,-20.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_3.port_a,sou. ports[3]) annotation (Line(
      points={{-60,-26},{-70,-26},{-70,-22},{-100,-22}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_4.port_a,sou. ports[4]) annotation (Line(
      points={{-60,-70},{-70,-70},{-70,-24},{-96,-24},{-96,-23.6},{-100,-23.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_5.port_a,sou. ports[5]) annotation (Line(
      points={{-60,-120},{-70,-120},{-70,-25.2},{-100,-25.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_2.port_b, fan1.port_a) annotation (Line(
      points={{-40,20},{38,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_3.port_b, fan2.port_a) annotation (Line(
      points={{-40,-26},{38,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_4.port_b, fan3.port_a) annotation (Line(
      points={{-40,-70},{38,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stratosPump80dash1to12_5.port_b, fan4.port_a) annotation (Line(
      points={{-40,-120},{38,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rpm2.y, stratosPump80dash1to12_2.Nrpm) annotation (Line(
      points={{-77.4,40},{-50,40},{-50,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rpm3.y, stratosPump80dash1to12_3.Nrpm) annotation (Line(
      points={{-77.4,0},{-50,0},{-50,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rpm4.y, stratosPump80dash1to12_4.Nrpm) annotation (Line(
      points={{-77.4,-50},{-50,-50},{-50,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rpm5.y, stratosPump80dash1to12_5.Nrpm) annotation (Line(
      points={{-77.4,-102},{-50,-102},{-50,-108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan.m_flow_in, min1.y) annotation (Line(
      points={{47.8,82},{48,82},{48,91},{40.5,91}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min1.u1, m_flow.y) annotation (Line(
      points={{29,94},{-23.4,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min2.y, fan1.m_flow_in) annotation (Line(
      points={{34.5,45},{42,45},{42,44},{48,44},{48,32},{47.8,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min2.u1, m_flow.y) annotation (Line(
      points={{23,48},{-14,48},{-14,94},{-23.4,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min3.y, fan2.m_flow_in) annotation (Line(
      points={{40.5,-1},{44.25,-1},{44.25,-14},{47.8,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min5.y, fan4.m_flow_in) annotation (Line(
      points={{40.5,-97},{44.25,-97},{44.25,-108},{47.8,-108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min4.y, fan3.m_flow_in) annotation (Line(
      points={{40.5,-49},{44.25,-49},{44.25,-58},{47.8,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min3.u1, m_flow.y) annotation (Line(
      points={{29,2},{-14,2},{-14,94},{-23.4,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min4.u1, m_flow.y) annotation (Line(
      points={{29,-46},{-14,-46},{-14,94},{-23.4,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min5.u1, m_flow.y) annotation (Line(
      points={{29,-94},{-14,-94},{-14,94},{-23.4,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mMax_flow1.y, min1.u2) annotation (Line(
      points={{14.6,80},{18,80},{18,88},{29,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mMax_flow2.y, min2.u2) annotation (Line(
      points={{16.6,30},{20,30},{20,42},{23,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min3.u2, mMax_flow3.y) annotation (Line(
      points={{29,-4},{20,-4},{20,-12},{14.6,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mMax_flow4.y, min4.u2) annotation (Line(
      points={{20.6,-62},{26,-62},{26,-52},{29,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mMax_flow5.y, min5.u2) annotation (Line(
      points={{16.6,-110},{20,-110},{20,-100},{29,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan.port_b, senMasFlo.port_a) annotation (Line(
      points={{58,70},{66,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, sin.ports[1]) annotation (Line(
      points={{86,70},{96,70},{96,3.2},{110,3.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan4.port_b, senMasFlo4.port_a) annotation (Line(
      points={{58,-120},{66,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan3.port_b, senMasFlo3.port_a) annotation (Line(
      points={{58,-70},{66,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan2.port_b, senMasFlo2.port_a) annotation (Line(
      points={{58,-26},{66,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan1.port_b, senMasFlo1.port_a) annotation (Line(
      points={{58,20},{66,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[2], senMasFlo1.port_b) annotation (Line(
      points={{110,1.6},{94,1.6},{94,20},{86,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo2.port_b, sin.ports[3]) annotation (Line(
      points={{86,-26},{92,-26},{92,0},{110,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo3.port_b, sin.ports[4]) annotation (Line(
      points={{86,-70},{94,-70},{94,-1.6},{110,-1.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo4.port_b, sin.ports[5]) annotation (Line(
      points={{86,-120},{94,-120},{94,-3.2},{110,-3.2}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1000),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/FlowMachine_Nrpm_stratos.mos"
        "Simulate and plot"),
    Documentation(info="<html>
    <p>Test of a Nrpm pump based on real pump data. 
    Outputs X and Y give the coordinates of a pump power curve P=f (m_flow), 
    which can be compared to the manufacturers data sheet for different rotational speeds.
    </p>
</html>",
        revisions="<html>
<ul>
<li>
February 27, 2014, by Filip Jorissen:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>
for a discussion and validation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-140},{140,120}},
          preserveAspectRatio=false), graphics),
    Icon(coordinateSystem(extent={{-140,-140},{140,120}})));
end FlowMachine_Nrpm_stratos;
