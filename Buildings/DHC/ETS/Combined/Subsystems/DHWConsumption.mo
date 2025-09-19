within Buildings.DHC.ETS.Combined.Subsystems;
model DHWConsumption "DHW tank, HX, thermostatic mixing valve, and sink"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=QHotWat_flow_nominal/4200/dT_nominal);

  parameter Buildings.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    dat "Performance data"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  parameter Modelica.Units.SI.HeatFlowRate QHotWat_flow_nominal(min=0)
    "Nominal capacity of heat pump condenser for hot water production system (>=0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=Modelica.Constants.eps)
    "Nominal temperature difference from the condenser"
    annotation(Dialog(group="Nominal condition"));
  parameter Medium.Temperature T_start=Medium.T_default
    "Temperature start value of the tank"
    annotation(Dialog(tab = "Initialization"));

  Buildings.DHC.ETS.Combined.Subsystems.StorageTankWithExternalHeatExchanger
    domHotWatTan(
    redeclare final package MediumDom = Medium,
    redeclare final package MediumHea = Medium,
    final dat=dat,
    final TTan_start=T_start)
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.DHC.Loads.HotWater.ThermostaticMixingValve theMixVal(
    redeclare final package Medium = Medium, mMix_flow_nominal=1.2*dat.mDom_flow_nominal)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Fluid.Sources.Boundary_pT souDCW(
    redeclare final package Medium = Medium,
    use_T_in=true,
    nPorts=1) "Source for domestic cold water"
                                 annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-50,30})));
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
        origin={10,30})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(final unit="K",
      displayUnit="degC")
    "Domestic hot water temperature set point for supply to fixtures"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80}),
        iconTransformation(
        extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColWat(final unit="K",
      displayUnit="degC")
    "Cold water temperature" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QReqHotWat_flow(final unit="W")
                                   "Service hot water load"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=1/
        QHotWat_flow_nominal)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
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
    displayUnit="degC") "Temperature at the tank top" annotation (Placement(
        transformation(extent={{100,60},{140,100}}), iconTransformation(extent={{100,60},
            {140,100}})));
  Modelica.Blocks.Sources.RealExpression expTTanTop(
    y=domHotWatTan.TTanTop.T)
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate dHFlow(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m_flow_nominal=m_flow_nominal,
    allowFlowReversal=false)             "Variation of enthalpy flow rate"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={30,-30})));
  Modelica.Blocks.Interfaces.RealOutput dHFlo(unit="W") "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
        iconTransformation(extent={{100,30},{120,50}})));
equation
  connect(port_a, domHotWatTan.port_aHea) annotation (Line(points={{-100,0},{
          -90,0},{-90,-90},{50,-90},{50,-76},{40,-76}},color={0,127,255}));
  connect(domHotWatTan.port_bHea, port_b) annotation (Line(points={{20,-76},{10,
          -76},{10,-96},{92,-96},{92,0},{100,0}},  color={0,127,255}));
  connect(souDCW.ports[1], dcwSpl.port_1)
    annotation (Line(points={{-40,30},{0,30}}, color={0,127,255}));
  connect(dcwSpl.port_2, theMixVal.port_col) annotation (Line(points={{20,30},{30,
          30},{30,22},{60,22}},    color={0,127,255}));
  connect(souDCW.T_in, TColWat) annotation (Line(points={{-62,26},{-80,26},{-80,
          40},{-120,40}}, color={0,0,127}));
  connect(theMixVal.yMixSet, gai.y) annotation (Line(points={{59,38},{-30,38},{
          -30,-40},{-58,-40}},
                        color={0,0,127}));
  connect(QReqHotWat_flow, gai.u) annotation (Line(points={{-120,-40},{-82,-40}},
                             color={0,0,127}));
  connect(THotWatSupSet, theMixVal.TMixSet) annotation (Line(points={{-120,80},
          {50,80},{50,32},{59,32}},color={0,0,127}));
  connect(THotWatSupSet, domHotWatTan.TDomSet) annotation (Line(points={{-120,80},
          {-20,80},{-20,-70},{19,-70}}, color={0,0,127}));
  connect(domHotWatTan.PEle, PEle) annotation (Line(points={{41,-70},{80,-70},{
          80,-40},{120,-40}},
                         color={0,0,127}));
  connect(domHotWatTan.charge, charge) annotation (Line(points={{42,-79},{42,
          -82},{100,-82},{100,-80},{120,-80}},
                                        color={255,0,255}));
  connect(expTTanTop.y, TTanTop) annotation (Line(points={{81,80},{120,80}},
                         color={0,0,127}));
  connect(domHotWatTan.port_bDom, dHFlow.port_a1) annotation (Line(points={{40,
          -64},{50,-64},{50,-40},{36,-40}}, color={0,127,255}));
  connect(dHFlow.port_b1, theMixVal.port_hot) annotation (Line(points={{36,-20},
          {50,-20},{50,26},{60,26}}, color={0,127,255}));
  connect(dcwSpl.port_3, dHFlow.port_a2) annotation (Line(points={{10,20},{10,
          -14},{24,-14},{24,-20}}, color={0,127,255}));
  connect(dHFlow.port_b2, domHotWatTan.port_aDom) annotation (Line(points={{24,
          -40},{10,-40},{10,-64},{20,-64}}, color={0,127,255}));
  connect(dHFlow.dH_flow, dHFlo) annotation (Line(points={{33,-18},{33,10},{88,
          10},{88,40},{120,40}}, color={0,0,127}));
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
                                          Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DHWConsumption;
