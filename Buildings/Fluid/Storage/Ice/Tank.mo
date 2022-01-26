within Buildings.Fluid.Storage.Ice;
model Tank "A detailed ice tank model"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=true);

  // ice tank
  parameter Modelica.Units.SI.Mass mIce_max "Nominal mass of ice in the tank"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Mass mIce_start "Start value of ice mass in the tank"
    annotation(Dialog(tab = "Initialization"));

  replaceable parameter Buildings.Fluid.Storage.Ice.Data.Tank.Generic per
    "Performance data" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{40,70},{60,90}})));

  // Valve
  parameter Real l=0.0001 "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation (Dialog(group="Valve"));
  parameter Real R=50 "Rangeability, R=50...100 typically"
    annotation (Dialog(group="Valve"));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law"
     annotation (Dialog(group="Valve"));

  // Outlet temperature controller
  parameter Real k=1 "Gain of controller"
    annotation(Dialog(group="Temperature Controller"));
  parameter Modelica.Units.SI.Time Ti=120 "Time constant of Integrator block"
    annotation(Dialog(group="Temperature Controller"));

  parameter Modelica.Units.SI.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

   // valve dynamics
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation (Dialog(tab = "Dynamics", group="Valve"));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(tab = "Dynamics", group="Valve"));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation (Dialog(tab = "Dynamics", group="Valve"));
  parameter Real y_start=1 "Initial value of output"
    annotation (Dialog(tab = "Dynamics", group="Valve"));

  // Some final parameters
  final parameter Modelica.Units.SI.SpecificEnergy Hf = 333550 "Fusion of heat of ice";
  final parameter Modelica.Units.SI.Temperature TFre = 273.15
    "Freezing temperature of water or the latent energy storage material";
  final parameter Modelica.Units.SI.TemperatureDifference dT_nominal = 10
     "Nominal temperature difference";
  final parameter Modelica.Units.SI.Energy QSto_nominal=Hf*mIce_max "Normal stored energy";
  final parameter Modelica.Units.SI.PressureDifference dpValve_nominal=6000
    "Nominal pressure drop of fully open valve, used if CvData=Buildings.Fluid.Types.CvTypes.OpPoint"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
        p=Medium.p_default,
        T=273.15,
        X=Medium.X_default)) "Specific heat capacity";
  Modelica.Blocks.Interfaces.RealInput TOutSet(
    final unit = "K",
    final displayUnit="degC")
    "Outlet temperature setpoint"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.IntegerInput u "Ice storage operation mode"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealOutput TOut(
    final unit = "K",
    final displayUnit="degC") "Temperature of the passing fluid"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput SOC(
    final unit = "1")
    "state of charge"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput mIce(
    quantity="Mass",
    unit="kg") "Mass of remaining ice"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

