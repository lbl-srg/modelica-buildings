within Buildings.Fluid.HeatPumps.Validation;
model EquationFitWaterToWater_Dynamic "example"
 package Medium = Buildings.Media.Water "Medium model";

  parameter Data.EquationFitWaterToWater.Trane_Axiom_EXW240 per
   "Water to water heat pump performance data"
    annotation (Placement(transformation(extent={{-92,-80},{-72,-60}})));
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
   "Evaporator nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
   "Condenser nominal mass flow rate";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
   "Type of energy balance: dynamic (3 initialization options) or steady state";
  parameter Modelica.Fluid.Types.Dynamics massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
   "Type of mass balance: dynamic (3 initialization options) or steady state";

  EquationFitWaterToWater heaPum(
    per=per,
    scaling_factor=1,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    dp1_nominal=200,
    dp2_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Water to Water heatpump model"
     annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Sources.MassFlowSource_T conPum(
    use_m_flow_in=false,
    m_flow=mCon_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium)
    "Condenser water pump"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,70})));
  Sources.MassFlowSource_T evaPum(
    m_flow=mEva_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium)
    "Evaporator water pump"
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={74,-6})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TConEnt(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=20 + 273.15,
    startTime=0)
    "Condesner entering water temperature"
     annotation (Placement(transformation(extent={{-80,56},{-60,76}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0)
    "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{60,-58},{80,-38}})));
  Modelica.Fluid.Sources.FixedBoundary cooVol(
    nPorts=1,
    redeclare package Medium = Medium)
    "Volume for cooling load"
     annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Fluid.Sources.FixedBoundary heaVol(
    nPorts=1,
    redeclare package Medium = Medium)
    "Volume for heating load"
     annotation (Placement(transformation(extent={{112,60},{92,80}})));
  FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{-22,-80},{-2,-60}})));
  FixedResistances.PressureDrop   res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TEvaSet(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0)
    "Evaporator setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TConSet(
    height=20,
    duration(displayUnit="h") = 14400,
    offset= 40 + 273.15,
    startTime=0)
    "Condenser setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
    height=2,
    duration(displayUnit="h") = 14400,
    offset=-1,
    startTime=0)
    "HeatPump operational mode input signal"
     annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
equation
  connect(heaPum.port_a1,conPum. ports[1])
  annotation (Line(points={{33.8182,6},{24,6},{24,70},{-20,70}}, color={0,127,255}));
  connect(TConEnt.y, conPum.T_in)
  annotation (Line(points={{-58,66},{-42,66}}, color={0,0,127}));
  connect(cooVol.ports[1],res2. port_a)
  annotation (Line(points={{-40,-70},{-22,-70}}, color={0,127,255}));
  connect(res2.port_b, heaPum.port_b2)
  annotation (Line(points={{-2,-70},{24,-70},{24,-6},{33.8182,-6}},color={0,127,255}));
  connect(TConSet.y, heaPum.TConSet)
  annotation (Line(points={{2,30},{16,30},{16,9},{32.5455,9}}, color={0,0,127}));
  connect(TEvaSet.y, heaPum.TEvaSet)
  annotation (Line(points={{2,-30},{16,-30},{16,-9},{32.5455,-9}},color={0,0,127}));
  connect(res1.port_a, heaPum.port_b1)
  annotation (Line(points={{60,70},{52,70},{52,6}}, color={0,127,255}));
  connect(res1.port_b,heaVol. ports[1])
  annotation (Line(points={{80,70},{92,70}}, color={0,127,255}));
  connect(TEvaEnt.y, evaPum.T_in)
  annotation (Line(points={{82,-48},{98,-48},{98,-10},{86,-10}}, color={0,0,127}));
  connect(evaPum.ports[1], heaPum.port_a2)
  annotation (Line(points={{64,-6},{52,-6}},color={0,127,255}));
  connect(uMod.y, reaToInt.u)
  annotation (Line(points={{-58,0},{-46,0}}, color={0,0,127}));
  connect(reaToInt.y, heaPum.uMod)
  annotation (Line(points={{-23,0},{32.5455,0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-102},{100,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
                           Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,
            100}})),
            __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/EquationFitWaterToWater_Dynamic.mos"
           "Simulate and plot"),experiment(Tolerance=1e-6, StopTime=14400),
 Documentation(info="<html>
  <p>
  Model that demonstrates the use of the <a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitWaterToWater\">
  Buildings.Fluid.HeatPumps.EquationFitWaterToWater </a> heat pump model implementing dynamic energy and mass balance.
  <p>
  The heat pump power, condenser heat transfer rate and evaporator heat transfer rate are calculated for given
  leaving water temperatures and flow rates on the evaporator and condenser sides.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
May 3, 2019, by Hagar Elarga:<br/>
First implementation.
  </li>
  </ul>
  </html>"));
end EquationFitWaterToWater_Dynamic;