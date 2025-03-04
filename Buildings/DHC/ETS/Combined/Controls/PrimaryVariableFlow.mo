within Buildings.DHC.ETS.Combined.Controls;
block PrimaryVariableFlow
  "Ideal control of condenser or evaporator variable flow rate"

  constant Real cp(
    final quantity="SpecificHeatCapacity",
    final unit="J/(kg.K)")=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity";
  parameter Real Q_flow_nominal(
    final quantity="HeatFlowRate",
    final unit="W")
    "Heat flow rate at nominal conditions (>0 for condenser)";
  parameter Real dT_nominal(
    final quantity="TemperatureDifference",
    final unit="K",
    min=if Q_flow_nominal > 0 then Buildings.Controls.OBC.CDL.Constants.eps else -100,
    max=if Q_flow_nominal < 0 then -Buildings.Controls.OBC.CDL.Constants.eps else 100)
    "DeltaT at nominal conditions (>0 for condenser)";
  parameter Real ratFloMin(
    final unit="1",
    final min=0,
    final max=1)=0.3
    "Minimum mass flow rate (ratio to nominal)";

  final parameter Real m_flow_nominal(
    final quantity="MassFlowRate",
    final unit="kg/s",
    final min=0)=
    Q_flow_nominal/cp/dT_nominal
    "Mass flow rate at nominal conditions";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput loa(final unit="W")
    "Signal approximating the load on condenser or evaporator"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow(final unit="kg/s")
    "Mass flow rate"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant masFloMin(
    final k=ratFloMin*m_flow_nominal)
    "Minimum mass flow rate"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter masFlo_dT(
    final k=1/cp/dT_nominal)
    "Mass flow rate for constant DeltaT"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Max masFlo "Mass flow rate"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1 "Absolute value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(loa, masFlo_dT.u)
    annotation (Line(points={{-120,0},{-62,0}}, color={0,0,127}));
  connect(masFloMin.y, masFlo.u1) annotation (Line(points={{12,40},{20,40},{20,
          6},{38,6}}, color={0,0,127}));
  connect(masFlo.y, m_flow)
    annotation (Line(points={{62,0},{120,0}}, color={0,0,127}));
  connect(masFlo_dT.y, abs1.u)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(abs1.y, masFlo.u2)
    annotation (Line(points={{12,0},{20,0},{20,-6},{38,-6}}, color={0,0,127}));
  annotation (
    defaultComponentName="conFlo",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{102,140}},
          textString="%name")}),                       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block implements an ideal control of the evaporator (or condenser) water
mass flow rate.
The control intent aims to maintain a constant water temperature difference
<code>dT_nominal</code> across the heat exchanger, within the limit of a
minimum mass flow rate ratio <code>ratFloMin</code>.
For computational performance and to avoid the use of a PI controller,
the required mass flow rate is computed based on a signal representative of
the load.
</p>
</html>", revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrimaryVariableFlow;
