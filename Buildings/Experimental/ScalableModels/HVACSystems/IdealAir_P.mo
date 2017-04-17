within Buildings.Experimental.ScalableModels.HVACSystems;
model IdealAir_P "Simple ideal heating and cooling"
  package MediumA = Buildings.Media.Air "Buildings library air media package";
  parameter Real sensitivityGainHeat "[K] Control gain for heating";
  parameter Real sensitivityGainCool "[K] Control gain for cooling";

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
    each nPorts=1,
    each use_T_in=true)
    annotation (Placement(transformation(extent={{64,-8},{84,12}})));
  Modelica.Fluid.Interfaces.FluidPorts_b supplyAir[nZon,nFlo](
      redeclare each package Medium = MediumA) "Supply air"    annotation (Placement(transformation(extent={{100,-40},
            {120,40}}),
        iconTransformation(extent={{100,-40},{120,40}})));
  Modelica.Blocks.Math.Gain heatGain[nZon,nFlo](each k=sensitivityGainHeat)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Math.Gain coolGain[nZon,nFlo](each k=-sensitivityGainCool)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
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
  Modelica.Blocks.Math.Feedback feedback[nZon,nFlo]
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));
  Modelica.Blocks.Math.Feedback feedback1[nZon,nFlo]
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));

  Modelica.Blocks.Nonlinear.Limiter limiter[nZon,nFlo](each uMin=0)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1[nZon,nFlo](each uMin=0)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Blocks.Logical.Switch switch1[nZon,nFlo]
    annotation (Placement(transformation(extent={{34,60},{50,44}})));
  Modelica.Blocks.Logical.Greater greater[nZon,nFlo] "Need cooling?"
    annotation (Placement(transformation(extent={{-6,-8},{10,8}})));
  Modelica.Blocks.Logical.Switch switch2[nZon,nFlo]
    annotation (Placement(transformation(extent={{34,-40},{50,-24}})));
  Modelica.Blocks.Sources.Constant const[nZon,nFlo](each k=273.15 + 50)
    "Heating supply temperature"
    annotation (Placement(transformation(extent={{-4,-54},{10,-40}})));
  Modelica.Blocks.Sources.Constant const1[nZon,nFlo](each k=273.15 + 13)
    "Cooling supply temperature"
    annotation (Placement(transformation(extent={{-4,-32},{10,-18}})));
equation
  for iZon in 1:nZon loop
    for iFlo in 1:nFlo loop

      connect(TheatSetpoint[iZon, iFlo], feedback[iZon, iFlo].u1) annotation (Line(points={{-120,70},{-68,70}}, color={0,0,127}));
      connect(Tmea[iZon, iFlo], feedback[iZon, iFlo].u2) annotation (Line(points={{-120,
              -40},{-120,-40},{-60,-40},{-60,62}},
                               color={0,0,127}));
      connect(feedback[iZon, iFlo].y, heatGain[iZon, iFlo].u) annotation (Line(points={{-51,70},{-51,70},
          {-42,70}}, color={0,0,127}));
      connect(TcoolSetpoint[iZon, iFlo], feedback1[iZon, iFlo].u1) annotation (Line(points={{-120,30},{-88,30}}, color={0,0,127}));
      connect(Tmea[iZon, iFlo], feedback1[iZon, iFlo].u2) annotation (Line(points={{-120,
              -40},{-80,-40},{-80,22}},
                     color={0,0,127}));
      connect(feedback1[iZon, iFlo].y, coolGain[iZon, iFlo].u) annotation (Line(points={{-71,30},{-56.5,
          30},{-42,30}}, color={0,0,127}));
      connect(coolGain[iZon, iFlo].y, limiter[iZon, iFlo].u)  annotation (Line(points={{-19,30},{-12,30}}, color={0,0,127}));
      connect(heatGain[iZon, iFlo].y, limiter1[iZon, iFlo].u) annotation (Line(points={{-19,70},{-16,70},
          {-12,70}}, color={0,0,127}));
      connect(SupplyAirSou[iZon, iFlo].ports[1], supplyAir[iZon, iFlo])
        annotation (Line(points={{84,2},{88,2},{100,2},{100,0},{110,0}}, color={
              0,127,255}));

      connect(Tmea[iZon, iFlo], greater[iZon, iFlo].u1) annotation (Line(points={{-120,-40},{-60,-40},
          {-60,0},{-7.6,0}}, color={0,0,127}));
      connect(TcoolSetpoint[iZon, iFlo], greater[iZon, iFlo].u2) annotation (Line(points={{-120,30},{-94,
          30},{-94,-6.4},{-7.6,-6.4}}, color={0,0,127}));
      connect(greater[iZon, iFlo].y, switch2[iZon, iFlo].u2) annotation (Line(points={{10.8,0},{22,0},{22,-32},
          {32.4,-32}}, color={255,0,255}));
      connect(const1[iZon, iFlo].y, switch2[iZon, iFlo].u1) annotation (Line(points={{10.7,-25},{22,-25},{22,
          -25.6},{32.4,-25.6}}, color={0,0,127}));
      connect(const[iZon, iFlo].y, switch2[iZon, iFlo].u3) annotation (Line(points={{10.7,-47},{22,-47},{22,
          -38.4},{32.4,-38.4}}, color={0,0,127}));
      connect(greater[iZon, iFlo].y, switch1[iZon, iFlo].u2) annotation (Line(points={{10.8,0},{22,0},{22,52},
          {32.4,52}}, color={255,0,255}));
      connect(limiter[iZon, iFlo].y, switch1[iZon, iFlo].u1) annotation (Line(points={{11,30},{22,30},
          {22,45.6},{32.4,45.6}}, color={0,0,127}));
      connect(limiter1[iZon, iFlo].y, switch1[iZon, iFlo].u3) annotation (Line(points={{11,70},{22,70},
          {22,58.4},{32.4,58.4}}, color={0,0,127}));
      connect(switch1[iZon, iFlo].y, SupplyAirSou[iZon, iFlo].m_flow_in) annotation (Line(points={{50.8,
          52},{56,52},{56,10},{64,10}}, color={0,0,127}));
      connect(switch2[iZon, iFlo].y, SupplyAirSou[iZon, iFlo].T_in) annotation (Line(points={{50.8,-32},
          {56,-32},{56,6},{62,6}}, color={0,0,127}));

    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-62,54},{78,-38}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="IdealAir_P")}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IdealAir_P;
