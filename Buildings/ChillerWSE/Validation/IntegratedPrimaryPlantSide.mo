within Buildings.ChillerWSE.Validation;
model IntegratedPrimaryPlantSide
  "Integrated WSE on the plant side in a primary-only chilled water system"

  extends Modelica.Icons.Example;
  extends Buildings.ChillerWSE.Validation.BaseClasses.PartialChillerWSE(
    sou1(nPorts=1),
    sin1(nPorts=1),
    TSet(k=273.15 + 5.56),
    TCon_in(table=[0,273.15 + 2.78; 7200,273.15 + 2.78; 7200,273.15 + 8.33;
          14400,273.15 + 8.33; 14400,273.15 + 16.67]),
    TEva_in(k=273.15 + 15.28),
    redeclare Buildings.Fluid.Sources.MassFlowSource_T sou2(
         nPorts=1, m_flow=mCHW_flow_nominal));

  Buildings.ChillerWSE.IntegratedPrimaryPlantSide intWSEPri(
    mChiller1_flow_nominal=mCW_flow_nominal,
    mChiller2_flow_nominal=mCHW_flow_nominal,
    mWSE1_flow_nominal=mCW_flow_nominal,
    mWSE2_flow_nominal=mCHW_flow_nominal,
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    dpChiller1_nominal=dpCW_nominal,
    dpWSE1_nominal=dpCW_nominal,
    dpChiller2_nominal=dpCHW_nominal,
    dpWSE2_nominal=dpCHW_nominal,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHF_2567kW_11_77COP_VSD
      perChi,
    k=0.4,
    Ti=80,
    nChi=nChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Integrated waterside economizer in the primary-only chilled water system"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

  Modelica.Blocks.Sources.RealExpression yVal5(y=if onChi.y and not onWSE.y
         then 1 else 0) "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{40,86},{20,106}})));
  Modelica.Blocks.Sources.RealExpression yVal6(y=if not onChi.y and onWSE.y
         then 1 else 0) "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{40,66},{20,86}})));
  Modelica.Blocks.Sources.BooleanStep onChi(startTime(displayUnit="h") = 7200)
    "On and off signal for the chiller"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.BooleanStep onWSE(startTime(displayUnit="h") = 14400,
      startValue=true) "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
equation
  connect(onChi.y, intWSEPri.on[1]) annotation (Line(points={{-79,90},{-68,90},
          {-20,90},{-20,-30.4},{-11.6,-30.4}}, color={255,0,255}));
  connect(onWSE.y, intWSEPri.on[2]) annotation (Line(points={{-79,20},{-46,20},
          {-20,20},{-20,-30.4},{-11.6,-30.4}}, color={255,0,255}));
  connect(TSet.y, intWSEPri.TSet) annotation (Line(points={{-79,60},{-48,60},{
          -20,60},{-20,-27.2},{-11.6,-27.2}}, color={0,0,127}));
  connect(yVal5.y, intWSEPri.yVal5) annotation (Line(points={{19,96},{4,96},{
          -16,96},{-16,-35},{-11.6,-35}}, color={0,0,127}));
  connect(yVal6.y, intWSEPri.yVal6) annotation (Line(points={{19,76},{-6,76},{
          -16,76},{-16,-38.2},{-11.6,-38.2}}, color={0,0,127}));
  connect(intWSEPri.port_a1, sou1.ports[1]) annotation (Line(points={{-10,-32},
          {-22,-32},{-28,-32},{-28,-4},{-40,-4}}, color={0,127,255}));
  connect(intWSEPri.port_b2, TSup.port_a) annotation (Line(points={{-10,-44},{
          -20,-44},{-40,-44}}, color={0,127,255}));
  connect(intWSEPri.port_b1, sin1.ports[1]) annotation (Line(points={{10,-32},{
          26,-32},{26,-4},{80,-4}}, color={0,127,255}));
  connect(intWSEPri.port_a2, sou2.ports[1]) annotation (Line(points={{10,-44},{
          20,-44},{26,-44},{26,-74},{38,-74}}, color={0,127,255}));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/ChillerWSE/Validation/IntegratedPrimaryPlantSide.mos"
        "Simulate and Plot"));
end IntegratedPrimaryPlantSide;
