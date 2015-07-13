within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
partial model CoolingTower "Base class for cooling towers"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol);
  extends Buildings.BaseClasses.BaseIcon;
  Modelica.Blocks.Interfaces.RealOutput TLvg "Leaving water temperature"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.SIunits.HeatFlowRate Q_flow = QWat_flow.y
    "Heat input into water circuit";
  Modelica.SIunits.TemperatureDifference TAppAct(min=0, nominal=1, displayUnit="K")
    "Actual approach temperature";

protected
  Modelica.SIunits.Temperature TAirHT
    "Air temperature that is used to compute the heat transfer with the water";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Sources.RealExpression QWat_flow(y=m_flow*(
        Medium.specificEnthalpy(Medium.setState_pTX(
        p=port_b.p,
        T=TAirHT + TAppAct,
        X=inStream(port_b.Xi_outflow))) - inStream(port_a.h_outflow)))
    "Heat input into water"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_Vol
    "Water temperature in volume, or leaving water temperature"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

equation
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-20,-50},{-16,-50},{-16,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QWat_flow.y, preHea.Q_flow)
                                   annotation (Line(
      points={{-59,-50},{-40,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_Vol.port, vol.heatPort) annotation (Line(
      points={{20,-60},{-16,-60},{-16,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_Vol.T, TLvg) annotation (Line(
      points={{40,-60},{110,-60}},
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
          extent={{-100,41},{-70,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-104,70},{-70,32}},
          lineColor={0,0,127},
          textString="TAir"),
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
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
