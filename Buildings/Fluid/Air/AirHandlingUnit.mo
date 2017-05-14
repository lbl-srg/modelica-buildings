within Buildings.Fluid.Air;
model AirHandlingUnit
  extends Buildings.Fluid.Air.BaseClasses.PartialAirHandlingUnit(
    redeclare Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage watVal(
      final allowFlowReversal=allowFlowReversal1,
      final show_T=show_T,
      redeclare final package Medium = Medium1,
      final dpFixed_nominal=0,
      final deltaM=deltaM,
      final l=l,
      final kFixed=kFixed,
      final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
      final R=R,
      final delta0=delta0,
      final from_dp=from_dp,
      final homotopyInitialization=homotopyInitialization,
      final linearized=linearized,
      final rhoStd=rhoStd,
      final use_inputFilter=use_inputFilterValve,
      final riseTime=riseTimeValve,
      final init=initValve,
      final y_start=yValve_start,
      final dpValve_nominal=dat.nomVal.dpValve_nominal,
      final m_flow_nominal=m1_flow_nominal),
    redeclare Buildings.Fluid.Movers.SpeedControlled_y fan(
      final per=dat.perCur,
      redeclare final package Medium = Medium2,
      final allowFlowReversal=allowFlowReversal2,
      final show_T=show_T,
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final inputType=inputType,
      final addPowerToMedium=addPowerToMedium,
      final tau=tauFan,
      final use_inputFilter=use_inputFilterFan,
      final riseTime=riseTimeFan,
      final init=initFan,
      final y_start=yFan_start,
      final p_start=p_start,
      final T_start=T_start,
      each final X_start=X_start,
      each final C_start=C_start,
      each final C_nominal=C_nominal,
      final m_flow_small=m2_flow_small));

  parameter Real R=50 "Rangeability, R=50...100 typically"
  annotation(Dialog(group="Valve"));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law"
    annotation(Dialog(group="Valve"));
  // electric heater
   parameter Real deltaMLaminar = 0.1
    "Fraction of nominal flow rate where where flowrate transitions to laminar"
    annotation(Dialog(group="Electric Heater",tab="Advanced"));
  parameter Modelica.SIunits.Time tauEleHea = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Electric Heater"));
  // humidfier parameters
  parameter Modelica.SIunits.Temperature THum = 293.15
    "Temperature of water that is added to the fluid stream"
    annotation (Dialog(group="Humidifier"));
  parameter Modelica.SIunits.Time tauHum = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Humidifier"));

  parameter Real yMinVal(min=0, max=1, unit="1")=0.2
  "Minimum valve position when valve is controled to maintain outlet water temperature"
  annotation(Dialog(group="Valve"));

  // parameters for heater controller
  parameter Real y1Low "if y1=true and y1<=y1Low, switch to y1=false";
  parameter Real y1Hig "if y1=false and y1>=y1High, switch to y1=true";
  parameter Real y2Low "if y2=true and y2<=y2Low, switch to y2=false";
  parameter Real y2Hig "if y2=false and y2>=y2High, switch to y2=true";
  parameter Boolean pre_start1=true "Value of pre(y) at initial time";
  parameter Boolean pre_start2=true "Value of pre(y) at initial time";

  Medium2.Temperature T_inflow_hea "Temperature of inflowing fluid at port_a of reheater";

  MassExchangers.Humidifier_X                 hum(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_small=m2_flow_small,
    final show_T=show_T,
    final massDynamics=massDynamics,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearized,
    final deltaM=deltaMLaminar,
    final tau=tauHum,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dat.nomVal.dpHumidifier_nominal,
    final m_flow_nominal=m2_flow_nominal,
    mWatMax_flow=dat.nomVal.mWat_flow_nominal)
    "Humidifier" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={12,-30})));
  Buildings.Fluid.Air.BaseClasses.ElectricHeater eleHea(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T,
    final m_flow_small=m2_flow_small,
    final energyDynamics=energyDynamics,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearized,
    final deltaM=deltaMLaminar,
    final tau=tauEleHea,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dat.nomVal.dpHeater_nominal,
    final QMax_flow=dat.nomVal.QHeater_nominal,
    final eff=dat.nomVal.effHeater_nominal,
    final m_flow_nominal=m2_flow_nominal)
    "Electric heater" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-22,-60})));

  Modelica.Blocks.Interfaces.RealOutput PHea
    "Power consumed by electric heater" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={18,-110})));
  Modelica.Blocks.Interfaces.RealInput TSet
    "Set point temperature of the fluid that leaves port_b" annotation (
      Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput XSet_w
    "Set point for water vapor mass fraction in kg/kg total air of the fluid that leaves port_b"
    annotation (Placement(transformation(extent={{-140,-4},{-100,36}}),
        iconTransformation(extent={{-120,16},{-100,36}})));
  BaseClasses.ReheatControl heaCon(
    final y1Low=y1Low,
    final y1Hig=y1Hig,
    final y2Low=y2Low,
    final y2Hig=y2Hig,
    final pre_start1=pre_start1,
    final pre_start2=pre_start2)
                     "Reheater on/off controller"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.RealExpression e2(y=T_inflow_hea - TSet)
    annotation (Placement(transformation(extent={{-76,-6},{-56,14}})));
  Modelica.Blocks.Sources.RealExpression e1(y=y_valve - yMinVal)
    annotation (Placement(transformation(extent={{-76,12},{-56,32}})));
equation
    T_inflow_hea = Medium2.temperature(state=Medium2.setState_phX(
      p=eleHea.port_a.p, h=inStream(eleHea.port_a.h_outflow), X=inStream(eleHea.port_a.Xi_outflow)));
  connect(TSet, eleHea.TSet)
  annotation (Line(points={{-120,-10},{-80,-10},{-80, -32},{-6,-32},{-6,-52},{-10,-52}},
  color={0,0,127}));
  connect(XSet_w, hum.X_w) annotation (Line(points={{-120,16},{-80,16},{-80,-32},
          {-6,-32},{-6,-32},{-6,-12},{6,-12},{6,-18}},
                 color={0,0,127}));
  connect(fan.port_a, eleHea.port_b) annotation (Line(points={{-50,-60},{-41,-60},
          {-32,-60}}, color={0,127,255}));
  connect(eleHea.port_a, hum.port_b)
    annotation (Line(points={{-12,-60},{12,-60},{12,-40}}, color={0,127,255}));
  connect(hum.port_a, cooCoi.port_b2)
    annotation (Line(points={{12,-20},{12,-8},{22,-8}}, color={0,127,255}));
  connect(eleHea.P, PHea) annotation (Line(points={{-33,-66},{-40,-66},{-40,-80},
          {18,-80},{18,-110}}, color={0,0,127}));
  connect(uFan,fan.y)
    annotation (Line(points={{-120,-40},{-120,-48},{-59.8,-48}},color={0,0,127}));
  connect(heaCon.y, eleHea.On) annotation (Line(points={{-19,10},{0,10},{0,-57},
          {-10,-57}}, color={255,0,255}));
  connect(e2.y, heaCon.y2)
    annotation (Line(points={{-55,4},{-42,4},{-42,5}}, color={0,0,127}));
  connect(e1.y, heaCon.y1) annotation (Line(points={{-55,22},{-52,22},{-52,15},{
          -42,15}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
      Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Text(extent={{54,70},{80,64}},lineColor={0,0,255},
                     textString="Waterside",textStyle={TextStyle.Bold}),
                 Text(extent={{58,-64},{84,-70}},lineColor={0,0,255},
                     textString="Airside",textStyle={TextStyle.Bold})}),
    Documentation(info="<html>
<p>This model can represent a typical air handler with a cooling coil, a variable-speed fan, a humidifier and an electric reheater. The heating coil is not included in this model. </p>
<p>The water-side valve can be manipulated to control the outlet temperature on air side, as shown in <a href=\"modelica://Buildings.Fluid.Air.Example.AirHandlingUnitControl\">Buildings.Fluid.Air.Example.AirHandlingUnitControl.</a> </p>
<p>To avoid that water-valve and reheater can control the outlet temperature at the same time, a buit-in reheater on/off controller is implemented. The detailed control logic about the reheater on/off control is shown in Buildings.Fluid.Air.BaseClasses.ReheatControl</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirHandlingUnit;
