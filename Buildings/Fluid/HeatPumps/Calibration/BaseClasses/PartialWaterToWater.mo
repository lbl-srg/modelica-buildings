within Buildings.Fluid.HeatPumps.Calibration.BaseClasses;
model PartialWaterToWater
  "Partial model for calibration of water to water heat pumps"

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Nominal mass flow rate on condenser side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Nominal mass flow rate on evaporator side";

  parameter Modelica.SIunits.Pressure dp1_nominal = 1000
    "Pressure drop at nominal mass flow rate on condenser side";
  parameter Modelica.SIunits.Pressure dp2_nominal = 1000
    "Pressure drop at nominal mass flow rate on evaporator side";

  parameter Modelica.SIunits.ThermalConductance UACon
    "Thermal conductance of condenser";

  parameter Modelica.SIunits.ThermalConductance UAEva
    "Thermal conductance of evaporator";

  replaceable package Medium1 = Buildings.Media.Water "Medium model";
  replaceable package Medium2 = Buildings.Media.Water "Medium model";

  replaceable package ref =
      Buildings.Fluid.Chillers.Compressors.Refrigerants.R410A
    "Refrigerant model";


  Modelica.Blocks.Sources.CombiTimeTable calDat(tableOnFile=true, columns=2:5,
    tableName=tableName,
    fileName=tableFileName)
    annotation (Placement(transformation(extent={{-130,0},{-110,20}})));

  Modelica.Blocks.Routing.DeMultiplex4 splDat
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Sources.FixedBoundary                 sin2(
    redeclare package Medium = Medium2, nPorts=1)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,-30})));
  Modelica.Fluid.Sources.MassFlowSource_T Sou(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true)
    annotation (Placement(transformation(extent={{60,-16},{40,4}})));
  Sources.FixedBoundary                 sin1(
    redeclare package Medium = Medium1, nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,24})));
  Modelica.Fluid.Sources.MassFlowSource_T Loa(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true)
    annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));
  Modelica.Fluid.Sensors.Temperature Con_in(
    redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Modelica.Fluid.Sensors.Temperature Con_out(
    redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Modelica.Fluid.Sensors.Temperature Eva_in(
    redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Fluid.Sensors.Temperature Eva_out(
    redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  replaceable Chillers.BaseClasses.PartialWaterToWater heaPum(
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    enable_variable_speed=false)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant          isOn(k=1)
    annotation (Placement(transformation(extent={{-50,-16},{-38,-4}})));
equation
  connect(calDat.y, splDat.u)
    annotation (Line(points={{-109,10},{-112,10},{-102,10}}, color={0,0,127}));
  connect(splDat.y1[1], Sou.T_in) annotation (Line(points={{-79,19},{-76,19},{-76,
          84},{92,84},{92,-2},{62,-2}}, color={0,0,127}));
  connect(splDat.y3[1], Sou.m_flow_in) annotation (Line(points={{-79,7},{-72,7},
          {-72,80},{88,80},{88,2},{60,2}}, color={0,0,127}));
  connect(splDat.y4[1], Loa.m_flow_in) annotation (Line(points={{-79,1},{-75.5,1},
          {-75.5,16},{-60,16}}, color={0,0,127}));
  connect(Loa.ports[1], heaPum.port_a1) annotation (Line(points={{-40,8},{-40,8},
          {-30,8},{-20,8},{-20,6},{-10,6}}, color={0,127,255}));
  connect(sin2.ports[1], heaPum.port_b2) annotation (Line(points={{-60,-30},{-20,
          -30},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(Sou.ports[1], heaPum.port_a2)
    annotation (Line(points={{40,-6},{26,-6},{10,-6}}, color={0,127,255}));
  connect(sin1.ports[1], heaPum.port_b1) annotation (Line(points={{40,24},{20,24},
          {20,6},{10,6}}, color={0,127,255}));
  connect(Con_out.port, heaPum.port_b1) annotation (Line(points={{20,30},{20,30},
          {20,6},{10,6}}, color={0,127,255}));
  connect(Con_in.port, heaPum.port_a1) annotation (Line(points={{-20,30},{-20,30},
          {-20,6},{-10,6}}, color={0,127,255}));
  connect(Eva_out.port, heaPum.port_b2) annotation (Line(points={{-40,-60},{-20,
          -60},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(Eva_in.port, heaPum.port_a2) annotation (Line(points={{0,-60},{20,-60},
          {20,-6},{10,-6}}, color={0,127,255}));
  connect(splDat.y2[1], Loa.T_in) annotation (Line(points={{-79,13},{-70.5,13},{
          -70.5,12},{-62,12}}, color={0,0,127}));

  connect(isOn.y, heaPum.N) annotation (Line(points={{-37.4,-10},{-30,-10},{-30,
          3},{-12,3}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),preferredView="info",Documentation(info="<HTML>
<p>
Base class for the calibration of water to water heat pump models. 
</p>
<p>
Source and load temperatures and flow rates are read from an external time table.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWaterToWater;
