within Buildings.Applications.DHC.CentralPlants.Cooling;
model Plant "District cooling plant model"

  package Medium = Buildings.Media.Water "Medium model";

  parameter Integer numChi(min=1, max=2)=2 "Number of chillers, maximum is 2";

  parameter Boolean show_T = true
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  // chiller parameters
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi
    "Performance data of chiller"
    annotation (Dialog(group="Chiller"), choicesAllMatching = true,
    Placement(transformation(extent={{98,82},{112,96}})));
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal
    "Nominal chilled water mass flow rate"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.Pressure dpCHW_nominal
    "Pressure difference at the chilled water side"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.Power QEva_nominal
    "Nominal cooling capacity of single chiller (negative means cooling)"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.MassFlowRate mMin_flow
    "Minimum mass flow rate of single chiller"
    annotation (Dialog(group="Chiller"));

  // cooling tower parameters
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal
    "Nominal condenser water mass flow rate"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Pressure dpCW_nominal
    "Pressure difference at the condenser water side"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Temperature TAirInWB_nominal
    "Nominal air wetbulb temperature"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Temperature TCW_nominal
    "Nominal condenser water temperature at tower inlet"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal
    "Temperature difference between inlet and outlet of the tower"
     annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Temperature TMin
    "Minimum allowed water temperature entering chiller"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Power PFan_nominal
    "Fan power"
    annotation (Dialog(group="Cooling Tower"));

  // pump parameters
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perCHWPum
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data of chilled water pump"
    annotation (Dialog(group="Pump"),choicesAllMatching=true,
      Placement(transformation(extent={{120,82},{134,96}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perCWPum
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data of condenser water pump"
    annotation (Dialog(group="Pump"),choicesAllMatching=true,
      Placement(transformation(extent={{142,82},{156,96}})));
  parameter Modelica.SIunits.Pressure dpCHWPum_nominal
    "Nominal pressure drop of chilled water pumps"
    annotation (Dialog(group="Pump"));
  parameter Modelica.SIunits.Pressure dpCWPum_nominal
    "Nominal pressure drop of condenser water pumps"
    annotation (Dialog(group="Pump"));

  // control settings
  parameter Modelica.SIunits.Time tWai "Waiting time"
    annotation (Dialog(group="Control Settings"));
  parameter Modelica.SIunits.PressureDifference dpSetPoi(displayUnit="Pa")
   "Demand side pressure difference setpoint"
    annotation (Dialog(group="Control Settings"));

  // dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  Medium.ThermodynamicState sta_a( T(start=273.15+16))=
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if
         show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b( T(start=273.15+7))=
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if
          show_T "Medium properties in port_b";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium,
    m_flow(start = mCHW_flow_nominal))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{150,40},{170,60}}),
        iconTransformation(extent={{90,40},{110,60}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium,
    m_flow(start = -mCHW_flow_nominal))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{150,-60},{170,-40}}),
        iconTransformation(extent={{90,-60},{110,-40}})));

  Modelica.Blocks.Interfaces.BooleanInput on "On signal of the plant"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final unit="K",
    displayUnit="degC")
    "Set point for chilled water supply temperature"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final unit="K",
    displayUnit="degC")
    "Entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealInput dpMea(
    final unit="Pa")
    "Measured pressure difference"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.ElectricChillerParallel mulChiSys(
    per=fill(perChi, numChi),
    m1_flow_nominal=mCHW_flow_nominal,
    m2_flow_nominal=mCW_flow_nominal,
    dp1_nominal=dpCHW_nominal,
    dp2_nominal=dpCW_nominal,
    num=numChi,
    redeclare package Medium1=Medium,
    redeclare package Medium2=Medium) "Chillers connected in parallel"
    annotation (Placement(transformation(extent={{10,20},{-10,0}})));

  Buildings.Applications.DHC.CentralPlants.Cooling.Subsystems.CoolingTowerWithBypass
    cooTowWitByp(
    redeclare package Medium = Medium,
    num=numChi,
    m_flow_nominal=mCW_flow_nominal,
    dp_nominal=dpCW_nominal,
    TAirInWB_nominal=TAirInWB_nominal,
    TWatIn_nominal=TCW_nominal,
    dT_nominal=dT_nominal,
    PFan_nominal=PFan_nominal,
    TMin=TMin) "Cooling towers with bypass valve"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_y pumCHW(
    redeclare package Medium = Medium,
    per=fill(perCHWPum, numChi),
    energyDynamics=energyDynamics,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=dpCHWPum_nominal,
    num=numChi) "Chilled water pumps"
    annotation (Placement(transformation(extent={{10,40},{-10,60}})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_m pumCW(
    redeclare package Medium = Medium,
    per=fill(perCWPum, numChi),
    energyDynamics=energyDynamics,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=dpCWPum_nominal,
    num=numChi) "Condenser water pumps"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mCHW_flow_nominal*0.05,
    dpValve_nominal=dpCHW_nominal) "Chilled water bypass valve"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,0})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFloByp(
    redeclare package Medium = Medium)
    "Chilled water bypass valve mass flow meter"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,-30})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mCHW_flow_nominal) "Chilled water supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-50})));

  Buildings.Applications.DHC.CentralPlants.Cooling.Controls.ChilledWaterPumpSpeed
    CHWPumCon(
    tWai=0,
    m_flow_nominal=mCHW_flow_nominal,
    dpSetPoi=dpSetPoi,
    controllerType=Modelica.Blocks.Types.SimpleController.PI) "Chilled water pump controller"
    annotation (Placement(transformation(extent={{-120,-26},{-100,-6}})));

  Buildings.Applications.DHC.CentralPlants.Cooling.Controls.ChillerStage chiStaCon(
    tWai=tWai,
    QEva_nominal=QEva_nominal) "Chiller staging controller"
    annotation (Placement(transformation(extent={{-120,46},{-100,66}})));

  Modelica.Blocks.Math.RealToBoolean chiOn[numChi]
    "Real value to boolean value"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Modelica.Blocks.Sources.RealExpression mPum_flow(y=pumCHW.port_a.m_flow)
    "Total chilled water pump mass flow rate"
    annotation (Placement(transformation(extent={{-100,-2},{-120,18}})));

  Modelica.Blocks.Sources.RealExpression mValByp_flow(y=valByp.port_a.m_flow/(
        if chiOn[numChi].y then numChi*mMin_flow else mMin_flow))
    "Chilled water bypass valve mass flow rate"
    annotation (Placement(transformation(extent={{160,-40},{140,-20}})));

  Buildings.Controls.Continuous.LimPID bypValCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
           "Chilled water bypass valve controller"
    annotation (Placement(transformation(extent={{140,-10},{120,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWRet(redeclare package Medium = Medium,
      m_flow_nominal=mCHW_flow_nominal) "Chilled water return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,50})));
  Modelica.Blocks.Math.Add dT(final k1=-1, final k2=+1)
    "Temperature difference"
    annotation (Placement(transformation(extent={{80,70},{60,90}})));
  Modelica.Blocks.Math.Product pro
    "Product"
    annotation (Placement(transformation(extent={{40,70},{20,90}})));
  Modelica.Blocks.Math.Gain cp(final k=cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{0,70},{-20,90}})));

  Buildings.Fluid.Sources.Boundary_pT expTanCW(redeclare package Medium = Medium,
    nPorts=1) "Condenser water expansion tank"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));

  Buildings.Fluid.Sources.Boundary_pT expTanCHW(redeclare package Medium = Medium,
      nPorts=1) "Chilled water expansion tank"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "Chilled water return mass flow"
    annotation (Placement(transformation(extent={{50,40},{30,60}})));

  Modelica.Blocks.Sources.Constant mSetSca_flow(k=1)
    "Scaled bypass valve mass flow setpoint"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
