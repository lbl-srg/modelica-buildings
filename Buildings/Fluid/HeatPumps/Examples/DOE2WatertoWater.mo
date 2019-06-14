within Buildings.Fluid.HeatPumps.Examples;
model DOE2WatertoWater
 extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water "Medium model";

  DOE2WaterToWater                           heaPum(redeclare package Medium1 =
        Medium, redeclare package Medium2 = Medium,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=per)
    annotation (Placement(transformation(extent={{20,-12},{40,8}})));

 parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
       "Nominal mass flow rate";
 parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
       "Nominal mass flow rate";

  Sources.FixedBoundary cooBui(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-52,-94},{-32,-74}})));
  Sources.FixedBoundary heaBui(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{102,-2},{82,18}})));
  Sources.MassFlowSource_T evaPum(
    m_flow=0.5*mEva_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={58,-36})));
  Sources.MassFlowSource_T conPum(
    m_flow=0.5*mCon_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-38,92})));
  FixedResistances.PressureDrop                 res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{46,-2},{66,18}})));
  FixedResistances.PressureDrop                 res2(
    redeclare package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{-24,-94},{-4,-74}})));

//   Buildings.Fluid.HeatPumps.WaterSourceHeatPump heaPum1
//     annotation (Placement(transformation(extent={{32,24},{52,44}})));

  Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=10,
    duration(displayUnit="h") = 3600,
    offset=-5,
    startTime=0)      annotation (Placement(transformation(extent={{-98,-14},{-84,
            0}})));
  Controls.OBC.CDL.Continuous.LessEqualThreshold           lesEquThr(threshold=
        -1) annotation (Placement(transformation(extent={{-70,16},{-56,30}})));
  Controls.OBC.CDL.Continuous.GreaterEqualThreshold           greEquThr(threshold=
       1)
    annotation (Placement(transformation(extent={{-68,-44},{-54,-30}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt(integerTrue=
        -1)
    annotation (Placement(transformation(extent={{-44,16},{-30,30}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt1
    annotation (Placement(transformation(extent={{-44,-44},{-30,-30}})));
  Controls.OBC.CDL.Integers.Add           heaMod
    annotation (Placement(transformation(extent={{-16,-10},{-4,2}})));

  Controls.OBC.CDL.Continuous.Sources.Ramp     TSet_HeatingWater(
    height=5,
    duration(displayUnit="h") = 3600,
    offset=40 + 273.15)
    annotation (Placement(transformation(extent={{-18,42},{-2,58}})));
  Modelica.Blocks.Sources.Ramp             TCon_Ent(
    height=5,
    duration(displayUnit="h") = 3600,
    offset=35 + 273.15)
    annotation (Placement(transformation(extent={{-76,70},{-62,84}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TEva_ent(
    height=5,
    duration(displayUnit="h") = 3600,
    offset=11 + 273.15)
    annotation (Placement(transformation(extent={{72,-66},{86,-52}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp     TSet_ChilledWater(
    height=5,
    duration(displayUnit="h") = 3600,
    offset=7 + 273.15)
    annotation (Placement(transformation(extent={{-20,-58},{-4,-42}})));
  parameter
    Data.DOE2WaterToWater.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes per
    annotation (Placement(transformation(extent={{44,58},{74,88}})));
equation
  connect(evaPum.ports[1], heaPum.port_a2)
    annotation (Line(points={{48,-36},{40,-36},{40,-8}}, color={0,127,255}));
  connect(heaPum.port_a1, conPum.ports[1]) annotation (Line(points={{20,4},{18,4},
          {18,92},{-28,92}}, color={0,127,255}));
  connect(heaPum.port_b1, res1.port_a)
    annotation (Line(points={{40,4},{40,6},{46,6},{46,8}},
                                             color={0,127,255}));
  connect(res1.port_b, heaBui.ports[1])
    annotation (Line(points={{66,8},{82,8}}, color={0,127,255}));
  connect(heaPum.port_b2, res2.port_b) annotation (Line(points={{20,-8},{8,-8},{
          8,-84},{-4,-84}},     color={0,127,255}));
  connect(res2.port_a, cooBui.ports[1])
    annotation (Line(points={{-24,-84},{-32,-84}}, color={0,127,255}));

  connect(ram.y,lesEquThr. u) annotation (Line(points={{-83.3,-7},{-78,-7},{-78,
          23},{-71.4,23}},
                     color={0,0,127}));
  connect(ram.y,greEquThr. u) annotation (Line(points={{-83.3,-7},{-80,-7},{-80,
          -8},{-78,-8},{-78,-37},{-69.4,-37}},
                      color={0,0,127}));
  connect(lesEquThr.y,booToInt. u)
    annotation (Line(points={{-55.3,23},{-45.4,23}},
                                                color={255,0,255}));
  connect(greEquThr.y,booToInt1. u)
    annotation (Line(points={{-53.3,-37},{-45.4,-37}},    color={255,0,255}));
  connect(booToInt1.y,heaMod. u2) annotation (Line(points={{-29.3,-37},{-26,-37},
          {-26,-8},{-22,-8},{-22,-7.6},{-17.2,-7.6}},
                           color={255,127,0}));
  connect(booToInt.y,heaMod. u1) annotation (Line(points={{-29.3,23},{-24,23},{-24,
          -0.4},{-17.2,-0.4}},
                   color={255,127,0}));
  connect(heaMod.y, heaPum.heaPumMod) annotation (Line(points={{-3.4,-4},{10,-4},
          {10,-11.5},{18.7,-11.5}}, color={255,127,0}));
  connect(TSet_HeatingWater.y, heaPum.TConSet)
    annotation (Line(points={{-1.2,50},{16,50},{16,7},{19.4,7}},
                                                            color={0,0,127}));
  connect(TCon_Ent.y, conPum.T_in)
    annotation (Line(points={{-61.3,77},{-50,77},{-50,88}}, color={0,0,127}));
  connect(TEva_ent.y, evaPum.T_in) annotation (Line(points={{86.7,-59},{96,-59},
          {96,-40},{70,-40}},  color={0,0,127}));
  connect(TSet_ChilledWater.y, heaPum.TEvaSet) annotation (Line(points={{-3.2,-50},
          {16,-50},{16,-1.9},{18.7,-1.9}}, color={0,0,127}));
   annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/DOE2WaterToWater.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
Example that simulates a water to water heatpump whose efficiency is computed based on the
condenser entering and evaporator leaving fluid temperature.
A bicubic polynomial is used to compute the heatpump part load performance.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 10, 2019, by Hagar Elarga:<br/>
Refactored model to include heating and simultaneous heating and cooling modes
</li>

<li>
November 25, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2WatertoWater;
