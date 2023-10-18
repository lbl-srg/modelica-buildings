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
  parameter Modelica.Units.SI.HeatFlowRate QHotWat_flow_nominal(min=0) = 0
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna(start=false)
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
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    QCon_flow_nominal=QHotWat_flow_nominal,
    dTEva_nominal=-dT_nominal,
    dTCon_nominal=dT_nominal,
    use_eta_Carnot_nominal=false,
    COP_nominal=COP_nominal,
    TCon_nominal=TCon_nominal,
    TEva_nominal=TEva_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    QCon_flow_max = datWatHea.QCon_flow_max)
    "Domestic hot water heat pump"
    annotation (Placement(transformation(extent={{-20,-64},{0,-44}})));
  Fluid.Movers.Preconfigured.FlowControlled_m_flow
                                     pumCon(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    riseTime=10) "Pump for heat pump condenser"
    annotation (Placement(transformation(extent={{0,4},{-20,24}})));

  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumEva(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    dp_nominal=dp2_nominal)
    "Heat pump evaporator water pump"
    annotation (Placement(transformation(extent={{78,-70},{58,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal floCon(realTrue=
        mCon_flow_nominal) "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Fluid.Sensors.TemperatureTwoPort senTHotSup(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=mHotSou_flow_nominal)
    "Temperature of water leaving the domestic hot water storage tank"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-110,60})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold staPum(
    y(each start=false),
    t=1e-2*heaPumTan.mHea_flow_nominal,
    h=0.5e-2*heaPumTan.mHea_flow_nominal)
                              "Pump return status"
    annotation (Placement(transformation(extent={{-80,-110},{-100,-90}})));
  Loads.HotWater.StorageTankWithExternalHeatExchanger heaPumTan(final dat=
        datWatHea)
    "Heat pump with storage tank for domestic hot water"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Modelica.Blocks.Math.Add3 add3_1 "Electricity use for pumps"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotSouSet(k=datWatHea.THotSou_nominal)
    "Set point of water in hot water tank"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(p=datWatHea.dTHexApp_nominal)
    annotation (Placement(transformation(extent={{-120,-56},{-100,-36}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCon_flow(final unit="kg/s")
    "Actual heat pump heating heat flow rate added to fluid" annotation (
      Placement(transformation(extent={{200,-120},{240,-80}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal floEva(realTrue=
        mEva_flow_nominal) "Evaporator mass flow rate"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
equation
  connect(uEna, floCon.u)
    annotation (Line(points={{-220,120},{-182,120}}, color={255,0,255}));
  connect(senTHotSup.port_b, port_b1)
    annotation (Line(points={{-120,60},{-200,60}},       color={0,127,255}));
  connect(pumEva.m_flow_actual, mEva_flow) annotation (Line(points={{57,-55},{44,
          -55},{44,-40},{220,-40}},    color={0,0,127}));
  connect(port_a2, pumEva.port_a)
    annotation (Line(points={{200,-60},{78,-60}}, color={0,127,255}));
  connect(pumEva.m_flow_actual, staPum.u) annotation (Line(points={{57,-55},{44,
          -55},{44,-100},{-78,-100}},
                                color={0,0,127}));
  connect(add3_1.y, PPum) annotation (Line(points={{161,-10},{180,-10},{180,0},{
          220,0}}, color={0,0,127}));
  connect(heaPum.port_a1, heaPumTan.port_bHea) annotation (Line(points={{-20,-48},
          {-92,-48},{-92,14},{-80,14}}, color={0,127,255}));
  connect(pumCon.port_b, heaPumTan.port_aHea)
    annotation (Line(points={{-20,14},{-60,14}}, color={0,127,255}));
  connect(heaPum.port_b1,pumCon. port_a) annotation (Line(points={{0,-48},{12,-48},
          {12,14},{0,14}}, color={0,127,255}));
  connect(heaPumTan.port_bDom, senTHotSup.port_a) annotation (Line(points={{-60,
          26},{-50,26},{-50,60},{-100,60}}, color={0,127,255}));
  connect(addPar.y, heaPum.TSet) annotation (Line(points={{-98,-46},{-40,-46},{
          -40,-45},{-22,-45}},
                           color={0,0,127}));
  connect(THotSouSet.y, heaPumTan.TDomSet) annotation (Line(points={{-158,10},{
          -140,10},{-140,20},{-81,20}},
                                   color={0,0,127}));
  connect(addPar.u, THotSouSet.y) annotation (Line(points={{-122,-46},{-140,-46},
          {-140,10},{-158,10}},
                              color={0,0,127}));
  connect(heaPum.P, PHea) annotation (Line(points={{1,-54},{30,-54},{30,40},{220,
          40}}, color={0,0,127}));
  connect(pumEva.port_b, heaPum.port_a2)
    annotation (Line(points={{58,-60},{0,-60}}, color={0,127,255}));
  connect(heaPum.port_b2, port_b2) annotation (Line(points={{-20,-60},{-30,-60},
          {-30,-110},{180,-110},{180,60},{200,60}}, color={0,127,255}));
  connect(floEva.u, uEna) annotation (Line(points={{-182,90},{-190,90},{-190,
          120},{-220,120}}, color={255,0,255}));
  connect(floCon.y, pumCon.m_flow_in)
    annotation (Line(points={{-158,120},{-10,120},{-10,26}}, color={0,0,127}));
  connect(floEva.y, pumEva.m_flow_in)
    annotation (Line(points={{-158,90},{68,90},{68,-48}}, color={0,0,127}));
  connect(port_a1, heaPumTan.port_aDom) annotation (Line(points={{-200,-60},{
          -188,-60},{-188,26},{-80,26}}, color={0,127,255}));
  connect(add3_1.u1, heaPumTan.PEle) annotation (Line(points={{138,-2},{130,-2},
          {130,50},{-46,50},{-46,20},{-59,20}}, color={0,0,127}));
  connect(pumEva.P, add3_1.u3) annotation (Line(points={{57,-51},{50,-51},{50,
          -18},{138,-18}}, color={0,0,127}));
  connect(add3_1.u2, pumCon.P) annotation (Line(points={{138,-10},{122,-10},{
          122,46},{-32,46},{-32,23},{-21,23}}, color={0,0,127}));
  annotation (
  defaultComponentName="heaPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,62},{62,-58}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})),
    Documentation(info="<html>
<p>
This model represents a water-to-water heat pump with storage tank and an evaporator water pump.
The heat pump model with storage tank is described in
<a href=\"modelica://Buildings.Experimental.DHC.Loads.HotWater.HeatPumpWithTank\">
Buildings.Experimental.DHC.Loads.HotWater.HeatPumpWithTank</a>.
By default a variable speed evaporator pump is considered.
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
