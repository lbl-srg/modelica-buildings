within Buildings.Fluid.HeatPumps.Validation;
model EquationFitWaterToWater_Static "example"
  package Medium = Buildings.Media.Water "Medium model";

    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
    "Evaporator nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
    "Condenser nominal mass flow rate";
    parameter Data.EquationFitWaterToWater.Trane_Axiom_EXW240 per
    "Water to water heat pump performance data "
     annotation (Placement(transformation(extent={{74,24},{94,44}})));

    Buildings.Fluid.HeatPumps.EquationFitWaterToWater heaPum(
      per=per,
      scaling_factor=1,
      redeclare package Medium1 = Medium,
      redeclare package Medium2 = Medium,
      show_T=true,
      dp1_nominal=200,
      dp2_nominal=200,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Water to Water heatpump"
     annotation (Placement(transformation(extent={{34,-10},{54,10}})));
    Sources.MassFlowSource_T evaPum(
      m_flow=mEva_flow_nominal,
      nPorts=1,
      use_T_in=true,
      redeclare package Medium = Medium)
    "Evaporator water pump"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                    rotation=180,origin={86,-20})));
    Sources.MassFlowSource_T conPum(
      m_flow=mCon_flow_nominal,
      nPorts=1,
      use_T_in=true,
      redeclare package Medium = Medium)
    "Condenser water pump"
     annotation (Placement(transformation(extent={{10,-10},{-10,10}},
                    rotation=180,origin={-50,70})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TConEnt(
      height=20,
      duration(displayUnit="h") = 14400,
      offset=20 + 273.15,
      startTime=0)
    "Condesner entering water temperature"
     annotation (Placement(transformation(extent={{-106,56},{-86,76}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
      height=4,
      duration(displayUnit="h") = 14400,
      offset=12 + 273.15,
      startTime=0)
    "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
    FixedResistances.PressureDrop  res1(
      redeclare package Medium = Medium,
      m_flow_nominal=mCon_flow_nominal,
      dp_nominal=6000)
      "Flow resistance"
     annotation (Placement(transformation(extent={{68,58},{88,78}})));
    FixedResistances.PressureDrop  res2(
      redeclare package Medium = Medium,
      m_flow_nominal=mEva_flow_nominal,
      dp_nominal=6000)
      "Flow resistance"
     annotation (Placement(transformation(extent={{26,-80},{6,-60}})));
    Modelica.Fluid.Sources.FixedBoundary heaVol(
      nPorts=1,
      redeclare package Medium = Medium)
    "Volume for heating load"
     annotation (Placement(transformation(extent={{118,58},{98,78}})));
    Modelica.Fluid.Sources.FixedBoundary cooVol(
      redeclare package Medium = Medium,
      nPorts=1)
    "Volume for cooling load"
     annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
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
      offset=40 + 273.15,
      startTime=0)
    "Condenser setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
      height=2,
      duration(displayUnit="h") = 14400,
      offset=-1,
      startTime=0)
    "HeatPump operational mode input signal"
     annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
    Modelica.Blocks.Math.RealToInteger reaToInt
     annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(res1.port_b,heaVol. ports[1])
  annotation (Line(points={{88,68},{98,68}},color={0,127,255}));
  connect(TEvaSet.y, heaPum.TEvaSet)
  annotation (Line(points={{2,-30},{22,-30},{22,-9},{34.5455,-9}}, color={0,0,127}));
  connect(evaPum.ports[1], heaPum.port_a2)
  annotation (Line(points={{76,-20},{56,-20},{56,-6},{54,-6}},color={0,127,255}));
  connect(heaPum.port_a1, conPum.ports[1])
  annotation (Line(points={{35.8182,6},{30,6},{30,70},{-40,70}}, color={0,127,255}));
  connect(TConSet.y, heaPum.TConSet)
  annotation (Line(points={{2,30},{22,30},{22,9},{34.5455,9}},color={0,0,127}));
  connect(res1.port_a, heaPum.port_b1)
  annotation (Line(points={{68,68},{54,68},{54,6}}, color={0,127,255}));
  connect(TConEnt.y, conPum.T_in)
  annotation (Line(points={{-84,66},{-62,66}}, color={0,0,127}));
  connect(uMod.y, reaToInt.u)
  annotation (Line(points={{-86,0},{-62,0}}, color={0,0,127}));
  connect(reaToInt.y, heaPum.uMod)
  annotation (Line(points={{-39,0},{34.5455,0}},color={255,127,0}));
  connect(cooVol.ports[1], res2.port_b)
  annotation (Line(points={{-40,-70},{6,-70}}, color={0,127,255}));
  connect(heaPum.port_b2, res2.port_a)
  annotation (Line(points={{35.8182,-6},{32,-6},{32,-70},{26,-70}}, color={0,127,255}));
  connect(TEvaEnt.y, evaPum.T_in)
  annotation (Line(points={{82,-70},{112,-70},{112,-24},{98,-24}},  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
     __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/EquationFitWaterToWater_Static.mos"
           "Simulate and plot"),experiment(Tolerance=1e-6, StopTime=14400),
Documentation(info="<html>
  <p>
  Model that demonstrates the use of <a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitWaterToWater\">
  Buildings.Fluid.HeatPumps.EquationFitWaterToWater </a> heat pump model implementing steady state energy and mass balance.
  The heat pump power, condenser heat transfer rate and evaporator heat transfer rate are calculated for given leaving water
    temperatures and mass flow rates on the evaporator and condenser sides.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  May 3, 2019, by Hagar Elarga:<br/>
  First implementation.
   </li>
   </ul>
 </html>"));
end EquationFitWaterToWater_Static;
