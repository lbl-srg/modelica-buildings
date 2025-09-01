within Buildings.Templates.Components.Validation;
model CoolersCoolingTower
  "Validation model for cooling tower component"
  extends Modelica.Icons.Example;
  replaceable package MediumLiq=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";
  constant Modelica.Units.SI.AbsolutePressure pAtm=101325
    "Atmospheric pressure";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Data.Cooler dat(
    typ=coo.typ,
    mConWat_flow_nominal=20,
    mAir_flow_nominal=dat.mConWat_flow_nominal /
      Buildings.Templates.Data.Defaults.ratMFloConWatByMFloAirTow,
    TWetBulEnt_nominal=Buildings.Templates.Data.Defaults.TWetBulTowEnt,
    TConWatRet_nominal=Buildings.Templates.Data.Defaults.TConWatRet,
    TConWatSup_nominal=Buildings.Templates.Data.Defaults.TConWatSup,
    PFan_nominal=Buildings.Templates.Data.Defaults.ratPFanByMFloConWatTow *
      dat.mConWat_flow_nominal,
    dpConWatFri_nominal=Buildings.Templates.Data.Defaults.dpConWatFriTow,
    dpConWatSta_nominal=Buildings.Templates.Data.Defaults.dpConWatStaTow)
    "Cooler parameters"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[
      0, 0;
      0.5, 1],
    timeScale=1000,
    period=3000)
    "Heat pump Enable signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Fluid.Sensors.TemperatureTwoPort TConWatSup(redeclare final package Medium =
        MediumLiq, final m_flow_nominal=dat.mConWat_flow_nominal)
    "CW supply temperature"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Fluid.Sources.Boundary_pT supConWat(
    redeclare final package Medium = MediumLiq,
    p=pAtm,
    nPorts=1)
    "Boundary conditions of CW at chiller inlet"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));
  Fluid.Sources.Boundary_pT retConWat(
    redeclare final package Medium=MediumLiq,
    p=supConWat.p + dat.dpConWatFri_nominal,
    T=dat.TConWatRet_nominal,
    nPorts=1)
    "Boundary condition of CW at chiller outlet"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal y
    "CT speed command"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Coolers.CoolingTower coo(
    redeclare final package MediumConWat=MediumLiq,
    final dat=dat,
    final energyDynamics=energyDynamics,
    typTow=Buildings.Templates.Components.Types.CoolingTower.Open)
    "Cooling tower"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TWetBul(
    k=dat.TWetBulEnt_nominal,
    y(final unit="K", displayUnit="degC"))
    "Outdoor air wetbulb temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Fluid.Sensors.TemperatureTwoPort TConWatRet(redeclare final package Medium =
        MediumLiq, final m_flow_nominal=dat.mConWat_flow_nominal)
    "CW return temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
protected
  Interfaces.Bus bus "CT control bus" annotation (Placement(transformation(
          extent={{-20,0},{20,40}}),  iconTransformation(extent={{-276,6},{-236,
            46}})));
  BoundaryConditions.WeatherData.Bus busWea
    "Weather bus"
    annotation (Placement(transformation(extent={{-60,0},{-20,40}}),
      iconTransformation(extent={{-70,90},{-50,110}})));
equation
  connect(y1.y[1], bus.y1)
    annotation (Line(points={{-58,60},{-50,60},{-50,40},{0,40},{0,20}},
                                                        color={255,0,255}));
  connect(y1.y[1], y.u) annotation (Line(points={{-58,60},{-42,60}},
                color={255,0,255}));
  connect(y.y, bus.y)
    annotation (Line(points={{-18,60},{0,60},{0,20}}, color={0,0,127}));
  connect(coo.port_b, TConWatSup.port_a)
    annotation (Line(points={{10,-20},{30,-20}},
                                             color={0,127,255}));
  connect(TConWatSup.port_b, supConWat.ports[1])
    annotation (Line(points={{50,-20},{60,-20}},    color={0,127,255}));
  connect(TWetBul.y, busWea.TWetBul) annotation (Line(points={{-58,20},{-48,20},
          {-48,20.1},{-39.9,20.1}}, color={0,0,127}));
  connect(busWea, coo.busWea) annotation (Line(
      points={{-40,20},{-40,0},{-6,0},{-6,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(bus, coo.bus) annotation (Line(
      points={{0,20},{0,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(retConWat.ports[1], TConWatRet.port_a)
    annotation (Line(points={{-60,-20},{-40,-20}}, color={0,127,255}));
  connect(TConWatRet.port_b, coo.port_a)
    annotation (Line(points={{-20,-20},{-10,-20}}, color={0,127,255}));
  annotation (
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}}, grid={2,2})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/CoolersCoolingTower.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StartTime=0.0,
      StopTime=1000.0),
    Documentation(
      info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Templates.Components.Coolers.CoolingTower\">
Buildings.Templates.Components.Coolers.CoolingTower</a>
at nominal conditions.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 17, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolersCoolingTower;
