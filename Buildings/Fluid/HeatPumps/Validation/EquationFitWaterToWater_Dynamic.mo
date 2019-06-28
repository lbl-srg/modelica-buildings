within Buildings.Fluid.HeatPumps.Validation;
model EquationFitWaterToWater_Dynamic "example"
 package Medium = Buildings.Media.Water "Medium model";

  EquationFitWaterToWater heaPum(
    per=per,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    dp1_nominal=200,
    dp2_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    massDynamics=massDynamics)
    "Water to Water heatpump"
     annotation (Placement(transformation(extent={{32,-10},{52,10}})));

  parameter Data.EquationFitWaterToWater.Trane_Axiom_EXW240 per
   "Water to water heat pump performance data"
     annotation (Placement(transformation(extent={{72,22},{92,42}})));
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
   "Evaporator nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
    "Condenser nominal mass flow rate";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state";
  parameter Modelica.Fluid.Types.Dynamics massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of mass balance: dynamic (3 initialization options) or steady state";

  Sources.MassFlowSource_T conPum(
    use_m_flow_in=false,
    m_flow=mCon_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium)
    "Condenser water Pump"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,90})));
  Sources.MassFlowSource_T evaPum(
    m_flow=mEva_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium)
    "Evaporator water Pump"
     annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={73,-47})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TConEnt(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=20 + 273.15,
    startTime=0)
    "Condesner entering water temperature"
     annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0)
    "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{66,-94},{86,-74}})));
  Modelica.Fluid.Sources.FixedBoundary cooVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for cooling load"
     annotation (Placement(transformation(extent={{-60,-94},{-40,-74}})));
  Modelica.Fluid.Sources.FixedBoundary heaVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for heating load"
     annotation (Placement(transformation(extent={{106,74},{86,94}})));
  FixedResistances.PressureDrop   res2(
    redeclare package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{-10,-94},{10,-74}})));
  FixedResistances.PressureDrop   res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{58,56},{78,76}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TEvaSet(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0)
    "Evaporator setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TConSet(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=40 + 273.15,
    startTime=0)
    "Condenser setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
    height=2,
    duration(displayUnit="h") = 14400,
    offset=-1,
    startTime=0)
    "HeatPump operational mode input signal"
     annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
     annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(heaPum.port_a1,conPum. ports[1])
   annotation (Line(points={{32,6},{24,
          6},{24,90},{-40,90}}, color={0,127,255}));
  connect(TConEnt.y, conPum.T_in) annotation (Line(points={{-99,90},{-68,90},{-68,
          86},{-62,86}}, color={0,0,127}));
  connect(cooVol.ports[1],res2. port_a)
   annotation (Line(points={{-40,-84},{-10,-84}}, color={0,127,255}));
  connect(res2.port_b, heaPum.port_b2)
   annotation (Line(points={{10,-84},{24,-84},{24,-6},{32,-6}},  color={0,127,255}));
  connect(TConSet.y, heaPum.TConSet)
   annotation (Line(points={{1,70},{16,70},{16,9},{30.6,9}},color={0,0,127}));
  connect(TEvaSet.y, heaPum.TEvaSet)
   annotation (Line(points={{1,-50},{16,-50},{
          16,-9},{30.6,-9}},color={0,0,127}));
  connect(res1.port_a, heaPum.port_b1)
   annotation (Line(points={{58,66},{52,66},{52,6}},  color={0,127,255}));
  connect(res1.port_b,heaVol. ports[1])
   annotation (Line(points={{78,66},{86,66},{86,84}}, color={0,127,255}));
  connect(TEvaEnt.y, evaPum.T_in) annotation (Line(points={{87,-84},{98,-84},{98,
          -51.4},{86.2,-51.4}}, color={0,0,127}));
  connect(evaPum.ports[1], heaPum.port_a2)
   annotation (Line(points={{62,-47},{
          56,-47},{56,-6},{52,-6}}, color={0,127,255}));
  connect(uMod.y, reaToInt.u)
   annotation (Line(points={{-99,0},{-62,0}}, color={0,0,127}));
  connect(reaToInt.y, heaPum.uMod)
   annotation (Line(points={{-39,0},{30.6,0}}, color={255,127,0}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
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
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,
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
