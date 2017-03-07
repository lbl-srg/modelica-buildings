within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
model PartialWaterCooledDXCoil "Base class for water-cooled DX coils"
  extends Buildings.BaseClasses.BaseIcon;
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.EssentialParameters(
          redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi);


  replaceable package Medium1 =
      Modelica.Media.Interfaces.PartialMedium "Medium for evaporator"
      annotation (choicesAllMatching = true);
  replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialMedium "Medium for condensor"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversalEva = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for evaporator"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalCon = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for condensor"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Pressure difference over evaporator at nominal flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Pressure difference over condensor at nominal flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean homotopyInitialization=true "= true, use homotopy method"
    annotation (Dialog(tab="Advanced"));

  parameter Boolean from_dpEva=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean from_dpCon=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Boolean linearizeFlowResistanceEva=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean linearizeFlowResistanceCon=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Real deltaMEva(final unit="1")=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Real deltaMCon(final unit="1")=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Modelica.SIunits.Time tauEva=60
    "Time constant at nominal flow rate (used if energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.SIunits.Time tauCon=60
    "Time constant at nominal flow rate (used if energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Boolean computeReevaporation=true
    "Set to true to compute reevaporation of water that accumulated on coil";

  // Initialization
  parameter Medium1.AbsolutePressure pEva_start = Medium1.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.Temperature TEva_start = Medium1.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.MassFraction XEva_start[Medium1.nX] = Medium1.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nXi > 0));
  parameter Medium1.ExtraProperty CEva_start[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames)=fill(0, Medium1.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));
  parameter Medium1.ExtraProperty CEva_nominal[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames) = fill(1E-2, Medium1.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));

  parameter Medium2.AbsolutePressure pCon_start = Medium2.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.Temperature TCon_start = Medium2.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.MassFraction XCon_start[Medium2.nX] = Medium2.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nXi > 0));
  parameter Medium2.ExtraProperty CCon_start[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames)=fill(0, Medium2.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty CCon_nominal[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power", unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput QEvaSen_flow(quantity="Power", unit="W")
    "Sensible heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput QEvaLat_flow(quantity="Power", unit="W")
    "Latent heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));


  // Ports
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium1,
    m_flow(min=if allowFlowReversalEva then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default))
    "Fluid connector for evaporator inlet (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium1,
    m_flow(max=if allowFlowReversalEva then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a portCon_a(
    redeclare final package Medium = Medium2,
    m_flow(min=if allowFlowReversalCon then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default))
    "Fluid connector a of condensor (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b portCon_b(
    redeclare final package Medium = Medium2,
    m_flow(max=if allowFlowReversalCon then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default))
    "Fluid connector b of condensor (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-50,-110},{-70,-90}})));

  // Components
  replaceable Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil eva
   constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
    redeclare final package Medium = Medium1,
    final use_mCon_flow=true,
    final dp_nominal=dpEva_nominal,
    final allowFlowReversal=allowFlowReversalEva,
    final show_T=false,
    final from_dp=from_dpEva,
    final linearizeFlowResistance=linearizeFlowResistanceEva,
    final deltaM=deltaMEva,
    final m_flow_small=mEva_flow_small,
    final tau=tauEva,
    final homotopyInitialization=homotopyInitialization,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=pEva_start,
    final T_start=TEva_start,
    final X_start=XEva_start,
    final C_start=CEva_start,
    final computeReevaporation=computeReevaporation,
    redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
    dxCoo(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
          wetCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacityWaterCooled cooCap,
                 redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                 appDewPt(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                         uacp(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues per))),
          dryCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacityWaterCooled cooCap,
                 redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                 appDryPt(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                         uacp(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues per)))),
    eva(final nomVal=Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=datCoi.sta[nSta].nomVal.Q_flow_nominal,
        COP_nominal=datCoi.sta[nSta].nomVal.COP_nominal,
        SHR_nominal=datCoi.sta[nSta].nomVal.SHR_nominal,
        m_flow_nominal=datCoi.sta[nSta].nomVal.m_flow_nominal,
        TEvaIn_nominal=datCoi.sta[nSta].nomVal.TEvaIn_nominal,
        TConIn_nominal=datCoi.sta[nSta].nomVal.TConIn_nominal,
        phiIn_nominal=datCoi.sta[nSta].nomVal.phiIn_nominal,
        p_nominal=datCoi.sta[nSta].nomVal.p_nominal,
        tWet= datCoi.sta[nSta].nomVal.tWet,
        gamma=datCoi.sta[nSta].nomVal.gamma))) "Direct evaporative coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u watCooCon(
    redeclare package Medium=Medium2,
    final m_flow_nominal = datCoi.sta[nSta].nomVal.mCon_flow_nominal,
    final Q_flow_nominal=-datCoi.sta[nSta].nomVal.Q_flow_nominal*(1+1/datCoi.sta[nSta].nomVal.COP_nominal),
    final allowFlowReversal=allowFlowReversalCon,
    final show_T=false,
    final from_dp=from_dpCon,
    final linearizeFlowResistance=linearizeFlowResistanceCon,
    final dp_nominal = dpCon_nominal,
    final deltaM=deltaMCon,
    final m_flow_small=mCon_flow_small,
    final tau=tauCon,
    final homotopyInitialization=homotopyInitialization,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=pCon_start,
    final T_start=TCon_start,
    final X_start=XCon_start,
    final C_start=CCon_start)
    "Water-cooled condenser"
    annotation (Placement(transformation(extent={{-20,-90},{-40,-70}})));

  Medium1.ThermodynamicState sta_a1=Medium1.setState_phX(
      port_a.p,
      noEvent(actualStream(port_a.h_outflow)),
      noEvent(actualStream(port_a.Xi_outflow))) if show_T
    "Medium properties in port_a1";
  Medium1.ThermodynamicState sta_b1=Medium1.setState_phX(
      port_b.p,
      noEvent(actualStream(port_b.h_outflow)),
      noEvent(actualStream(port_b.Xi_outflow))) if show_T
    "Medium properties in port_b1";
  Medium2.ThermodynamicState sta_a2=Medium2.setState_phX(
      portCon_a.p,
      noEvent(actualStream(portCon_a.h_outflow)),
      noEvent(actualStream(portCon_a.Xi_outflow))) if show_T
    "Medium properties in port_a2";
  Medium2.ThermodynamicState sta_b2=Medium2.setState_phX(
      portCon_b.p,
      noEvent(actualStream(portCon_b.h_outflow)),
      noEvent(actualStream(portCon_b.Xi_outflow))) if show_T
    "Medium properties in port_b2";

