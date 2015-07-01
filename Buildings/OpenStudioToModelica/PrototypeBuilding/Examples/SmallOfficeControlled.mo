within Buildings.OpenStudioToModelica.PrototypeBuilding.Examples;
model SmallOfficeControlled
  "Example with a small office with temperature controlled"
  extends Modelica.Icons.Example;
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data used for the example"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeControlled office(
    lon=weaDat.lon,
    lat=weaDat.lat,
    timZon=weaDat.timZon,
    pf=0.9,
    azi_pv=Buildings.Types.Azimuth.S,
    V_nominal=480,
    P_hvac_nominal=20e3,
    COP_nominal=3,
    a={0.3,0.7},
    A=50,
    T_sp(displayUnit="K"),
    til_pv=0.5235987755983)
    annotation (Placement(transformation(extent={{0,12},{20,32}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.FixedVoltage sou
    annotation (Placement(transformation(extent={{80,12},{60,32}})));
equation
  connect(weaDat.weaBus, office.weaBus) annotation (Line(
      points={{-40,30},{-20,30},{0,30}},
      color={255,204,51},
      thickness=0.5));
  connect(sou.terminal, office.term)
    annotation (Line(points={{60,22},{40,22},{21,22}}, color={0,120,120}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end SmallOfficeControlled;
