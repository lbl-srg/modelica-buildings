within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model ChillerGroup "Validation model for chiller group"
  extends Modelica.Icons.Example;

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";
  replaceable package MediumAir = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Integer nChi=3
    "Number of chillers";

  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=
    capChi_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (TChiWatRet_nominal-TChiWatSup_nominal)
    "CHW mass flow rate for each chiller"
    annotation (Evaluate=true, Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal=
    sum(mChiWatChi_flow_nominal)
    "Primary CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi]=
    capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiWatCoo)/
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (TConWatRet_nominal-TConWatSup_nominal)
    "CW mass flow rate for each water-cooled chiller"
    annotation (Evaluate=true,Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConAirChi_flow_nominal[nChi]=
    capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiAirCoo)*
    Buildings.Templates.Data.Defaults.mConAirByCap
    "Air mass flow rate at condenser for each air-cooled chiller"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal=
    sum(mConWatChi_flow_nominal)
    "CW mass flow rate (total)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi]=
    fill(Buildings.Templates.Data.Defaults.dpChiWatChi, nChi)
    "CHW pressure drop for each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatChi_nominal[nChi]=
    fill(Buildings.Templates.Data.Defaults.dpConWatChi, nChi)
    "WSE CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each min=0)=fill(1e6, nChi)
    "Cooling capacity for each chiller (>0)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    Buildings.Templates.Data.Defaults.TChiWatSup
    "CHW supply temperature";
  parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
    Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature";
  parameter Modelica.Units.SI.Temperature TConWatSup_nominal=
    Buildings.Templates.Data.Defaults.TConWatSup
    "CW supply temperature";
  parameter Modelica.Units.SI.Temperature TConWatRet_nominal=
    Buildings.Templates.Data.Defaults.TConWatRet
    "CW return temperature";

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatPri(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    dp_nominal=1.5*dpChiWatChi_nominal)
    "Parameter record for primary CHW pumps";
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumConWat(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mConWatChi_flow_nominal,
    dp_nominal=1.5*dpConWatChi_nominal)
    "Parameter record for CW pumps";
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup datChiWatCoo(
    final nChi=nChi,
    final typChi=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
    final mConFluChi_flow_nominal=mConWatChi_flow_nominal,
    final dpChiWatChi_nominal=dpChiWatChi_nominal,
    final dpConFluChi_nominal=dpConWatChi_nominal,
    final capChi_nominal=capChi_nominal,
    final TChiWatChiSup_nominal=fill(TChiWatSup_nominal, nChi),
    PLRChi_min=fill(0.15, nChi),
    redeclare each Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHE_1442kW_6_61COP_VSD per)
    "Parameter record for water-cooled chiller group";
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup datChiAirCoo(
    final nChi=nChi,
    final typChi=Buildings.Templates.Components.Types.Chiller.AirCooled,
    final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
    final mConFluChi_flow_nominal=mConAirChi_flow_nominal,
    final dpChiWatChi_nominal=dpChiWatChi_nominal,
    final capChi_nominal=capChi_nominal,
    final TChiWatChiSup_nominal=fill(TChiWatSup_nominal, nChi),
    PLRChi_min=fill(0.15, nChi),
    redeclare each Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled per)
    "Parameter record for air-cooled chiller group";

  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,180},{220,220}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Chi[nChi](
    each table=[0,0; 1.2,0; 1.2,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "Chiller, CW pumps and primary CHW pumps Start/Stop signal"
    annotation (Placement(transformation(extent={{-250,310},{-230,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPri(
    k=1) "Primary CHW pumps speed signal"
    annotation (Placement(transformation(extent={{-250,350},{-230,370}})));
  Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{30,110},{10,130}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,180})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{50,170},{70,190}})));
  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium=MediumChiWat,
    final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,100})));
  Fluid.Sources.PropertySource_T tow(
    redeclare final package Medium=MediumConWat,
    final use_T_in=true)
    "Ideal cooling to input set point (representing cooling tower)"
    annotation (Placement(transformation(extent={{-206,110},{-186,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWat(
    final k=TConWatSup_nominal) "CW supply temperature set point"
    annotation (Placement(transformation(extent={{-250,390},{-230,410}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValIso[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Chiller CW and CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-250,270},{-230,290}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable yValIso[nChi](each
      table=[0,0; 1,0; 1.5,1; 2,1],
    each timeScale=1000)
    "Chiller CW or CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-250,230},{-230,250}})));
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla
    "Plant control bus"
    annotation (Placement(transformation(extent={{180,200},{220,240}}),
                 iconTransformation(extent={{-432,12},{-412,32}})));
  ChillerGroups.Compression chi(
    redeclare final package MediumChiWat=MediumChiWat,
    redeclare final package MediumCon=MediumConWat,
    final dat=datChiWatCoo,
    final nChi=nChi,
    final energyDynamics=energyDynamics,
    typChi=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    typCtrHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None,
    typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    typArrPumConWat=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    typCtrSpePumConWat=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant,
    typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Chiller group"
    annotation (Placement(transformation(extent={{-100,90},{-60,210}})));
  Buildings.Templates.Components.Pumps.Multiple pumConWat(
    redeclare final package Medium = MediumConWat,
    final dat=datPumConWat,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant)
    "CW pumps"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat(
    redeclare final package Medium = MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));
  Buildings.Templates.Components.Routing.SingleToMultiple outConWatChi(
    redeclare final package Medium = MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CW outlet manifold"
    annotation (Placement(transformation(extent={{-150,170},{-130,190}})));
  Buildings.Templates.Components.Routing.MultipleToSingle inlChiWatChi(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CHW inlet manifold"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));
  Fluid.Sources.Boundary_pT bouCon(redeclare final package Medium =
        MediumConWat, nPorts=1) "CW pressure boundary condition" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-180,90})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumChiWatPri(
    redeclare final package Medium = MediumChiWat,
    nPorts_a=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau) "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple outPumConWat(
    redeclare final package Medium = MediumConWat,
    nPorts_a=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat
    "CW pumps control bus" annotation (Placement(transformation(extent={{180,160},
            {220,200}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWat[nChi](final k=
        fill(TChiWatSup_nominal, nChi)) "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-180,390},{-160,410}})));
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus" annotation (Placement(transformation(extent={{180,220},
            {220,260}}), iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri1(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau) "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri1(
    redeclare final package Medium = MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Fluid.HeatExchangers.HeaterCooler_u loa1(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{30,-30},{10,-10}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup1(redeclare final package
      Medium = MediumChiWat, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,40})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow1(redeclare final package Medium =
        MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Fluid.Sources.Boundary_pT bouChiWat1(redeclare final package Medium =
        MediumChiWat, final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-40})));
  Fluid.Sources.PropertySource_T tow1(redeclare final package Medium =
        MediumConWat, final use_T_in=true)
    "Ideal cooling to input set point (representing cooling tower)"
    annotation (Placement(transformation(extent={{-206,-30},{-186,-10}})));
  ChillerGroups.Compression chi1(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumCon = MediumConWat,
    final dat=datChiWatCoo,
    final nChi=nChi,
    final energyDynamics=energyDynamics,
    typChi=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    typCtrHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External,
    typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
    typArrPumConWat=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
    typCtrSpePumConWat=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant,
    typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Chiller group"
    annotation (Placement(transformation(extent={{-100,-50},{-60,70}})));

  Buildings.Templates.Components.Pumps.Multiple pumConWat1(
    redeclare final package Medium = MediumConWat,
    final dat=datPumConWat,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant)
    "CW pumps"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat1(
    redeclare final package Medium = MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-170,-30},{-150,-10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple outConWatChi1(
    redeclare final package Medium = MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CW outlet manifold"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle inlChiWatChi1(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CHW inlet manifold"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Fluid.Sources.Boundary_pT bouCon1(redeclare final package Medium =
        MediumConWat, nPorts=1) "CW pressure boundary condition" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-180,-50})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumChiWatPri1(
    redeclare final package Medium = MediumChiWat,
    nPorts_a=nChi,
    have_comLeg=true,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau) "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple outPumConWat1(
    redeclare final package Medium = MediumConWat,
    nPorts_a=nChi,
    have_comLeg=true,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri1
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,40},{220,80}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla1
    "Plant control bus"
    annotation (Placement(transformation(extent={{180,60},{220,100}}),
                 iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat1
    "CW pumps control bus" annotation (Placement(transformation(extent={{180,20},
            {220,60}}),  iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busChi1[nChi]
    "Chiller control bus" annotation (Placement(transformation(extent={{180,80},
            {220,120}}), iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatChiIso[nChi]
    "Chiller CW isolation valves control bus" annotation (Placement(
        transformation(extent={{220,80},{260,120}}), iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso[nChi]
    "Chiller CHW isolation valves control bus" annotation (Placement(
        transformation(extent={{120,80},{160,120}}), iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri2
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,-100},{220,-60}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla2
    "Plant control bus"
    annotation (Placement(transformation(extent={{180,-80},{220,-40}}),
                 iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busChi2[nChi]
    "Chiller control bus" annotation (Placement(transformation(extent={{180,-60},
            {220,-20}}), iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso1
                                                                  [nChi]
    "Chiller CHW isolation valves control bus" annotation (Placement(
        transformation(extent={{120,-60},{160,-20}}),iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri2(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau) "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri2(
    redeclare final package Medium = MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Fluid.HeatExchangers.HeaterCooler_u loa2(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{30,-170},{10,-150}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup2(redeclare final package
      Medium = MediumChiWat, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-100})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow2(redeclare final package Medium =
        MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Fluid.Sources.Boundary_pT bouChiWat2(redeclare final package Medium =
        MediumChiWat, final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-180})));
  ChillerGroups.Compression chi2(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumCon = MediumAir,
    final dat=datChiAirCoo,
    final nChi=nChi,
    final energyDynamics=energyDynamics,
    typChi=Buildings.Templates.Components.Types.Chiller.AirCooled,
    typCtrHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External,
    typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
    typArrPumConWat=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
    typCtrSpePumConWat=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant,
    typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Chiller group"
    annotation (Placement(transformation(extent={{-100,-190},{-60,-70}})));
  Buildings.Templates.Components.Routing.MultipleToSingle inlChiWatChi2(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CHW inlet manifold"
    annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));
  Fluid.Sources.Boundary_pT bouCon2(
    redeclare final package Medium = MediumAir,
    final nPorts=nChi)
    "Condenser cooling fluid pressure boundary condition"
    annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-190,-100})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumChiWatPri2(
    redeclare final package Medium = MediumChiWat,
    nPorts_a=nChi,
    have_comLeg=true,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Fluid.Sources.MassFlowSource_T souCon[nChi](
    redeclare each final package Medium = MediumAir,
    final m_flow=mConAirChi_flow_nominal,
    each final nPorts=1)
    "Condenser air flow source"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-190,-160})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,180})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,150})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
                                                               [nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,40})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa1(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,10})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-100})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa2(k=fill(1/nChi, nChi),
      nin=nChi)
      "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-130})));
equation
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{-20,180},{-20,180}},color={0,127,255}));
  connect(y1Chi.y[1], busPumChiWatPri.y1) annotation (Line(points={{-228,320},{160,
          320},{160,202},{200,202},{200,200}}, color={255,0,255}));
  connect(busPumChiWatPri, pumChiWatPri.bus) annotation (Line(
      points={{200,200},{-30,200},{-30,190}},
      color={255,204,51},
      thickness=0.5));
  connect(outPumChiWatPri.port_b, TChiWatPriSup.port_a)
    annotation (Line(points={{0,180},{20,180}},  color={0,127,255}));
  connect(TChiWatPriSup.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{40,180},{50,180}}, color={0,127,255}));
  connect(loa.port_a, mChiWatPri_flow.port_b) annotation (Line(points={{30,120},
          {80,120},{80,180},{70,180}},  color={0,127,255}));
  connect(bouChiWat.ports[1], loa.port_b)
    annotation (Line(points={{0,110},{0,120},{10,120}},
                                                     color={0,127,255}));
  connect(TConWat.y, tow.T_in) annotation (Line(points={{-228,400},{-200,400},{-200,
          132}}, color={0,0,127}));
  connect(tow.port_b, inlPumConWat.port_a)
    annotation (Line(points={{-186,120},{-170,120}}, color={0,127,255}));
  connect(pumConWat.ports_a, inlPumConWat.ports_b)
    annotation (Line(points={{-150,120},{-150,120}}, color={0,127,255}));
  connect(chi.ports_bCon, outConWatChi.ports_b)
    annotation (Line(points={{-100,180},{-130,180}}, color={0,127,255}));
  connect(outConWatChi.port_a, tow.port_a) annotation (Line(points={{-150,180},{
          -220,180},{-220,120},{-206,120}},  color={0,127,255}));
  connect(loa.port_b,inlChiWatChi. port_b)
    annotation (Line(points={{10,120},{-30,120}},  color={0,127,255}));
  connect(inlChiWatChi.ports_a, chi.ports_aChiWat)
    annotation (Line(points={{-50,120},{-60,120}}, color={0,127,255}));
  connect(chi.ports_bChiWat, inlPumChiWatPri.ports_a)
    annotation (Line(points={{-60,180},{-60,180}}, color={0,127,255}));
  connect(inlPumChiWatPri.ports_b, pumChiWatPri.ports_a)
    annotation (Line(points={{-40,180},{-40,180}}, color={0,127,255}));
  connect(pumConWat.ports_b, outPumConWat.ports_a)
    annotation (Line(points={{-130,120},{-130,120}}, color={0,127,255}));
  connect(outPumConWat.ports_b, chi.ports_aCon)
    annotation (Line(points={{-110,120},{-100,120}}, color={0,127,255}));
  connect(tow.port_b, bouCon.ports[1]) annotation (Line(points={{-186,120},{-180,
          120},{-180,100}}, color={0,127,255}));
  connect(y1Chi.y[1], busPumConWat.y1) annotation (Line(points={{-228,320},{160,
          320},{160,180},{200,180}}, color={255,0,255}));
  connect(busPumConWat, pumConWat.bus) annotation (Line(
      points={{200,180},{200,140},{-140,140},{-140,130}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla, chi.bus) annotation (Line(
      points={{200,220},{-80,220},{-80,210}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Chi.y[1], busChi.y1) annotation (Line(points={{-228,320},{160,320},
          {160,240},{200,240}}, color={255,0,255}));
  connect(busChi, busPla.chi) annotation (Line(
      points={{200,240},{200,220}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWat.y, busChi.TChiWatSupSet) annotation (Line(points={{-158,400},{
          166,400},{166,244},{200,244},{200,240}}, color={0,0,127}));
  connect(pumChiWatPri1.ports_b, outPumChiWatPri1.ports_a)
    annotation (Line(points={{-20,40},{-20,40}}, color={0,127,255}));
  connect(y1Chi.y[1], busPumChiWatPri1.y1) annotation (Line(points={{-228,320},{
          160,320},{160,62},{200,62},{200,60}}, color={255,0,255}));
  connect(busPumChiWatPri1, pumChiWatPri1.bus) annotation (Line(
      points={{200,60},{-30,60},{-30,50}},
      color={255,204,51},
      thickness=0.5));
  connect(outPumChiWatPri1.port_b, TChiWatPriSup1.port_a)
    annotation (Line(points={{0,40},{20,40}}, color={0,127,255}));
  connect(TChiWatPriSup1.port_b, mChiWatPri_flow1.port_a)
    annotation (Line(points={{40,40},{50,40}}, color={0,127,255}));
  connect(loa1.port_a, mChiWatPri_flow1.port_b) annotation (Line(points={{30,-20},
          {80,-20},{80,40},{70,40}}, color={0,127,255}));
  connect(bouChiWat1.ports[1], loa1.port_b)
    annotation (Line(points={{0,-30},{0,-20},{10,-20}}, color={0,127,255}));
  connect(TConWat.y, tow1.T_in) annotation (Line(points={{-228,400},{-200,400},{
          -200,-8}}, color={0,0,127}));
  connect(tow1.port_b, inlPumConWat1.port_a)
    annotation (Line(points={{-186,-20},{-170,-20}}, color={0,127,255}));
  connect(pumConWat1.ports_a, inlPumConWat1.ports_b)
    annotation (Line(points={{-150,-20},{-150,-20}}, color={0,127,255}));
  connect(chi1.ports_bCon, outConWatChi1.ports_b)
    annotation (Line(points={{-100,40},{-130,40}}, color={0,127,255}));
  connect(outConWatChi1.port_a, tow1.port_a) annotation (Line(points={{-150,40},
          {-220,40},{-220,-20},{-206,-20}}, color={0,127,255}));
  connect(loa1.port_b, inlChiWatChi1.port_b)
    annotation (Line(points={{10,-20},{-30,-20}}, color={0,127,255}));
  connect(inlChiWatChi1.ports_a, chi1.ports_aChiWat)
    annotation (Line(points={{-50,-20},{-60,-20}}, color={0,127,255}));
  connect(chi1.ports_bChiWat, inlPumChiWatPri1.ports_a)
    annotation (Line(points={{-60,40},{-60,40}}, color={0,127,255}));
  connect(inlPumChiWatPri1.ports_b, pumChiWatPri1.ports_a)
    annotation (Line(points={{-40,40},{-40,40}}, color={0,127,255}));
  connect(pumConWat1.ports_b, outPumConWat1.ports_a)
    annotation (Line(points={{-130,-20},{-130,-20}}, color={0,127,255}));
  connect(outPumConWat1.ports_b, chi1.ports_aCon)
    annotation (Line(points={{-110,-20},{-100,-20}}, color={0,127,255}));
  connect(tow1.port_b, bouCon1.ports[1]) annotation (Line(points={{-186,-20},{-180,
          -20},{-180,-40}}, color={0,127,255}));
  connect(y1Chi.y[1], busPumConWat1.y1) annotation (Line(points={{-228,320},{160,
          320},{160,40},{200,40}}, color={255,0,255}));
  connect(busPumConWat1, pumConWat1.bus) annotation (Line(
      points={{200,40},{200,0},{-140,0},{-140,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1, chi1.bus) annotation (Line(
      points={{200,80},{-80,80},{-80,70}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Chi.y[1], busChi1.y1) annotation (Line(points={{-228,320},{160,320},
          {160,100},{200,100}}, color={255,0,255}));
  connect(busChi1, busPla1.chi) annotation (Line(
      points={{200,100},{200,80}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWat.y, busChi1.TChiWatSupSet) annotation (Line(points={{-158,400},
          {166,400},{166,104},{200,104},{200,100}}, color={0,0,127}));
  connect(yValIso.y[1], busValChiWatChiIso.y) annotation (Line(points={{-228,240},
          {120,240},{120,170},{140,170},{140,100}},
                                color={0,0,127}));
  connect(yValIso.y[1], busValConWatChiIso.y) annotation (Line(points={{-228,240},
          {120,240},{120,120},{240,120},{240,100}}, color={0,0,127}));
  connect(busValChiWatChiIso, busPla1.valChiWatChiIso) annotation (Line(
      points={{140,100},{140,84},{200,84},{200,80}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatChiIso, busPla1.valConWatChiIso) annotation (Line(
      points={{240,100},{240,80},{200,80}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Chi.y[1],busPumChiWatPri2. y1) annotation (Line(points={{-228,320},{
          160,320},{160,-78},{200,-78},{200,-80}},
                                                color={255,0,255}));
  connect(busPla2,chi2. bus) annotation (Line(
      points={{200,-60},{-80,-60},{-80,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Chi.y[1],busChi2. y1) annotation (Line(points={{-228,320},{160,320},
          {160,-40},{200,-40}}, color={255,0,255}));
  connect(busChi2,busPla2. chi) annotation (Line(
      points={{200,-40},{200,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWat.y,busChi2. TChiWatSupSet) annotation (Line(points={{-158,400},
          {166,400},{166,-36},{200,-36},{200,-40}}, color={0,0,127}));
  connect(yValIso.y[1], busValChiWatChiIso1.y) annotation (Line(points={{-228,240},
          {120,240},{120,-40},{140,-40}},
                                color={0,0,127}));
  connect(busValChiWatChiIso1, busPla2.valChiWatChiIso) annotation (Line(
      points={{140,-40},{140,-56},{200,-56},{200,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(pumChiWatPri2.ports_b,outPumChiWatPri2. ports_a)
    annotation (Line(points={{-20,-100},{-20,-100}},
                                                 color={0,127,255}));
  connect(outPumChiWatPri2.port_b,TChiWatPriSup2. port_a)
    annotation (Line(points={{0,-100},{20,-100}},
                                              color={0,127,255}));
  connect(TChiWatPriSup2.port_b,mChiWatPri_flow2. port_a)
    annotation (Line(points={{40,-100},{50,-100}}, color={0,127,255}));
  connect(loa2.port_a,mChiWatPri_flow2. port_b) annotation (Line(points={{30,-160},
          {80,-160},{80,-100},{70,-100}}, color={0,127,255}));
  connect(bouChiWat2.ports[1],loa2. port_b)
    annotation (Line(points={{0,-170},{0,-160},{10,-160}}, color={0,127,255}));
  connect(loa2.port_b,inlChiWatChi2. port_b)
    annotation (Line(points={{10,-160},{-30,-160}}, color={0,127,255}));
  connect(inlChiWatChi2.ports_a,chi2. ports_aChiWat)
    annotation (Line(points={{-50,-160},{-60,-160}}, color={0,127,255}));
  connect(chi2.ports_bChiWat,inlPumChiWatPri2. ports_a)
    annotation (Line(points={{-60,-100},{-60,-100}}, color={0,127,255}));
  connect(inlPumChiWatPri2.ports_b,pumChiWatPri2. ports_a)
    annotation (Line(points={{-40,-100},{-40,-100}}, color={0,127,255}));
  connect(chi2.ports_bCon, bouCon2.ports)
    annotation (Line(points={{-100,-100},{-180,-100}}, color={0,127,255}));
  connect(souCon.ports[1], chi2.ports_aCon)
    annotation (Line(points={{-180,-160},{-100,-160}}, color={0,127,255}));
  connect(busPumChiWatPri2, pumChiWatPri2.bus) annotation (Line(
      points={{200,-80},{-30,-80},{-30,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea.y,comSigLoa. u)
    annotation (Line(points={{240,168},{240,162}},   color={0,0,127}));
  connect(comSigLoa.y, loa.u)
    annotation (Line(points={{240,138},{240,126},{32,126}}, color={0,0,127}));
  connect(booToRea1.y, comSigLoa1.u)
    annotation (Line(points={{240,28},{240,22}}, color={0,0,127}));
  connect(comSigLoa1.y, loa1.u)
    annotation (Line(points={{240,-2},{240,-14},{32,-14}}, color={0,0,127}));
  connect(booToRea2.y, comSigLoa2.u)
    annotation (Line(points={{240,-112},{240,-118}}, color={0,0,127}));
  connect(comSigLoa2.y, loa2.u) annotation (Line(points={{240,-142},{240,-154},{
          32,-154}}, color={0,0,127}));
  connect(busChi2.y1_actual, booToRea2.u) annotation (Line(
      points={{200,-40},{240,-40},{240,-88}},
      color={255,204,51},
      thickness=0.5));
  connect(busChi1.y1_actual, booToRea1.u) annotation (Line(
      points={{200,100},{220,100},{220,60},{240,60},{240,52}},
      color={255,204,51},
      thickness=0.5));
  connect(busChi.y1_actual, booToRea.u) annotation (Line(
      points={{200,240},{240,240},{240,192}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-260,-640},{260,440}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Components/Validation/ChillerGroup.mos"
    "Simulate and plot"));
end ChillerGroup;
