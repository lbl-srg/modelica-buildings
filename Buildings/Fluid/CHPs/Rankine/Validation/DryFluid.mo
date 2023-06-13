within Buildings.Fluid.CHPs.Rankine.Validation;
model DryFluid "Organic Rankine cycle with a dry working fluid"
  extends Modelica.Icons.Example;
  Buildings.Fluid.CHPs.Rankine.Cycle cyc(
    final pro=pro,
    TEva(displayUnit="K") = max(pro.T)*2/3 + min(pro.T)/3,
    TCon(displayUnit="K") = max(pro.T)/3 + min(pro.T)*2/3,
    etaExp=0.85)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable parameter
            Buildings.Fluid.CHPs.Rankine.Data.WorkingFluids.Toluene pro
    constrainedby Buildings.Fluid.CHPs.Rankine.Data.Generic
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{60,60},{80,80}})),
      choicesAllMatching=true);
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Ramp ram(height=2E5, duration=1)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.CHPs.Rankine.BaseClasses.HeatSink heaSin "Heat sink"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
equation
  connect(preHeaFlo.port, cyc.port_a)
    annotation (Line(points={{-20,30},{0,30},{0,10}}, color={191,0,0}));
  connect(preHeaFlo.Q_flow, ram.y)
    annotation (Line(points={{-40,30},{-59,30}}, color={0,0,127}));
  connect(cyc.port_b, heaSin.port) annotation (Line(points={{0,-10},{0,-46},{30,
          -46},{30,-40}}, color={191,0,0}));
end DryFluid;
