within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model PVsimple
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.UnbalancedPV;
  Modelica.Blocks.Interfaces.RealInput G(unit="W/m2")
    "Total solar irradiation per unit area"
     annotation (Placement(transformation(
        origin={0,100},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
equation
  connect(G, G_int) annotation (Line(
      points={{0,100},{0,70},{-20,70},{-20,88},{-94,88},{-94,20},{-66,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end PVsimple;
