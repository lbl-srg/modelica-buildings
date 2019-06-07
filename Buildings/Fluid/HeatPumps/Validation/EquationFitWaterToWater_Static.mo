within Buildings.Fluid.HeatPumps.Validation;
model EquationFitWaterToWater_Static "example"

 package Medium = Buildings.Media.Water "Medium model";

  Buildings.Fluid.HeatPumps.EquationFitWaterToWater heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    dp1_nominal=200,
    dp2_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per)
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));

    parameter Data.EquationFitWaterToWater.Trane_Axiom_EXW240 per
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
       "Nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
       "Nominal mass flow rate";

  Sources.MassFlowSource_T Con_heatingWater(
    use_m_flow_in=false,
    m_flow=mCon_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={-44,92})));

  Controls.OBC.CDL.Continuous.Sources.Ramp TCon_Ent(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=20 + 273.15,
    startTime=0)
    annotation (Placement(transformation(extent={{-98,78},{-80,96}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TEva_ent(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0)
    annotation (Placement(transformation(extent={{64,-96},{78,-82}})));
  Sources.MassFlowSource_T Eva_chilledWater(
    m_flow=mEva_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=180,
        origin={70,-50})));
  FixedResistances.PressureDrop                 res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{64,80},{84,100}})));
  Sources.FixedBoundary heating_blg(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{100,82},{86,98}})));
  Sources.FixedBoundary cooling_building(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-58,-98},{-42,-82}})));
  FixedResistances.PressureDrop   res2(
    redeclare package Medium = Medium,
     m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

  Controls.OBC.CDL.Continuous.Sources.Ramp     TSet_ChilledWater(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0)
    annotation (Placement(transformation(extent={{-16,-58},{0,-42}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp     TSet_HeatingWater(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=40 + 273.15,
    startTime=0)
    annotation (Placement(transformation(extent={{-16,42},{0,58}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=10,
    duration(displayUnit="h") = 14400,
    offset=-5,
    startTime=0)
    annotation (Placement(transformation(extent={{-96,-10},{-82,4}})));
  Controls.OBC.CDL.Continuous.LessEqualThreshold           lesEquThr(threshold=-1)
            annotation (Placement(transformation(extent={{-68,20},{-54,34}})));
  Controls.OBC.CDL.Continuous.GreaterEqualThreshold           greEquThr(threshold=1)
    annotation (Placement(transformation(extent={{-66,-40},{-52,-26}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt(integerTrue=-1)
    annotation (Placement(transformation(extent={{-42,20},{-28,34}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt1
    annotation (Placement(transformation(extent={{-42,-40},{-28,-26}})));
  Controls.OBC.CDL.Integers.Add           addInt
    annotation (Placement(transformation(extent={{-12,-6},{0,6}})));

equation

  connect(heaPum.port_a1, Con_heatingWater.ports[1])
    annotation (Line(points={{32,6},{24,6},{24,92},{-36,92}},
                                                        color={0,127,255}));
  connect(TCon_Ent.y, Con_heatingWater.T_in) annotation (Line(points={{-79.1,87},{-66,87},{-66,88.8},{-53.6,88.8}},
                                      color={0,0,127}));
  connect(TEva_ent.y, Eva_chilledWater.T_in)
    annotation (Line(points={{78.7,-89},{98,-89},{98,-53.2},{79.6,-53.2}},
                                                 color={0,0,127}));
  connect(Eva_chilledWater.ports[1], heaPum.port_a2)
    annotation (Line(points={{62,-50},{56,-50},{56,-6},{52,-6}},
                                                         color={0,127,255}));
  connect(heating_blg.ports[1], res1.port_b)
    annotation (Line(points={{86,90},{84,90}}, color={0,127,255}));
  connect(cooling_building.ports[1], res2.port_a)
    annotation (Line(points={{-42,-90},{-10,-90}}, color={0,127,255}));
  connect(res1.port_a, heaPum.port_b1)
    annotation (Line(points={{64,90},{58,90},{58,6},{52,6}},
                                                       color={0,127,255}));
  connect(res2.port_b, heaPum.port_b2)
    annotation (Line(points={{10,-90},{24,-90},{24,-6},{32,-6}},  color={0,127,255}));
  connect(TSet_HeatingWater.y, heaPum.TConSet)
    annotation (Line(points={{0.8,50},{16,50},{16,9},{30,9}},
                                                            color={0,0,127}));
  connect(TSet_ChilledWater.y, heaPum.TEvaSet) annotation (Line(points={{0.8,-50},
          {16,-50},{16,-9},{30,-9}},
                                   color={0,0,127}));
  connect(ram.y, lesEquThr.u) annotation (Line(points={{-81.3,-3},{-76,-3},{-76,
          27},{-69.4,27}}, color={0,0,127}));
  connect(ram.y, greEquThr.u) annotation (Line(points={{-81.3,-3},{-78,-3},{-78,
          -4},{-76,-4},{-76,-33},{-67.4,-33}}, color={0,0,127}));
  connect(lesEquThr.y,booToInt. u)
    annotation (Line(points={{-53.3,27},{-43.4,27}},
                                                color={255,0,255}));
  connect(greEquThr.y,booToInt1. u)
    annotation (Line(points={{-51.3,-33},{-43.4,-33}},    color={255,0,255}));
  connect(booToInt1.y,addInt. u2) annotation (Line(points={{-27.3,-33},{-24,-33},
          {-24,-4},{-20,-4},{-20,-3.6},{-13.2,-3.6}},
                           color={255,127,0}));
  connect(booToInt.y,addInt. u1) annotation (Line(points={{-27.3,27},{-22,27},{
          -22,3.6},{-13.2,3.6}},
                   color={255,127,0}));
  connect(addInt.y, heaPum.uMod)
  annotation (Line(points={{0.6,0},{30,0}},  color={255,127,0}));


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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
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
