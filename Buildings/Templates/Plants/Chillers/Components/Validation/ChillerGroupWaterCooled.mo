within Buildings.Templates.Plants.Chillers.Components.Validation;
model ChillerGroupWaterCooled
  "Validation model for water-cooled chiller group"
  extends Modelica.Icons.Example;

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  parameter Integer nChi=3
    "Number of chillers";
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=
    capChi_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (TChiWatRet_nominal-TChiWatSup_nominal)
    "CHW mass flow rate - Each chiller"
    annotation (Evaluate=true, Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal=
    sum(mChiWatChi_flow_nominal)
    "Primary CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi]=
    capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiWatCoo)/
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (TConWatRet_nominal-TConWatSup_nominal)
    "CW mass flow rate - Each water-cooled chiller"
    annotation (Evaluate=true,Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal=
    sum(mConWatChi_flow_nominal)
    "CW mass flow rate (total)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi]=
    fill(Buildings.Templates.Data.Defaults.dpChiWatChi, nChi)
    "CHW pressure drop - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatChi_nominal[nChi]=
    fill(Buildings.Templates.Data.Defaults.dpConWatChi, nChi)
    "WSE CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each min=0)=fill(1e6, nChi)
    "Cooling capacity - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Real COPChi_nominal[nChi](
    each min=0)=fill(Buildings.Templates.Data.Defaults.COPChiWatCoo, nChi)
    "Cooling COP - Each chiller"
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
  parameter Buildings.Templates.Plants.Chillers.Components.Data.ChillerGroup
    datChi(
    final nChi=nChi,
    final typ=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
    final mConWatChi_flow_nominal=mConWatChi_flow_nominal,
    final dpChiWatChi_nominal=dpChiWatChi_nominal,
    final dpConChi_nominal=dpConWatChi_nominal,
    final capChi_nominal=capChi_nominal,
    final COPChi_nominal=COPChi_nominal,
    final TChiWatSupChi_nominal=fill(TChiWatSup_nominal, nChi),
    final TConWatEntChi_nominal=fill(TConWatSup_nominal, nChi),
    PLRChi_min=fill(0.15, nChi),
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_Trane_CVHE_1442kW_6_61COP_VSD
      perChi)
    "Parameter record for water-cooled chiller group";

  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final have_var=false,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,100})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium=MediumChiWat, nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,-100})));
  Fluid.Sources.PropertySource_T tow(
    redeclare final package Medium=MediumConWat,
    final use_T_in=true)
    "Ideal cooling to input set point (representing cooling tower)"
    annotation (Placement(transformation(extent={{-206,-90},{-186,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConWat(
    final k=TConWatSup_nominal) "CW supply temperature set point"
    annotation (Placement(transformation(extent={{-240,130},{-220,150}})));

  Plants.Chillers.Components.ChillerGroups.Compression chi(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumCon = MediumConWat,
    typArr=Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel,
    typDisChiWat=Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only,
    final dat=datChi,
    final nChi=nChi,
    final energyDynamics=energyDynamics,
    typ=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    typCtlHea=Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.None,
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typArrPumConWat=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumConWatVar=false,
    typEco=Buildings.Templates.Plants.Chillers.Types.Economizer.None,
    show_T=true)
    "Chiller group"
    annotation (Placement(transformation(extent={{-100,-96},{-60,104}})));

  Buildings.Templates.Components.Pumps.Multiple pumConWat(
    redeclare final package Medium = MediumConWat,
    final dat=datPumConWat,
    final nPum=nChi,
    final have_var=false,
    final energyDynamics=energyDynamics)
    "CW pumps"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat(
    redeclare final package Medium = MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-170,-90},{-150,-70}})));
  Buildings.Templates.Components.Routing.SingleToMultiple outConWatChi(
    redeclare final package Medium = MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CW outlet manifold"
    annotation (Placement(transformation(extent={{-150,90},{-130,110}})));
  Buildings.Templates.Components.Routing.MultipleToSingle inlChiWatChi(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CHW inlet manifold"
    annotation (Placement(transformation(extent={{-52,-90},{-32,-70}})));
  Fluid.Sources.Boundary_pT bouCon(redeclare final package Medium =
        MediumConWat, nPorts=1) "CW pressure boundary condition" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-180,-110})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumChiWatPri(
    redeclare final package Medium = MediumChiWat,
    nPorts_a=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau) "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple outPumConWat(
    redeclare final package Medium = MediumConWat,
    nPorts_a=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));

  Plants.Chillers.Components.Controls.OpenLoop ctl(
    cfg=Buildings.Templates.Plants.Chillers.Components.Validation.Configuration.Variable1OnlyWaterCooledParallel(
      nChi=chi.nChi,
      typArrPumChiWatPri=chi.typArrPumChiWatPri,
      typArrPumConWat=chi.typArrPumConWat,
      have_pumChiWatPriVar=pumChiWatPri.have_var,
      have_pumChiWatPriVarCom=pumChiWatPri.have_varCom,
      have_pumConWatVar=pumConWat.have_var,
      have_pumConWatVarCom=pumConWat.have_varCom,
      typEco=chi.typEco,
      typValChiWatChiIso=chi.typValChiWatChiIso,
      typValConWatChiIso=chi.typValConWatChiIso),
    dat(sta=fill(fill(0, ctl.dat.nUniSta), ctl.dat.nUniSta)))
    "Plant controller"
    annotation (Placement(transformation(extent={{-160,170},{-180,190}})));
  Buildings.Templates.Plants.Chillers.Interfaces.Bus busPla
    "Plant control bus"
    annotation (Placement(transformation(extent={{-100,120},{-60,160}}),
                         iconTransformation(extent={{-432,12},{-412,32}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriRet(redeclare final package Medium =
        MediumChiWat, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-80})));
  Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    final energyDynamics=energyDynamics,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{88,-90},{68,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert pump return signal to real"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,80})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum comSigLoa(k=fill(1/nChi, nChi), nin
      =nChi)    "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,50})));
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus"
    annotation (Placement(transformation(extent={{140,120},{180,160}}),
                         iconTransformation(extent={{-422,198},{-382,238}})));
equation
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{-20,100},{-20,100}},color={0,127,255}));
  connect(outPumChiWatPri.port_b, TChiWatPriSup.port_a)
    annotation (Line(points={{0,100},{20,100}},  color={0,127,255}));
  connect(TChiWatPriSup.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{40,100},{50,100}}, color={0,127,255}));
  connect(TConWat.y, tow.T_in) annotation (Line(points={{-218,140},{-200,140},{-200,
          -68}}, color={0,0,127}));
  connect(tow.port_b, inlPumConWat.port_a)
    annotation (Line(points={{-186,-80},{-170,-80}}, color={0,127,255}));
  connect(pumConWat.ports_a, inlPumConWat.ports_b)
    annotation (Line(points={{-150,-80},{-150,-80}}, color={0,127,255}));
  connect(chi.ports_bCon, outConWatChi.ports_b)
    annotation (Line(points={{-100,100},{-130,100}}, color={0,127,255}));
  connect(outConWatChi.port_a, tow.port_a) annotation (Line(points={{-150,100},{
          -220,100},{-220,-80},{-206,-80}},  color={0,127,255}));
  connect(inlChiWatChi.ports_a, chi.ports_aChiWat)
    annotation (Line(points={{-52,-80},{-56,-80},{-56,-92},{-60,-92}},
                                                   color={0,127,255}));
  connect(chi.ports_bChiWat, inlPumChiWatPri.ports_a)
    annotation (Line(points={{-60,100},{-60,100}}, color={0,127,255}));
  connect(inlPumChiWatPri.ports_b, pumChiWatPri.ports_a)
    annotation (Line(points={{-40,100},{-40,100}}, color={0,127,255}));
  connect(pumConWat.ports_b, outPumConWat.ports_a)
    annotation (Line(points={{-130,-80},{-130,-80}}, color={0,127,255}));
  connect(outPumConWat.ports_b, chi.ports_aCon)
    annotation (Line(points={{-110,-80},{-106,-80},{-106,-92},{-100,-92}},
                                                     color={0,127,255}));
  connect(tow.port_b, bouCon.ports[1]) annotation (Line(points={{-186,-80},{-180,
          -80},{-180,-100}},color={0,127,255}));
  connect(chi.bus, busPla) annotation (Line(
      points={{-80,104.2},{-80,140}},
      color={255,204,51},
      thickness=0.5));
  connect(ctl.bus, busPla) annotation (Line(
      points={{-160,180},{-80,180},{-80,140}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumChiWatPri, pumChiWatPri.bus) annotation (Line(
      points={{-80,140},{-29,140},{-29,110},{-30,110}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busPla.pumConWat, pumConWat.bus) annotation (Line(
      points={{-80,140},{-140,140},{-140,-70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TChiWatPriRet.port_b, inlChiWatChi.port_b)
    annotation (Line(points={{-10,-80},{-32,-80}}, color={0,127,255}));
  connect(loa.port_a, mChiWatPri_flow.port_b) annotation (Line(points={{88,-80},
          {100,-80},{100,100},{70,100}},color={0,127,255}));
  connect(booToRea.y,comSigLoa. u)
    annotation (Line(points={{200,68},{200,62}},     color={0,0,127}));
  connect(comSigLoa.y,loa. u)
    annotation (Line(points={{200,38},{200,-74},{90,-74}},  color={0,0,127}));
  connect(busChi.y1_actual,booToRea. u) annotation (Line(
      points={{160,140},{200,140},{200,92}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.chi,busChi)  annotation (Line(
      points={{-80,140},{160,140}},
      color={255,204,51},
      thickness=0.5));
  connect(loa.port_b, TChiWatPriRet.port_a)
    annotation (Line(points={{68,-80},{10,-80}}, color={0,127,255}));
  connect(bouChiWat.ports[1], loa.port_b)
    annotation (Line(points={{40,-90},{40,-80},{68,-80}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-260,-140},{260,220}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Components/Validation/ChillerGroupWaterCooled.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the chiller group model
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.ChillerGroups.Compression\">
Buildings.Templates.Plants.Chillers.Components.ChillerGroups.Compression</a>
for water-cooled chillers.
</p>
<p>
The validation uses open-loop controls and tests a single
system configuration.
The controller is automatically configured (by means
of parameters bindings with the chiller group component parameters)
to provide the necessary signals for any system configuration.
To test a different system configuration, one needs only to modify the
chiller group component.
</p>
</html>"));
end ChillerGroupWaterCooled;
