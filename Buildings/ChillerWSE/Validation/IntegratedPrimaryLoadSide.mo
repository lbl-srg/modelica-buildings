within Buildings.ChillerWSE.Validation;
model IntegratedPrimaryLoadSide
  "Integrated WSE on the load side in a primary-only chilled water system"
  extends Modelica.Icons.Example;
  extends Buildings.ChillerWSE.Validation.BaseClasses.PartialPlant(
    sou1(nPorts=1),
    sin1(nPorts=1),
    sou2(nPorts=1),
    TSet(k=273.15 + 5.56),
    TEva_in(k=273.15 + 15.28));

  Buildings.ChillerWSE.IntegratedPrimaryLoadSide intWSEPri(
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
    use_controller=false)
    "Integrated waterside economizer on the load side of the primary-only chilled water system"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

  Modelica.Blocks.Sources.Constant yPum(k=1)
    "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{40,40},{20,60}})));
  Modelica.Blocks.Sources.RealExpression yVal5(
    y=if onChi.y and not onWSE.y then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{40,86},{20,106}})));
  Modelica.Blocks.Sources.RealExpression yVal6(
    y=if not onChi.y and onWSE.y then 1 else 0)
    "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{40,66},{20,86}})));
  Modelica.Blocks.Sources.BooleanStep onChi(startTime(displayUnit="h") = 7200)
    "On and off signal for the chiller"
    annotation (Placement(transformation(extent={{-60,76},{-40,96}})));
  Modelica.Blocks.Sources.BooleanStep onWSE(
    startTime(displayUnit="h") = 14400,
    startValue=true)
    "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-88,60},{-68,80}})));
equation
  connect(onChi.y, intWSEPri.on[1])
    annotation (Line(points={{-39,86},{-39,86},{-20,86},{-20,-30.4},{-11.6,
          -30.4}},                             color={255,0,255}));
  connect(onWSE.y, intWSEPri.on[2])
    annotation (Line(points={{-67,70},{-67,70},{-20,70},{-20,-30.4},{-11.6,
          -30.4}},                             color={255,0,255}));
  connect(TSet.y, intWSEPri.TSet)
    annotation (Line(points={{-69,40},{-22,40},{-22,-27.2},{-11.6,-27.2}},
                          color={0,0,127}));
  connect(yVal5.y, intWSEPri.yVal5)
    annotation (Line(points={{19,96},{4,96},{-16,96},{-16,-35},
      {-11.6,-35}}, color={0,0,127}));
  connect(yVal6.y, intWSEPri.yVal6)
    annotation (Line(points={{19,76},{-24,76},{-24,-38.2},{-11.6,-38.2}},
                                  color={0,0,127}));
  connect(yPum.y, intWSEPri.yPum[1])
    annotation (Line(points={{19,50},{-18,50},{-18,-42.4},{-11.6,-42.4}},
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
    annotation (Line(points={{10,-44},{20,-44},{26,-44},{26,-74},{38,-74}},
      color={0,127,255}));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/ChillerWSE/Validation/IntegratedPrimaryLoadSide.mos"
        "Simulate and Plot"), Documentation(info="<html>
<p>
This example demonstrates how the model responses 
according to different cooling mode signals
(free cooling mode, partially mechanical cooling and fully mechanical cooling).
</p>
</html>", revisions="<html>
<ul>
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
