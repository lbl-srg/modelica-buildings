within Buildings.Air.Systems.SingleZone.VAV.BaseClasses.Validation;
model HysteresisWithHold
  import Buildings;
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine pulse1(amplitude=0.2, freqHz=1/360)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.HysteresisWithHold onHold_30sec(offHolDur=
       30, onHolDur=30)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.HysteresisWithHold onHold_90sec(offHolDur=
       30, onHolDur=90)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.HysteresisWithHold onHold_120sec(offHolDur=
       30, onHolDur=120)
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.HysteresisWithHold onHold_150sec(offHolDur=
       30, onHolDur=150)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
equation
  connect(pulse1.y, onHold_30sec.u)
    annotation (Line(points={{-19,0},{0,0},{0,60},{18,60}}, color={0,0,127}));
  connect(pulse1.y, onHold_90sec.u)
    annotation (Line(points={{-19,0},{0,0},{0,20},{18,20}}, color={0,0,127}));
  connect(pulse1.y, onHold_120sec.u) annotation (Line(points={{-19,0},{0,0},{0,-20},
          {18,-20}}, color={0,0,127}));
  connect(pulse1.y, onHold_150sec.u) annotation (Line(points={{-19,0},{0,0},{0,-60},
          {18,-60}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1800,  Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/BaseClasses/Validation/HysteresisWithHold.mos"
        "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end HysteresisWithHold;
