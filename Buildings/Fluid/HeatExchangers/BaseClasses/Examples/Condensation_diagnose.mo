within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model Condensation_diagnose
  "Test model for water condensation process - WaterIF97_R2pT model"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  Buildings.Fluid.HeatExchangers.BaseClasses.Condensation con
    "Condensation process"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Sources.Boundary_pT watSin(redeclare package Medium = MediumWat, nPorts=1)
    "Water (100% liquid) sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));

  Modelica.Blocks.Interfaces.RealOutput dh
    "Change in enthalpy for secondary side"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Math.Gain inv(k=-1) "Inverse"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Sources.Boundary_pT steSou(
    redeclare package Medium = MediumSte,
    T=473.15,
    nPorts=1) "Steam source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Pump"
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));
equation
  connect(inv.y, dh)
    annotation (Line(points={{61,60},{110,60}}, color={0,0,127}));
  connect(inv.u, con.dh)
    annotation (Line(points={{38,60},{16,60},{16,6},{11,6}}, color={0,0,127}));
  connect(steSou.ports[1], con.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(con.port_b, pum.port_a)
    annotation (Line(points={{10,0},{24,0}}, color={0,127,255}));
  connect(pum.port_b, watSin.ports[1])
    annotation (Line(points={{44,0},{60,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/Condensation.mos"
        "Simulate and plot"));
end Condensation_diagnose;
