within Buildings.Experimental.DHC.Plants.Heating;
model SewageHeatRecovery
  "Model for sewage heat recovery plant"
  extends Buildings.Experimental.DHC.Plants.BaseClasses.PartialPlant(
    final have_fan=false,
    final have_pum=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false,
    final typ=Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration5);

  parameter Modelica.Units.SI.MassFlowRate mSew_flow_nominal
    "Sewage water nominal mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal
    "District water nominal mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.PressureDifference dpSew_nominal
    "Sewage side pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.PressureDifference dpDis_nominal
    "District side pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.Efficiency epsHex "Heat exchanger effectiveness";
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSewWat(
    final unit="K",
    displayUnit="degC")
    "Sewage water temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-400,240}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,220})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mPum_flow(
    final unit="kg/s")
    "Pumps mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-400,160}),iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,140})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dH_flow(final unit="W")
    "Variation of enthalpy flow rate across HX (leaving - entering)"
    annotation (
      Placement(transformation(extent={{300,60},{340,100}}),
        iconTransformation(extent={{300,80},{380,160}})));
  // COMPONENTS
  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final m1_flow_nominal=mSew_flow_nominal,
    final m2_flow_nominal=mDis_flow_nominal,
    final dp1_nominal=dpSew_nominal,
    final dp2_nominal=dpDis_nominal,
    final eps=epsHex)
    "Heat exchanger (primary is sewage water side)"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,14})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumDis(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mDis_flow_nominal,
    final dp_nominal=dpDis_nominal,
    final allowFlowReversal=allowFlowReversal)
    "District water pump"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-40})));
  Fluid.Sources.Boundary_pT souSew(
    redeclare final package Medium = Medium,
    final use_T_in=true,
    final nPorts=2)
    "Source of sewage water"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-70,76})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumSew(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mSew_flow_nominal,
    final dp_nominal=dpSew_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Sewage water pump"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,80})));
  Fluid.Sensors.TemperatureTwoPort senTSewOut(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSew_flow_nominal,
    tau=0)
    annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-40,20})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo(
    redeclare package Medium1 = Medium,
    final m_flow_nominal=mDis_flow_nominal)
    "Variation of enthalpy flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-16})));
 Buildings.Controls.OBC.CDL.Reals.MultiSum sumPPum(nin=2) "Sum pump power"
    annotation (Placement(transformation(extent={{260,150},{280,170}})));
equation
  connect(senTSewOut.port_b, souSew.ports[1])
    annotation (Line(points={{-46,20},{-60,20},{-60,75}}, color={0,127,255}));
  connect(souSew.ports[2], pumSew.port_a)
    annotation (Line(points={{-60,77},{-60,80},{30,80}},
                                                 color={0,127,255}));
  connect(souSew.T_in, TSewWat) annotation (Line(points={{-82,80},{-100,80},{
          -100,240},{-400,240}},
                          color={0,0,127}));
  connect(mPum_flow, pumSew.m_flow_in)
    annotation (Line(points={{-400,160},{40,160},{40,92}},
                                                       color={0,0,127}));
  connect(pumSew.port_b, hex.port_a1) annotation (Line(points={{50,80},{60,80},
          {60,20},{10,20}},                color={0,127,255}));
  connect(hex.port_b1, senTSewOut.port_a) annotation (Line(points={{-10,20},{
          -34,20}},               color={0,127,255}));
  connect(mPum_flow, pumDis.m_flow_in)
    annotation (Line(points={{-400,160},{80,160},{80,-28}},
                                                         color={0,0,127}));
  connect(senDifEntFlo.dH_flow, dH_flow) annotation (Line(points={{3,-28},{3,
          -78},{258,-78},{258,80},{320,80}},
                                        color={0,0,127}));
  connect(senDifEntFlo.port_b2, hex.port_a2) annotation (Line(points={{-6,-6},{-6,
          0},{-20,0},{-20,8},{-10,8}},         color={0,127,255}));
  connect(hex.port_b2, senDifEntFlo.port_a1) annotation (Line(points={{10,8},{20,
          8},{20,0},{6,0},{6,-6}},         color={0,127,255}));
  connect(port_aSerAmb, senDifEntFlo.port_a2) annotation (Line(points={{-380,40},
          {-280,40},{-280,-40},{-6,-40},{-6,-26}}, color={0,127,255}));
  connect(senDifEntFlo.port_b1, pumDis.port_a)
    annotation (Line(points={{6,-26},{6,-40},{70,-40}}, color={0,127,255}));
  connect(pumDis.port_b, port_bSerAmb) annotation (Line(points={{90,-40},{280,
          -40},{280,40},{380,40}},
                              color={0,127,255}));
  connect(sumPPum.y, PPum) annotation (Line(points={{282,160},{294,160},{294,
          160},{400,160}}, color={0,0,127}));
  connect(pumSew.P, sumPPum.u[1]) annotation (Line(points={{51,89},{238,89},{
          238,159.5},{258,159.5}},
                               color={0,0,127}));
  connect(pumDis.P, sumPPum.u[2]) annotation (Line(points={{91,-31},{240,-31},{
          240,160.5},{258,160.5}},
                               color={0,0,127}));
  annotation (
  DefaultComponentName="pla",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Model of sewage heat recovery plant with sewage mass flow rate and temperature as an input.
</p>
</html>", revisions="<html>
<ul>
<li>
January 16, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SewageHeatRecovery;
