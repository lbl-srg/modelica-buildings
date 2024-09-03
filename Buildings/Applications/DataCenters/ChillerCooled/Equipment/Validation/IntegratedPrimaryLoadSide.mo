within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model IntegratedPrimaryLoadSide
  "Integrated WSE on the load side in a primary-only chilled water system"
  extends Modelica.Icons.Example;
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses.PartialPlant(
    sou1(nPorts=2),
    sin1(nPorts=2),
    TSet(k=273.15 + 5.56),
    TEva_in(k=273.15 + 15.28),
    sin2(nPorts=2));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide
    intWSEPri1(
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
    perPum=perPum,
    numChi=numChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Integrated waterside economizer on the load side of the primary-only chilled water system"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

  Modelica.Blocks.Sources.Constant yPum(k=1)
    "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{40,20},{20,40}})));
  Modelica.Blocks.Sources.RealExpression yVal5(
    y=if onChi.y and not onWSE.y then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{40,70},{20,90}})));
  Modelica.Blocks.Sources.RealExpression yVal6(
    y=if not onChi.y and onWSE.y then 1 else 0)
    "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{40,50},{20,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou2(
    redeclare package Medium = MediumCHW,
    nPorts=2,
    use_T_in=true) "Source on medium 2 side"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,-74})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide intWSEPri2(
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
    perPum=perPum,
    numChi=numChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
    "Integrated waterside economizer on the load side of the primary-only chilled water system with PI controller reset"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup2(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-136},{-60,-116}})));
  Modelica.Blocks.Sources.BooleanPulse tri(period=1800)
    "Trigger controller reset"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  parameter Fluid.Movers.Data.Generic[numChi] perPum(each pressure=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
        V_flow=mCHW_flow_nominal/1000*{0.2,0.6,1.0,1.2}, dp=dpCHW_nominal*{1.2,1.1,
        1.0,0.6})) "Pump performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
equation
  connect(TSet.y, intWSEPri1.TSet) annotation (Line(points={{-79,30},{-28,30},{-28,
          -27.2},{-11.6,-27.2}}, color={0,0,127}));
  connect(yVal5.y, intWSEPri1.yVal5) annotation (Line(points={{19,80},{-24,80},{
          -24,-35},{-11.6,-35}}, color={0,0,127}));
  connect(yVal6.y, intWSEPri1.yVal6) annotation (Line(points={{19,60},{2,60},{2,
          50},{-22,50},{-22,-38.2},{-11.6,-38.2}}, color={0,0,127}));
  connect(yPum.y, intWSEPri1.yPum[1]) annotation (Line(points={{19,30},{-20,30},
          {-20,-42.4},{-11.6,-42.4}}, color={0,0,127}));
  connect(intWSEPri1.port_a1, sou1.ports[1]) annotation (Line(points={{-10,-32},
          {-32,-32},{-32,-4},{-40,-4}}, color={0,127,255}));
  connect(intWSEPri1.port_b2, TSup1.port_a)
    annotation (Line(points={{-10,-44},{-40,-44}}, color={0,127,255}));
  connect(intWSEPri1.port_b1, sin1.ports[1]) annotation (Line(points={{10,-32},{
          22,-32},{22,-4},{70,-4}}, color={0,127,255}));
  connect(intWSEPri1.port_a2, sou2.ports[1]) annotation (Line(points={{10,-44},
          {26,-44},{26,-75},{40,-75}},color={0,127,255}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{69,-70},{62,-70}},          color={0,0,127}));
  connect(TSup2.port_a, intWSEPri2.port_b2)
    annotation (Line(points={{-40,-126},{-10,-126}}, color={0,127,255}));
  connect(intWSEPri2.port_a2, sou2.ports[2]) annotation (Line(points={{10,-126},
          {26,-126},{26,-73},{40,-73}}, color={0,127,255}));
  connect(intWSEPri2.port_b1, sin1.ports[2]) annotation (Line(points={{10,-114},
          {22,-114},{22,-4},{70,-4}}, color={0,127,255}));
  connect(intWSEPri2.port_a1, sou1.ports[2]) annotation (Line(points={{-10,-114},
          {-32,-114},{-32,-4},{-40,-4}}, color={0,127,255}));
  connect(TSup2.port_b, sin2.ports[2]) annotation (Line(points={{-60,-126},{-64,
          -126},{-64,-70},{-70,-70}}, color={0,127,255}));
  connect(TSet.y, intWSEPri2.TSet) annotation (Line(points={{-79,30},{-28,30},{-28,
          -109.2},{-11.6,-109.2}}, color={0,0,127}));
  connect(yVal5.y, intWSEPri2.yVal5) annotation (Line(points={{19,80},{-24,80},{
          -24,-117},{-11.6,-117}}, color={0,0,127}));
  connect(yVal6.y, intWSEPri2.yVal6) annotation (Line(points={{19,60},{2,60},{2,
          50},{-22,50},{-22,-120.2},{-11.6,-120.2}}, color={0,0,127}));
  connect(yPum.y, intWSEPri2.yPum[1]) annotation (Line(points={{19,30},{-20,30},
          {-20,-124.4},{-11.6,-124.4}}, color={0,0,127}));
  connect(tri.y, intWSEPri2.trigger) annotation (Line(points={{-79,-150},{-6,-150},
          {-6,-130}}, color={255,0,255}));
  connect(intWSEPri2.on[1], onChi.y) annotation (Line(points={{-11.6,-112.4},{
          -26,-112.4},{-26,90},{-79,90}}, color={255,0,255}));
  connect(intWSEPri2.on[2], onWSE.y) annotation (Line(points={{-11.6,-112.4},{
          -26,-112.4},{-26,60},{-79,60}}, color={255,0,255}));
  connect(intWSEPri1.on[1], onChi.y) annotation (Line(points={{-11.6,-30.4},{
          -26,-30.4},{-26,90},{-79,90}}, color={255,0,255}));
  connect(intWSEPri1.on[2], onWSE.y) annotation (Line(points={{-11.6,-30.4},{
          -26,-30.4},{-26,60},{-79,60}}, color={255,0,255}));
  annotation (__Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/IntegratedPrimaryLoadSide.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example demonstrates how the model responses
according to different cooling mode signals
(free cooling mode, partially mechanical cooling and fully mechanical cooling). 
</p>
<p>
The reponses are also compared with a second case where the PI controller in the WSE
is reset every 1800s.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2022, by Michael Wetter:<br/>
Avoided duplicate model instances with different declarations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2963\">issue 2963</a>.
</li>
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
end IntegratedPrimaryLoadSide;
