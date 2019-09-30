within Buildings.Controls.OBC.CDL.Utilities.Validation;
model OptimalStart
  extends Modelica.Icons.Example;
  Continuous.Sources.Constant TSetHea(k=21 + 273.15)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Continuous.Sources.Constant TSetCoo(k=24 + 273.15)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Continuous.Sources.Sine TZon(
    amplitude=8,
    freqHz=1/172800,
    offset=20 + 273.15,
    startTime(displayUnit="h") = -3600) "Zone temperature"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Utilities.OptimalStart optStaHea(heating_only=true,
      cooling_only=false) "Heating only case"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Utilities.OptimalStart optStaCoo(heating_only=
        false, cooling_only=true) "Cooling only case"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Utilities.OptimalStart optSta(heating_only=false,
      cooling_only=false) "Both heating and cooling"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
equation
  connect(TZon.y, optStaHea.TZon)
    annotation (Line(points={{-18,30},{18,30}}, color={0,0,127}));
  connect(optStaCoo.TZon, TZon.y) annotation (Line(points={{18,-10},{-12,-10},{
          -12,30},{-18,30}}, color={0,0,127}));
  connect(optStaCoo.TSetZonCoo, TSetCoo.y) annotation (Line(points={{18,-18},{0,
          -18},{0,-50},{-18,-50}}, color={0,0,127}));
  connect(TZon.y, optSta.TZon) annotation (Line(points={{-18,30},{-12,30},{-12,
          -50},{18,-50}}, color={0,0,127}));
  connect(TSetHea.y, optSta.TSetZonHea) annotation (Line(points={{-18,-10},{-6,
          -10},{-6,-42},{18,-42}}, color={0,0,127}));
  connect(TSetCoo.y, optSta.TSetZonCoo) annotation (Line(points={{-18,-50},{0,
          -50},{0,-58},{18,-58}}, color={0,0,127}));
  connect(TSetHea.y, optStaHea.TSetZonHea) annotation (Line(points={{-18,-10},{
          -6,-10},{-6,38},{18,38}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=345600));
end OptimalStart;
