within Buildings.Fluid.FMI.Examples;
model LoopPressureDrop "Fluid loop with a pressure drop"
  extends Modelica.Icons.Example;
  IdealSource_m_flow sou "Flow source"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  FixedResistanceDpM fixedResistanceDpM
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end LoopPressureDrop;
