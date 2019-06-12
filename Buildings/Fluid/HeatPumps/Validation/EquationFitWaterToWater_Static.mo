within Buildings.Fluid.HeatPumps.Validation;
model EquationFitWaterToWater_Static "example"
  import Buildings;

 package Medium = Buildings.Media.Water "Medium model";

    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
       "Nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
       "Nominal mass flow rate";

  parameter Data.EquationFitWaterToWater.Trane_Axiom_EXW240 per
    annotation (Placement(transformation(extent={{74,24},{94,44}})));

  Controls.OBC.CDL.Continuous.Sources.Ramp TCon_Ent(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=20 + 273.15,
    startTime=0) "Condesner entering water temperature"
    annotation (Placement(transformation(extent={{-116,76},{-96,96}})));
  FixedResistances.PressureDrop                 res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{66,66},{86,86}})));
  Sources.FixedBoundary heaVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for heating load"
    annotation (Placement(transformation(extent={{118,74},{98,94}})));
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
    annotation (Placement(transformation(extent={{38,-12},{58,8}})));
  Sources.FixedBoundary cooVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for cooling load"
    annotation (Placement(transformation(extent={{-54,-96},{-34,-76}})));
  FixedResistances.PressureDrop   res2(
    redeclare package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{-4,-96},{16,-76}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TSetCoo(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0) "Evaporator setpoint water temperature"
    annotation (Placement(transformation(extent={{-14,-62},{6,-42}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
    height=10,
    duration(displayUnit="h") = 14400,
    offset=-5,
    startTime=0) "HeatPump operational mode input signal"
    annotation (Placement(transformation(extent={{-120,-12},{-100,8}})));
  Controls.OBC.CDL.Continuous.GreaterEqualThreshold           greEquThr(threshold=
       1)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt1
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Controls.OBC.CDL.Integers.Add           addInt
    annotation (Placement(transformation(extent={{-2,-12},{18,8}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TEva_ent(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0) "Evaporator entering water temperature"
    annotation (Placement(transformation(extent={{72,-96},{92,-76}})));
  Sources.MassFlowSource_T evaPum(
    m_flow=mEva_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium) "Evaporator water Pump"
                                       annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={79,-49})));
  Controls.OBC.CDL.Continuous.LessEqualThreshold           lesEquThr(threshold=
        -1) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt(integerTrue=
        -1)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Sources.MassFlowSource_T conPum(
    use_m_flow_in=false,
    m_flow=mCon_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium) "Condenser water Pump"
                                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,90})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TSetHea(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=40 + 273.15,
    startTime=0) "Condenser setpoint water temperature"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

equation


  connect(res1.port_b,heaVol. ports[1])
    annotation (Line(points={{86,76},{98,76},{98,84}}, color={0,127,255}));
  connect(cooVol.ports[1],res2. port_a)
    annotation (Line(points={{-34,-86},{-4,-86}},  color={0,127,255}));
  connect(res2.port_b, heaPum.port_b2) annotation (Line(points={{16,-86},{30,
          -86},{30,-8},{38,-8}}, color={0,127,255}));
  connect(TSetCoo.y, heaPum.TEvaSet) annotation (Line(points={{7,-52},{22,-52},{
          22,-11},{31.8,-11}},color={0,0,127}));
  connect(uMod.y,greEquThr. u) annotation (Line(points={{-99,-2},{-94,-2},{-94,
          -30},{-82,-30}}, color={0,0,127}));
  connect(greEquThr.y,booToInt1. u)
    annotation (Line(points={{-59,-30},{-42,-30}},        color={255,0,255}));
  connect(booToInt1.y,addInt. u2) annotation (Line(points={{-19,-30},{-12,-30},
          {-12,-8},{-4,-8}},
                           color={255,127,0}));
  connect(addInt.y, heaPum.uMod)
    annotation (Line(points={{19,-2},{26,-2},{26,-1.8},{32,-1.8}},
                                               color={255,127,0}));
  connect(TEva_ent.y,evaPum. T_in) annotation (Line(points={{93,-86},{104,-86},
          {104,-53.4},{92.2,-53.4}},
                                   color={0,0,127}));
  connect(evaPum.ports[1], heaPum.port_a2) annotation (Line(points={{68,-49},{
          62,-49},{62,-8},{58,-8}}, color={0,127,255}));
  connect(heaPum.port_a1, conPum.ports[1]) annotation (Line(points={{38,4},{30,
          4},{30,90},{-40,90}}, color={0,127,255}));
  connect(TSetHea.y, heaPum.TConSet)
    annotation (Line(points={{1,70},{22,70},{22,7},{32,7}}, color={0,0,127}));
  connect(lesEquThr.y, booToInt.u)
    annotation (Line(points={{-59,30},{-42,30}}, color={255,0,255}));
  connect(uMod.y, lesEquThr.u) annotation (Line(points={{-99,-2},{-94,-2},{-94,
          30},{-82,30}}, color={0,0,127}));
  connect(res1.port_a, heaPum.port_b1) annotation (Line(points={{66,76},{58,76},
          {58,4},{58,4}}, color={0,127,255}));
  connect(booToInt.y, addInt.u1) annotation (Line(points={{-19,30},{-12,30},{
          -12,4},{-4,4}}, color={255,127,0}));
  connect(TCon_Ent.y,conPum. T_in) annotation (Line(points={{-95,86},{-62,86}},
                                   color={0,0,127}));
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
                           Diagram(graphics,
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
