within IceTank;
model IceTank
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=true);

  parameter Modelica.SIunits.Mass mIce_max "Nominal mass of ice in the tank";
  parameter Modelica.SIunits.Mass mIce_start "Start value of ice mass in the tank";
  parameter Modelica.SIunits.SpecificEnergy Hf = 333550 "Fusion of heat of ice";
  final parameter Modelica.SIunits.Energy QSto_nominal=Hf*mIce_max "Normal stored energy";
  final parameter Modelica.SIunits.TemperatureDifference dTif_min = 0.5
    "Temperature difference tolerance between inlet temperature and freezing temperature";
  final parameter Modelica.SIunits.HeatFlowRate smaLoa = m_flow_small*cp*dTif_min;

  parameter Modelica.SIunits.Temperature TFre=273.15
    "Freezing temperature of water or the latent energy storage material";
  parameter Modelica.SIunits.TemperatureDifference dT_nominal=10
    "Nominal temperature difference";
  parameter Integer nCha=6 "Number of coefficients for charging qstar curve";
  parameter Real coeffCha[nCha]={1.99930278E-5,0,0,0,0,0}
    "Coefficients for charging qstar curve";
  parameter Real dtCha=10 "Time step of curve fitting data";
  parameter Integer nDisCha=6
    "Number of coefficients for discharging qstar curve";
  parameter Real coeffDisCha[nDisCha]={5.54E-05,-0.000145679,9.28E-05,0.001126122,
      -0.0011012,0.000300544} "Coefficients for discharging qstar curve";
  parameter Real dtDisCha=10 "Time step of curve fitting data";

  parameter Modelica.SIunits.Time waiTim=120
    "Wait time before transition fires";

  parameter Real k=1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of Integrator block";

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.SIunits.Time tau = 30
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

  Modelica.Blocks.Interfaces.RealInput TOutSet(
    final unit = "K",
    final displayUnit="degC")
                             "Outlet temperature setpoint"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.IntegerInput u "Storage mode"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealOutput TOut(
    final unit = "K",
    final displayUnit="degC") "Temperature of the passing fluid"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput SOC "state of charge"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput mIce "Mass of remaining ice"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

  Medium.ThermodynamicState state_phX "Medium state at inlet";

  parameter Modelica.SIunits.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
        p=Medium.p_default,
        T=273.15,
        X=Medium.X_default)) "Specific heat capacity";

  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small,
    show_T=show_T,
    from_dp=from_dp,
    dp_nominal=0,
    linearizeFlowResistance=linearizeFlowResistance,
    deltaM=deltaM,
    tau=tau,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    Q_flow_nominal=1)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=273.65)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  BaseClasses.NormalizedChargingDischargingRate norQSta(
    nCha=nCha,
    coeffCha=coeffCha,
    dtCha=dtCha,
    nDisCha=nDisCha,
    coeffDisCha=coeffDisCha,
    dtDisCha=dtDisCha)
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  Modelica.Blocks.Math.Gain gai(k=QSto_nominal) "Gain"
    annotation (Placement(transformation(extent={{-2,-80},{18,-60}})));
  BaseClasses.LMTDStar lmtdSta(TFre=TFre, dT_nominal=dT_nominal)
    annotation (Placement(transformation(extent={{-66,-80},{-46,-60}})));

  BaseClasses.IceMass iceMas(
    mIce_max=mIce_max,
    mIce_start=mIce_start,
    Hf=Hf) annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    use_inputFilter=false,
    dpFixed_nominal=0)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  BaseClasses.StorageModeControl stoCon(
    dTif_min=dTif_min,
    smaLoa=smaLoa,
    TFre=TFre,
    waiTim=waiTim)
    annotation (Placement(transformation(extent={{-66,62},{-46,82}})));

  BaseClasses.TankTOutControl TSetCon(k=k, Ti=Ti)
    "PI control for valve1 and valve2 to enable outlet ice tank temperature control"
    annotation (Placement(transformation(extent={{-20,62},{0,82}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=6000,
    use_inputFilter=false,
    dpFixed_nominal=0)
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Integers.LessThreshold chaMod(
      threshold=Integer(IceTank.Types.IceThermalStorageMode.Discharging))
    "Charging mode"
    annotation (Placement(transformation(extent={{-42,-96},{-30,-84}})));
  Modelica.Blocks.Math.Max max
    annotation (Placement(transformation(extent={{22,-98},{32,-88}})));
  Modelica.Blocks.Math.Min min
    annotation (Placement(transformation(extent={{22,-64},{32,-54}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{40,-76},{52,-64}})));

protected
  Modelica.Blocks.Sources.RealExpression TIn(
    final y=Medium.temperature(state_phX)) "Water inlet temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.RealExpression locLoa(
    final y=port_a.m_flow*cp*(TIn.y - TFre)) "Estimated load"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Modelica.Blocks.Sources.RealExpression lim(final y=hea.port_a.m_flow*cp*(TFre
         - TIn.y)) "Upper/Lower limit for charging/discharging rate"
    annotation (Placement(transformation(extent={{0,-102},{16,-90}})));

equation

  state_phX = Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow));