//  Medium.ThermodynamicState state_phX = Medium.setState_phX(
//        p=port_a.p,
//        h=inStream(port_a.h_outflow),
//        X=inStream(port_a.Xi_outflow)) "Medium state at inlet";

  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final from_dp=from_dp,
    final dp_nominal=0,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final Q_flow_nominal=1)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTOutMix(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final T_start=T_start)
    "Temperature sensor for the mixed fluid at the outlet of the tank"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  BaseClasses.StorageHeatTransferRate norQSta(
    final coeCha=per.coeCha,
    final coeDisCha=per.coeDisCha,
    final dtCha=per.dtCha,
    final dtDisCha=per.dtDisCha)
    annotation (Placement(transformation(extent={{-54,-54},{-34,-34}})));
  Modelica.Blocks.Math.Gain gai(k=QSto_nominal) "Gain"
    annotation (Placement(transformation(extent={{-26,-54},{-6,-34}})));
  Buildings.Fluid.Storage.Ice.BaseClasses.LMTDStar lmtdSta(
    final TFre=TFre,
    final dT_nominal=dT_nominal)
    annotation (Placement(transformation(extent={{-86,-54},{-66,-34}})));

  Buildings.Fluid.Storage.Ice.BaseClasses.IceMass iceMas(
    final mIce_max=mIce_max,
    final mIce_start=mIce_start,
    final Hf=Hf)
    "Mass of the remaining ice"
    annotation (Placement(transformation(extent={{68,-80},{88,-60}})));

  Buildings.Fluid.Storage.Ice.BaseClasses.OutletTemperatureControl TOutCon(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti)
    "PI controller to enable outlet ice tank temperature control"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Buildings.Controls.OBC.CDL.Integers.LessThreshold nonDisChaMod(t=Integer(
        Buildings.Fluid.Storage.Ice.Types.OperationModes.Discharging))
    "Charging or dormant mode"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Math.Max max "Maximum"
    annotation (Placement(transformation(extent={{6,-100},{26,-80}})));
  Modelica.Blocks.Math.Min min "Minimum"
    annotation (Placement(transformation(extent={{34,-48},{54,-28}})));
  Modelica.Blocks.Logical.Switch swi "Switch"
    annotation (Placement(transformation(extent={{38,-80},{58,-60}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTIn(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final T_start=T_start)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final dpValve_nominal=dpValve_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final dpFixed_nominal=dp_nominal,
    final l=l,
    final R=R,
    final delta0=delta0) "Valve"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final dpValve_nominal=dpValve_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final dpFixed_nominal=0,
    final l=l,
    final R=R,
    final delta0=delta0) "Valve"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.Constant uni(k=1) "Unit"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Math.Add add(k1=-1) "Add"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTOut(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final T_start=T_start)
    "Temperature sensor for the fluid at the outlet of the tank"
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));
protected
  Modelica.Blocks.Sources.RealExpression limQ(
    final y=hea.port_a.m_flow*cp*(TFre - senTIn.T)) "Upper/Lower limit for charging/discharging rate"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

