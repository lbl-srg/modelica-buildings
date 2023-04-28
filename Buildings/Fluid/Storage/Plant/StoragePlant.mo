within Buildings.Fluid.Storage.Plant;
model StoragePlant "Model of a storage plant with a chiller and a CHW tank"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  Buildings.Fluid.Storage.Plant.BaseClasses.IdealTemperatureSource chi(
    redeclare final package Medium = Medium,
    final m_flow_nominal=nom.mChi_flow_nominal,
    final TSet=nom.T_CHWS_nominal)
    "Chiller represented by an ideal temperature source" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-30})));
  Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow pumPri(
    redeclare final package Medium = Medium,
    final addPowerToMedium=false,
    final m_flow_nominal=nom.mChi_flow_nominal,
    final dp_nominal=chi2PreDro.dp_nominal) "Primary CHW pump"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop chi2PreDro(
    redeclare final package Medium = Medium,
    final m_flow_nominal=nom.mChi_flow_nominal,
    dp_nominal=0.1*nom.dp_nominal)
    "Pressure drop of the chiller branch in plant 2" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-50})));
  Buildings.Fluid.Storage.Plant.BaseClasses.TankBranch tanBra(
    redeclare final package Medium = Medium,
    final nom=nom,
    VTan=0.8,
    hTan=3,
    dIns=0.3) "Tank branch, tank can be charged remotely" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-10})));
  Buildings.Fluid.Storage.Plant.BaseClasses.ReversibleConnection revCon(
    redeclare final package Medium = Medium,
    final nom=nom) "Reversible connection"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Fluid.Storage.Plant.Controls.FlowControl floCon(
    final mChi_flow_nominal=nom.mChi_flow_nominal,
    final mTan_flow_nominal=nom.mTan_flow_nominal,
    final use_outFil=true) "Control block for storage plant flows"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Fluid.Storage.Plant.Controls.TankStatus tanSta(
    TLow=nom.T_CHWS_nominal,
    THig=nom.T_CHWR_nominal)
    "Tank status"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom
    "Nominal values for the storage plant"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Interfaces.BooleanInput chiIsOnl annotation (Placement(
        transformation(rotation=0, extent={{-120,40},{-100,60}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.IntegerInput com annotation (Placement(
        transformation(rotation=0, extent={{-120,60},{-100,80}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.BooleanInput hasLoa annotation (Placement(
        transformation(rotation=0, extent={{-120,20},{-100,40}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput yPum(final unit="1") annotation (
      Placement(transformation(rotation=0, extent={{-120,80},{-100,100}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare final package Medium =
        Medium) annotation (Placement(transformation(rotation=0, extent={{90,30},
            {110,50}}), iconTransformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare final package Medium =
        Medium) annotation (Placement(transformation(rotation=0, extent={{90,-70},
            {110,-50}}), iconTransformation(extent={{90,-70},{110,-50}})));
equation
  connect(tanSta.y, floCon.tanSta) annotation (Line(points={{61,-70},{70,-70},{70,
          -90},{-70,-90},{-70,42},{-61,42}},                   color={255,0,255}));
  connect(tanBra.port_bRetChi,chi2PreDro. port_a) annotation (Line(points={{0,-16},
          {-10,-16},{-10,-50},{-20,-50}},           color={0,127,255}));
  connect(chi2PreDro.port_b, chi.port_a) annotation (Line(points={{-40,-50},{-50,
          -50},{-50,-40}}, color={0,127,255}));
  connect(chi.port_b, pumPri.port_a)
    annotation (Line(points={{-50,-20},{-50,10},{-40,10}}, color={0,127,255}));
  connect(pumPri.port_b, tanBra.port_aSupChi) annotation (Line(points={{-20,10},
          {-10,10},{-10,-4},{0,-4}}, color={0,127,255}));
  connect(floCon.mPriPum_flow, pumPri.m_flow_in)
    annotation (Line(points={{-39,56},{-30,56},{-30,22}}, color={0,0,127}));
  connect(tanBra.port_bSupNet,revCon. port_a) annotation (Line(points={{20,-4},{
          34,-4},{34,10},{40,10}},        color={0,127,255}));
  connect(floCon.ySecPum,revCon. yPum) annotation (Line(points={{-39,50},{34,50},
          {34,16},{39,16}},          color={0,0,127}));
  connect(floCon.yVal,revCon. yVal) annotation (Line(points={{-39,44},{28,44},{28,
          4},{39,4}},                color={0,0,127}));
  connect(tanBra.TTan,tanSta. TTan) annotation (Line(points={{21,-20},{30,-20},{
          30,-70},{39,-70}},            color={0,0,127}));
  connect(chiIsOnl, floCon.chiIsOnl) annotation (Line(points={{-110,50},{-61,50}},
                                  color={255,0,255}));
  connect(com, floCon.com) annotation (Line(points={{-110,70},{-80,70},{-80,54},
          {-61,54}},   color={255,127,0}));
  connect(hasLoa, floCon.hasLoa) annotation (Line(points={{-110,30},{-80,30},{-80,
          46},{-61,46}},                                             color={255,
          0,255}));
  connect(yPum, floCon.yPum) annotation (Line(points={{-110,90},{-70,90},{-70,58},
          {-61,58}},        color={0,0,127}));
  connect(port_b, revCon.port_b)
    annotation (Line(points={{100,40},{80,40},{80,10},{60,10}},
                                                         color={0,127,255}));
  connect(port_a, tanBra.port_aRetNet) annotation (Line(points={{100,-60},{80,-60},
          {80,-16},{20,-16}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
end StoragePlant;
