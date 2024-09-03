within Buildings.Fluid.HeatExchangers.CoolingTowers;
model FixedApproach "Cooling tower with constant approach temperature"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower;

  parameter Modelica.Units.SI.TemperatureDifference TApp(
    min=0,
    displayUnit="K") = 2 "Approach temperature difference";
  Modelica.Blocks.Interfaces.RealInput TAir(min=0, unit="K")
    "Entering air dry or wet bulb temperature"
     annotation (Placement(transformation(
          extent={{-140,20},{-100,60}})));

protected
  Modelica.Blocks.Sources.RealExpression QWat_flow(
    y = m_flow*(
      Medium.specificEnthalpy(Medium.setState_pTX(
      p=port_b.p,
      T=TAir + TApp,
      X=inStream(port_b.Xi_outflow))) - inStream(port_a.h_outflow)))
    "Heat input into water"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
equation
  connect(QWat_flow.y, preHea.Q_flow)
    annotation (Line(points={{-59,-60},{-40,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-100,70},{-70,32}},
          textColor={0,0,127},
          textString="TAir")}),
    Documentation(info="<html>
<p>
Model for a steady-state or dynamic cooling tower with constant approach temperature.
The approach temperature is the difference between the leaving water temperature and
the entering air temperature.
The entering air temperature is used from the signal <code>TAir</code>. If
connected to the a dry-bulb temperature, then a dry cooling tower is modeled.
If connected to a wet-bulb temperature, then a wet cooling tower is modeled.
</p><p>
By connecting a signal that contains either the dry-bulb or the wet-bulb
temperature, this model can be used to estimate the water return temperature
from a cooling tower.
For a more detailed model, use for example the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">YorkCalc</a>
model.
</p>
</html>", revisions="<html>
<ul>
<li>
January 16, 2020, by Michael Wetter:<br/>
Refactored model to avoid mixing textual equations and connect statements.
</li>
<li>
July 12, 2011, by Michael Wetter:<br/>
Introduced common base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc</a>
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach\">Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach</a>
so that they can be used as replaceable models.
</li>
<li>
May 12, 2011, by Michael Wetter:<br/>
Added binding equations for <code>Q_flow</code> and <code>mXi_flow</code>.
</li>
<li>
March 8, 2011, by Michael Wetter:<br/>
Removed base class and unused variables.
</li>
<li>
April 7, 2009, by Michael Wetter:<br/>
Changed interface to new Modelica.Fluid stream concept.
</li>
<li>
May 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FixedApproach;
