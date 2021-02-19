within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block PrimaryVariableFlow
  "Block that computes the variable mass flow rate through condenser or evaporator"
  extends Modelica.Blocks.Icons.Block;
  parameter Boolean have_ratLim = true
    "Set to true to limit to limit the rate of change in the flow rate";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat flow rate at nominal conditions (>0 for condenser)";
  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    min=if Q_flow_nominal>0 then Modelica.Constants.eps else -100,
    max=if Q_flow_nominal<0 then -Modelica.Constants.eps else 100)
    "DeltaT at nominal conditions (>0 for condenser)";
  parameter Real ratFloMin(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Minimum mass flow rate (ratio to nominal)";
  constant Modelica.SIunits.SpecificHeatCapacity cp=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    Q_flow_nominal/cp/dT_nominal
    "Mass flow rate at nominal conditions";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput loa(final unit="W")
    "Signal approximating the load on condenser or evaporator"
    annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant masFloMin(
    final k=ratFloMin*m_flow_nominal)
    "Minimum mass flow rate"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain masFlo_dT(
    final k=1/cp/dT_nominal)
    "Mass flow rate for constant DeltaT"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max masFlo "Mass flow rate"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow(final unit="kg/s")
    "Mass flow rate"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
                   iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.SlewRateLimiter ramLim(
    raisingSlewRate=0.1/60,
    Td=60,
    final enable=have_ratLim)
    "Rate limiter"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(loa, masFlo_dT.u)
    annotation (Line(points={{-120,0},{-62,0}}, color={0,0,127}));
  connect(masFloMin.y, masFlo.u1) annotation (Line(points={{-38,40},{-20,40},{-20,
          6},{-2,6}}, color={0,0,127}));
  connect(masFlo_dT.y, masFlo.u2) annotation (Line(points={{-38,0},{-10,0},{-10,
          -6},{-2,-6}}, color={0,0,127}));
  connect(ramLim.y, m_flow)
    annotation (Line(points={{62,0},{80,0},{80,0},{120,0}}, color={0,0,127}));
  connect(masFlo.y, ramLim.u)
    annotation (Line(points={{22,0},{38,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="conFlo",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PrimaryVariableFlow;
