within Buildings.Applications.DHC.Networks.BaseClasses;
block EnthalpyFlowRateDifference
  "Block that computes the enthalpy flow rate difference"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput TInl(
    final unit="K",
    displayUnit="degC") "Inlet temperature" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC") "Outlet temperature" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,10})));
  Modelica.Blocks.Interfaces.RealOutput dh_flow(final unit="W")
    "Enthalpy flow rate difference" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(final k=cp)
    "Times cp"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,0})));
  Buildings.Controls.OBC.CDL.Continuous.Add sub(final k1=-1)
    "Delta T"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro if show_heaFlo
    "Delta T times flow rate"
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Blocks.Interfaces.RealInput m_flow(
    final unit="kg/s") "Mass flow rate"
    annotation (Placement(
      transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,-60}), iconTransformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,10})));
equation
  connect(gai.y, dh_flow)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(TOut, sub.u2) annotation (Line(points={{-120,0},{-80,0},{-80,-6},{-62,
          -6}}, color={0,0,127}));
  connect(TInl, sub.u1) annotation (Line(points={{-120,60},{-80,60},{-80,6},{-62,
          6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Block that computes the enthalpy flow rate difference between two streams
of the <i>same circuit</i>, so with the same medium at the same mass flow rate.
The computation uses the temperature of the two streams as inputs and
the variation of the specific heat capacity is neglected.
</p>
</html>"));
end EnthalpyFlowRateDifference;
