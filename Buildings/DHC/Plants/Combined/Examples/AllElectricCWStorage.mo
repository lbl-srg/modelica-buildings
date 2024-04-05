within Buildings.DHC.Plants.Combined.Examples;
model AllElectricCWStorage
  "Validation of all-electric plant model with buildings loads"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common to CHW, HW and CW)";
  replaceable package MediumConWatCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in cooler circuit";

  parameter String filNam[2]={"modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos",
                              "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos"}
    "Path to file with timeseries loads";
  parameter Modelica.Units.SI.Temperature TSetDisSupHea = 273.15+60 "District heating supply temperature set point";
  parameter Modelica.Units.SI.Temperature TSetDisSupCoo = 273.15+6 "District cooling supply temperature set point";

  replaceable parameter
    Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_Carrier_19XR_1403kW_7_09COP_VSD datChi(
      EIRFunT={0.0101739374, 0.0607200115, 0.0003348647, 0.003162578, 0.0002388594, -0.0014121289},
      capFunT={0.0387084662, 0.2305017927, 0.0004779504, 0.0178244359, -8.48808e-05, -0.0032406711},
      EIRFunPLR={0.4304252832, -0.0144718912, 5.12039e-05, -0.7562386674, 0.5661683373,
        0.0406987748, 3.0278e-06, -0.3413411197, -0.000469572, 0.0055009208},
    QEva_flow_nominal=sum(loaCoo.QCoo_flow_nominal)/pla.nChi,
      COP_nominal=2.5,
    mEva_flow_nominal=-datChi.QEva_flow_nominal/5/4186,
      mCon_flow_nominal=-datChi.QEva_flow_nominal * (1 + 1/datChi.COP_nominal) / 10 / 4186,
    TEvaLvg_nominal=TSetDisSupCoo,
    TEvaLvgMin=277.15,
    TEvaLvgMax=308.15,
    TConLvg_nominal=TSetDisSupHea,
    TConLvgMin=296.15,
    TConLvgMax=336.15)
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="CHW loop and cooling-only chillers"),
      Placement(transformation(extent={{140,200},{160,220}})));
  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChiHea = datChi
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="HW loop and heat recovery chillers"),
      Placement(transformation(extent={{170,200},{190,220}})));
  replaceable parameter Fluid.HeatPumps.Data.EquationFitReversible.Generic datHeaPum(
    dpHeaLoa_nominal=50000,
    dpHeaSou_nominal=100,
    hea(
      mLoa_flow=datHeaPum.hea.Q_flow/10/4186,
      mSou_flow=1E-4*datHeaPum.hea.Q_flow,
      Q_flow=sum(loaHea.QHea_flow_nominal)/pla.nHeaPum,
      P=datHeaPum.hea.Q_flow/2.2,
      coeQ={-5.64420084,1.95212447,9.96663913,0.23316322,-5.64420084},
      coeP={-3.96682255,6.8419453,1.99606939,0.01393387,-3.96682255},
      TRefLoa=298.15,
      TRefSou=253.15),
    coo(
      mLoa_flow=0,
      mSou_flow=0,
      Q_flow=-1,
      P=0,
      coeQ=fill(0, 5),
      coeP=fill(0, 5),
      TRefLoa=273.15,
      TRefSou=273.15))
    "Heat pump parameters (each unit)"
    annotation (Placement(transformation(extent={{200,200},{220,220}})));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Buildings.DHC.Plants.Combined.AllElectricCWStorage pla(
    redeclare final package Medium = Medium,
    redeclare package MediumHea_b = Medium,
    redeclare final package MediumConWatCoo = MediumConWatCoo,
    allowFlowReversal=true,
    dpConWatCooFri_nominal=1E4,
    mAirCooUni_flow_nominal=pla.mConWatCoo_flow_nominal/pla.nCoo/1.45,
    TWetBulCooEnt_nominal=297.05,
    PFanCoo_nominal=340*pla.mConWatCoo_flow_nominal/pla.nCoo,
    chi(show_T=true),
    chiHea(show_T=true),
    heaPum(show_T=true),
    final datChi=datChi,
    final datChiHea=datChiHea,
    final datHeaPum=datHeaPum,
    nChi=2,
    dpChiWatSet_max=(sum(disCoo.lDis) + disCoo.lEnd)*disCoo.dp_length_nominal,
    nChiHea=2,
    dpHeaWatSet_max=(sum(disHea.lDis) + disHea.lEnd)*disHea.dp_length_nominal,
    nHeaPum=2,
    dInsTan=0.05,
    nCoo=3,
    final energyDynamics=energyDynamics)
    "CHW and HW plant"
    annotation (Placement(transformation(extent={{-30,-30},{30,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(final k=pla.TChiWatSup_nominal,
    y(final unit="K", displayUnit="degC"))
                   "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(final k=pla.THeaWatSup_nominal,
    y(final unit="K", displayUnit="degC"))
                   "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-190,-10},{-170,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHeaWatSet_max(
    k=pla.dpHeaWatSet_max,
    y(final unit="Pa")) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-190,-70},{-170,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWatSet_max(
    k=pla.dpChiWatSet_max,
    y(final unit="Pa")) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-210,120})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRet[2](each k=pla.TChiWatRet_nominal)
    "Source signal for CHW return temperature"
    annotation (Placement(transformation(extent={{-190,-110},{-170,-90}})));
  Loads.Heating.BuildingTimeSeriesWithETS loaHea[2](
    each THeaWatSup_nominal=pla.THeaWatSup_nominal,
    filNam=filNam)                     "Building heating load"
    annotation (Placement(transformation(extent={{10,100},{-10,120}})));
    // dpCheVal_nominal to avoid too hot water in building waterr supply due to problem of temperature drop in Dymola
  Loads.Cooling.BuildingTimeSeriesWithETS loaCoo[2](
    each TChiWatSup_nominal=pla.TChiWatSup_nominal,
    filNam=filNam,
    each bui(w_aLoaCoo_nominal=0.015)) "Building cooling load"
    annotation (Placement(transformation(extent={{10,-130},{-10,-110}})));
    // dpCheVal_nominal to avoid freezing in building waterr supply due to problem of temperature drop in Dymola
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatRet[2](each k=pla.THeaWatRet_nominal)
    "Source signal for HW return temperature"
    annotation (Placement(transformation(extent={{-190,40},{-170,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not
                               onPla "On signal for the plant"
    annotation (Placement(transformation(extent={{-64,146},{-44,166}})));
  Buildings.Controls.OBC.CDL.Logical.Timer
                                 tim(t=3600)
    annotation (Placement(transformation(extent={{-104,154},{-84,174}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold offHea(t=1e-4)
    "Threshold comparison to disable the plant"
    annotation (Placement(transformation(extent={{-144,154},{-124,174}})));
  Modelica.Blocks.Math.Gain norQFloHea(k=1/sum(loaHea.QHea_flow_nominal))
    "Normalized Q_flow"
    annotation (Placement(transformation(extent={{-184,154},{-164,174}})));
  Buildings.Controls.OBC.CDL.Logical.Not
                               onPla1
                                     "On signal for the plant"
    annotation (Placement(transformation(extent={{-26,-198},{-6,-178}})));
  Buildings.Controls.OBC.CDL.Logical.Timer
                                 tim1(t=3600)
    annotation (Placement(transformation(extent={{-66,-190},{-46,-170}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold offCoo1(t=1e-4)
    "Threshold comparison to disable the plant"
    annotation (Placement(transformation(extent={{-106,-190},{-86,-170}})));
  Modelica.Blocks.Math.Gain norQFloCoo(k=1/sum(loaCoo.QCoo_flow_nominal))
    "Normalized Q_flow"
    annotation (Placement(transformation(extent={{-146,-190},{-126,-170}})));
  Buildings.DHC.Networks.Distribution2Pipe_R disHea(
    redeclare final package Medium = Medium,
    nCon=2,
    allowFlowReversal=false,
    mDis_flow_nominal=sum(loaHea.mBui_flow_nominal),
    mCon_flow_nominal={loaHea[1].mBui_flow_nominal,loaHea[2].mBui_flow_nominal},

    mEnd_flow_nominal=sum(loaHea.mBui_flow_nominal),
    lDis={800,200},
    lEnd=200) "Distribution network for district heating system"
    annotation (Placement(transformation(extent={{20,62},{-20,82}})));

  Buildings.DHC.Networks.Distribution2Pipe_R disCoo(
    redeclare final package Medium = Medium,
    nCon=2,
    allowFlowReversal=false,
    mDis_flow_nominal=sum(loaCoo.mBui_flow_nominal),
    mCon_flow_nominal={loaCoo[1].mBui_flow_nominal,loaCoo[2].mBui_flow_nominal},

    mEnd_flow_nominal=sum(loaCoo.mBui_flow_nominal),
    lDis={80,20},
    lEnd=20) "Distribution network for district cooling system"
    annotation (Placement(transformation(extent={{20,-60},{-20,-80}})));

  Modelica.Blocks.Math.Sum QTotHea_flow(nin=2)
    "Total heating flow rate for all buildings "
    annotation (Placement(transformation(extent={{-60,120},{-80,140}})));
  Modelica.Blocks.Math.Sum QTotCoo_flow(nin=2)
    "Total cooling flow rate for all buildings "
    annotation (Placement(transformation(extent={{-82,-150},{-102,-130}})));
equation
  connect(TChiWatSupSet.y, pla.TChiWatSupSet) annotation (Line(points={{-198,20},
          {-34,20}},                   color={0,0,127}));
  connect(THeaWatSupSet.y, pla.THeaWatSupSet) annotation (Line(points={{-168,0},
          {-74,0},{-74,16},{-34,16}},   color={0,0,127}));
  connect(dpChiWatSet_max.y, pla.dpChiWatSet) annotation (Line(points={{-198,-40},
          {-70,-40},{-70,12},{-34,12}},color={0,0,127}));
  connect(dpHeaWatSet_max.y, pla.dpHeaWatSet) annotation (Line(points={{-168,-60},
          {-66,-60},{-66,8},{-34,8}},   color={0,0,127}));

  connect(weaDat.weaBus, pla.weaBus) annotation (Line(
      points={{-200,120},{-100,120},{-100,40},{0,40},{0,30}},
      color={255,204,51},
      thickness=0.5));
  connect(norQFloHea.y,offHea. u)
    annotation (Line(points={{-163,164},{-146,164}}, color={0,0,127}));
  connect(offHea.y, tim.u)
    annotation (Line(points={{-122,164},{-106,164}}, color={255,0,255}));
  connect(tim.passed, onPla.u)
    annotation (Line(points={{-82,156},{-66,156}}, color={255,0,255}));
  connect(onPla.y, pla.u1Hea) annotation (Line(points={{-42,156},{-38,156},{-38,
          24},{-34,24}},                     color={255,0,255}));
  connect(tim1.passed, onPla1.u)
    annotation (Line(points={{-44,-188},{-40,-188},{-40,-190},{-36,-190},{-36,-188},
          {-28,-188}},                               color={255,0,255}));
  connect(offCoo1.y, tim1.u)
    annotation (Line(points={{-84,-180},{-80,-180},{-80,-182},{-76,-182},{-76,-180},
          {-68,-180}},                               color={255,0,255}));
  connect(norQFloCoo.y, offCoo1.u)
    annotation (Line(points={{-125,-180},{-120,-180},{-120,-182},{-116,-182},{-116,
          -180},{-108,-180}},                          color={0,0,127}));
  connect(onPla1.y, pla.u1Coo) annotation (Line(points={{-4,-188},{8,-188},{8,-150},
          {-54,-150},{-54,28},{-34,28}}, color={255,0,255}));
  connect(pla.port_bSerHea, disHea.port_aDisSup) annotation (Line(points={{30,0},
          {40,0},{40,72},{20,72}}, color={0,127,255}));
  connect(disHea.port_bDisRet, pla.port_aSerHea) annotation (Line(points={{20,66},
          {30,66},{30,50},{-40,50},{-40,0},{-30,0}}, color={0,127,255}));
  connect(disCoo.port_aDisSup, pla.port_bSerCoo) annotation (Line(points={{20,-70},
          {40,-70},{40,-4},{30,-4}}, color={0,127,255}));
  connect(disCoo.port_bDisRet, pla.port_aSerCoo) annotation (Line(points={{20,-64},
          {30,-64},{30,-46},{-40,-46},{-40,-4},{-30,-4}}, color={0,127,255}));
  connect(disCoo.ports_aCon, loaCoo.port_bSerCoo) annotation (Line(points={{-12,
          -80},{-12,-92},{-32,-92},{-32,-128},{-10,-128}}, color={0,127,255}));
  connect(disCoo.ports_bCon, loaCoo.port_aSerCoo) annotation (Line(points={{12,-80},
          {12,-92},{30,-92},{30,-128},{10,-128}}, color={0,127,255}));
  connect(disHea.ports_bCon, loaHea.port_aSerHea) annotation (Line(points={{12,82},
          {12,92},{32,92},{32,106},{10,106}}, color={0,127,255}));
  connect(loaHea.port_bSerHea, disHea.ports_aCon) annotation (Line(points={{-10,
          106},{-32,106},{-32,90},{-12,90},{-12,82}}, color={0,127,255}));
  connect(QTotHea_flow.y, norQFloHea.u) annotation (Line(points={{-81,130},{-194,
          130},{-194,164},{-186,164}}, color={0,0,127}));
  connect(loaCoo.QCoo_flow, QTotCoo_flow.u) annotation (Line(points={{-7,-132},{
          -8,-132},{-8,-140},{-80,-140}}, color={0,0,127}));
  connect(QTotCoo_flow.y, norQFloCoo.u) annotation (Line(points={{-103,-140},{-160,
          -140},{-160,-180},{-148,-180}}, color={0,0,127}));
  connect(loaHea.QHea_flow, QTotHea_flow.u) annotation (Line(points={{-5,98},{-4,
          98},{-4,94},{-50,94},{-50,130},{-58,130}}, color={0,0,127}));
  connect(TChiWatRet.y,loaCoo.TDisRetSet)  annotation (Line(points={{-168,-100},
          {20,-100},{20,-113},{11,-113}}, color={0,0,127}));
  connect(THeaWatRet.y,loaHea.TDisRetSet)  annotation (Line(points={{-168,50},{-44,
          50},{-44,126},{20,126},{20,117},{11,117}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Combined/Examples/AllElectricCWStorage.mos"
      "Simulate and plot"),
    experiment(
      StartTime=3024000,
      StopTime=3456000,
      Tolerance=1e-06),
  Diagram(coordinateSystem(extent={{-240,-240},{240,240}})),
    Documentation(info="<html>
<p>
This model uses
<a href=\"modelica://Buildings.DHC.Plants.Combined.AllElectricCWStorage\">
Buildings.DHC.Plants.Combined.AllElectricCWStorage</a>
to provide heating and cooling to two identical buildings with heating and cooling
loads provided as time series.
</p>
</html>", revisions="<html>
<ul>
<li>
April 7, 2023, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end AllElectricCWStorage;
