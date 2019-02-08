within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model NonIntegrated "Non-integrated WSE  in a chilled water system"
  extends Modelica.Icons.Example;
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses.PartialPlant(
    sou1(nPorts=2, m_flow=2*mCW_flow_nominal),
    sin1(nPorts=2),
    TSet(k=273.15 + 5.56),
    TEva_in(k=273.15 + 15.28),
    onWSE(startTime=7200),
    sin2(nPorts=2));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.NonIntegrated nonIntWSE1(
    m1_flow_chi_nominal=mCW_flow_nominal,
    m2_flow_chi_nominal=mCHW_flow_nominal,
    m1_flow_wse_nominal=mCW_flow_nominal,
    m2_flow_wse_nominal=mCHW_flow_nominal,
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    dp1_chi_nominal=dpCW_nominal,
    dp1_wse_nominal=dpCW_nominal,
    dp2_chi_nominal=dpCHW_nominal,
    dp2_wse_nominal=dpCHW_nominal,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHF_2567kW_11_77COP_VSD
      perChi,
    k=0.4,
    Ti=80,
    numChi=numChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Non-integrated waterside economizer "
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumCHW,
    nPorts=2,
    use_T_in=true,
    m_flow=2*mCHW_flow_nominal)
                   "Source on medium 2 side"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,-74})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.NonIntegrated nonIntWSE2(
    m1_flow_chi_nominal=mCW_flow_nominal,
    m2_flow_chi_nominal=mCHW_flow_nominal,
    m1_flow_wse_nominal=mCW_flow_nominal,
    m2_flow_wse_nominal=mCHW_flow_nominal,
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    dp1_chi_nominal=dpCW_nominal,
    dp1_wse_nominal=dpCW_nominal,
    dp2_chi_nominal=dpCHW_nominal,
    dp2_wse_nominal=dpCHW_nominal,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHF_2567kW_11_77COP_VSD
      perChi,
    k=0.4,
    Ti=80,
    numChi=numChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0) "Non-integrated waterside economizer "
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup2(redeclare package Medium =
        MediumCHW, m_flow_nominal=mCHW_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-126},{-60,-106}})));
  Modelica.Blocks.Sources.BooleanPulse tri(period=1800)
    "Trigger controller reset"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
equation
  connect(TSet.y, nonIntWSE1.TSet) annotation (Line(points={{-79,30},{-79,30},{-20,
          30},{-20,-27.2},{-11.6,-27.2}}, color={0,0,127}));
  connect(nonIntWSE1.port_a1, sou1.ports[1]) annotation (Line(points={{-10,-32},
          {-22,-32},{-28,-32},{-28,-4},{-40,-4}}, color={0,127,255}));
  connect(nonIntWSE1.port_b2, TSup1.port_a) annotation (Line(points={{-10,-44},{
          -20,-44},{-40,-44}}, color={0,127,255}));
  connect(nonIntWSE1.port_b1, sin1.ports[1]) annotation (Line(points={{10,-32},{
          20,-32},{20,-4},{70,-4}}, color={0,127,255}));
  connect(nonIntWSE1.port_a2, sou2.ports[1]) annotation (Line(points={{10,-44},{
          26,-44},{26,-72},{40,-72}}, color={0,127,255}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{69,-70},{62,-70}},            color={0,0,127}));
  connect(onChi.y, nonIntWSE1.on[1]) annotation (Line(points={{-79,90},{-22,90},
          {-22,-30.4},{-11.6,-30.4}}, color={255,0,255}));
  connect(onWSE.y, nonIntWSE1.on[2]) annotation (Line(points={{-79,60},{-22,60},
          {-22,-30.4},{-11.6,-30.4}}, color={255,0,255}));
  connect(TSet.y, nonIntWSE2.TSet) annotation (Line(points={{-79,30},{-20,30},{-20,
          -99.2},{-11.6,-99.2}}, color={0,0,127}));
  connect(onChi.y, nonIntWSE2.on[1]) annotation (Line(points={{-79,90},{-22,90},
          {-22,-102.4},{-11.6,-102.4}}, color={255,0,255}));
  connect(onWSE.y, nonIntWSE2.on[2]) annotation (Line(points={{-79,60},{-22,60},
          {-22,-102.4},{-11.6,-102.4}}, color={255,0,255}));
  connect(sou1.ports[2], nonIntWSE2.port_a1) annotation (Line(points={{-40,-4},{
          -28,-4},{-28,-104},{-10,-104}}, color={0,127,255}));
  connect(sin1.ports[2], nonIntWSE2.port_b1) annotation (Line(points={{70,-4},{20,
          -4},{20,-104},{10,-104}}, color={0,127,255}));
  connect(nonIntWSE2.port_a2, sou2.ports[2]) annotation (Line(points={{10,-116},
          {26,-116},{26,-76},{40,-76}}, color={0,127,255}));
  connect(sin2.ports[2], TSup2.port_b) annotation (Line(points={{-70,-70},{-64,-70},
          {-64,-116},{-60,-116}}, color={0,127,255}));
  connect(TSup2.port_a, nonIntWSE2.port_b2)
    annotation (Line(points={{-40,-116},{-10,-116}}, color={0,127,255}));
  connect(tri.y, nonIntWSE2.trigger) annotation (Line(points={{-79,-150},{-6,-150},
          {-6,-120}}, color={255,0,255}));
  annotation (__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/NonIntegrated.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example demonstrates how the model responses
according to different cooling mode signals
(free cooling mode, and fully mechanical cooling).
</p>
<p>
The reponses are also compared with a second case where the PI controller in the WSE
is reset every 1800s.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Yangyang Fu:<br/>
Added test case for PI controller reset.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
September 11, 2017, by Michael Wetter:<br/>
Corrected wrong use of replaceable model in the base class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/921\">issue 921</a>.
</li>
<li>
July 22, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=21600,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-160},{100,100}})));
end NonIntegrated;
