within Buildings.Fluid.CHPs.Rankine.BaseClasses;
model HeatSink "A heat sink with unspecified temperature and infinite capacity"
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a
                        port annotation (Placement(transformation(
        origin={0,-100},
        extent={{-10,-10},{10,10}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-100})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Ellipse(extent={{-100,100},{100,-100}}, lineColor={28,108,200}), Text(
          extent={{-100,40},{98,-40}},
          textColor={28,108,200},
          textString="C = inf")}), Diagram(coordinateSystem(preserveAspectRatio
          =false)));
end HeatSink;
