within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems;
model HeatPumpDHWTank
  "Base subsystem with water-to-water heat pump with storage tank for domestic hot water"
  replaceable package Medium1=Modelica.Media.Interfaces.PartialMedium
    "Medium model on condenser side"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,X_a=0.40)
    "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2=Modelica.Media.Interfaces.PartialMedium
    "Medium model on evaporator side"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,X_a=0.40)
    "Propylene glycol water, 40% mass fraction")));
  parameter Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    datWatHea "Performance data"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
//  parameter Boolean have_varFloEva = true
//    "Set to true for a variable evaporator flow. Fixme: false does not make sense here."
//    annotation(Evaluate=true);
  parameter Real COP_nominal(final unit="1")
    "Heat pump COP"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TCon_nominal
    "Condenser outlet temperature used to compute COP_nominal"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TEva_nominal
    "Evaporator outlet temperature used to compute COP_nominal"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QHotWat_flow_nominal(min=0)
    "Nominal capacity of heat pump condenser for hot water production system (>=0)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0) = 5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = heaPum.m1_flow_nominal
    "Condenser mass flow rate";
  final parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal = heaPum.m2_flow_nominal
    "Evaporator mass flow rate";

  parameter Boolean allowFlowReversal1=false
    "Set to true to allow flow reversal on condenser side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2=false
    "Set to true to allow flow reversal on evaporator side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.Units.SI.Pressure dp1_nominal(displayUnit="Pa")
    "Pressure difference over condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dp2_nominal(displayUnit="Pa")
    "Pressure difference over evaporator"
    annotation (Dialog(group="Nominal condition"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "Enable signal"
    annotation (
      Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium2,
    m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default))
    "Fluid port for entering evaporator water" annotation (Placement(
        transformation(extent={{190,-70},{210,-50}}), iconTransformation(extent=
           {{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium2,
    m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default))
    "Fluid port for leaving evaporator water" annotation (Placement(
        transformation(extent={{190,50},{210,70}}), iconTransformation(extent={{
            90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium1,
    m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid port for entering condenser water" annotation (Placement(
        transformation(extent={{-210,-70},{-190,-50}}), iconTransformation(
          extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium1,
    m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid port for leaving condenser water" annotation (Placement(
        transformation(extent={{-210,50},{-190,70}}), iconTransformation(extent=
           {{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PHea(
    final unit="W") "Heat pump power"
    annotation (Placement(transformation(extent={{200,20},{240,60}}),
    iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W") "Pump power"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mEva_flow(final unit="kg/s")
    "Evaporator water mass flow rate"
    annotation (Placement(transformation(
      extent={{200,-60},{240,-20}}), iconTransformation(extent={{100,-50},{
        140,-10}})));
  // COMPONENTS
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    QCon_flow_nominal=QHotWat_flow_nominal,
    dTEva_nominal=-dT_nominal,
    dTCon_nominal=dT_nominal,
    use_eta_Carnot_nominal=false,
    COP_nominal=COP_nominal,
    TCon_nominal=TCon_nominal,
    TEva_nominal=TEva_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    QCon_flow_max=QHotWat_flow_nominal)
    "Domestic hot water heat pump"
    annotation (Placement(transformation(extent={{-82,-70},{-62,-50}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
                                     pumCon(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = Medium2,
    m_flow_nominal=mCon_flow_nominal,
    riseTime=10) "Pump for heat pump condenser"
    annotation (Placement(transformation(extent={{-20,4},{-40,24}})));

  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumEva(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=dp2_nominal + 6000)
    "Heat pump evaporator water pump"
    annotation (Placement(transformation(extent={{20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal floCon(realTrue=
        mCon_flow_nominal) "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Loads.HotWater.StorageTankWithExternalHeatExchanger heaPumTan(
    redeclare package MediumDom = Medium1,
    redeclare package MediumHea = Medium2,                      final dat=
        datWatHea)
    "Heat pump with storage tank for domestic hot water"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Modelica.Blocks.Math.Add3 add3_1 "Electricity use for pumps"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotSouSet(k=datWatHea.TMix_nominal)
    "Set point of water in hot water tank"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(p=datWatHea.dTHexApp_nominal)
    annotation (Placement(transformation(extent={{-120,-62},{-100,-42}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCon_flow(final unit="kg/s")
    "Actual heat pump heating heat flow rate added to fluid" annotation (
      Placement(transformation(extent={{200,-120},{240,-80}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal floEva(realTrue=
        mEva_flow_nominal) "Evaporator mass flow rate"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valHeaPumEva(
    redeclare package Medium = Medium2,
    m_flow_nominal=mEva_flow_nominal,
    dpValve_nominal=6000) "Valve at heat pump evaporator"
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  Fluid.Sensors.TemperatureTwoPort senTEvaRet(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=mEva_flow_nominal,
    tau=0)
    "Evaporator return temperature sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-120})));
  Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=mEva_flow_nominal,
    tau=0)
    "District supply temperature sensor" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-60})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dT_supRet
    "Temperature difference over heat pump connection"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTSet(k=dT_nominal)
    "Set point for temperature difference over heat pump"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPI(Ti=20, xi_start=0.2)
    "Controller to ensure dT_nominal over heat pump connection"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium2)
    "Mass flow rate drawn from ETS"
    annotation (Placement(transformation(extent={{160,-70},{140,-50}})));
equation
  connect(add3_1.y, PPum) annotation (Line(points={{161,70},{172,70},{172,0},{220,
          0}},     color={0,0,127}));
  connect(heaPum.port_a1, heaPumTan.port_bHea) annotation (Line(points={{-82,-54},
          {-92,-54},{-92,14},{-80,14}}, color={0,127,255}));
  connect(pumCon.port_b, heaPumTan.port_aHea)
    annotation (Line(points={{-40,14},{-60,14}}, color={0,127,255}));
  connect(heaPum.port_b1,pumCon. port_a) annotation (Line(points={{-62,-54},{
          -14,-54},{-14,14},{-20,14}},
                           color={0,127,255}));
  connect(addPar.y, heaPum.TSet) annotation (Line(points={{-98,-52},{-94,-52},{
          -94,-51},{-84,-51}},
                           color={0,0,127}));
  connect(THotSouSet.y, heaPumTan.TDomSet) annotation (Line(points={{-158,10},{-140,
          10},{-140,20},{-81,20}}, color={0,0,127}));
  connect(addPar.u, THotSouSet.y) annotation (Line(points={{-122,-52},{-140,-52},
          {-140,10},{-158,10}},
                              color={0,0,127}));
  connect(heaPum.P, PHea) annotation (Line(points={{-61,-60},{-20,-60},{-20,-20},
          {22,-20},{22,40},{220,40}},
                color={0,0,127}));
  connect(floCon.y, pumCon.m_flow_in)
    annotation (Line(points={{-58,120},{-30,120},{-30,26}},  color={0,0,127}));
  connect(floEva.y, pumEva.m_flow_in)
    annotation (Line(points={{-58,90},{10,90},{10,-48}},  color={0,0,127}));
  connect(port_a1, heaPumTan.port_aDom) annotation (Line(points={{-200,-60},{-188,
          -60},{-188,26},{-80,26}}, color={0,127,255}));
  connect(add3_1.u1, heaPumTan.PEle) annotation (Line(points={{138,78},{-46,78},
          {-46,20},{-59,20}},                   color={0,0,127}));
  connect(pumEva.P, add3_1.u3) annotation (Line(points={{-1,-51},{-2,-51},{-2,
          -52},{-8,-52},{-8,62},{138,62}},
                      color={0,0,127}));
  connect(add3_1.u2, pumCon.P) annotation (Line(points={{138,70},{-44,70},{-44,23},
          {-41,23}},                       color={0,0,127}));
  connect(valHeaPumEva.port_2, pumEva.port_a)
    annotation (Line(points={{60,-60},{20,-60}}, color={0,127,255}));
  connect(heaPum.port_b2, senTEvaRet.port_a) annotation (Line(points={{-82,-66},
          {-90,-66},{-90,-120},{40,-120}}, color={0,127,255}));
  connect(senTEvaRet.port_b, port_b2) annotation (Line(points={{60,-120},{180,-120},
          {180,60},{200,60}}, color={0,127,255}));
  connect(senTDisSup.T, dT_supRet.u1) annotation (Line(points={{110,-49},{110,
          -32},{34,-32},{34,-4},{78,-4}},
                                       color={0,0,127}));
  connect(senTEvaRet.T, dT_supRet.u2)
    annotation (Line(points={{50,-109},{50,-16},{78,-16}}, color={0,0,127}));
  connect(valHeaPumEva.port_1, senTDisSup.port_b)
    annotation (Line(points={{80,-60},{100,-60}}, color={0,127,255}));
  connect(pumEva.port_b, heaPum.port_a2) annotation (Line(points={{0,-60},{-14,
          -60},{-14,-66},{-62,-66}},
                                color={0,127,255}));
  connect(valHeaPumEva.port_3, senTEvaRet.port_b) annotation (Line(points={{70,-70},
          {70,-120},{60,-120}}, color={0,127,255}));
  connect(conPI.u_s, dTSet.y)
    annotation (Line(points={{118,20},{102,20}},
                                               color={0,0,127}));
  connect(dT_supRet.y, conPI.u_m)
    annotation (Line(points={{102,-10},{130,-10},{130,8}},   color={0,0,127}));
  connect(conPI.y, valHeaPumEva.y) annotation (Line(points={{142,20},{148,20},{
          148,-26},{70,-26},{70,-48}},
                                   color={0,0,127}));
  connect(heaPumTan.port_bDom, port_b1) annotation (Line(points={{-60,26},{-52,
          26},{-52,60},{-200,60}}, color={0,127,255}));
  connect(senTDisSup.port_a, senMasFlo.port_b)
    annotation (Line(points={{120,-60},{140,-60}}, color={0,127,255}));
  connect(senMasFlo.port_a, port_a2)
    annotation (Line(points={{160,-60},{200,-60}}, color={0,127,255}));
  connect(senMasFlo.m_flow, mEva_flow)
    annotation (Line(points={{150,-49},{150,-40},{220,-40}}, color={0,0,127}));
  connect(heaPumTan.charge, floCon.u) annotation (Line(points={{-58,11},{-56,11},
          {-56,12},{-54,12},{-54,0},{-100,0},{-100,120},{-82,120}}, color={255,
          0,255}));
  connect(heaPumTan.charge, floEva.u) annotation (Line(points={{-58,11},{-56,11},
          {-56,12},{-54,12},{-54,0},{-100,0},{-100,90},{-82,90}}, color={255,0,
          255}));
  connect(heaPumTan.charge, conPI.trigger) annotation (Line(points={{-58,11},{
          -54,11},{-54,0},{-100,0},{-100,106},{112,106},{112,0},{124,0},{124,8}},
        color={255,0,255}));
  annotation (
  defaultComponentName="heaPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,0},{60,-78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-60},{48,-68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,-38},{4,-46},{12,-46},{8,-38}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,-38},{4,-30},{12,-30},{8,-38}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,-20},{42,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,-32},{50,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-32},{32,-44},{50,-44},{40,-32}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-46},{10,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-20},{10,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-12},{46,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,52},{-60,28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,68},{-66,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1.5,9.5},{1.5,-9.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-57.5,66.5},
          rotation=90),
        Rectangle(
          extent={{-68,28},{-66,18}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1.5,9.5},{1.5,-9.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-57.5,18.5},
          rotation=90),
        Rectangle(
          extent={{-1.5,5.5},{1.5,-5.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-11.5,18.5},
          rotation=90),
        Rectangle(
          extent={{-1.5,34.5},{1.5,-34.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={17.5,66.5},
          rotation=90),
        Rectangle(
          extent={{-48,70},{-16,14}},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,70},{-16,42}},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,20},{-4,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{52,68},{50,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})),
    Documentation(info="<html>
<p>
This model represents a water-to-water heat pump with storage tank and an evaporator water pump.
The heat pump model with storage tank is described in
<a href=\"modelica://Buildings.Experimental.DHC.Loads.HotWater.HeatPumpWithTank\">
Buildings.Experimental.DHC.Loads.HotWater.HeatPumpWithTank</a>.
By default a variable speed evaporator pump is considered.
<br/>
fixme: Update documentation. Do we indeed need a constant flow rate option?<br/>
A constant speed pump may also be represented by setting <code>have_varFloEva</code>
to <code>false</code>.
</p>
<h4>Controls</h4>
<p>
The system is enabled when the input control signal <code>uEna</code> switches to
<code>true</code>.
When enabled,
</p>
<ul>
<li>
the evaporator pump is commanded on and supply either
the mass flow rate set point provided as an input in the case of a variable speed pump,
or the nominal mass flow rate in the case of a constant speed pump,
</li>
<li>
the heat pump with storage tank system operates to maintain the desired
storage tank temperature.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 16, 2022, by Michael Wetter:<br/>
Set <code>pumEva.dp_nominal</code> to correct value.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatPumpDHWTank;
