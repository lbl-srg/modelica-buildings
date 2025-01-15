within Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice;
model IdealHeatingCoolingWinter
  "Building with constant fresh air and ideal heating/cooling that exactly meets set point"
  extends Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.Unconditioned;
  Controls.OBC.CDL.Reals.Sources.Constant THeaSet[5](
    each k(
      final unit="K",
      displayUnit="degC")=293.15)
    "Set point temperature for heating"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Controls.OBC.CDL.Reals.Sources.Constant THeaCoo[5](
    each k(
      final unit="K",
      displayUnit="degC")=299.15)
    "Set point temperature for cooling"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  BaseClasses.IdealHeaterCooler[5] hea(
    Q_flow_nominal=70*{flo.AFloSou,flo.AFloEas,flo.AFloNor,flo.AFloWes,flo.AFloCor})
    "Ideal heater"
    annotation (Placement(transformation(rotation=0,extent={{-80,70},{-60,90}})));
  BaseClasses.IdealHeaterCooler[5] coo(
    Q_flow_nominal=-50*{flo.AFloSou,flo.AFloEas,flo.AFloNor,flo.AFloWes,flo.AFloCor})
    "Ideal cooling device for sensible cooling"
    annotation (Placement(transformation(rotation=0,extent={{-80,130},{-60,150}})));
  Controls.OBC.CDL.Reals.MultiSum QHea_flow(
    nin=5)
    "Total heat flow rate"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
  Modelica.Blocks.Continuous.Integrator EHea
    "Heating energy"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Controls.OBC.CDL.Reals.MultiSum QCoo_flow(
    nin=5)
    "Total heat flow rate"
    annotation (Placement(transformation(extent={{-30,150},{-10,170}})));
  Modelica.Blocks.Continuous.Integrator ECoo
    "Cooling energy"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));

equation
  connect(flo.TRooAir,hea.TMea)
    annotation (Line(points={{87.1739,13},{92,13},{92,66},{-70,66},{-70,68}},color={0,0,127}));
  connect(THeaSet.y,hea.TSet)
    annotation (Line(points={{-98,80},{-82,80}},color={0,0,127}));
  connect(coo[1].heaPor,flo.heaPorSou)
    annotation (Line(points={{-60,140},{64,140},{64,4.23077},{57.5913,4.23077}},color={191,0,0}));
  connect(coo[2].heaPor,flo.heaPorEas)
    annotation (Line(points={{-60,140},{79.8957,140},{79.8957,15.7692}},color={191,0,0}));
  connect(coo[3].heaPor,flo.heaPorNor)
    annotation (Line(points={{-60,140},{64,140},{64,20.6154},{57.3565,20.6154}},color={191,0,0}));
  connect(coo[4].heaPor,flo.heaPorWes)
    annotation (Line(points={{-60,140},{38.3391,140},{38.3391,15.7692}},color={191,0,0}));
  connect(coo[5].heaPor,flo.heaPorCor)
    annotation (Line(points={{-60,140},{64,140},{64,12.7692},{57.8261,12.7692}},color={191,0,0}));
  connect(hea[1].heaPor,flo.heaPorSou)
    annotation (Line(points={{-60,80},{64,80},{64,4.23077},{57.5913,4.23077}},color={191,0,0}));
  connect(hea[2].heaPor,flo.heaPorEas)
    annotation (Line(points={{-60,80},{79.8957,80},{79.8957,15.7692}},color={191,0,0}));
  connect(hea[3].heaPor,flo.heaPorNor)
    annotation (Line(points={{-60,80},{64,80},{64,20.6154},{57.3565,20.6154}},color={191,0,0}));
  connect(hea[4].heaPor,flo.heaPorWes)
    annotation (Line(points={{-60,80},{38.3391,80},{38.3391,15.7692}},color={191,0,0}));
  connect(hea[5].heaPor,flo.heaPorCor)
    annotation (Line(points={{-60,80},{64,80},{64,12.7692},{57.8261,12.7692}},color={191,0,0}));
  connect(THeaCoo.y,coo.TSet)
    annotation (Line(points={{-98,140},{-82,140}},color={0,0,127}));
  connect(flo.TRooAir,coo.TMea)
    annotation (Line(points={{87.1739,13},{92,13},{92,120},{-70,120},{-70,128}},color={0,0,127}));
  connect(QHea_flow.y,EHea.u)
    annotation (Line(points={{-8,100},{-2,100}},color={0,0,127}));
  connect(hea.Q_flow,QHea_flow.u)
    annotation (Line(points={{-58,86},{-40,86},{-40,100},{-32,100}},color={0,0,127}));
  connect(QCoo_flow.y,ECoo.u)
    annotation (Line(points={{-8,160},{-2,160}},color={0,0,127}));
  connect(QCoo_flow.u[1:5],coo.Q_flow)
    annotation (Line(points={{-32,160.8},{-46,160.8},{-46,146},{-58,146}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SmallOffice/IdealHeatingCoolingWinter.mos" "Simulate and plot"),
    experiment(
      StartTime=432000,
      StopTime=864000,
      Tolerance=1e-07),
    Documentation(
      info="<html>
<p>
Test case of the small office DOE reference building without an HVAC system
but an ideal heating/cooling device that exactly meets the load.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 25, 2024, by Jianjun Hu:<br/>
Changed tolerance to 1e-07.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4063\">issue #4063</a>.
</li>
<li>
March 4, 2021, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2381\">#2381</a>.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-140,-100},{100,180}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end IdealHeatingCoolingWinter;
