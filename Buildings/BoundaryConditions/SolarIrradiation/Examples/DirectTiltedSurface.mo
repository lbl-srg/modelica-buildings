within Buildings.BoundaryConditions.SolarIrradiation.Examples;
model DirectTiltedSurface
  "Test model for direct solar irradiation on a tilted surface"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Angle lat=37/180*Modelica.Constants.pi "Latitude";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (
      Placement(transformation(extent={{1,-1},{21,21}}), iconTransformation(
          extent={{20,20},{21,21}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface
                                                             HDirRoo(
    til=Buildings.HeatTransfer.Types.Tilt.Ceiling,
    lat=0.6457718232379,
    azi=0.78539816339745) "Direct irradiation on roof"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface
                                                             HDirFlo(
    til=Buildings.HeatTransfer.Types.Tilt.Floor,
    lat=0.6457718232379,
    azi=0.78539816339745) "Direct irradiation on floor"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface
                                                             HDirWal(
    til=Buildings.HeatTransfer.Types.Tilt.Wall,
    lat=0.6457718232379,
    azi=0.78539816339745) "Direct irradiation on wall"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu
    "Assert to ensure that direct radiation received by floor construction is zero"
    annotation (Placement(transformation(extent={{80,-86},{100,-66}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{0,-92},{20,-72}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,10},{11,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(HDirRoo.weaBus, weaBus) annotation (Line(
      points={{40,10},{11,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(HDirWal.weaBus, weaBus) annotation (Line(
      points={{40,-30},{30,-30},{30,10},{11,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(HDirFlo.weaBus, weaBus) annotation (Line(
      points={{40,-70},{30,-70},{30,10},{11,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(assEqu.u1, HDirFlo.H) annotation (Line(
      points={{78,-70},{61,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, assEqu.u2) annotation (Line(
      points={{21,-82},{78,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(StartTime=1.82304e+07, StopTime=1.83168e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/Examples/DirectTiltedSurface.mos"
        "Simulate and plot"),
    Icon(graphics),
    Documentation(info="<html>
<p>
This model tests the direct solar irradiation received on a ceiling, a wall and a floor.
The assert statement will stop the simulation if the floor receives
any direct solar irradiation.
</p>
</html>"));
end DirectTiltedSurface;
