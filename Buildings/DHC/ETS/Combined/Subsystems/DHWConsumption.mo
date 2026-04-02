within Buildings.DHC.ETS.Combined.Subsystems;
model DHWConsumption "DHW tank, HX, thermostatic mixing valve, and sink"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water")));
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Buildings.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    dat "Performance data"
    annotation (Placement(transformation(extent={{20,72},{40,92}})));
  parameter Modelica.Units.SI.HeatFlowRate QHotWat_flow_nominal(min=0)
    "Nominal capacity of heat pump condenser for hot water production system (>=0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=Modelica.Constants.eps)
    "Nominal temperature difference from the condenser"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=QHotWat_flow_nominal/4200/dT_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Medium.Temperature T_start=Medium.T_default
    "Temperature start value of the tank"
    annotation(Dialog(tab = "Initialization"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
     m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     h_outflow(
       start = Medium.h_default,
       nominal = Medium.h_default),
     Xi_outflow(each nominal=0.01))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
     h_outflow(
       start = Medium.h_default,
       nominal = Medium.h_default),
     Xi_outflow(each nominal=0.01))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}}),
        iconTransformation(extent={{-90,-70},{-110,-50}})));

  Buildings.DHC.ETS.Combined.Subsystems.StorageTankWithExternalHeatExchanger
    domHotWatTan(
    redeclare final package MediumDom = Medium,
    redeclare final package MediumHea = Medium,
    final dat=dat,
    final TTan_start=T_start)
    "Storage tank with fresh water station"
    annotation (Placement(transformation(extent={{20,-64},{40,-44}})));
  Buildings.DHC.Loads.HotWater.ThermostaticMixingValve theMixVal(
    redeclare final package Medium = Medium, mMix_flow_nominal=1.2*dat.mDom_flow_nominal)
    "Thermostatic mixing valve"
    annotation (Placement(transformation(extent={{60,42},{80,62}})));
  Buildings.Fluid.Sources.Boundary_pT souDCW(
    redeclare final package Medium = Medium,
    use_T_in=true,
    nPorts=1) "Source for domestic cold water"
    annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-48,44})));
  Buildings.DHC.ETS.BaseClasses.Junction dcwSpl(
    redeclare final package Medium = Medium,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m_flow_nominal*{1,-1,-1})
    "Splitter for domestic cold water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,44})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Domestic hot water temperature set point for supply to fixtures"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0}),
        iconTransformation(
        extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColWat(
    final unit="K",
    displayUnit="degC")
    "Cold water temperature" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QReqHotWat_flow(
    final unit="W")
    "Service hot water load"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=1/QHotWat_flow_nominal)
    "Gain to normalize hot water signal"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Interfaces.RealOutput PEle(unit="W")
    "Electric power required for pumping equipment"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput charge
    "Output true if tank needs to be charged, false if it is sufficiently charged"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TTanTop(
    final unit="K",
    displayUnit="degC")
    "Top temperature of tank"
    annotation (Placement(
        transformation(extent={{100,60},{140,100}}), iconTransformation(extent={{100,60},
            {140,100}})));
  Modelica.Blocks.Sources.RealExpression expTTanTop(
    y=domHotWatTan.TTanTop.T) "Top temperature of tank"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate dHFlow(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m_flow_nominal=m_flow_nominal,
    allowFlowReversal=false)
    "Enthalpy flow rate"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={16,-22})));
  Modelica.Blocks.Interfaces.RealOutput dHFlo(unit="W") "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
        iconTransformation(extent={{100,30},{120,50}})));
equation
  connect(port_a, domHotWatTan.port_aHea) annotation (Line(points={{-100,60},{-80,
          60},{-80,-90},{60,-90},{60,-60},{40,-60}},   color={0,127,255}));
  connect(domHotWatTan.port_bHea, port_b) annotation (Line(points={{20,-60},{-100,
          -60}},                                   color={0,127,255}));
  connect(souDCW.ports[1], dcwSpl.port_1)
    annotation (Line(points={{-38,44},{0,44}}, color={0,127,255}));
  connect(dcwSpl.port_2, theMixVal.port_col) annotation (Line(points={{20,44},{
          60,44}},                 color={0,127,255}));
  connect(souDCW.T_in, TColWat) annotation (Line(points={{-60,40},{-70,40},{-70,
          -40},{-120,-40}},
                          color={0,0,127}));
  connect(theMixVal.yMixSet, gai.y) annotation (Line(points={{59,60},{-30,60},{-30,
          80},{-38,80}},color={0,0,127}));
  connect(QReqHotWat_flow, gai.u) annotation (Line(points={{-120,40},{-92,40},{-92,
          80},{-62,80}},     color={0,0,127}));
  connect(THotWatSupSet, theMixVal.TMixSet) annotation (Line(points={{-120,0},{-60,
          0},{-60,20},{40,20},{40,54},{59,54}},
                                   color={0,0,127}));
  connect(THotWatSupSet, domHotWatTan.TDomSet) annotation (Line(points={{-120,0},
          {-60,0},{-60,-54},{19,-54}},  color={0,0,127}));
  connect(domHotWatTan.PEle, PEle) annotation (Line(points={{41,-54},{80,-54},{80,
          -40},{120,-40}},
                         color={0,0,127}));
  connect(domHotWatTan.charge, charge) annotation (Line(points={{42,-63},{42,-62},
          {80,-62},{80,-80},{120,-80}}, color={255,0,255}));
  connect(expTTanTop.y, TTanTop) annotation (Line(points={{81,80},{120,80}},
                         color={0,0,127}));
  connect(domHotWatTan.port_bDom, dHFlow.port_a1) annotation (Line(points={{40,-48},
          {48,-48},{48,-36},{22,-36},{22,-32}},
                                            color={0,127,255}));
  connect(dHFlow.port_b1, theMixVal.port_hot) annotation (Line(points={{22,-12},
          {22,16},{46,16},{46,48},{60,48}},
                                     color={0,127,255}));
  connect(dcwSpl.port_3, dHFlow.port_a2) annotation (Line(points={{10,34},{10,-12}},
                                   color={0,127,255}));
  connect(dHFlow.port_b2, domHotWatTan.port_aDom) annotation (Line(points={{10,-32},
          {10,-48},{20,-48}},               color={0,127,255}));
  connect(dHFlow.dH_flow, dHFlo) annotation (Line(points={{19,-10},{19,10},{88,10},
          {88,40},{120,40}},     color={0,0,127}));
  annotation (defaultComponentName="dhw",
    Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={              Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,-60},{52,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,70},{-48,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{52,72},{42,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,-16},{42,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,24},{42,-16}},
          lineColor={255,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-38,68},{42,24}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,76},{52,68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Model with fresh water station and domestic hot water load.
</p>
<p>
This model integrates a fresh water station, using
<a href=\"modelica://Buildings.DHC.ETS.Combined.Subsystems.StorageTankWithExternalHeatExchanger\">
Buildings.DHC.ETS.Combined.Subsystems.StorageTankWithExternalHeatExchanger</a>
with a domestic hot water load.
The load is served at a specified temperature, using
<a href=\"modelica://Buildings.DHC.Loads.HotWater.ThermostaticMixingValve\">
Buildings.DHC.Loads.HotWater.ThermostaticMixingValve</a>
to mix cold and hot water in order to meet the required hot water load.
</p>
<p>
The hot water load is specified through the input <code>QReqHotWat_flow</code>,
rather than the hot water mass flow rate, in order to take into account the actual
temperature of the hot water after the heat exchanger of the fresh water station.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 5, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DHWConsumption;
