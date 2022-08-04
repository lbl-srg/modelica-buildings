within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model PVsimple_N "Simple PV source with neutral cable"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.UnbalancedPV_N(
    redeclare Buildings.Electrical.AC.OnePhase.Sources.PVSimple pv_phase1,
    redeclare Buildings.Electrical.AC.OnePhase.Sources.PVSimple pv_phase2,
    redeclare Buildings.Electrical.AC.OnePhase.Sources.PVSimple pv_phase3);
  Modelica.Blocks.Interfaces.RealInput G(unit="W/m2")
    "Total solar irradiation per unit area"
     annotation (Placement(transformation(
        origin={0,110},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,110})));
equation
  connect(G, G_int) annotation (Line(
      points={{0,110},{0,94},{0,94},{0,88},{-94,88},{-94,20},{-80,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="pv",
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2022, by Michael Wetter:<br/>
Corrected documentation string for parameter <code>A</code>.
</li>
<li>
October 7, 2019, by Michael Wetter:<br/>
Corrected model to include DC/AC conversion in output <code>P</code>.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1577\">1577</a>.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Simple PV model for three-phase unbalanced systems with neutral cable connection.
</p>
<p>
For more information, see
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Sources.PVSimple\">
Buildings.Electrical.AC.OnePhase.Sources.PVSimple</a>.
</p>
</html>"));
end PVsimple_N;
