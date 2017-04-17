within Buildings.Experimental.ScalableModels.HVACSystems;
model IdealAir_PI "Simple ideal heating and cooling"
  package MediumA = Buildings.Media.Air "Buildings library air media package";
  parameter Integer nZon(min=1) = 1 "Number of zones per floor"
    annotation(Evaluate=true);
  parameter Integer nFlo(min=1) = 1 "Number of floors"
    annotation(Evaluate=true);
  Modelica.Blocks.Interfaces.RealInput Tmea[nZon,nFlo]
    "Measured mean zone air temperature" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Fluid.Sources.MassFlowSource_T SupplyAirSou[nZon,nFlo](
    each use_m_flow_in=true,
    redeclare each package Medium = MediumA,
    each use_T_in=true)
    annotation (Placement(transformation(extent={{66,10},{86,30}})));
  Buildings.Fluid.Sources.FixedBoundary bou(
    redeclare package Medium = MediumA,
    nPorts=1,
    p(displayUnit="Pa") = 101325)    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Modelica.Fluid.Interfaces.FluidPorts_b supplyAir[nZon,nFlo](
    redeclare each package Medium = MediumA) "Heating supply air"   annotation (Placement(transformation(extent={{100,20},
            {120,100}}), iconTransformation(extent={{100,20},{120,100}})));
  Modelica.Fluid.Interfaces.FluidPorts_b returnAir[nZon,nFlo](
    redeclare each package Medium = MediumA) "Return air"    annotation (Placement(transformation(extent={{100,
            -100},{120,-20}}), iconTransformation(extent={{100,-100},{120,-20}})));
  Modelica.Blocks.Math.Gain coolGain[nZon,nFlo](each k=-1)    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Interfaces.RealInput TheatSetpoint[nZon,nFlo]
    "Room heating setpoint temperature" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,70})));
  Modelica.Blocks.Interfaces.RealInput TcoolSetpoint[nZon,nFlo]
    "Room cooling setpoint temperature" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,30})));

  Buildings.Controls.Continuous.LimPID conPID[nZon,nFlo](
    each Ti=0.1,
    each Td=0,
    each yMax=0,
    each yMin=-10,
    each controllerType=Modelica.Blocks.Types.SimpleController.P,
    each k=1)   annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.Continuous.LimPID conPID1[nZon,nFlo](
    each Ti=0.1,
    each Td=0,
    each yMax=10,
    each yMin=0,
    each controllerType=Modelica.Blocks.Types.SimpleController.P,
    each k=1)    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Logical.Switch switch1[nZon,nFlo]
    annotation (Placement(transformation(extent={{30,62},{44,48}})));
  Modelica.Blocks.Logical.Greater greater[nZon,nFlo] "Need cooling?"
    annotation (Placement(transformation(extent={{-7,-4},{9,12}})));
  Modelica.Blocks.Sources.Constant const1[nZon,nFlo](each k=273.15 + 13)
    "Cooling supply temperature"
    annotation (Placement(transformation(extent={{-6,-28},{8,-14}})));
  Modelica.Blocks.Sources.Constant const[nZon,nFlo](each k=273.15 + 50)
    "Heating supply temperature"
    annotation (Placement(transformation(extent={{-6,-50},{8,-36}})));
  Modelica.Blocks.Logical.Switch switch2[nZon,nFlo]
    annotation (Placement(transformation(extent={{30,-34},{44,-20}})));
equation
  for iZon in 1:nZon loop
    for iFlo in 1:nFlo loop
      connect(returnAir[iZon, iFlo], bou.ports[1]) annotation (Line(points={{110,-60},
              {110,-60},{-40,-60}},
                           color={0,127,255}));
      connect(TcoolSetpoint[iZon, iFlo], conPID[iZon, iFlo].u_s) annotation (Line(points={{-120,30},{
          -91,30},{-62,30}}, color={0,0,127}));
      connect(Tmea[iZon, iFlo], conPID[iZon, iFlo].u_m) annotation (Line(points={{-120,-40},{-50,-40},{
          -50,18}}, color={0,0,127}));
      connect(TheatSetpoint[iZon, iFlo], conPID1[iZon, iFlo].u_s) annotation (Line(points={{-120,70},{
          -91,70},{-62,70}}, color={0,0,127}));
      connect(Tmea[iZon, iFlo], conPID1[iZon, iFlo].u_m) annotation (Line(points={{-120,-40},{-82,-40},
          {-82,50},{-50,50},{-50,58}}, color={0,0,127}));
      connect(conPID[iZon, iFlo].y, coolGain[iZon, iFlo].u) annotation (Line(points={{-39,30},{-30.5,30},
          {-22,30}}, color={0,0,127}));
      connect(SupplyAirSou[iZon, iFlo].ports[1], supplyAir[iZon, iFlo])
        annotation (Line(points={{86,20},{88,20},{110,20},{110,60}},     color={
              0,127,255}));
      connect(Tmea[iZon, iFlo], greater[iZon, iFlo].u1) annotation (Line(points={{-120,-40},{-66,
          -40},{-66,4},{-8.6,4}}, color={0,0,127}));
      connect(TcoolSetpoint[iZon, iFlo], greater[iZon, iFlo].u2) annotation (Line(points={{-120,
          30},{-74,30},{-74,-2.4},{-8.6,-2.4}}, color={0,0,127}));
      connect(greater[iZon, iFlo].y, switch2[iZon, iFlo].u2) annotation (Line(points={{9.8,4},{18,
          4},{18,-27},{28.6,-27}}, color={255,0,255}));
      connect(const1[iZon, iFlo].y, switch2[iZon, iFlo].u1) annotation (Line(points={{8.7,-21},{
          19.35,-21},{19.35,-21.4},{28.6,-21.4}}, color={0,0,127}));
      connect(const[iZon, iFlo].y, switch2[iZon, iFlo].u3) annotation (Line(points={{8.7,-43},{19.35,
          -43},{19.35,-32.6},{28.6,-32.6}}, color={0,0,127}));
      connect(greater[iZon, iFlo].y, switch1[iZon, iFlo].u2) annotation (Line(points={{9.8,4},{18,
          4},{18,55},{28.6,55}}, color={255,0,255}));
      connect(coolGain[iZon, iFlo].y, switch1[iZon, iFlo].u1) annotation (Line(points={{1,30},{14,
          30},{14,49.4},{28.6,49.4}}, color={0,0,127}));
      connect(conPID1[iZon, iFlo].y, switch1[iZon, iFlo].u3) annotation (Line(points={{-39,70},{
          -6,70},{-6,60.6},{28.6,60.6}}, color={0,0,127}));
      connect(switch1[iZon, iFlo].y, SupplyAirSou[iZon, iFlo].m_flow_in) annotation (Line(
        points={{44.7,55},{54,55},{54,28},{66,28}}, color={0,0,127}));
      connect(SupplyAirSou[iZon, iFlo].T_in, switch2[iZon, iFlo].y) annotation (Line(points={{64,24},{54,24},
          {54,-27},{44.7,-27}}, color={0,0,127}));

    end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-80,60},{76,-34}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="IdealAir_PI")}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IdealAir_PI;
