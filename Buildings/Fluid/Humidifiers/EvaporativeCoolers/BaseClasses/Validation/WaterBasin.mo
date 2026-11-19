within Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.Validation;
model WaterBasin "Water basin"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.WaterBasin watBas
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Controls.OBC.CDL.Reals.Sources.Sin mEva_flow(
    amplitude=0.01,
    freqHz=1/86400,
    offset=0.03) "Flow of evaporated water leaving the recirculation loop"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Controls.OBC.CDL.Reals.Sources.Constant mRecPum_flow(k=2)
    "Mass flow setpoint of the recirculation pump"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(mEva_flow.y, watBas.mEva_flow) annotation (Line(points={{-18,50},{20,
          50},{20,16},{58,16}}, color={0,0,127}));
  connect(mRecPum_flow.y, watBas.mRecPum_flow) annotation (Line(points={{-18,
          -30},{20,-30},{20,4},{58,4}}, color={0,0,127}));
  annotation (experiment(
      StopTime=86400,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end WaterBasin;
