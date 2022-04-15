within Buildings.Templates.ChilledWaterPlant.Validation;
model BaseWaterCooled
  extends Modelica.Icons.Example;
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Chilled water medium";

  replaceable Buildings.Templates.ChilledWaterPlant.WaterCooled chw(dat=dat)
    annotation (Placement(transformation(extent={{-80,-20},{0,20}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare final package Medium=MediumChiWat,
    nPorts=3)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));

  Buildings.Templates.ChilledWaterPlant.Validation.UserProject.UserData dat(
    final typ=chw.typ,
    con(
      final typ = chw.con.typ,
      final nSenDpChiWatRem = chw.con.nSenDpChiWatRem,
      final nChi = chw.con.nChi,
      final have_eco = chw.con.have_eco,
      final have_sendpChiWatLoc = chw.con.have_sendpChiWatLoc,
      final have_fixSpeConWatPum = chw.con.have_fixSpeConWatPum,
      final have_ctrHeaPre = chw.con.have_ctrHeaPre),
    chiSec(
      final typ = chw.chiSec.typ,
      final nChi = chw.chiSec.nChi,
      chi(final typ = chw.chiSec.chi.typ)),
    cooTowSec(
      final typ = chw.cooTowSec.typ,
      final nCooTow = chw.cooTowSec.nCooTow,
      cooTow(final typ = chw.cooTowSec.cooTow.typ)),
    pumPri(
      final typ = chw.pumPri.typ,
      final nPum = chw.pumPri.nPum,
      final have_byp = chw.pumPri.have_byp,
      final have_chiByp = chw.pumPri.have_chiByp,
      valChiWatChi(final typ = chw.typValChiWatChi),
      pum(each final typ = chw.pumPri.pum.typ)),
    pumSec(
      final typ = chw.pumSec.typ,
      final nPum = chw.pumSec.nPum),
    pumCon(
      final typ = chw.pumCon.typ,
      final nPum = chw.pumCon.nPum,
      valConWatChi(final typ = chw.typValConWatChi),
      pum(each final typ = chw.pumCon.pum.typ)),
    eco(final typ = chw.eco.typ))
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumChiWat,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Buildings.Fluid.Sensors.Pressure pDem(
    redeclare final package Medium=MediumChiWat) "Demand side pressure"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumChiWat,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{48,-30},{28,-10}})));
protected
  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busConExt(final
      nChi=chw.nChi, final nCooTow=chw.nCooTow) annotation (Placement(
        transformation(extent={{10,40},{50,80}}), iconTransformation(extent={{-258,
            -26},{-238,-6}})));
equation
  connect(res1.port_b, bou1.ports[1]) annotation (Line(points={{48,0},{60,0},{
          60,-1.33333},{70,-1.33333}},
                            color={0,127,255}));
  connect(bou1.ports[2],pDem. port) annotation (Line(points={{70,-2.22045e-16},
          {70,30}}, color={0,127,255}));
  connect(weaDat.weaBus, chw.weaBus) annotation (Line(
      points={{-60,50},{-40,50},{-40,20}},
      color={255,204,51},
      thickness=0.5));
  connect(res2.port_a, bou1.ports[3]) annotation (Line(points={{48,-20},{60,-20},
          {60,1.33333},{70,1.33333}},   color={0,127,255}));
  connect(res1.port_a,chw.port_b)
    annotation (Line(points={{28,0},{26,0},{26,2},{0,2}},
                                                     color={0,127,255}));
  connect(res2.port_b,chw.port_a)  annotation (Line(points={{28,-20},{6,-20},{6,
          -14},{0,-14}}, color={0,127,255}));
  connect(busConExt, chw.busCon) annotation (Line(
      points={{30,60},{30,14},{8,14},{8,12},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pDem.p, busConExt.pDem) annotation (Line(points={{59,40},{54,40},{54,
          60},{30,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseWaterCooled;
