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
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mRecPum_flow(k=2)
    "Mass flow setpoint of the recirculation pump"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(mWatEva_flow.y, watBas.mWatEva_flow) annotation (Line(points={{-18,50},
          {20,50},{20,16},{58,16}}, color={0,0,127}));
  connect(mRecPum_flow.y, watBas.mRecPum_flow) annotation (Line(points={{-18,
          -30},{20,-30},{20,4},{58,4}}, color={0,0,127}));
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
</html>", revisions="<html>
<ul>
<li>
November 27, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end WaterBasin;
