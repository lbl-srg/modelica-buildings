within Buildings.Templates.HeatingPlants.HotWater.Components.Validation;
model BoilerTable
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  Buildings.Templates.Components.Data.BoilerHotWater datBoi(
    final typMod=boi.typMod,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    mHeaWat_flow_nominal=datBoi.cap_nominal/15/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    cap_nominal=1000E3,
    dpHeaWat_nominal(displayUnit="Pa") = 5000,
    THeaWatSup_nominal=333.15)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
    //redeclare Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0500 per,
  Buildings.Templates.Components.Boilers.HotWaterTable boi(
    redeclare final package Medium = Medium,
    final dat=datBoi,
    is_con=false)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Sources.Boundary_pT retHeaWat(redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_min + boi.dpHeaWat_nominal,
    use_T_in=true,
    T=datBoi.THeaWatSup_nominal - 15,
    nPorts=1)
    "Boundary conditions for HW distribution system"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Sources.Boundary_pT supHeaWat(redeclare final package Medium =Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_min,
    nPorts=1)
    "Boundary conditions for HW distribution system"
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datBoi.mHeaWat_flow_nominal)
    "HW supply temperature"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp THeaWatRet(
    height=35,
    duration=500,
    offset=datBoi.THeaWatSup_nominal - 25,
    startTime=100) "HW return temperature value"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Boi(
    table=[0,1; 1,1],
    timeScale=3600,
    period=3600) "Boiler Enable signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus bus annotation (
      Placement(transformation(extent={{-20,20},{20,60}}), iconTransformation(
          extent={{-296,-74},{-256,-34}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(k=
        Buildings.Templates.Data.Defaults.THeaWatSup)
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(retHeaWat.ports[1], boi.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(boi.port_b, THeaWatSup.port_a)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  connect(THeaWatSup.port_b, supHeaWat.ports[1])
    annotation (Line(points={{50,0},{70,0}}, color={0,127,255}));
  connect(THeaWatRet.y, retHeaWat.T_in) annotation (Line(points={{-58,0},{-52,0},
          {-52,4},{-42,4}}, color={0,0,127}));
  connect(boi.bus, bus) annotation (Line(
      points={{0,10},{0,10},{0,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(y1Boi.y[1], bus.y1) annotation (Line(points={{-58,80},{0,80},{0,40}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(THeaWatSupSet.y, bus.THeaWatSupSet)
    annotation (Line(points={{-58,40},{0,40}}, color={0,0,127}));
  annotation (Documentation(info="<html>
FIXME: The example yields a final overriding message for fue with Dymola
when redeclaring per inside datBoi. Open ticket at DS.
</html>"));
end BoilerTable;
