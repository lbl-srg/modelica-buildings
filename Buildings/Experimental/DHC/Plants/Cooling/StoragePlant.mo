within Buildings.Experimental.DHC.Plants.Cooling;
model StoragePlant "Model of a storage plant with a chiller and a CHW tank"

  extends Buildings.Fluid.Interfaces.PartialFourPort(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
     mTan_flow_nominal+mChi_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal(min=0)
    "Nominal mass flow rate for CHW tank branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal(min=0)
    "Nominal mass flow rate for CHW chiller branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.PressureDifference dpPum_nominal
    "Nominal pressure difference for secondary pump sizing"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.PressureDifference dpVal_nominal
    "Nominal pressure difference for return valve sizing"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal(
    final displayUnit="degC")=
     7+273.15 "Nominal temperature of CHW supply"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal(
    final displayUnit="degC")=
     12+273.15
    "Nominal temperature of CHW return"
    annotation(Dialog(group="Nominal values"));

  Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow pumPri(
    redeclare final package Medium = Medium,
    final addPowerToMedium=false,
    final m_flow_nominal=mChi_flow_nominal,
    final dp_nominal=chi2PreDro.dp_nominal) "Primary CHW pump"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop chi2PreDro(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChi_flow_nominal,
    dp_nominal=0.1*dpPum_nominal) "Pressure drop of the chiller loop"
                                                     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-50})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.TankBranch tanBra(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final mTan_flow_nominal=mTan_flow_nominal,
    final mChi_flow_nominal=mChi_flow_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal,
    VTan=0.8,
    hTan=3,
    dIns=0.3) "Tank branch, tank can be charged remotely" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-10})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ReversibleConnection
    revCon(redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final mTan_flow_nominal=mTan_flow_nominal,
    final dpPum_nominal=dpPum_nominal,
    final dpVal_nominal=dpVal_nominal,
    final T_start=T_CHWS_nominal)
    "Reversible connection"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Experimental.DHC.Plants.Cooling.Controls.FlowControl floCon(
    final mChi_flow_nominal=mChi_flow_nominal,
    final mTan_flow_nominal=mTan_flow_nominal,
    final use_outFil=true) "Control block for storage plant flows"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Experimental.DHC.Plants.Cooling.Controls.TankStatus tanSta(
    TLow=T_CHWS_nominal,
    THig=T_CHWR_nominal) "Tank status"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Interfaces.BooleanInput chiEnaSta
    "Chiller enable status, true if chiller is enabled" annotation (Placement(
        transformation(rotation=-90,
                                   extent={{-10,-10},{10,10}},
        origin={-60,110}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));
  Modelica.Blocks.Interfaces.IntegerInput com
    "Command: 1 = charge tank, 2 = no command, 3 = discharge from tank"
                                              annotation (Placement(
        transformation(rotation=-90,
                                   extent={{-10,-10},{10,10}},
        origin={-40,110}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
  Modelica.Blocks.Interfaces.BooleanInput hasLoa "True: Has load"
                                                 annotation (Placement(
        transformation(rotation=-90,
                                   extent={{-10,-10},{10,10}},
        origin={-80,110}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,110})));
  Modelica.Blocks.Interfaces.RealInput yPum(final unit="1")
    "Normalised speed signal for the secondary pump"        annotation (
      Placement(transformation(rotation=-90,
                                           extent={{-10,-10},{10,10}},
        origin={-20,110}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,110})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium = Medium)
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,origin={80,10})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dp(
    final quantity="PressureDifference",
    final unit="Pa",
    final displayUnit="Pa")
    "Pressure drop accross the connection (measured)"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
      iconTransformation(extent={{100,-20},{140,20}})));
