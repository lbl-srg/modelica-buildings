within Districts.Electrical.DC.Loads;
model Conductor "Model of a constant conductive load"
    extends Districts.Electrical.Interfaces.PartialLoad(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.TwoConductor, redeclare
      Districts.Electrical.DC.Interfaces.Terminal_n
                                                 terminal);
  //Modelica.SIunits.Conductance G(start=1);
equation
  //PhaseSystem.systemVoltage(terminal.v)*G = PhaseSystem.systemCurrent(terminal.i);
  //G = P/PhaseSystem.systemVoltage(terminal.v)^2;
  PhaseSystem.activePower(terminal.v, terminal.i) = P;
  sum(i) = 0;
  annotation (
    Documentation(info="<html>
<p>
Model of a constant conductive load.
</p>
<p>
The model computes the power as
<i>P_nominal = v &nbsp; i</i>,
where <i>v</i> is the voltage and <i>i</i> is the current.
</p>
</html>", revisions="<html>
<ul>
<li>
February 1, 2013, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
          Rectangle(
            extent={{-70,30},{70,-30}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Text(
            extent={{-152,87},{148,47}},
            textString="%name",
            lineColor={0,0,255}),
          Text(
            extent={{-144,-38},{142,-70}},
            lineColor={0,0,0},
            textString="G=%G")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
          Line(points={{-96,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{96,0}}, color={0,0,255}),
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255})}));
end Conductor;
