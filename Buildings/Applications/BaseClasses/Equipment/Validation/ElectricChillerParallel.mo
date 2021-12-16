within Buildings.Applications.BaseClasses.Equipment.Validation;
model ElectricChillerParallel "Model that test electric chiller parallel"
  extends Modelica.Icons.Example;

  package Medium1 = Buildings.Media.Water "Medium model";
  package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.Power P_nominal=-per1.QEva_flow_nominal/per1.COP_nominal
    "Nominal compressor power (at y=1)";
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal=per1.mEva_flow_nominal
    "Nominal mass flow rate at evaporator";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=per1.mCon_flow_nominal
    "Nominal mass flow rate at condenser";

  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per1 "Chiller performance data"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_563kW_10_61COP_Vanes
    per2 "Chiller performance data"
    annotation (Placement(transformation(extent={{32,50},{52,70}})));
  Buildings.Applications.BaseClasses.Equipment.ElectricChillerParallel chiPar(
    num=2,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=mEva_flow_nominal,
    m2_flow_nominal=mCon_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    dpValve_nominal={6000,6000},
    per={per1,per2})
    "Chillers with identical nominal parameters but different performance curves"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium1,
    p=Medium1.p_default + 18E3,
    use_T_in=true,
    T=298.15,
    nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-80,-24},{-60,-4}})));
  Fluid.Sources.Boundary_pT sou2(
    redeclare package Medium = Medium2,
    p=Medium2.p_default + 18E3,
    use_T_in=true,
    T=291.15,
    nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1, nPorts=1) "Pressure boundary condition"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={70,10})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium2, nPorts=1) "Pressure boundary condition"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,-50})));
  Modelica.Blocks.Sources.Ramp TSet(
    duration=3600,
    startTime=3*3600,
    offset=273.15 + 10,
    height=8) "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    offset=273.15 + 20,
    duration=3600,
    startTime=2*3600) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    offset=273.15 + 15,
    height=5,
    startTime=3600,
    duration=3600) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{120,-36},{100,-16}})));
  Modelica.Blocks.Sources.Pulse pulse(period=3600/2)
   "Pulse input signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0.5)
    "Switch to switch chiller on or off"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium1,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{32,0},{52,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    dp_nominal=6000,
    redeclare package Medium = Medium2,
    m_flow_nominal=mEva_flow_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));

equation
  connect(chiPar.port_b1, res1.port_a)
    annotation (Line(points={{10,-14},{20,-14},{20,10},{32,10}},
                            color={0,127,255}));
  connect(res2.port_a, chiPar.port_b2)
    annotation (Line(points={{-20,-50},{-16,-50},{-16,-26},{-10,-26}},
                            color={0,127,255}));
  connect(greaterThreshold.y, chiPar.on[1])
    annotation (Line(points={{-19,60},{-16,60},{-16,-17},{-12,-17}},
      color={255,0,255}));
  connect(greaterThreshold.y, chiPar.on[2])
    annotation (Line(points={{-19,60},{-16,60},{-16,-15},{-12,-15}},
      color={255,0,255}));
  connect(TSet.y, chiPar.TSet)
    annotation (Line(points={{-59,30},{-28,30},{-28,-20},{-12,-20}},
      color={0,0,127}));

  connect(TCon_in.y, sou1.T_in) annotation (Line(
      points={{-99,-10},{-82,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEva_in.y, sou2.T_in) annotation (Line(
      points={{99,-26},{82,-26}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(greaterThreshold.u, pulse.y) annotation (Line(
      points={{-42,60},{-59,60}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(res1.port_b, sin1.ports[1]) annotation (Line(points={{52,10},{56,10},{
          56,10},{60,10}}, color={0,127,255}));
  connect(sou1.ports[1], chiPar.port_a1)
    annotation (Line(points={{-60,-14},{-10,-14}}, color={0,127,255}));
  connect(res2.port_b, sin2.ports[1]) annotation (Line(points={{-40,-50},{-50,-50},
          {-50,-50},{-60,-50}}, color={0,127,255}));
  connect(chiPar.port_a2, sou2.ports[1]) annotation (Line(points={{10,-26},{20,-26},
          {20,-30},{60,-30}}, color={0,127,255}));
  annotation (    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/BaseClasses/Equipment/Validation/ElectricChillerParallel.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates how the chiller parallel can operate under different performance curves.
</p>
</html>", revisions="<html>
<ul>
<li>
May 13, 2021, by Michael Wetter:<br/>
Changed boundary condition model to prescribed pressure rather than prescribed mass flow rate.
Prescribing the mass flow rate caused
unreasonably large pressure drop because the mass flow rate was forced through a closed valve.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2488\">#2488</a>.
</li>
<li>
July 10, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=14400,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ElectricChillerParallel;