equation
  connect(tanSta.y, floCon.tanSta) annotation (Line(points={{61,-70},{70,-70},{70,
          -90},{-70,-90},{-70,42},{-61,42}},                   color={255,0,255}));
  connect(floCon.mPriPum_flow, pumPri.m_flow_in)
    annotation (Line(points={{-39,56},{-30,56},{-30,22}}, color={0,0,127}));
  connect(floCon.ySecPum,revCon. yPum) annotation (Line(points={{-39,50},{34,50},
          {34,36},{39,36}},          color={0,0,127}));
  connect(floCon.yVal,revCon. yVal) annotation (Line(points={{-39,44},{30,44},{30,
          24},{39,24}},              color={0,0,127}));
  connect(tanBra.TTan,tanSta. TTan) annotation (Line(points={{21,-20},{30,-20},{
          30,-70},{39,-70}},            color={0,0,127}));
  connect(chiEnaSta, floCon.chiEnaSta) annotation (Line(points={{-60,110},{-60,80},
          {-76,80},{-76,50},{-61,50}},
                                  color={255,0,255}));
  connect(com, floCon.com) annotation (Line(points={{-40,110},{-40,76},{-72,76},
          {-72,54},{-61,54}},
                       color={255,127,0}));
  connect(hasLoa, floCon.hasLoa) annotation (Line(points={{-80,110},{-80,46},{-61,
          46}},                                                      color={255,
          0,255}));
  connect(yPum, floCon.yPum) annotation (Line(points={{-20,110},{-20,72},{-68,72},
          {-68,58},{-61,58}},
                            color={0,0,127}));
  connect(port_b2, chi2PreDro.port_b) annotation (Line(points={{-100,-60},{-84,-60},
          {-84,-50},{-40,-50}}, color={0,127,255}));
  connect(tanBra.port_a2, port_a2) annotation (Line(points={{20,-16},{80,-16},{80,
          -60},{100,-60}}, color={0,127,255}));
  connect(revCon.port_b, port_b1) annotation (Line(points={{60,30},{80,30},{80,60},
          {100,60}}, color={0,127,255}));
  connect(port_a1, pumPri.port_a) annotation (Line(points={{-100,60},{-84,60},{-84,
          10},{-40,10}}, color={0,127,255}));
  connect(pumPri.port_b, tanBra.port_a1) annotation (Line(points={{-20,10},{-6,10},
          {-6,-4},{0,-4}}, color={0,127,255}));
  connect(tanBra.port_b2, chi2PreDro.port_a) annotation (Line(points={{0,-16},{-6,
          -16},{-6,-50},{-20,-50}}, color={0,127,255}));
  connect(tanBra.port_b1, revCon.port_a) annotation (Line(points={{20,-4},{34,-4},
          {34,30},{40,30}}, color={0,127,255}));
  connect(port_b1, senRelPre.port_a)
    annotation (Line(points={{100,60},{80,60},{80,20}}, color={0,127,255}));
  connect(port_a2, senRelPre.port_b) annotation (Line(points={{100,-60},{80,-60},
          {80,-3.55271e-15}}, color={0,127,255}));
  connect(senRelPre.p_rel, dp) annotation (Line(points={{71,10},{66,10},{66,90},
          {120,90}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
                               Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,62},{100,58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,-58},{100,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{20,80},{60,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{60,60},{40,80},{40,40},{60,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,80},{-20,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-20,60},{-40,80},{-40,40},{-20,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,58},{2,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-20,22},{20,-18}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-14,16},{14,16}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-14,-12},{14,-12}},
          color={0,0,0},
          thickness=0.5)}),
        defaultComponentName="stoPla",
    Documentation(info="<html>
<p>
This model encompasses the components of a chilled water storage plant.
It includes a flow-controlled primary pump, a stratefied
storage tank, a reversible connection with a district network, and related controls
to coordinate charging and discharging of the tank.
The chiller is intentionally excluded in this model so that it can be
otherwise chosen and configured outside of this component.  
The tank in this plant can be charged by its local chiller or by a remote
chiller on the same CHW district network.
</p>
<h4>System Concept Example</h4>
<p>
An example usage of this model within a district network is implemented in
<a href=\"Modelica://Buildings.Experimental.DHC.Plants.Cooling.Examples.StoragePlantDualSource\">
Buildings.Experimental.DHC.Plants.Cooling.Examples.StoragePlantDualSource</a>.
Shown in the schematic below, it has two CHW plants and three users.
</p>
<ul>
<li>
Plant 1 only has a chiller. The supply pump, P1, is controlled to ensure that
all users have enough pressure head.  This represents a remote chiller plant,
referenced above.
</li>
<li>
Plant 2 has a chiller and a stratified CHW tank and is represented by this model.
The storage plant has a reversible connection to the district network 
that can either pump water to the network from the plant using the
pump P<sub>sec</sub>, 
or throttle water from the pressurised network to charge the tank.
</li>
</ul>
<p align=\"center\">
<img alt=\"SystemConcept\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Plants/Cooling/SystemConcept.png\"/>
</p>
<h4>Control Signals</h4>
<p>
The plants are controlled as follows:
</p>
<ul>
<li>
In plant 1, the chiller is always on. The speed-controlled pump
ensures that the users have enough pressure head at all times.
This includes plant 2 when its tank is charged remotely by plant 1 and
it acts like an energy consumer.
</li>
<li>
For plant 2:
<ul>
<li>
In the chiller loop, chiller 2 and its primary pump P<sub>pri</sub>
are on whenever needed (for charging the tank or producing CHW to the
network). Otherwise, they are commanded off.
</li>
<li>
The system receives a command to charge or discharge the storage tank.
The tank controller returns status signals indicating whether it is depleted,
cooled, or overcooled. The command may be disregarded. For example, if the
tank is receiving a discharge command but it is already depleted, it will not
discharge which would let warm return water directly flow to the supply side.
See the Implementation section for details.
</li>
<li>
The reversible connection between plant 2 and the district network
modulates the flow rate needed by plant 2.
<ul>
<li>
When the storage plant produces CHW, P<sub>sec</sub> receives a speed control
signal from the same PI controller as P1 in plant 1.
</li>
<li>
When the storage plant is charged remotely, the pressure-independent valve
is controlled to maintain a constant flow from the pressurised network
to the storage tank.
</li>
<li>
Otherwise, the connection cuts off flow to isolate plant 2 from
the district network.
</li>
</ul>
</li>
</ul>
</li>
</ul>
<p align=\"center\">
<img alt=\"ControlSignals\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Plants/Cooling/ControlSignals.png\"/>
</p>
<h4>Implementation</h4>
<p>
The chiller is implemented as an ideal temperature source where the outlet
temperature is always at the prescribed value in
<a href=\"Modelica://Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.IdealTemperatureSource\">
Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.IdealTemperatureSource</a>.
</p>
<p>
The control of the storage plant is implemented as a state graph in
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Cooling.Controls.FlowControl\">
Buildings.Experimental.DHC.Plants.Cooling.Controls.FlowControl</a>.
</p>
<p>
The status of tank is also implemented as a state graph in
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Cooling.Controls.TankStatus\">
Buildings.Experimental.DHC.Plants.Cooling.Controls.TankStatus</a>.
</p>
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
