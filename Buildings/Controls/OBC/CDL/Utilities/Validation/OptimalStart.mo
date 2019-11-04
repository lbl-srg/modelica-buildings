within Buildings.Controls.OBC.CDL.Utilities.Validation;
model OptimalStart
  extends Modelica.Icons.Example;
  Continuous.Sources.Constant TSetHea(k=21 + 273.15)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Continuous.Sources.Constant TSetCoo(k=24 + 273.15)
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Continuous.Sources.Sine TZon(
    amplitude=-1.3,
    freqHz=1/82800,
    offset=21 + 273.15,
    startTime(displayUnit="h") = 0) "Zone temperature for heating case"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Utilities.OptimalStart optStaHea(heating_only=true,
      cooling_only=false) "Heating only case"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Utilities.OptimalStart optStaCoo(heating_only=
        false, cooling_only=true) "Cooling only case"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Utilities.OptimalStart optSta(heating_only=false,
      cooling_only=false) "Both heating and cooling"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Continuous.Sources.Sine TZon1(
    amplitude=1,
    freqHz=1/82800,
    offset=24 + 273.15,
    startTime(displayUnit="h") = 0) "Zone temperature for cooling case"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Continuous.Sources.Sine TZon2(
    amplitude=2.5,
    freqHz=1/165600,
    offset=22.5 + 273.15,
    startTime(displayUnit="h") = 0)
    "Zone temperature for both heating and cooling case"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(TZon.y, optStaHea.TZon)
    annotation (Line(points={{-18,80},{0,80},{0,30},{18,30}},
                                                color={0,0,127}));
  connect(optStaCoo.TSetZonCoo, TSetCoo.y) annotation (Line(points={{18,-18},{0,
          -18},{0,-80},{-18,-80}}, color={0,0,127}));
  connect(TSetHea.y, optSta.TSetZonHea) annotation (Line(points={{-18,-40},{0,
          -40},{0,-42},{18,-42}},  color={0,0,127}));
  connect(TSetCoo.y, optSta.TSetZonCoo) annotation (Line(points={{-18,-80},{0,
          -80},{0,-58},{18,-58}}, color={0,0,127}));
  connect(TSetHea.y, optStaHea.TSetZonHea) annotation (Line(points={{-18,-40},{
          0,-40},{0,38},{18,38}},   color={0,0,127}));
  connect(TZon1.y, optStaCoo.TZon) annotation (Line(points={{-18,40},{-4,40},{
          -4,-10},{18,-10}}, color={0,0,127}));
  connect(TZon2.y, optSta.TZon) annotation (Line(points={{-18,0},{-10,0},{-10,
          -50},{18,-50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=604800));
end OptimalStart;
