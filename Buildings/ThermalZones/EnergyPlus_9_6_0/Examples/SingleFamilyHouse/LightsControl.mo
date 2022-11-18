within Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse;
model LightsControl
  "Example model with one actuator that controls the lights in EnergyPlus"
  extends Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Unconditioned;
  Buildings.ThermalZones.EnergyPlus_9_6_0.Actuator actLig(
    unit=Buildings.ThermalZones.EnergyPlus_9_6_0.Types.Units.Power,
    variableName="LIVING ZONE Lights",
    componentType="Lights",
    controlType="Electricity Rate")
    "Actuator for lights"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OutputVariable ligPow(
    name="Lights Electricity Rate",
    key="LIVING ZONE Lights",
    isDirectDependent=true,
    y(final unit="W"))
    "Block that reads the lighting power consumption from EnergyPlus"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Controls.OBC.CDL.Utilities.SunRiseSet sunRiseSet(
    lat=0.73268921998722,
    lon=-1.5344934783534,
    timZon=-21600)
    "Block that computes sunrise and sunset"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Controls.OBC.CDL.Continuous.Modulo mod1
    "Output time of day"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant day(
    k=24*3600)
    "Outputs one day"
    annotation (Placement(transformation(extent={{-150,38},{-130,58}})));
  Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    "Model time"
    annotation (Placement(transformation(extent={{-150,66},{-130,86}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesEquThr(
    t=22*3600)
    "Check whether time is earlier than 22:00"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Controls.OBC.CDL.Continuous.Subtract timToSunSet
    "Time to next sunset"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesEquThr1(
    t=1800)
    "Block that outputs true if sun sets in less than 30 minutes"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  Controls.OBC.CDL.Logical.Or or2
    "Output true if the lights should be on based on sun position"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Controls.OBC.CDL.Logical.And and2
    "Output true if the lights should be on"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Controls.OBC.CDL.Conversions.BooleanToReal PLig(
    realTrue=1000)
    "Lighting power"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Controls.OBC.CDL.Logical.Not not1
    "Output true if the sun is down"
    annotation (Placement(transformation(extent={{-70,100},{-50,120}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greEquThr(
    t=12*3600)
    "Output true after noon"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Controls.OBC.CDL.Logical.And and1
    "Output true if time of day allows lights to be on"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

equation
  connect(day.y,mod1.u2)
    annotation (Line(points={{-128,48},{-120,48},{-120,64},{-102,64}},color={0,0,127}));
  connect(mod1.u1,modTim.y)
    annotation (Line(points={{-102,76},{-128,76}},color={0,0,127}));
  connect(mod1.y,lesEquThr.u)
    annotation (Line(points={{-78,70},{-62,70}},color={0,0,127}));
  connect(sunRiseSet.nextSunSet,timToSunSet.u1)
    annotation (Line(points={{-118,140},{-110,140},{-110,146},{-102,146}},color={0,0,127}));
  connect(modTim.y,timToSunSet.u2)
    annotation (Line(points={{-128,76},{-110,76},{-110,134},{-102,134}},color={0,0,127}));
  connect(lesEquThr1.u,timToSunSet.y)
    annotation (Line(points={{-72,140},{-78,140}},color={0,0,127}));
  connect(lesEquThr1.y,or2.u1)
    annotation (Line(points={{-48,140},{-46,140},{-46,130},{-42,130}},color={255,0,255}));
  connect(or2.y,and2.u1)
    annotation (Line(points={{-18,130},{-14,130},{-14,110},{18,110}},color={255,0,255}));
  connect(and2.y,PLig.u)
    annotation (Line(points={{42,110},{58,110}},color={255,0,255}));
  connect(actLig.u,PLig.y)
    annotation (Line(points={{98,110},{82,110}},color={0,0,127}));
  connect(not1.y,or2.u2)
    annotation (Line(points={{-48,110},{-46,110},{-46,122},{-42,122}},color={255,0,255}));
  connect(not1.u,sunRiseSet.sunUp)
    annotation (Line(points={{-72,110},{-114,110},{-114,134},{-118,134}},color={255,0,255}));
  connect(greEquThr.u,mod1.y)
    annotation (Line(points={{-62,40},{-70,40},{-70,70},{-78,70}},color={0,0,127}));
  connect(greEquThr.y,and1.u2)
    annotation (Line(points={{-38,40},{-34,40},{-34,62},{-22,62}},color={255,0,255}));
  connect(and1.u1,lesEquThr.y)
    annotation (Line(points={{-22,70},{-38,70}},color={255,0,255}));
  connect(and1.y,and2.u2)
    annotation (Line(points={{2,70},{10,70},{10,102},{18,102}},color={255,0,255}));
  connect(actLig.y,ligPow.directDependency)
    annotation (Line(points={{122,110},{130,110},{130,90},{88,90},{88,70},{98,70}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/LightsControl.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Example of a building that uses an EMS actuator to assign the lighting power in EnergyPlus.
The lights are on <i>30</i> minutes before sunset, and remain on until <i>22:00</i>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 25, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-160,-160},{140,160}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end LightsControl;
