within Buildings.Fluid.HeatPumps.Validation;
model EquationFitWaterToWater_Static "example"
  package Medium = Buildings.Media.Water "Medium model";

   Buildings.Fluid.HeatPumps.EquationFitWaterToWater heaPum(
    per=per,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    dp1_nominal=200,
    dp2_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Water to Water heatpump"
     annotation (Placement(transformation(extent={{34,-10},
            {54,10}})));
    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
    "Evaporator nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
    "Condenser nominal mass flow rate";
    parameter Data.EquationFitWaterToWater.Trane_Axiom_EXW240 per
    "Water to water heat pump performance data "
     annotation (Placement(transformation(extent={{74,24},{94,44}})));
    Sources.MassFlowSource_T evaPum(
    m_flow=mEva_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium)
    "Evaporator water Pump"
     annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={79,-49})));
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
    Controls.OBC.CDL.Continuous.Sources.Ramp TConEnt(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=20 + 273.15,
    startTime=0)
    "Condesner entering water temperature"
     annotation (Placement(transformation(extent={{-116,76},{-96,96}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0)
    "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{72,-96},{92,-76}})));
    FixedResistances.PressureDrop  res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{66,66},{86,86}})));
    FixedResistances.PressureDrop  res2(
    redeclare package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{-4,-94},{16,
            -74}})));
    Modelica.Fluid.Sources.FixedBoundary heaVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for heating load"
     annotation (Placement(transformation(extent={{118,74},{98,94}})));
    Modelica.Fluid.Sources.FixedBoundary cooVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for cooling load"
     annotation (Placement(transformation(extent={{-54,-94},
            {-34,-74}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaSet(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0)
    "Evaporator setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,-60},
            {0,-40}})));
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
     annotation (Placement(transformation(extent={{-118,
            -10},{-98,10}})));
    Modelica.Blocks.Math.RealToInteger reaToInt
     annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(res1.port_b,heaVol. ports[1])
   annotation (Line(points={{86,76},{98,76},{98,84}}, color={0,127,255}));
  connect(cooVol.ports[1],res2. port_a)
   annotation (Line(points={{-34,-84},{-4,-84}},  color={0,127,255}));
  connect(res2.port_b, heaPum.port_b2)
   annotation (Line(points={{16,-84},{30,-84},{30,-6},{34,-6}},
                                 color={0,127,255}));
  connect(TEvaSet.y, heaPum.TEvaSet)
   annotation (Line(points={{1,-50},{22,-50},{22,-9},{32.6,-9}},
                              color={0,0,127}));
  connect(TEvaEnt.y, evaPum.T_in) annotation (Line(points={{93,-86},{104,-86},{104,
          -53.4},{92.2,-53.4}}, color={0,0,127}));
  connect(evaPum.ports[1], heaPum.port_a2)
   annotation (Line(points={{68,-49},{62,-49},{62,-6},{54,-6}},
                                    color={0,127,255}));
  connect(heaPum.port_a1, conPum.ports[1])
   annotation (Line(points={{34,6},{30,6},{30,90},{-40,90}},
                                color={0,127,255}));
  connect(TConSet.y, heaPum.TConSet)
   annotation (Line(points={{1,70},{22,70},{22,9},{32.6,9}},color={0,0,127}));
  connect(res1.port_a, heaPum.port_b1)
   annotation (Line(points={{66,76},{54,76},{54,6}},
                          color={0,127,255}));
  connect(TConEnt.y, conPum.T_in)
   annotation (Line(points={{-95,86},{-62,86}}, color={0,0,127}));
  connect(uMod.y, reaToInt.u)
   annotation (Line(points={{-97,0},{-62,0}}, color={0,0,127}));
  connect(reaToInt.y, heaPum.uMod)
   annotation (Line(points={{-39,0},{32.6,0}}, color={255,127,0}));
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
