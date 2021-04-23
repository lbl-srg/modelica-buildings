within Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses;
model Building
  "Dummy building model for validation purposes"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding;
  parameter Modelica.SIunits.HeatFlowRate QChiWat_flow_nominal
    "Design heat flow rate for chilled water production (<0)"
    annotation (Dialog(group="Nominal condition",enable=have_chiWat));
  parameter Modelica.SIunits.HeatFlowRate QHeaWat_flow_nominal
    "Design heat flow rate for heating water production (>0)"
    annotation (Dialog(group="Nominal condition",enable=have_heaWat));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPHea(
    k=1)
    annotation (Placement(transformation(extent={{240,190},{260,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPCoo(
    k=1)
    annotation (Placement(transformation(extent={{240,150},{260,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPFan(
    k=1)
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPPum(
    k=1)
    annotation (Placement(transformation(extent={{240,70},{260,90}})));
  Fluid.HeatExchangers.HeaterCooler_u loaHea(
    redeclare final package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=-QHeaWat_flow_nominal,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=0) if have_heaWat
    "Heating load"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Fluid.HeatExchangers.HeaterCooler_u loaCoo(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=-QChiWat_flow_nominal,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=0) if  have_chiWat
    "Cooling load"
    annotation (Placement(transformation(extent={{-10,-270},{10,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "One"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    p=0, k=-1) if  have_heaWat
    "Opposite"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    p=0, k=-1) if  have_chiWat
    "Opposite"
    annotation (Placement(transformation(extent={{30,-250},{50,-230}})));
equation
  connect(souPHea.y, mulPHea.u)
    annotation (Line(points={{262,200},{268,200}}, color={0,0,127}));
  connect(souPCoo.y, mulPCoo.u)
    annotation (Line(points={{262,160},{268,160}}, color={0,0,127}));
  connect(souPFan.y, mulPFan.u)
    annotation (Line(points={{262,120},{268,120}}, color={0,0,127}));
  connect(souPPum.y, mulPPum.u)
    annotation (Line(points={{262,80},{268,80}}, color={0,0,127}));
  connect(mulHeaWatInl[1].port_b, loaHea.port_a)
    annotation (Line(points={{-260,-60},{-10,-60}}, color={0,127,255}));
  connect(loaHea.port_b, mulHeaWatOut[1].port_a) annotation (Line(points={{10,-60},
          {136,-60},{136,-60},{260,-60}}, color={0,127,255}));
  connect(loaCoo.port_b, mulChiWatOut[1].port_a) annotation (Line(points={{10,-260},
          {260,-260},{260,-260}}, color={0,127,255}));
  connect(mulChiWatInl[1].port_b, loaCoo.port_a) annotation (Line(points={{-260,
          -260},{-136,-260},{-136,-260},{-10,-260}}, color={0,127,255}));
  connect(loaHea.Q_flow, addPar.u) annotation (Line(points={{11,-54},{20,-54},{20,
          -40},{28,-40}}, color={0,0,127}));
  connect(loaCoo.Q_flow, addPar1.u) annotation (Line(points={{11,-254},{20,-254},
          {20,-240},{28,-240}}, color={0,0,127}));
  connect(addPar.y, mulQHea_flow.u) annotation (Line(points={{52,-40},{80,-40},{
          80,280},{268,280}}, color={0,0,127}));
  connect(addPar1.y, mulQCoo_flow.u) annotation (Line(points={{52,-240},{100,-240},
          {100,240},{268,240}}, color={0,0,127}));
  connect(one.y, loaHea.u) annotation (Line(points={{-58,-160},{-40,-160},{-40,
          -54},{-12,-54}}, color={0,0,127}));
  connect(one.y, loaCoo.u) annotation (Line(points={{-58,-160},{-40,-160},{-40,
          -254},{-12,-254}}, color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a minimum example of a class extending
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding</a>
developed for testing purposes only.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Building;
