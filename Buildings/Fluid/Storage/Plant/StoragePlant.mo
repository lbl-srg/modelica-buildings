within Buildings.Fluid.Storage.Plant;
model StoragePlant "Model of a storage plant with a chiller and a CHW tank"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  Buildings.Fluid.Sources.PropertySource_T chi(
    redeclare final package Medium = Medium,
    final use_T_in=true) "Chiller represented by an ideal temperature source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-30})));
  Modelica.Blocks.Sources.Constant TSet(final k=nom.T_CHWS_nominal)
    "Constant CHW leaving temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow pumPri(
    redeclare final package Medium = Medium,
    final addPowerToMedium=false,
    final m_flow_nominal=nom.mChi_flow_nominal,
    final dp_nominal=chi2PreDro.dp_nominal) "Primary CHW pump"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop chi2PreDro(
    redeclare final package Medium = Medium,
    final m_flow_nominal=nom.mChi_flow_nominal,
    dp_nominal=0.1*nom.dp_nominal) "Pressure drop of the chiller loop"
                                                     annotation (Placement(
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
  Modelica.Blocks.Interfaces.BooleanInput chiEnaSta
    "Chiller enable status, true if chiller is enabled" annotation (Placement(
        transformation(rotation=0, extent={{-120,40},{-100,60}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.IntegerInput com
    "Command: 1 = charge tank, 2 = hold tank, 3 = discharge from tank"
                                              annotation (Placement(
        transformation(rotation=0, extent={{-120,60},{-100,80}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.BooleanInput hasLoa "True: Has load"
                                                 annotation (Placement(
        transformation(rotation=0, extent={{-120,20},{-100,40}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput yPum(final unit="1")
    "Normalised speed signal for the secondary pump"        annotation (
      Placement(transformation(rotation=0, extent={{-120,80},{-100,100}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium)
    annotation (Placement(transformation(rotation=0, extent={{90,30},
            {110,50}}), iconTransformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium)
    annotation (Placement(transformation(rotation=0, extent={{90,-70},
            {110,-50}}), iconTransformation(extent={{90,-70},{110,-50}})));
equation
  connect(tanSta.y, floCon.tanSta) annotation (Line(points={{61,-70},{70,-70},{70,
          -90},{-70,-90},{-70,42},{-61,42}},                   color={255,0,255}));
  connect(tanBra.port_bRetChi,chi2PreDro. port_a) annotation (Line(points={{0,-16},
          {-10,-16},{-10,-50},{-20,-50}},           color={0,127,255}));
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
  connect(chiEnaSta, floCon.chiEnaSta) annotation (Line(points={{-110,50},{-61,50}},
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
  connect(chi2PreDro.port_b, chi.port_a) annotation (Line(points={{-40,-50},{-50,
          -50},{-50,-40}}, color={0,127,255}));
  connect(chi.port_b, pumPri.port_a)
    annotation (Line(points={{-50,-20},{-50,10},{-40,10}}, color={0,127,255}));
  connect(TSet.y, chi.T_in) annotation (Line(points={{-79,-30},{-74,-30},{-74,-34},
          {-62,-34}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,62},{100,58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-60,-58},{100,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-60,58},{-56,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{40,80},{80,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{80,60},{60,80},{60,40},{80,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,80},{0,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{0,60},{-20,80},{-20,40},{0,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,22},{-38,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-62,22},{-74,-10}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-54,22},{-42,-10}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{18,58},{22,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{0,22},{40,-18}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{6,16},{34,16}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{6,-12},{34,-12}},
          color={0,0,0},
          thickness=0.5)}),
        defaultComponentName="stoPla",
    Documentation(info="<html>
<p>
This model encompasses the components of the storage plant.
It includes the chiller, the flow-controlled primary pump, the stratefied
storage tank, and the reversible connection.
</p>
<ul>
<li>
When the plant produces CHW, the pump activates and the valve on the parallel
branch is closed off.
</li>
<li>
When the storage tank in the plant is being charged remotely by a chiller
elsewhere in the district system, the valve is open to throttle water
from the district network to the tank.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 28, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end StoragePlant;
