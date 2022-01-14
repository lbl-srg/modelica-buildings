within Buildings.Fluid.HeatPumps.Calibration.BaseClasses;
model PartialWaterToWater
  "Partial model for calibration of water to water heat pumps"

  replaceable package Medium1 = Modelica.Media.Interfaces.PartialMedium
    "Medium model at the condenser side";

  replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium
    "Medium model at the evaporator side";

  replaceable package ref = Buildings.Media.Refrigerants.R410A
    "Refrigerant model";

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Nominal mass flow rate on condenser side";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal
    "Nominal mass flow rate on evaporator side";

  parameter Modelica.Units.SI.Pressure dp1_nominal=1000
    "Pressure drop at nominal mass flow rate on condenser side";
  parameter Modelica.Units.SI.Pressure dp2_nominal=1000
    "Pressure drop at nominal mass flow rate on evaporator side";

  parameter Modelica.Units.SI.ThermalConductance UACon
    "Thermal conductance of condenser";

  parameter Modelica.Units.SI.ThermalConductance UAEva
    "Thermal conductance of evaporator";

  Modelica.Blocks.Sources.CombiTimeTable calDat(
    tableOnFile=true,
    columns=2:5)
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Modelica.Blocks.Routing.DeMultiplex4 splDat
    "De-multiplex"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare final package Medium = Medium2,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-50,-40})));
  Modelica.Fluid.Sources.MassFlowSource_T Sou(
    redeclare final package Medium = Medium2,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true)
    "Mass flow source"
    annotation (Placement(transformation(extent={{60,-16},{40,4}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare final package Medium = Medium1,
    nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}}, origin={50,30})));

  Modelica.Fluid.Sources.MassFlowSource_T loa(
    redeclare final package Medium = Medium1,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true) "Mass flow source"
    annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));

  replaceable Buildings.Fluid.HeatPumps.BaseClasses.PartialWaterToWater heaPum
    constrainedby Buildings.Fluid.HeatPumps.BaseClasses.PartialWaterToWater(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    redeclare final package ref = ref,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    enable_variable_speed=false,
    show_T=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.IntegerConstant isOn(k=1)
    "Control signal"
    annotation (Placement(transformation(extent={{-50,-16},{-38,-4}})));

equation
  connect(calDat.y, splDat.u)
    annotation (Line(points={{-119,10},{-119,10},{-102,10}}, color={0,0,127}));
  connect(splDat.y1[1], Sou.T_in) annotation (Line(points={{-79,19},{-76,19},{-76,
          84},{92,84},{92,-2},{62,-2}}, color={0,0,127}));
  connect(splDat.y3[1], Sou.m_flow_in) annotation (Line(points={{-79,7},{-72,7},
          {-72,80},{88,80},{88,2},{60,2}}, color={0,0,127}));
  connect(splDat.y4[1],loa.m_flow_in)  annotation (Line(points={{-79,1},{-75.5,1},
          {-75.5,16},{-60,16}}, color={0,0,127}));
  connect(loa.ports[1], heaPum.port_a1) annotation (Line(points={{-40,8},{-40,8},
          {-30,8},{-20,8},{-20,6},{-10,6}}, color={0,127,255}));
  connect(sin2.ports[1], heaPum.port_b2) annotation (Line(points={{-40,-40},{
          -20,-40},{-20,-6},{-10,-6}},
                                   color={0,127,255}));
  connect(Sou.ports[1], heaPum.port_a2)
    annotation (Line(points={{40,-6},{26,-6},{10,-6}}, color={0,127,255}));
  connect(sin1.ports[1], heaPum.port_b1) annotation (Line(points={{40,30},{20,
          30},{20,6},{10,6}},
                          color={0,127,255}));
  connect(splDat.y2[1],loa.T_in)  annotation (Line(points={{-79,13},{-70.5,13},{
          -70.5,12},{-62,12}}, color={0,0,127}));

  connect(isOn.y, heaPum.stage) annotation (Line(points={{-37.4,-10},{-24,-10},
          {-24,3},{-12,3}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,
            100}})),                                 preferredView="info",Documentation(info="<HTML>
<p>
Base class for the calibration of water to water heat pump models.
</p>
<p>
Source and load temperatures and flow rates are read from an external time table.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for 
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
October 31, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWaterToWater;
