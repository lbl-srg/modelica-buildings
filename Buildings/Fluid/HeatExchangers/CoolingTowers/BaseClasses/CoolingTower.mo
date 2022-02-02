within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
partial model CoolingTower "Base class for cooling towers"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol);

  Modelica.Blocks.Interfaces.RealOutput TLvg(
    final unit="K",
    displayUnit="degC") "Leaving water temperature"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Units.SI.HeatFlowRate Q_flow=preHea.Q_flow
    "Heat input into water circuit";

protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Water temperature in volume, leaving at port_b"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

equation
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-20,-60},{-16,-60},{-16,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TVol.port, vol.heatPort) annotation (Line(
      points={{20,-60},{-16,-60},{-16,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TVol.T, TLvg) annotation (Line(
      points={{41,-60},{110,-60}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-70,86},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{76,-58},{100,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{76,-60},{80,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
         extent={{190,-6},{70,-56}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(TLvg-273.15, format=".1f"))),
        Text(
          extent={{90,-20},{124,-58}},
          textColor={0,0,127},
          textString=DynamicSelect("TLvg", ""))}),
defaultComponentName="cooTow",
    Documentation(info="<html>
<p>
Base class for a steady-state cooling tower.
The variable <code>TAirHT</code> is used to compute the heat transfer with the water side of the cooling tower.
For a dry cooling tower, this is equal to the dry-bulb temperature.
For a wet cooling tower, this is equal to the wet-bulb temperature.
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
end CoolingTower;