protected
  final parameter Medium1.MassFlowRate mEva_flow_small(min=0) = datCoi.m_flow_small
    "Small mass flow rate for regularization of zero flow at evaporator"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium2.MassFlowRate mCon_flow_small(min=0) = 1E-4*abs(datCoi.sta[nSta].nomVal.mCon_flow_nominal)
    "Small mass flow rate for regularization of zero flow at condensor"
    annotation(Dialog(tab = "Advanced"));

  Modelica.Blocks.Sources.RealExpression u(final y=(-eva.dxCoo.Q_flow + eva.P)/(
        -datCoi.sta[nSta].nomVal.Q_flow_nominal*(1 + 1/datCoi.sta[nSta].nomVal.COP_nominal)))
    "Signal of total heat flow removed by condenser" annotation (Placement(
        transformation(
        extent={{-13,-10},{13,10}},
        rotation=0,
        origin={-29,-60})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium=Medium2,
      m_flow_nominal=datCoi.sta[nSta].nomVal.mCon_flow_nominal)
    "fixme: to be replaced with a realexpression"
    annotation (Placement(transformation(extent={{50,-90},{30,-70}})));

  Sensors.MassFlowRate senMasFloCon(redeclare final package Medium = Medium2)
    "Mass flow through condensor"
    annotation (Placement(transformation(extent={{20,-90},{0,-70}})));
equation
  connect(u.y, watCooCon.u) annotation (Line(points={{-14.7,-60},{-8,-60},{-8,-74},
          {-18,-74}},
                    color={0,0,127}));
  connect(eva.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}},           color={0,127,255}));
  connect(eva.port_a, port_a)
    annotation (Line(points={{-10,0},{-10,0},{-100,0}},    color={0,127,255}));
  connect(watCooCon.port_b, portCon_b) annotation (Line(points={{-40,-80},{-60,-80},
          {-60,-100}}, color={0,127,255}));
  connect(senTem.port_a, portCon_a) annotation (Line(points={{50,-80},{50,-80},{
          58,-80},{58,-80},{60,-80},{60,-100},{60,-100}},
                      color={0,127,255}));
  connect(senTem.T, eva.TConIn) annotation (Line(points={{40,-69},{40,-69},{40,-20},
          {-20,-20},{-20,3},{-11,3}}, color={0,0,127}));
  connect(eva.P, P) annotation (Line(points={{11,9},{40,9},{40,90},{110,90}},
        color={0,0,127}));
  connect(eva.QSen_flow, QEvaSen_flow) annotation (Line(points={{11,7},{44,7},{44,
          60},{110,60}},     color={0,0,127}));
  connect(eva.QLat_flow, QEvaLat_flow) annotation (Line(points={{11,5},{48,5},{48,
          30},{110,30}},   color={0,0,127}));
  connect(watCooCon.port_a, senMasFloCon.port_b)
    annotation (Line(points={{-20,-80},{0,-80}}, color={0,127,255}));
  connect(senMasFloCon.port_a, senTem.port_b)
    annotation (Line(points={{20,-80},{30,-80}}, color={0,127,255}));
  connect(senMasFloCon.m_flow, eva.mCon_flow) annotation (Line(points={{10,-69},
          {10,-69},{10,-38},{10,-30},{-30,-30},{-30,-3.2},{-11,-3.2}}, color={0,
          0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-74,20},{80,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,4},{102,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,-6},{-2,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{52,42},{96,22}},
          lineColor={0,0,127},
          textString="QEvaLat"),Text(
          extent={{54,72},{98,52}},
          lineColor={0,0,127},
          textString="QEvaSen"),
        Rectangle(
          extent={{0,-56},{62,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,-66},{0,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{54,100},{98,80}},
          lineColor={0,0,127},
          textString="P"),
        Rectangle(
          extent={{-64,-66},{-56,-90}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-90},{66,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model can be used to simulate a water-cooled DX cooling coil with single speed compressor.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>", revisions="<html>
<ul>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWaterCooledDXCoil;