equation
  connect(senTOutMix.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(norQSta.qNor, gai.u)
    annotation (Line(points={{-33,-44},{-28,-44}},
                                              color={0,0,127}));
  connect(iceMas.mIce, mIce) annotation (Line(points={{89,-70},{94,-70},{94,-50},
          {110,-50}}, color={0,0,127}));
  connect(senTOutMix.T, TOut)
    annotation (Line(points={{70,11},{70,40},{110,40}}, color={0,0,127}));
  connect(nonDisChaMod.y, swi.u2)
    annotation (Line(points={{-58,-70},{36,-70}}, color={255,0,255}));
  connect(swi.y, iceMas.q)
    annotation (Line(points={{59,-70},{66,-70}},   color={0,0,127}));
  connect(swi.y, hea.u) annotation (Line(points={{59,-70},{62,-70},{62,-16},{-10,
          -16},{-10,6},{-2,6}},     color={0,0,127}));
  connect(min.y, swi.u1) annotation (Line(points={{55,-38},{60,-38},{60,-54},{26,
          -54},{26,-62},{36,-62}},
                                color={0,0,127}));
  connect(gai.y, min.u2)
    annotation (Line(points={{-5,-44},{32,-44}},          color={0,0,127}));
  connect(gai.y, max.u1) annotation (Line(points={{-5,-44},{0,-44},{0,-84},{4,-84}},
                    color={0,0,127}));
  connect(limQ.y, max.u2) annotation (Line(points={{-19,-90},{0,-90},{0,-96},{4,
          -96}}, color={0,0,127}));
  connect(limQ.y, min.u1) annotation (Line(points={{-19,-90},{0,-90},{0,-32},{32,
          -32}}, color={0,0,127}));
  connect(TOutSet,TOutCon. TOutSet) annotation (Line(points={{-120,30},{-80,30},
          {-80,80},{-12,80}}, color={0,0,127}));
  connect(senTOutMix.T, TOutCon.TOutMea) annotation (Line(points={{70,11},{70,96},
          {-60,96},{-60,74},{-12,74}}, color={0,0,127}));
  connect(u,TOutCon. u) annotation (Line(points={{-120,80},{-62,80},{-62,86},{
          -12,86}},
                color={255,127,0}));
  connect(norQSta.u, u) annotation (Line(points={{-56,-38},{-62,-38},{-62,80},{-120,
          80}}, color={255,127,0}));
  connect(iceMas.fraCha, SOC) annotation (Line(points={{89,-66},{92,-66},{92,-20},
          {110,-20}}, color={0,0,127}));
  connect(max.y, swi.u3) annotation (Line(points={{27,-90},{30,-90},{30,-78},{36,
          -78}}, color={0,0,127}));
  connect(u, nonDisChaMod.u) annotation (Line(points={{-120,80},{-62,80},{-62,-58},
          {-88,-58},{-88,-70},{-82,-70}}, color={255,127,0}));
  connect(lmtdSta.lmtdSta, norQSta.lmtdSta) annotation (Line(points={{-65,-44},{
          -64,-44},{-64,-50},{-56,-50}}, color={0,0,127}));
  connect(iceMas.fraCha, norQSta.fraCha) annotation (Line(points={{89,-66},{92,-66},
          {92,-22},{-60,-22},{-60,-44},{-56,-44}}, color={0,0,127}));
  connect(port_a, senTIn.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(senTIn.T, lmtdSta.TIn) annotation (Line(points={{-80,11},{-80,14},{-94,
          14},{-94,-40},{-88,-40}}, color={0,0,127}));
  connect(val1.port_b, hea.port_a)
    annotation (Line(points={{-40,0},{0,0}}, color={0,127,255}));
  connect(val1.port_a, senTIn.port_b)
    annotation (Line(points={{-60,0},{-70,0}}, color={0,127,255}));
  connect(senTIn.port_b, val2.port_a) annotation (Line(points={{-70,0},{-64,0},
          {-64,30},{20,30}}, color={0,127,255}));
  connect(val2.port_b, senTOutMix.port_a) annotation (Line(points={{40,30},{48,30},
          {48,0},{60,0}}, color={0,127,255}));
  connect(uni.y, add.u2) annotation (Line(points={{-39,50},{-30,50},{-30,44},{-22,
          44}},     color={0,0,127}));
  connect(add.y, val1.y) annotation (Line(points={{1,50},{10,50},{10,22},{-50,22},
          {-50,12}},     color={0,0,127}));
  connect(TOutCon.y, val2.y)
    annotation (Line(points={{11,80},{30,80},{30,42}}, color={0,0,127}));
  connect(TOutCon.y, add.u1) annotation (Line(points={{11,80},{30,80},{30,66},{-32,
          66},{-32,56},{-22,56}},     color={0,0,127}));
  connect(hea.port_b, senTOut.port_a)
    annotation (Line(points={{20,0},{24,0}}, color={0,127,255}));
  connect(senTOut.port_b, senTOutMix.port_a)
    annotation (Line(points={{44,0},{60,0}}, color={0,127,255}));
  connect(senTOut.T, lmtdSta.TOut) annotation (Line(points={{34,11},{34,24},{-96,
          24},{-96,-48},{-88,-48}}, color={0,0,127}));
  annotation (defaultComponentModel="iceTan", Icon(graphics={
        Rectangle(
          extent={{-76,46},{76,70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,46},{76,-92}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,28},{-46,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-34,28},{-18,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-6,28},{10,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{22,28},{38,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{50,28},{66,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-90,4},{90,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{58,22},{62,80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,78},{100,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,48},{102,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,18},{102,22}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>This model implements an ice tank model based on the EnergyPlus ice tank model
<a href=\"https://bigladdersoftware.com/epx/docs/9-0/input-output-reference/group-plant-equipment.html#thermalstorageicedetailed\">ThermalStorage:Ice:Detailed</a>.
</p>

<h4>
Reference
</h4>
<p>
Strand, R.K. 1992. “Indirect Ice Storage System Simulation,” M.S. Thesis,
Department of Mechanical and Industrial Engineering, University of Illinois at Urbana-Champaign.

</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tank;
