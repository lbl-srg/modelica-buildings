within Buildings.AirCleaning;
model RoomGUV "In-room GUV"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  parameter Real frad(min=0, max=1) = 0.2
    "Fraction of irradiated space";

  parameter Modelica.Units.SI.Irradiance Eavg=0.5
    "Effluence rate";

  parameter Real krad[Medium.nC](unit="m2/J")=0.28
    "Inactivation constant";

  parameter Modelica.Units.SI.Power kpow(min=0) = 120
    "Rated power";

  parameter Modelica.Units.SI.Volume V=120
    "Zone volume";

  Modelica.Blocks.Interfaces.RealInput C[Medium.nC] "Zone concentration"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput yC_flow[Medium.nC]
    "Concentration outflow"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.BooleanInput u "on/off"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a diss "Heat dissipation"
    annotation (Placement(transformation(extent={{94,-90},{114,-70}})));

protected
  Modelica.Blocks.Math.Gain pow(final k=kpow)
                                             "power of GUV"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prePow(final alpha=0)
    "Prescribed power (=heat and flow work) flow for dynamic model"
    annotation (Placement(transformation(extent={{42,-30},{62,-10}})));

equation

  for i in 1:Medium.nC loop
    yC_flow[i]  = booleanToReal.y*1.2*(-frad)*Eavg*krad[i]*V*C[i];
  end for;

  connect(u, booleanToReal.u)
    annotation (Line(points={{-120,-20},{-82,-20}}, color={255,0,255}));
  connect(booleanToReal.y, pow.u)
    annotation (Line(points={{-59,-20},{-22,-20}}, color={0,0,127}));
  connect(pow.y, prePow.Q_flow) annotation (Line(points={{1,-20},{42,-20}},
                                     color={0,0,127}));
  connect(prePow.port, diss) annotation (Line(points={{62,-20},{90,-20},{90,-80},
          {104,-80}}, color={191,0,0}));
  annotation (Icon(graphics={
        Polygon(
          points={{-60,58},{-60,-64},{-40,-64},{-40,58},{-60,58}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-36,48},{42,48}}, color={28,108,200}),
        Line(points={{-36,26},{42,26}}, color={28,108,200}),
        Line(points={{-36,8},{42,8}},   color={28,108,200}),
        Line(points={{-36,-32},{42,-32}}, color={28,108,200}),
        Line(points={{-36,-52},{42,-52}}, color={28,108,200}),
        Line(points={{-36,-12},{42,-12}}, color={28,108,200})}),
      Documentation(info="<html>
<p>This model is designed to simulate the inactivation of trace species by either upper- or whole-room germicidal ultraviolet (GUV) devices when the GUV is enabled <span style=\"font-family: Courier New;\">uGUVEna</span>. The RoomGUV model calculates the mass inactivation rate of trace species in the zone from the GUV(yC_flow) based on the equation described below. The GUV device consumes energy based on a constant power rating, <span style=\"font-family: Courier New;\">kpow</span>, which is ultimately dissipated into the zone as heat. </p>
<h4>Main Equations </h4>
<p>Ċ<sub>GUV</sub> = E<sub>avg</sub> k<sub>rad</sub>f<sub>rad</sub>V<sub>zone</sub>c<sub>zone</sub> </p>
<p>where Ċ<sub>PAC</sub> is the inactivation rate of trace species by the GUV, E<sub>avg</sub> is the average fluence rate of the GUV device, k<sub>rad</sub> is susceptibility of the trace species to the GUV irrdiation, f<sub>rad</sub> is the fraction of irradiated volume in the zone, V<sub>zone</sub> is the total volume of the zone, and c<sub>zone</sub> is the trace species concentration in the zone where the GUV is located. </p>
<h4>Assumptions </h4>
<p>This assumes that the zone is well mixed and the parameters E<sub>avg</sub>,k<sub>rad</sub>, and f<sub>rad</sub> are constant for the given simulation when the GUV device is on. </p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024 by Cary Faulkner:<br/>
First implementation.
</li>
</ul>
</html>"));
end RoomGUV;
