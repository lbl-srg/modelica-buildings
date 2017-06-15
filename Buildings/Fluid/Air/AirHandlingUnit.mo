within Buildings.Fluid.Air;
model AirHandlingUnit
  extends Buildings.Fluid.Air.BaseClasses.PartialAirHandlingUnit(
    redeclare Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage watVal(
      final allowFlowReversal=allowFlowReversal1,
      final show_T=show_T,
      redeclare final package Medium = Medium1,
      final dpFixed_nominal=dp1_nominal,
      final l=l,
      final kFixed=kFixed,
      final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
      final R=R,
      final delta0=delta0,
      final from_dp=from_dp1,
      final homotopyInitialization=homotopyInitialization,
      final linearized=linearizeFlowResistance1,
      final rhoStd=rhoStd,
      final use_inputFilter=use_inputFilterValve,
      final riseTime=riseTimeValve,
      final init=initValve,
      final y_start=yValve_start,
      final dpValve_nominal=dpValve_nominal,
      final m_flow_nominal=m_flow_nominal,
      final deltaM=deltaM1),
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

  // parameters for heater controller
  parameter Real yValLow(min=0, max=1, unit="1")=0.1
  "if yVal<=yValLow, hysVal.y switches to false"
  annotation(Dialog(group="Reheat controller"));
  parameter Real yValHig(min=0, max=1, unit="1")=0.15
  "if yVal>=yValHig, hysVal.y switches to true"
  annotation(Dialog(group="Reheat controller"));
  parameter Modelica.SIunits.TemperatureDifference dTLow=-0.5
  "if dT<=dTLow, hysTemDif.y switches to false"
  annotation(Dialog(group="Reheat controller"));
  parameter Modelica.SIunits.TemperatureDifference dTHig=0.5
  "if dT>=dTHig, hysTemDif.y switches to true"
  annotation(Dialog(group="Reheat controller"));

  parameter Boolean pre_yVal_start=true "Previous value of hysVal.y used at initialization"
    annotation (Dialog(group="Reheat controller", tab="Initialization"));
  parameter Boolean pre_dT_start=true "Previous value of hysTemDif.y used at initialization"
    annotation (Dialog(group="Reheat controller", tab="Initialization"));

  Modelica.Blocks.Interfaces.RealOutput PHea(unit="W")
    "Power consumed by electric heater" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={18,-110})));
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
    "Set point temperature of the fluid that leaves port_b" annotation (
      Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput XSet_w(unit="kg/kg")
    "Set point for water vapor mass fraction in kg/kg total air of the fluid that leaves port_b"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-120,0},{-100,20}})));
  Modelica.Blocks.Sources.RealExpression dT(y(unit="K")=T_inflow_hea - TSet)
    "Difference between inlet temperature and temperature setpoint of the reheater"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Humidifiers.SteamHumidifier_X hum(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_small=m2_flow_small,
    final show_T=show_T,
    final massDynamics=massDynamics,
    final tau=tauHum,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=0,
    final m_flow_nominal=m2_flow_nominal,
    final mWatMax_flow=dat.nomVal.mWat_flow_nominal,
    each final X_start=X_start,
    final from_dp=from_dp2,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2)
    "Humidifier" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={20,-60})));
  Buildings.Fluid.Air.BaseClasses.ElectricHeater eleHea(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T,
    final m_flow_small=m2_flow_small,
    final energyDynamics=energyDynamics,
    final tau=tauEleHea,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=0,
    final QMax_flow=dat.nomVal.QHeater_nominal,
    final eta=dat.nomVal.etaHeater_nominal,
    final m_flow_nominal=m2_flow_nominal,
    final T_start=T_start,
    final from_dp=from_dp2,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2)
    "Electric heater" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-22,-60})));

  Buildings.Fluid.Air.BaseClasses.ReheatControl heaCon(
    final pre_yVal_start=pre_yVal_start,
    final pre_dT_start=pre_dT_start,
    final yValLow=yValLow,
    final yValHig=yValHig,
    final dTLow=dTLow,
    final dTHig=dTHig)
    "Reheater on/off controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,10})));