protected
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default) "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

equation

  connect(senTCHWSup.port_b, port_b) annotation (Line(
      points={{140,-50},{160,-50}},
      color={0,127,255}));
  connect(senMasFloByp.port_b, valByp.port_a) annotation (Line(
      points={{80,-20},{80,-10}},
      color={0,127,255}));
  connect(senMasFloByp.port_a, senTCHWSup.port_a) annotation (Line(points={{80,-40},
          {80,-50},{120,-50}},                                                                           color={0,127,255}));
  connect(cooTowWitByp.port_b, pumCW.port_a) annotation (Line(points={{-40,-50},{-10,-50}}, color={0,127,255}));
  connect(on, chiStaCon.on) annotation (Line(points={{-160,60},{-122,60}},
                      color={255,0,255}));
  connect(chiStaCon.y, cooTowWitByp.on) annotation (Line(points={{-99,56},{-90,
          56},{-90,-46},{-62,-46}},
                                color={0,0,127}));
  connect(chiStaCon.y, pumCW.u) annotation (Line(points={{-99,56},{-90,56},{-90,
          -38},{-20,-38},{-20,-46},{-12,-46}}, color={0,0,127}));
  connect(TWetBul, cooTowWitByp.TWetBul) annotation (Line(points={{-160,-60},{
          -90,-60},{-90,-52},{-62,-52}},
                                     color={0,0,127}));
  connect(chiStaCon.y, chiOn.u) annotation (Line(points={{-99,56},{-90,56},{-90,60},{-82,60}},
                                                 color={0,0,127}));
  connect(CHWPumCon.dpMea, dpMea) annotation (Line(points={{-122,-20},{-160,-20}}, color={0,0,127}));
  connect(mPum_flow.y, CHWPumCon.masFloPum) annotation (Line(points={{-121,8},
          {-132,8},{-132,-12},{-122,-12}}, color={0,0,127}));
  connect(CHWPumCon.y, pumCHW.u) annotation (Line(points={{-99,-16},{-80,-16},{-80,
          8},{-40,8},{-40,60},{20,60},{20,54},{12,54}},      color={0,0,127}));
  connect(bypValCon.y, valByp.y) annotation (Line(points={{119,0},{92,0}},color={0,0,127}));
  connect(mValByp_flow.y, bypValCon.u_m) annotation (Line(points={{139,-30},{
          130,-30},{130,-12}},                                                                    color={0,0,127}));
  connect(port_a, senTCHWRet.port_a) annotation (Line(points={{160,50},{140,50}}, color={0,127,255}));
  connect(senTCHWSup.T, dT.u2) annotation (Line(points={{130,-39},{130,-32},{116,
          -32},{116,74},{82,74}},color={0,0,127}));
  connect(senTCHWRet.T, dT.u1) annotation (Line(points={{130,61},{130,78},{88,78},
          {88,86},{82,86}}, color={0,0,127}));
  connect(dT.y, pro.u1) annotation (Line(points={{59,80},{54,80},{54,86},{42,86}},
        color={0,0,127}));
  connect(cp.u, pro.y) annotation (Line(points={{2,80},{19,80}}, color={0,0,127}));
  connect(cp.y, chiStaCon.QLoa) annotation (Line(points={{-21,80},{-130,80},{-130,
          52},{-122,52}}, color={0,0,127}));
  connect(pumCHW.port_b, mulChiSys.port_a2) annotation (Line(points={{-10,50},{-20,
          50},{-20,16},{-10,16}}, color={0,127,255}));
  connect(mulChiSys.port_b2, senTCHWSup.port_a) annotation (Line(points={{10,16},
          {32,16},{32,-50},{120,-50}}, color={0,127,255}));
  connect(pumCW.port_b, mulChiSys.port_a1) annotation (Line(points={{10,-50},{20,
          -50},{20,4},{10,4}}, color={0,127,255}));
  connect(mulChiSys.port_b1, cooTowWitByp.port_a) annotation (Line(points={{-10,
          4},{-70,4},{-70,-50},{-60,-50}}, color={0,127,255}));
  connect(chiOn.y, mulChiSys.on) annotation (Line(points={{-59,60},{-48,60},{-48,
          32},{22,32},{22,6},{12,6}}, color={255,0,255}));
  connect(expTanCW.ports[1], pumCW.port_a) annotation (Line(points={{-30,-20},{-26,
          -20},{-26,-50},{-10,-50}}, color={0,127,255}));
  connect(senTCHWRet.port_b, senMasFlo.port_a)
    annotation (Line(points={{120,50},{50,50}}, color={0,127,255}));
  connect(pumCHW.port_a, senMasFlo.port_b)
    annotation (Line(points={{10,50},{30,50}}, color={0,127,255}));
  connect(senMasFlo.m_flow, pro.u2) annotation (Line(points={{40,61},{40,66},{54,
          66},{54,74},{42,74}}, color={0,0,127}));
  connect(expTanCHW.ports[1], senMasFlo.port_a) annotation (Line(points={{70,30},
          {80,30},{80,50},{50,50}}, color={0,127,255}));
  connect(valByp.port_b, senMasFlo.port_a)
    annotation (Line(points={{80,10},{80,50},{50,50}}, color={0,127,255}));
  connect(mulChiSys.TSet, TCHWSupSet) annotation (Line(points={{12,10},{20,10},
          {20,20},{-160,20}},color={0,0,127}));
  connect(chiOn[1].y, bypValCon.trigger) annotation (Line(points={{-59,60},{-48,
          60},{-48,32},{40,32},{40,-16},{138,-16},{138,-12}}, color={255,0,255}));
  connect(mSetSca_flow.y, bypValCon.u_s) annotation (Line(points={{111,20},{150,
          20},{150,0},{142,0}}, color={0,0,127}));
  annotation (__Dymola_Commands,
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-80},{160,100}})),
    experiment(
      StartTime=1.728e+007,
      StopTime=1.73664e+007,
      __Dymola_NumberOfIntervals=1440,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>The schematic drawing of the Lejeune plant is shown as folowing.</p>
<p><img src=\"Resources/Images/lejeunePlant/lejeune_schematic_drawing.jpg\" alt=\"image\"/> </p>
<p>In addition, the parameters are listed as below.</p>
<p>The parameters for the chiller plant.</p>
<p><img src=\"Resources/Images/lejeunePlant/Chiller.png\" alt=\"image\"/> </p>
<p>The parameters for the primary chilled water pump.</p>
<p><img src=\"Resources/Images/lejeunePlant/PriCHWPum.png\" alt=\"image\"/> </p>
<p>The parameters for the secondary chilled water pump.</p>
<p><img src=\"Resources/Images/lejeunePlant/SecCHWPum1.png\" alt=\"image\"/> </p>
<p><img src=\"Resources/Images/lejeunePlant/SecCHWPum2.png\" alt=\"image\"/> </p>
<p>The parameters for the condenser water pump.</p>
<p><img src=\"Resources/Images/lejeunePlant/CWPum.png\" alt=\"image\"/> </p>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),    graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,-14},{-62,-14}},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{80,-60},{-80,-60},{-80,60},{-60,60},{-60,0},{-40,0},{-40,20},
              {0,0},{0,20},{40,0},{40,20},{80,0},{80,-60}},
          lineColor={95,95,95},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{46,-38},{58,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{62,-38},{74,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{62,-54},{74,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{46,-54},{58,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{22,-54},{34,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{6,-54},{18,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{6,-38},{18,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{22,-38},{34,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-18,-54},{-6,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-34,-54},{-22,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-34,-38},{-22,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-18,-38},{-6,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}));
end Plant;
