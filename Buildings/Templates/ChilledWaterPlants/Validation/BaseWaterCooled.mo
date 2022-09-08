within Buildings.Templates.ChilledWaterPlants.Validation;
model BaseWaterCooled
  extends Modelica.Icons.Example;
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Chilled water medium";

  replaceable Buildings.Templates.ChilledWaterPlants.WaterCooled chw(dat=dat)
    "CHW plant"
    annotation (Placement(transformation(extent={{-40,-30},{0,10}})));
  Fluid.Sources.Boundary_pT bou(redeclare final package Medium = MediumChiWat,
      nPorts=3) "Boundary conditions for CHW distribution system "
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));

  Buildings.Templates.ChilledWaterPlants.Validation.UserProject.UserData dat(
    final typ=chw.typ,
    ctr(
      final typ=chw.ctr.typ,
      final nChi=chw.ctr.nChi,
      final have_eco=chw.ctr.have_eco,
      final nSenDpChiWatRem=chw.ctr.nSenDpChiWatRem,
      final have_sendpChiWatLoc=chw.ctr.have_sendpChiWatLoc,
      final have_fixSpeConWatPum=chw.ctr.have_fixSpeConWatPum,
      final have_ctrHeaPre=chw.ctr.have_ctrHeaPre),
    chiSec(
      final typ=chw.chiSec.typ,
      final nChi=chw.chiSec.nChi,
      chi(final typ=chw.chiSec.chi.typ)),
    cooTowSec(
      final typ=chw.cooTowSec.typ,
      final nCooTow=chw.cooTowSec.nCooTow,
      cooTow(final typ=chw.cooTowSec.cooTow.typ),
      valCooTowInlIso(final typ=chw.cooTowSec.valCooTowInlIso.typ),
      valCooTowOutIso(final typ=chw.cooTowSec.valCooTowOutIso.typ)),
    pumPri(
      final typ=chw.chiSec.pumPri.typ,
      final nPum=chw.chiSec.pumPri.nPum,
      final have_minFloByp=chw.chiSec.pumPri.have_minFloByp,
      final have_chiWatChiByp=chw.chiSec.pumPri.have_chiWatChiByp,
      valChiWatChiIso(final typ=chw.chiSec.typValChiWatChiIso),
      pum(each final typ=chw.chiSec.pumPri.pum.typ)),
    pumSec(
      final typ=chw.pumSec.typ,
      final nPum=chw.pumSec.nPum,
      pum(each final typ=chw.pumSec.pum.typ)),
    pumCon(
      final typ=chw.pumCon.typ,
      final nPum=chw.pumCon.nPum,
      valConWatChiIso(final typ=chw.pumCon.typValConWatChiIso),
      pum(each final typ=chw.pumCon.pum.typ)),
    eco(final typ=chw.eco.typ, final have_valChiWatEcoByp=chw.eco.have_valChiWatEcoByp))
    annotation (Placement(transformation(extent={{70,72},{90,92}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumChiWat,
    m_flow_nominal=dat.mSec_flow_nominal,
    dp_nominal=dat.dpDem_nominal) "Flow resistance of CHW distribution system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sensors.Pressure pDem(
    redeclare final package Medium=MediumChiWat) "Demand side pressure"
    annotation (Placement(transformation(extent={{70,30},{50,50}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
protected
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus(final nChi=chw.nChi,
      final nCooTow=chw.nCooTow) "CHW plant control bus" annotation (Placement(
        transformation(extent={{-100,20},{-60,60}}),
                                                  iconTransformation(extent={{-258,
            -26},{-238,-6}})));
equation
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{40,0},{60,0},{60,-11.3333}}, color={0,127,255}));
  connect(bou.ports[2], pDem.port)
    annotation (Line(points={{60,-10},{60,30}}, color={0,127,255}));
  connect(weaDat.weaBus,chw.busWea)  annotation (Line(
      points={{-10,60},{-20,60},{-20,10}},
      color={255,204,51},
      thickness=0.5));
  connect(res.port_a, chw.port_b)
    annotation (Line(points={{20,0},{0.2,0}},
                                            color={0,127,255}));
  connect(pDem.p, bus.pDem) annotation (Line(points={{49,40},{-80,40}},color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chw.bus, bus) annotation (Line(
      points={{-40,0},{-80,0},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(chw.port_a, bou.ports[3]) annotation (Line(points={{0.2,-20.2},{60,
          -20.2},{60,-8.66667}},
                         color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseWaterCooled;