protected
  Medium2.Temperature T_inflow_hea = Medium2.temperature(
    state=Medium2.setState_phX(
      p=eleHea.port_a.p,
      h=inStream(eleHea.port_a.h_outflow),
      X=inStream(eleHea.port_a.Xi_outflow)))
      "Temperature of inflowing fluid at port_a of reheater";

equation

  connect(TSet, eleHea.TSet)
  annotation (Line(points={{-120,-20},{-88,-20},{-88,-28},{-4,-28},{-4,-52},{
          -10,-52}},
  color={0,0,127}));
  connect(XSet_w, hum.X_w) annotation (Line(points={{-120,0},{-80,0},{-80,-20},
          {36,-20},{36,-54},{32,-54}},
                 color={0,0,127}));
  connect(fan.port_a, eleHea.port_b) annotation (Line(points={{-50,-60},{-41,-60},
          {-32,-60}}, color={0,127,255}));
  connect(eleHea.port_a, hum.port_b)
    annotation (Line(points={{-12,-60},{10,-60}},          color={0,127,255}));
  connect(hum.port_a, cooCoi.port_b2)
    annotation (Line(points={{30,-60},{30,-60},{40,-60},{40,32},{10,32},{10,48},
          {22,48}},                                     color={0,127,255}));
  connect(eleHea.P, PHea) annotation (Line(points={{-33,-66},{-40,-66},{-40,-76},
          {18,-76},{18,-110}}, color={0,0,127}));
  connect(uFan,fan.y)
    annotation (Line(points={{-120,-50},{-120,-48},{-60,-48}},  color={0,0,127}));
  connect(dT.y,heaCon.dT)
    annotation (Line(points={{-19,40},{-22,40},{-5,40},{-5,22}},
                                                       color={0,0,127}));
  connect(watVal.y_actual, heaCon.yVal) annotation (Line(points={{75,67},{84,67},
          {84,80},{0,80},{0,40},{5,40},{5,22}}, color={0,0,127}));
  connect(heaCon.y, eleHea.on)
    annotation (Line(points={{0,-1},{0,-57},{-10,-57}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>This model can represent a typical air handler with a cooling coil, a variable-speed fan, 
    a humidifier and an electric reheater. The heating coil is not included in this model. </p>
    <p>The water-side valve can be manipulated to control the outlet temperature on air side, 
    as shown in <a href=\"modelica://Buildings.Fluid.Air.Example.AirHandlingUnitControl\">
    Buildings.Fluid.Air.Example.AirHandlingUnitControl.</a> </p>
    <p>It's usually undesired to control the outlet air temperature by simultenanously 
    manipulating the water-valve and reheater, because energy waste could happen in this case. For example,
    under the part-load condition, the water valve might be in its maximum position with
    the reheater turning on to maintain the outlet air temperature.
    To avoid that water-valve and reheater control the outlet 
    temperature at the same time, a buit-in reheater on/off controller is implemented. 
    The detailed control logic about the reheater on/off control is shown in 
    <a href=\"modelica://Buildings.Fluid.Air.BaseClasses.ReheatControl\">Buildings.Fluid.Air.BaseClasses.ReheatControl.</a></p>
    <p>The humidfier is an adiabatic humidifier with a prescribed outlet water vapor mass fraction
    in kg/kg total air.
    Details can be found in <a href=\"modelica://Buildings.Fluid.MassExchangers.Humidifier_X\">
    Buildings.Fluid.MassExchangers.Humidifier_X.</a> The humidifer can be turned off when the prescribed mass fraction 
    is smaller than the current state at the outlet, for example, <code>XSet=0</code>.
    </p>
</html>", revisions="<html>
<ul>
<li>
May 14, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirHandlingUnit;
