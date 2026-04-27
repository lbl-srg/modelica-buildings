within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
block DryCooler "Model for thermal performance of dry cooling tower"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  parameter Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic
    dat "Performance data record"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of water"
    annotation (Dialog(group="Nominal condition"));

  final parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
      m_flow_nominal/dat.ratCooAir_nominal "Nominal mass flow rate of air"
    annotation (Dialog(group="Fan"));

  parameter Real yMin(min=0.01, max=1, final unit="1")
    "Minimum control signal until fan is switched off (used for smoothing
    between forced and free convection regime)"
    annotation (Dialog(group="Fan"));

  final parameter Modelica.Units.SI.ThermalConductance UA_nominal = UA.UA_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity";
  final parameter Real eps_nominal = UA.eps_nominal "Nominal heat transfer effectiveness";
  final parameter Real NTU_nominal(min = 0) = UA.NTU_nominal "Nominal number of transfer units";

  Modelica.Blocks.Interfaces.RealInput y(unit="1") "Fan control signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput m_flow(final unit="kg/s")
    "Cooling fluid mass flow rate"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TCooIn(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Inlet water temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput TAir(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Entering air wet bulb temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow "Heat removed from water"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil hA(
    final UA_nominal=UA.UA_nominal,
    final m_flow_nominal_w=m_flow_nominal,
    final m_flow_nominal_a=mAir_flow_nominal,
    final r_nominal=dat.UACor.r_nominal,
    final n_w=dat.UACor.n_w,
    final n_a=dat.UACor.n_a,
    final T0_w=dat.TCooIn_nominal,
    final T0_a=dat.TAirIn_nominal)
    "Convective heat transfer correction for flow rate and temperatures"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mAirFlo(
    final k=mAir_flow_nominal)
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.DryCoolerUA UA(
    redeclare final package Medium = Medium,
    final dat=dat,
    final m_flow_nominal=m_flow_nominal,
    final yMin=yMin)
    "Block that computes UA, effectiveness, and heat flow rate"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(hA.m1_flow, m_flow) annotation (Line(points={{-1,-23},{-12,-23},{-12,
          -80},{-120,-80}},                     color={0,0,127}));
  connect(hA.T_1, TCooIn) annotation (Line(points={{-1,-27},{-60,-27},{-60,-40},
          {-120,-40}}, color={0,0,127}));
  connect(hA.T_2, TAir) annotation (Line(points={{-1,-33},{-96,-33},{-96,40},{
          -120,40}},
                color={0,0,127}));
  connect(mAirFlo.u, y)
    annotation (Line(points={{-62,80},{-120,80}},                    color={0,0,127}));
  connect(hA.m2_flow, mAirFlo.y)
    annotation (Line(points={{-1,-37},{-20,-37},{-20,80},{-38,80}},  color={0,0,127}));
  connect(UA.mAir_flow, mAirFlo.y) annotation (Line(points={{59,7},{-20,7},{-20,
          80},{-38,80}}, color={0,0,127}));
  connect(UA.y, y) annotation (Line(points={{59,10},{-80,10},{-80,80},{-120,80}},
        color={0,0,127}));
  connect(UA.mCoo_flow, m_flow) annotation (Line(points={{59,4},{48,4},{48,-80},
          {-120,-80}}, color={0,0,127}));
  connect(UA.TCooIn, TCooIn) annotation (Line(points={{59,-2},{-60,-2},{-60,-40},
          {-120,-40}}, color={0,0,127}));
  connect(UA.TAirIn, TAir) annotation (Line(points={{59,1},{-96,1},{-96,40},{-120,
          40}}, color={0,0,127}));
  connect(UA.hA_1, hA.hA_1) annotation (Line(points={{59,-5},{30,-5},{30,-23},{21,
          -23}}, color={0,0,127}));
  connect(UA.hA_2, hA.hA_2) annotation (Line(points={{59,-8},{40,-8},{40,-37},{21,
          -37}}, color={0,0,127}));
  connect(UA.Q_flow, Q_flow)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-66,78},{68,-38}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,-10},{58,-130}},
          textColor={0,0,0},
          textString="DryCooler"),
        Ellipse(
          extent={{-54,62},{0,50}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,62},{54,50}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Model for the thermal performance of the dry cooling tower.
</p>
<p>
The air mass flow rate is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775;<sub>air</sub> = y m&#775;<sub>air,nominal</sub>
</p>
<p>
This air flow rate is supplied to both the heat transfer coefficient block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil\">
Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil</a>
(instance <code>hA</code>)
and to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.DryCoolerUA\">
Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.DryCoolerUA</a>
(instance <code>dryCoolerUA</code>), which computes the overall thermal
conductance <i>UA</i>, the effectiveness <i>&epsilon;</i>, and the
heat flow rate <i>Q&#775;</i>.
</p>
<p>
For the full documentation, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler\">
Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 27, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryCooler;
