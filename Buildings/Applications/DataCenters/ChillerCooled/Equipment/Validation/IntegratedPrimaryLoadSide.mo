within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model IntegratedPrimaryLoadSide
  "Integrated WSE on the load side in a primary-only chilled water system"
  extends Modelica.Icons.Example;
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses.PartialPlant(
    sou1(nPorts=1),
    sin1(nPorts=1),
    TSet(k=273.15 + 5.56),
    TEva_in(k=273.15 + 15.28));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide intWSEPri(
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
    annotation (Placement(transformation(extent={{40,24},{20,44}})));
  Modelica.Blocks.Sources.RealExpression yVal5(
    y=if onChi.y and not onWSE.y then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{40,70},{20,90}})));
  Modelica.Blocks.Sources.RealExpression yVal6(
    y=if not onChi.y and onWSE.y then 1 else 0)
    "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{40,50},{20,70}})));
  Modelica.Blocks.Sources.BooleanStep onChi(startTime(displayUnit="h") = 7200)
    "On and off signal for the chiller"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.BooleanStep onWSE(
    startTime(displayUnit="h") = 14400,
    startValue=true)
    "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou2(
    redeclare package Medium = MediumCHW,
    nPorts=1,
    use_T_in=true) "Source on medium 2 side"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,-70})));
equation
  connect(onChi.y, intWSEPri.on[1])
    annotation (Line(points={{-39,80},{-39,80},{-20,80},{-20,-30.4},{-11.6,
          -30.4}},                             color={255,0,255}));
  connect(onWSE.y, intWSEPri.on[2])
    annotation (Line(points={{-69,60},{-69,60},{-20,60},{-20,-30.4},{-11.6,
          -30.4}},                             color={255,0,255}));
  connect(TSet.y, intWSEPri.TSet)
    annotation (Line(points={{-69,30},{-22,30},{-22,-27.2},{-11.6,-27.2}},
                          color={0,0,127}));
  connect(yVal5.y, intWSEPri.yVal5)
    annotation (Line(points={{19,80},{4,80},{-16,80},{-16,-35},{-11.6,-35}},
                    color={0,0,127}));
  connect(yVal6.y, intWSEPri.yVal6)
    annotation (Line(points={{19,60},{0,60},{0,50},{-24,50},{-24,-38.2},{-11.6,
          -38.2}},                color={0,0,127}));
  connect(yPum.y, intWSEPri.yPum[1])
    annotation (Line(points={{19,34},{-18,34},{-18,-42.4},{-11.6,-42.4}},
                      color={0,0,127}));
  connect(intWSEPri.port_a1, sou1.ports[1])
    annotation (Line(points={{-10,-32},
          {-22,-32},{-28,-32},{-28,-4},{-40,-4}}, color={0,127,255}));
  connect(intWSEPri.port_b2, TSup.port_a)
    annotation (Line(points={{-10,-44},{-20,-44},{-40,-44}},
      color={0,127,255}));
  connect(intWSEPri.port_b1, sin1.ports[1])
    annotation (Line(points={{10,-32},{26,-32},{26,-4},{70,-4}}, color={0,127,255}));
  connect(intWSEPri.port_a2, sou2.ports[1])
    annotation (Line(points={{10,-44},{20,-44},{26,-44},{26,-70},{40,-70}},
      color={0,127,255}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{69,-70},{66,-70},{66,-66},{62,-66}},
                                                          color={0,0,127}));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/IntegratedPrimaryLoadSide.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example demonstrates how the model responses
according to different cooling mode signals
(free cooling mode, partially mechanical cooling and fully mechanical cooling).
</p>
</html>", revisions="<html>
<ul>
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
      Tolerance=1e-06));
end IntegratedPrimaryLoadSide;