//  cp = Medium.specificHeatCapacityCp(state_phX);

  connect(hea.port_b, senTOut.port_a)
    annotation (Line(points={{20,0},{60,0}}, color={0,127,255}));
  connect(senTOut.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(norQSta.qNor, gai.u)
    annotation (Line(points={{-9,-70},{-4,-70}},
                                              color={0,0,127}));
  connect(lmtdSta.lmtd, norQSta.lmtdSta) annotation (Line(points={{-45,-70},{
          -38,-70},{-38,-76},{-32,-76}},
                                  color={0,0,127}));
  connect(iceMas.SOC, norQSta.fraCha) annotation (Line(points={{81,-66},{96,-66},
          {96,-46},{-36,-46},{-36,-70},{-32,-70}}, color={0,0,127}));
  connect(TIn.y, lmtdSta.TIn) annotation (Line(points={{-79,-30},{-74,-30},{-74,
          -66},{-68,-66}},   color={0,0,127}));
  connect(iceMas.SOC, SOC) annotation (Line(points={{81,-66},{86,-66},{86,80},{
          110,80}},  color={0,0,127}));
  connect(iceMas.mIce, mIce) annotation (Line(points={{81,-70},{88,-70},{88,50},
          {110,50}},  color={0,0,127}));
  connect(senTOut.T, lmtdSta.TOut) annotation (Line(points={{70,11},{70,20},{50,
          20},{50,-40},{-76,-40},{-76,-74},{-68,-74}},
                                    color={0,0,127}));
  connect(senTOut.T, TOut)
    annotation (Line(points={{70,11},{70,20},{110,20}}, color={0,0,127}));
  connect(u, stoCon.u)
    annotation (Line(points={{-120,80},{-68,80}}, color={255,127,0}));
  connect(stoCon.y, norQSta.u) annotation (Line(points={{-45,72},{-32,72},{-32,
          40},{-46,40},{-46,-64},{-32,-64}},
                                         color={255,127,0}));
  connect(TIn.y, stoCon.TIn) annotation (Line(points={{-79,-30},{-74,-30},{-74,72},
          {-68,72}}, color={0,0,127}));
  connect(locLoa.y, stoCon.locLoa) annotation (Line(points={{-79,50},{-78,50},{
          -78,76},{-68,76}},
                         color={0,0,127}));
  connect(stoCon.y, TSetCon.u)
    annotation (Line(points={{-45,72},{-22,72}}, color={255,127,0}));
  connect(TSetCon.yVal1, val1.y) annotation (Line(points={{1,76},{12,76},{12,30},
          {-30,30},{-30,12}}, color={0,0,127}));
  connect(iceMas.SOC, stoCon.SOC) annotation (Line(points={{81,-66},{86,-66},{
          86,-38},{-76,-38},{-76,72},{-68,72}}, color={0,0,127}));
  connect(port_a, val1.port_a)
    annotation (Line(points={{-100,0},{-40,0}}, color={0,127,255}));
  connect(val1.port_b, hea.port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(port_a, val2.port_a) annotation (Line(points={{-100,0},{-50,0},{-50,
          40},{20,40}},  color={0,127,255}));
  connect(val2.port_b, senTOut.port_a)
    annotation (Line(points={{40,40},{60,40},{60,0}},   color={0,127,255}));
  connect(stoCon.y, chaMod.u) annotation (Line(points={{-45,72},{-43.2,72},{
          -43.2,-90}}, color={255,127,0}));
  connect(chaMod.y, swi.u2) annotation (Line(points={{-28.8,-90},{-4,-90},{-4,
          -86},{24,-86},{24,-70},{38.8,-70}}, color={255,0,255}));
  connect(swi.y, iceMas.q)
    annotation (Line(points={{53.2,-70},{58,-70}}, color={0,0,127}));
  connect(swi.y, hea.u) annotation (Line(points={{53.2,-70},{54,-70},{54,-48},{
          -10,-48},{-10,6},{-2,6}}, color={0,0,127}));
  connect(min.y, swi.u1) annotation (Line(points={{32.5,-59},{36.25,-59},{36.25,
          -65.2},{38.8,-65.2}}, color={0,0,127}));
  connect(max.y, swi.u3) annotation (Line(points={{32.5,-93},{32.5,-84.5},{38.8,
          -84.5},{38.8,-74.8}}, color={0,0,127}));
  connect(gai.y, min.u2)
    annotation (Line(points={{19,-70},{21,-70},{21,-62}}, color={0,0,127}));
  connect(gai.y, max.u1) annotation (Line(points={{19,-70},{20,-70},{20,-90},{
          21,-90}}, color={0,0,127}));
  connect(lim.y, max.u2)
    annotation (Line(points={{16.8,-96},{21,-96}}, color={0,0,127}));
  connect(lim.y, min.u1) annotation (Line(points={{16.8,-96},{16,-96},{16,-56},
          {21,-56}}, color={0,0,127}));
  connect(TSetCon.yVal2, val2.y)
    annotation (Line(points={{1,72},{30,72},{30,52}}, color={0,0,127}));
  connect(TOutSet, TSetCon.TOutSet) annotation (Line(points={{-120,30},{-36,30},
          {-36,68},{-22,68}}, color={0,0,127}));
  connect(senTOut.T, TSetCon.TOutMea) annotation (Line(points={{70,11},{70,58},{
          -28,58},{-28,64},{-22,64}}, color={0,0,127}));
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
          fillPattern=FillPattern.Solid)}));
end IceTank;
