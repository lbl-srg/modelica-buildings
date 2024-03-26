within Buildings.Templates.Plants.HeatPumps.Components.Controls;
model AirToWater
  "Controller for AWHP plant"
  extends
    Buildings.Templates.Plants.HeatPumps.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater);
  final parameter Real staEqu[:, nHp](
    each final max=1,
    each final min=0,
    each final unit="1")=dat.staEqu
    "Staging matrix – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation"));
  final parameter Integer nSta(
    final min=1)=size(staEqu, 1)
    "Number of stages"
    annotation (Evaluate=true);
  final parameter Integer nEquAlt(
    final min=0)=max({sum({(if staEqu[i, j] > 0 and staEqu[i, j] < 1 then 1 else 0) for j in 1:nHp}) for i in 1:nSta})
    "Number of lead/lag alternate equipment"
    annotation (Evaluate=true);
  final parameter Integer idxEquAlt[nEquAlt]=Modelica.Math.BooleanVectors.index(
    {Modelica.Math.BooleanVectors.anyTrue({staEqu[i,j] > 0 and staEqu[i,j] < 1 for i in 1:nSta})
    for j in 1:nHp})
    "Indices of lead/lag alternate equipment"
    annotation (Evaluate=true,
    Dialog(group="Equipment staging and rotation"));
  Buildings.Templates.Plants.Controls.HeatPumps.AirToWater ctl(
    final TChiWatSupSet_max=dat.TChiWatSupSet_max,
    final TChiWatSup_nominal=dat.TChiWatSup_nominal,
    final THeaWatSupSet_min=dat.THeaWatSupSet_min,
    final THeaWatSup_nominal=dat.THeaWatSup_nominal,
    final TOutChiWatLck=dat.TOutChiWatLck,
    final TOutHeaWatLck=dat.TOutHeaWatLck,
    final VChiWatSec_flow_nominal=dat.VChiWatSec_flow_nominal,
    final VHeaWatSec_flow_nominal=dat.VHeaWatSec_flow_nominal,
    final capCooHp_nominal=fill(dat.capCooHp_nominal, cfg.nHp),
    final capHeaHp_nominal=fill(dat.capHeaHp_nominal, cfg.nHp),
    final cp_default=if cfg.have_heaWat then cfg.cpHeaWat_default else cfg.cpChiWat_default,
    final dpChiWatRemSet_max=dat.dpChiWatRemSet_max,
    final dpChiWatRemSet_min=dat.dpChiWatRemSet_min,
    final dpHeaWatRemSet_max=dat.dpHeaWatRemSet_max,
    final dpHeaWatRemSet_min=dat.dpHeaWatRemSet_min,
    final have_chiWat=cfg.have_chiWat,
    final have_heaWat=cfg.have_heaWat,
    final have_inpSch=have_inpSch,
    final have_pumChiWatPriDed_select=cfg.have_pumChiWatPriDed,
    final have_pumChiWatSec_select=cfg.typPumChiWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized,
    final have_pumHeaWatSec_select=cfg.typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized,
    final have_pumPriHdr=cfg.typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final have_pumHeaWatPriVar=cfg.have_pumHeaWatPriVar,
    final have_pumChiWatPriVar=cfg.have_pumChiWatPriVar,
    final have_senDpChiWatRemWir=cfg.have_senDpChiWatRemWir,
    final have_senDpHeaWatRemWir=cfg.have_senDpHeaWatRemWir,
    final have_senTChiWatPriRet_select=have_senTChiWatPriRet_select,
    final have_senTChiWatSecRet=have_senTChiWatSecRet,
    final have_senTHeaWatPriRet_select=have_senTHeaWatPriRet_select,
    final have_senTHeaWatSecRet=have_senTHeaWatSecRet,
    final have_senVChiWatPri_select=have_senVChiWatPri_select,
    final have_senVHeaWatPri_select=have_senVHeaWatPri_select,
    final have_valHpInlIso=cfg.have_valHpInlIso,
    final have_valHpOutIso=cfg.have_valHpOutIso,
    final idxEquAlt=idxEquAlt,
    final nHp=cfg.nHp,
    final nPumChiWatPri=cfg.nPumChiWatPri,
    final nPumChiWatSec=cfg.nPumChiWatSec,
    final nPumHeaWatPri=cfg.nPumHeaWatPri,
    final nPumHeaWatSec=cfg.nPumHeaWatSec,
    final nSenDpChiWatRem=nSenDpChiWatRem,
    final nSenDpHeaWatRem=nSenDpHeaWatRem,
    final plrSta=dat.plrSta,
    final rho_default=if cfg.have_heaWat then cfg.rhoHeaWat_default else cfg.rhoChiWat_default,
    final schCoo=dat.schCoo,
    final schHea=dat.schHea,
    final staEqu=dat.staEqu,
    final yPumChiWatPriSet=dat.yPumChiWatPriSet,
    final yPumHeaWatPriSet=dat.yPumHeaWatPriSet)
    "Plant controller"
    annotation (Placement(transformation(extent={{-20,-20},{20,40}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqPlaHeaWatAirHan(
    final nin=nAirHan) if cfg.have_heaWat "Sum of HW plant requests from AHU"
    annotation (Placement(transformation(extent={{210,190},{190,210}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqPlaHeaWatEquZon(
    final nin=nEquZon) if cfg.have_heaWat
    "Sum of HW plant requests from zone equipment"
    annotation (Placement(transformation(extent={{210,-90},{190,-70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqResHeaWatAirHan(nin=1)
    if cfg.have_heaWat "Sum of HW reset requests from AHU"
    annotation (Placement(transformation(extent={{210,110},{190,130}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqResHeaWatEquZon(
    final nin=nEquZon) if cfg.have_heaWat
    "Sum of HW reset requests from zone equipment"
    annotation (Placement(transformation(extent={{210,-170},{190,-150}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqResChiWatAirHan(final nin=
        nAirHan) if cfg.have_chiWat "Sum of CHW reset requests from AHU"
    annotation (Placement(transformation(extent={{210,70},{190,90}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqPlaChiWatEquZon(final nin=
        nEquZon) if cfg.have_chiWat
    "Sum of CHW plant requests from zone equipment"
    annotation (Placement(transformation(extent={{210,-130},{190,-110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqResChiWatEquZon(final nin=
        nEquZon) if cfg.have_chiWat
    "Sum of CHW reset requests from zone equipment"
    annotation (Placement(transformation(extent={{210,-210},{190,-190}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqPlaChiWatAirHan(final nin=
        nAirHan) if cfg.have_chiWat "Sum of CHW plant requests from AHU"
    annotation (Placement(transformation(extent={{210,150},{190,170}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderInteger phReqPlaHeaWatAirHan(
    final have_inp=cfg.have_heaWat,
    final u_internal=0)
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{170,190},{150,210}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderInteger phReqPlaChiWatAirHan(final
      have_inp=cfg.have_chiWat, final u_internal=0)
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{170,150},{150,170}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderInteger phReqResHeaWatAirHan(final
      have_inp=cfg.have_heaWat, final u_internal=0)
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{170,110},{150,130}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderInteger phReqResChiWatAirHan(final
      have_inp=cfg.have_chiWat, final u_internal=0)
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{170,70},{150,90}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderInteger phReqPlaHeaWatEquZon(final
      have_inp=cfg.have_heaWat, final u_internal=0)
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{170,-90},{150,-70}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderInteger phReqPlaChiWatEquZon(final
      have_inp=cfg.have_chiWat, final u_internal=0)
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{170,-130},{150,-110}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderInteger phReqResHeaWatEquZon(final
      have_inp=cfg.have_heaWat, final u_internal=0)
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{170,-170},{150,-150}})));
  Buildings.Templates.Plants.Controls.Utilities.PlaceholderInteger phReqResChiWatEquZon(final
      have_inp=cfg.have_chiWat, final u_internal=0)
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{170,-210},{150,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqPlaHeaWat
    "Sum of HW plant requests of all loads served"
    annotation (Placement(transformation(extent={{110,184},{90,204}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqPlaChiWat
    "Sum of CHW plant requests of all loads served"
    annotation (Placement(transformation(extent={{110,144},{90,164}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqResHeaWat
    "Sum of HW reset requests of all loads served"
    annotation (Placement(transformation(extent={{110,104},{90,124}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqResChiWat
    "Sum of CHW reset requests of all loads served"
    annotation (Placement(transformation(extent={{110,64},{90,84}})));
equation
  /* Control point connection - start */
  // Inputs from plant control bus
  connect(bus.TChiWatPriRet, ctl.TChiWatPriRet);
  connect(bus.TChiWatPriSup, ctl.TChiWatPriSup);
  connect(bus.TChiWatSecRet, ctl.TChiWatSecRet);
  connect(bus.TChiWatSecSup, ctl.TChiWatSecSup);
  connect(bus.THeaWatPriRet, ctl.THeaWatPriRet);
  connect(bus.THeaWatPriSup, ctl.THeaWatPriSup);
  connect(bus.THeaWatSecRet, ctl.THeaWatSecRet);
  connect(bus.THeaWatSecSup, ctl.THeaWatSecSup);
  connect(bus.TOut, ctl.TOut);
  connect(bus.VChiWatPri_flow, ctl.VChiWatPri_flow);
  connect(bus.VChiWatSec_flow, ctl.VChiWatSec_flow);
  connect(bus.VHeaWatPri_flow, ctl.VHeaWatPri_flow);
  connect(bus.VHeaWatSec_flow, ctl.VHeaWatSec_flow);
  connect(bus.dpChiWatLoc, ctl.dpChiWatLoc);
  connect(bus.dpChiWatLocSet, ctl.dpChiWatLocSet);
  connect(bus.dpChiWatRem, ctl.dpChiWatRem);
  connect(bus.dpHeaWatLoc, ctl.dpHeaWatLoc);
  connect(bus.dpHeaWatLocSet, ctl.dpHeaWatLocSet);
  connect(bus.dpHeaWatRem, ctl.dpHeaWatRem);
  connect(busHp.y1_actual, ctl.u1Hp_actual);
  connect(busPumChiWatPri.y1_actual, ctl.u1PumChiWatPri_actual);
  connect(busPumChiWatSec.y1_actual, ctl.u1PumChiWatSec_actual);
  connect(busPumHeaWatPri.y1_actual, ctl.u1PumHeaWatPri_actual);
  connect(busPumHeaWatSec.y1_actual, ctl.u1PumHeaWatSec_actual);
  connect(bus.u1SchCoo, ctl.u1SchCoo);
  connect(bus.u1SchHea, ctl.u1SchHea);
  // Outputs to plant control bus
  connect(ctl.TSupSet, busHp.TSet);
  connect(ctl.TChiWatSupSet, bus.TChiWatSupSet);
  connect(ctl.THeaWatSupSet, bus.THeaWatSupSet);
  connect(ctl.dpChiWatRemSet, bus.dpChiWatRemSet);
  connect(ctl.dpHeaWatRemSet, bus.dpHeaWatRemSet);
  connect(ctl.y1HeaHp, busHp.y1Hea);
  connect(ctl.y1Hp, busHp.y1);
  connect(ctl.y1PumChiWatPri, busPumChiWatPri.y1);
  connect(ctl.y1PumChiWatSec, busPumChiWatSec.y1);
  connect(ctl.y1PumHeaWatPri, busPumHeaWatPri.y1);
  connect(ctl.y1PumHeaWatSec, busPumHeaWatSec.y1);
  connect(ctl.y1ValChiWatHpInlIso, busValChiWatHpInlIso.y1);
  connect(ctl.y1ValChiWatHpOutIso, busValChiWatHpOutIso.y1);
  connect(ctl.y1ValHeaWatHpInlIso, busValHeaWatHpInlIso.y1);
  connect(ctl.y1ValHeaWatHpOutIso, busValHeaWatHpOutIso.y1);
  connect(ctl.yPumChiWatPriDed, busPumChiWatPri.y);
  connect(ctl.yPumChiWatPriHdr, busPumChiWatPri.y);
  connect(ctl.yPumChiWatSec, busPumChiWatSec.y);
  connect(ctl.yPumHeaWatPriDed, busPumHeaWatPri.y);
  connect(ctl.yPumHeaWatPriHdr, busPumHeaWatPri.y);
  connect(ctl.yPumHeaWatSec, busPumHeaWatSec.y);
  /* Control point connection - stop */
  connect(busAirHan.reqResChiWat, reqResChiWatAirHan.u) annotation (Line(
      points={{260,140},{240,140},{240,80},{212,80}},
      color={255,204,51},
      thickness=0.5));
  connect(busEquZon.reqPlaHeaWat, reqPlaHeaWatEquZon.u) annotation (Line(
      points={{260,-140},{240,-140},{240,-80},{212,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(busEquZon.reqResHeaWat, reqResHeaWatEquZon.u) annotation (Line(
      points={{260,-140},{240,-140},{240,-160},{212,-160}},
      color={255,204,51},
      thickness=0.5));
  connect(busEquZon.reqPlaChiWat, reqPlaChiWatEquZon.u) annotation (Line(
      points={{260,-140},{240,-140},{240,-120},{212,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(busEquZon.reqResChiWat, reqResChiWatEquZon.u) annotation (Line(
      points={{260,-140},{240,-140},{240,-200},{212,-200}},
      color={255,204,51},
      thickness=0.5));
  connect(busAirHan.reqPlaChiWat, reqPlaChiWatAirHan.u) annotation (Line(
      points={{260,140},{240,140},{240,160},{212,160}},
      color={255,204,51},
      thickness=0.5));
  connect(busAirHan.reqPlaHeaWat, reqPlaHeaWatAirHan.u) annotation (Line(
      points={{260,140},{240,140},{240,200},{212,200}},
      color={255,204,51},
      thickness=0.5));
  connect(busAirHan.reqResHeaWat, reqResHeaWatAirHan.u[1:1]) annotation (Line(
      points={{260,140},{240,140},{240,120},{212,120}},
      color={255,204,51},
      thickness=0.5));
  connect(reqPlaHeaWatAirHan.y, phReqPlaHeaWatAirHan.u)
    annotation (Line(points={{188,200},{172,200}}, color={255,127,0}));
  connect(reqPlaChiWatAirHan.y, phReqPlaChiWatAirHan.u)
    annotation (Line(points={{188,160},{172,160}}, color={255,127,0}));
  connect(reqResHeaWatAirHan.y, phReqResHeaWatAirHan.u)
    annotation (Line(points={{188,120},{172,120}}, color={255,127,0}));
  connect(reqResChiWatAirHan.y, phReqResChiWatAirHan.u)
    annotation (Line(points={{188,80},{172,80}}, color={255,127,0}));
  connect(reqPlaHeaWatEquZon.y, phReqPlaHeaWatEquZon.u) annotation (Line(points
        ={{188,-80},{180,-80},{180,-80},{172,-80}}, color={255,127,0}));
  connect(reqPlaChiWatEquZon.y, phReqPlaChiWatEquZon.u)
    annotation (Line(points={{188,-120},{172,-120}}, color={255,127,0}));
  connect(reqResChiWatEquZon.y, phReqResChiWatEquZon.u)
    annotation (Line(points={{188,-200},{172,-200}}, color={255,127,0}));
  connect(reqResHeaWatEquZon.y, phReqResHeaWatEquZon.u) annotation (Line(points
        ={{188,-160},{178,-160},{178,-160},{172,-160}}, color={255,127,0}));
  connect(phReqPlaHeaWatAirHan.y, reqPlaHeaWat.u1)
    annotation (Line(points={{148,200},{112,200}}, color={255,127,0}));
  connect(phReqPlaHeaWatEquZon.y, reqPlaHeaWat.u2) annotation (Line(points={{148,
          -80},{140,-80},{140,188},{112,188}}, color={255,127,0}));
  connect(phReqPlaChiWatAirHan.y, reqPlaChiWat.u1)
    annotation (Line(points={{148,160},{112,160}}, color={255,127,0}));
  connect(phReqPlaChiWatEquZon.y, reqPlaChiWat.u2) annotation (Line(points={{148,
          -120},{138,-120},{138,148},{112,148}}, color={255,127,0}));
  connect(phReqResHeaWatAirHan.y, reqResHeaWat.u1)
    annotation (Line(points={{148,120},{112,120}}, color={255,127,0}));
  connect(phReqResChiWatAirHan.y, reqResChiWat.u1)
    annotation (Line(points={{148,80},{112,80}}, color={255,127,0}));
  connect(phReqResHeaWatEquZon.y, reqResHeaWat.u2) annotation (Line(points={{148,
          -160},{136,-160},{136,108},{112,108}}, color={255,127,0}));
  connect(phReqResChiWatEquZon.y, reqResChiWat.u2) annotation (Line(points={{148,
          -200},{134,-200},{134,68},{112,68}}, color={255,127,0}));
  connect(reqPlaHeaWat.y, ctl.nReqPlaHeaWat) annotation (Line(points={{88,194},
          {-40,194},{-40,22.3529},{-22,22.3529}},
                                       color={255,127,0}));
  connect(reqPlaChiWat.y, ctl.nReqPlaChiWat) annotation (Line(points={{88,154},
          {-38,154},{-38,20.5882},{-22,20.5882}},
                                       color={255,127,0}));
  connect(reqResHeaWat.y,ctl.nReqResHeaWat)  annotation (Line(points={{88,114},
          {-36,114},{-36,18.8235},{-22,18.8235}},
                                       color={255,127,0}));
  connect(reqResChiWat.y,ctl.nReqResChiWat)  annotation (Line(points={{88,74},{
          -34,74},{-34,17.0588},{-22,17.0588}},
                                  color={255,127,0}));
  annotation (
    defaultComponentName="ctl");
end AirToWater;
