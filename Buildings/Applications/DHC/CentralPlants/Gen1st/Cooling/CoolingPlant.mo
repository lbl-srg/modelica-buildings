within Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling;
model CoolingPlant "District cooling plant model"

  package Medium = Buildings.Media.Water "Medium model";

  parameter Integer numChi(min=1, max=2)=2 "Number of chillers, maximum is 2";

  parameter Boolean show_T = true
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  // chiller parameters
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi
    "Performance data of chiller"
    annotation (Dialog(group="Chiller"), choicesAllMatching = true,
    Placement(transformation(extent={{38,62},{52,76}})));
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
      Placement(transformation(extent={{60,62},{74,76}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perCWPum
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data of condenser water pump"
    annotation (Dialog(group="Pump"),choicesAllMatching=true,
      Placement(transformation(extent={{82,62},{96,76}})));
  parameter Modelica.SIunits.Pressure dpCHWPum_nominal
    "Nominal pressure drop of chilled water pumps"
    annotation (Dialog(group="Pump"));
  parameter Modelica.SIunits.Pressure dpCWPum_nominal
    "Nominal pressure drop of condenser water pumps"
    annotation (Dialog(group="Pump"));

  // control settings
  parameter Modelica.SIunits.Time tWai "Waiting time"
    annotation (Dialog(group="Control Settings"));
  parameter Modelica.SIunits.Temperature TCHWSet "Chilled water supply temperature setpoint"
    annotation (Dialog(group="Control Settings"));
  parameter Modelica.SIunits.PressureDifference dpSetPoi "Demand side pressure difference setpoint"
    annotation (Dialog(group="Control Settings"));

  Medium.ThermodynamicState sta_a=
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if
         show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if
          show_T "Medium properties in port_b";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{130,40},{150,60}}),
        iconTransformation(extent={{90,40},{110,60}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{130,-60},{150,-40}}),
        iconTransformation(extent={{90,-60},{110,-40}})));

  Modelica.Blocks.Interfaces.BooleanInput on "On signal of the plant"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final unit="K",
    displayUnit="degC")
   "Entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealInput QLoa(
    final unit="W")
    "District cooling load"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
        iconTransformation(extent={{-140,6},{-100,46}})));

  Modelica.Blocks.Interfaces.RealInput dpMea(
    final unit="bar")
   "Measured pressure difference"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-48},{-100,-8}})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.ElectricChillerParallel mulChiSys(
    per=fill(perChi, numChi),
    m1_flow_nominal=mCHW_flow_nominal,
    m2_flow_nominal=mCW_flow_nominal,
    dp1_nominal=dpCHW_nominal,
    dp2_nominal=dpCW_nominal,
    num=numChi,
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Subsystems.CoolingTowerWithBypass cooTowWitByp(
    redeclare package Medium = Medium,
    num=numChi,
    m_flow_nominal=mCW_flow_nominal,
    dp_nominal=dpCW_nominal,
    TAirInWB_nominal=TAirInWB_nominal,
    TWatIn_nominal=TCW_nominal,
    dT_nominal=dT_nominal,
    PFan_nominal=PFan_nominal,
    TMin=TMin)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_y pumCHW(
    redeclare package Medium = Medium,
    per=fill(perCHWPum, numChi),
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=dpCHWPum_nominal,
    num=numChi)
    annotation (Placement(transformation(extent={{10,40},{-10,60}})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_m pumCW(
    redeclare package Medium = Medium,
    per=fill(perCWPum, numChi),
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=dpCWPum_nominal,
    num=numChi)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(
    redeclare package Medium = Medium, V_start=2)
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Fluid.Storage.ExpansionVessel expVesCW(
    redeclare package Medium = Medium, V_start=2)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare package Medium = Medium,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=dpCHW_nominal)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,0})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFloByp(
    redeclare package Medium = Medium)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,-30})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mCHW_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-50})));

  Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Controls.ChilledWaterPumpSpeed CHWPumCon(
    tWai=tWai,
    m_flow_nominal=mCHW_flow_nominal,
    dpSetPoi=dpSetPoi)
    "Chilled water pump controller"
    annotation (Placement(transformation(extent={{-120,-26},{-100,-6}})));

  Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Controls.ChillerStage chiStaCon(
    tWai=tWai,
    QEva_nominal=QEva_nominal)
    "Chiller staging controller"
    annotation (Placement(transformation(extent={{-120,46},{-100,66}})));

  Modelica.Blocks.Math.RealToBoolean chiOn[numChi]
    "Real value to boolean value"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Modelica.Blocks.Sources.RealExpression mPum_flow(y=pumCHW.port_b.m_flow)
    "Total chilled water pump mass flow rate"
    annotation (Placement(transformation(extent={{-100,-2},{-120,18}})));

  Modelica.Blocks.Sources.Constant TCHWSupSet(k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Modelica.Blocks.Sources.RealExpression mValByp_flow(y=valByp.port_b.m_flow)
    "Chilled water bypass valve mass flow rate"
    annotation (Placement(transformation(extent={{140,-30},{120,-10}})));

  Modelica.Blocks.Sources.RealExpression mSet_flow(
    y=if chiOn[numChi].y then numChi*mMin_flow else mMin_flow)
    "Chilled water bypass valve mass flow rate"
    annotation (Placement(transformation(extent={{100,14},{120,34}})));

  Buildings.Controls.Continuous.LimPID bypValCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    k=1,
    Ti=60) "Chilled water bypass valve controller"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
