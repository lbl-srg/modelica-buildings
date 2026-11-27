within Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.Validation;
model WaterBasin "Water basin"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.WaterBasin watBas(
    height=0.5,
    crossArea=2,
    level_target=0.15,
    mMakUp_flow_nominal=0.5,
    cycCon=4,
      redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8
      perRecPum) "Water basin"
                 annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin mWatEva_flow(
    amplitude=0.01,
    freqHz=1/86400,
    offset=0.03)
    "Mass flow of water evaporation that leaves the water recirculation loop"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Controls.OBC.CDL.Logical.Sources.Pulse wetMod(period=86400)
    "True: the basin is operating on the wet mode; false: the basin is operating on the dry mode"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(mWatEva_flow.y, watBas.mWatEva_flow) annotation (Line(points={{-18,50},
          {20,50},{20,16},{58,16}}, color={0,0,127}));
  connect(wetMod.y, watBas.wetMod) annotation (Line(points={{-18,-30},{20,-30},
          {20,4},{58,4}}, color={255,0,255}));
  annotation (experiment(
      StopTime=86400,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/EvaporativeCoolers/BaseClasses/Validation/WaterBasin.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.WaterBasin\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.WaterBasin</a>.
</p>
<p>
The water basin is configured with a tank height of <i>0.5</i> m, a
cross-sectional area of <i>2</i> m<sup>2</sup>, a target water level of
<i>0.15</i> m, a nominal make-up water mass flow rate of <i>0.5</i> kg/s,
and a cycle of concentration of <i>4</i>. The mass flow rate of water that
evaporates from the recirculation loop is prescribed as a sinusoidal signal
with a period of one day and an amplitude of <i>0.01</i> kg/s around an
offset of <i>0.03</i> kg/s. The boolean input <code>wetMod</code> is a pulse
signal with a period of one day, so the basin operates in the wet mode during
the first half of each day and in the dry mode during the second half.
</p>
<p>
The validation generates three subplots.
</p>
<ul>
<li>
Subplot 1 shows the water level of the tank <code>watBas.tan.level</code>.
During the wet mode, the level decreases due to the evaporation and blowdown
water flows until the hysteresis enables the make-up water flow, which brings
the level back toward the target. During the dry mode, the level remains
constant because no water leaves the recirculation loop.
</li>
<li>
Subplot 2 shows the evaporation mass flow rate <code>watBas.mWatEva_flow</code>
and the make-up water mass flow rate <code>watBas.mMakUp_flow</code>.
The make-up water flow is enabled and disabled by the hysteresis of the water
level control.
</li>
<li>
Subplot 3 shows the prescribed recirculation pump mass flow rate
<code>watBas.mov.m_flow_in</code> and the actual recirculation water mass flow
rate <code>watBas.tan.ports[1].m_flow</code>. The pump operates at the nominal
mass flow rate during the wet mode and is off during the dry mode.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 27, 2026, by Weiping Huang:<br/>
Revised the documentation.
</li>
<li>
November 27, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end WaterBasin;