equation

  connect(senTCHWSup.port_b, port_b) annotation (Line(
      points={{120,-50},{140,-50}},
      color={0,127,255}));
  connect(pumCHW.port_a, port_a) annotation (Line(
      points={{10,50},{140,50}},
      color={0,127,255}));
  connect(senMasFloByp.port_b, valByp.port_a) annotation (Line(
      points={{80,-20},{80,-10}},
      color={0,127,255}));
  connect(pumCW.port_b, mulChiSys.port_a2) annotation (Line(points={{10,-50},{20,
          -50},{20,4},{10,4}}, color={0,127,255}));
  connect(mulChiSys.port_b1, senTCHWSup.port_a) annotation (Line(points={{10,16},
          {28,16},{28,-50},{100,-50}}, color={0,127,255}));
  connect(senMasFloByp.port_a, senTCHWSup.port_a) annotation (Line(points={{80,-40},{80,-50},{100,-50}}, color={0,127,255}));
  connect(expVesCHW.port_a, senTCHWSup.port_a) annotation (Line(points={{50,-30},{50,-50},{100,-50}}, color={0,127,255}));
  connect(cooTowWitByp.port_b, pumCW.port_a) annotation (Line(points={{-40,-50},{-10,-50}}, color={0,127,255}));
  connect(mulChiSys.port_b2, cooTowWitByp.port_a) annotation (Line(points={{-10,4},
          {-70,4},{-70,-50},{-60,-50}},    color={0,127,255}));
  connect(expVesCW.port_a, pumCW.port_a) annotation (Line(points={{-30,-30},{-30,
          -50},{-10,-50}}, color={0,127,255}));
  connect(pumCHW.port_b, mulChiSys.port_a1) annotation (Line(points={{-10,50},{-20,
          50},{-20,16},{-10,16}}, color={0,127,255}));
  connect(on, chiStaCon.on) annotation (Line(points={{-160,60},{-122,60}},
                      color={255,0,255}));
  connect(QLoa, chiStaCon.QLoa) annotation (Line(points={{-160,20},{-132,20},{
          -132,52},{-122,52}},
                          color={0,0,127}));
  connect(chiStaCon.y, cooTowWitByp.on) annotation (Line(points={{-99,56},{-90,
          56},{-90,-46},{-62,-46}},
                                color={0,0,127}));
  connect(chiStaCon.y, pumCW.u) annotation (Line(points={{-99,56},{-90,56},{-90,
          -38},{-20,-38},{-20,-46},{-12,-46}}, color={0,0,127}));
  connect(TWetBul, cooTowWitByp.TWetBul) annotation (Line(points={{-160,-60},{-90,
          -60},{-90,-54},{-62,-54}}, color={0,0,127}));
  connect(chiStaCon.y, chiOn.u) annotation (Line(points={{-99,56},{-90,56},{-90,60},{-82,60}},
                                                 color={0,0,127}));
  connect(chiOn.y, mulChiSys.on) annotation (Line(points={{-59,60},{-50,60},{-50,
          14},{-12,14}}, color={255,0,255}));
  connect(CHWPumCon.dpMea, dpMea) annotation (Line(points={{-122,-20},{-160,-20}}, color={0,0,127}));
  connect(mPum_flow.y, CHWPumCon.masFloPum) annotation (Line(points={{-121,8},
          {-132,8},{-132,-12},{-122,-12}}, color={0,0,127}));
  connect(CHWPumCon.y, pumCHW.u) annotation (Line(points={{-99,-16},{-80,-16},{-80,
          8},{-40,8},{-40,60},{20,60},{20,54},{12,54}},      color={0,0,127}));
  connect(TCHWSupSet.y, mulChiSys.TSet) annotation (Line(points={{-59,30},{-52,
          30},{-52,10},{-12,10}}, color={0,0,127}));
  connect(bypValCon.y, valByp.y) annotation (Line(points={{99,0},{92,0}}, color={0,0,127}));
  connect(mValByp_flow.y, bypValCon.u_m) annotation (Line(points={{119,-20},{110,-20},{110,-12}}, color={0,0,127}));
  connect(mSet_flow.y, bypValCon.u_s) annotation (Line(points={{121,24},{132,24},
          {132,0},{122,0}}, color={0,0,127}));
  connect(valByp.port_b, port_a) annotation (Line(points={{80,10},{80,50},{140,50}}, color={0,127,255}));
  annotation (__Dymola_Commands,
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-80},{140,80}})),
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
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),   graphics={
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
        fillPattern=FillPattern.Solid)}));
end CoolingPlant;
