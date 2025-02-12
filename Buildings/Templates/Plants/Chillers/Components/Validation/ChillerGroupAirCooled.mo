within Buildings.Templates.Plants.Chillers.Components.Validation;
model ChillerGroupAirCooled
  "Validation model for water-cooled chiller group"
  extends Modelica.Icons.Example;

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumAir = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

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
  parameter Modelica.Units.SI.MassFlowRate mConAirChi_flow_nominal[nChi]=
    capChi_nominal*Buildings.Templates.Data.Defaults.ratMFloAirByCapChi
    "Air mass flow rate at condenser - Each air-cooled chiller"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi]=
    fill(Buildings.Templates.Data.Defaults.dpChiWatChi, nChi)
    "CHW pressure drop - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each min=0)=fill(1e6, nChi)
    "Cooling capacity - Each chiller (>0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Real COPChi_nominal[nChi](
    each min=0)=fill(Buildings.Templates.Data.Defaults.COPChiAirCoo, nChi)
    "Cooling COP - Each chiller"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    Buildings.Templates.Data.Defaults.TChiWatSup
    "CHW supply temperature";
  parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
    Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature";

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
  parameter Buildings.Templates.Plants.Chillers.Components.Data.ChillerGroup
    datChi(
    final nChi=nChi,
    final typ=Buildings.Templates.Components.Types.Chiller.AirCooled,
    final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
    final dpChiWatChi_nominal=dpChiWatChi_nominal,
    final capChi_nominal=capChi_nominal,
    final COPChi_nominal=COPChi_nominal,
    final TChiWatSupChi_nominal=fill(TChiWatSup_nominal, nChi),
    TOut_nominal=Buildings.Templates.Data.Defaults.TOutChi,
    PLRChi_min=fill(0.15, nChi),
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_Carrier_19XR_742kW_5_42COP_VSD
      perChi)
    "Parameter record for air-cooled chiller group";

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
    "Primary CHW supply temperature" annotation (Placement(transformation(
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

  Plants.Chillers.Components.ChillerGroups.Compression chi(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumCon = MediumAir,
    typArr=Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel,
    typDisChiWat=Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only,
    final dat=datChi,
    final nChi=nChi,
    final energyDynamics=energyDynamics,
    final typ=Buildings.Templates.Components.Types.Chiller.AirCooled,
    typCtlHea=Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.None,
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typArrPumConWat=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumConWatVar=false,
    typEco=Buildings.Templates.Plants.Chillers.Types.Economizer.None)
    "Chiller group"
    annotation (Placement(transformation(extent={{-100,-90},{-60,110}})));

  Buildings.Templates.Components.Routing.MultipleToSingle inlChiWatChi(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CHW inlet manifold"
    annotation (Placement(transformation(extent={{-52,-90},{-32,-70}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumChiWatPri(
    redeclare final package Medium = MediumChiWat,
    nPorts_a=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau) "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Plants.Chillers.Components.Controls.OpenLoop ctl(
    cfg=Buildings.Templates.Plants.Chillers.Components.Validation.Configuration.Variable1OnlyAirCooledParallel(
      nChi=chi.nChi,
      typArrPumChiWatPri=chi.typArrPumChiWatPri,
      have_pumChiWatPriVar=pumChiWatPri.have_var,
      have_pumChiWatPriVarCom=pumChiWatPri.have_varCom,
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
  Fluid.Sources.Boundary_pT bouConAir(
    redeclare final package Medium = MediumAir,
    final nPorts=nChi)
    "Condenser cooling fluid pressure boundary condition"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-150,100})));
  Fluid.Sources.MassFlowSource_T souConAir[nChi](
    redeclare each final package Medium = MediumAir,
    final m_flow=mConAirChi_flow_nominal,
    each final nPorts=1) "Condenser air flow source" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-150,-80})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriRet(redeclare final package Medium =
        MediumChiWat, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-80})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert pump return signal to real"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,80})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum comSigLoa(k=fill(1/nChi, nChi), nin
      =nChi)    "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,50})));
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
                         iconTransformation(extent={{-422,198},{-382,238}})));
  Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    final energyDynamics=energyDynamics,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{88,-90},{68,-70}})));
equation
  connect(chi.ports_bCon, bouConAir.ports)
    annotation (Line(points={{-100,106},{-120,106},{-120,100},{-140,100}},
                                                     color={0,127,255}));
  connect(souConAir.ports[1], chi.ports_aCon)
    annotation (Line(points={{-140,-80},{-120,-80},{-120,-86},{-100,-86}},
                                                     color={0,127,255}));
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{-20,100},{-20,100}},color={0,127,255}));
  connect(outPumChiWatPri.port_b, TChiWatPriSup.port_a)
    annotation (Line(points={{0,100},{20,100}},  color={0,127,255}));
  connect(TChiWatPriSup.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{40,100},{50,100}}, color={0,127,255}));
  connect(inlChiWatChi.ports_a, chi.ports_aChiWat)
    annotation (Line(points={{-52,-80},{-56,-80},{-56,-86},{-60,-86}},
                                                   color={0,127,255}));
  connect(chi.ports_bChiWat, inlPumChiWatPri.ports_a)
    annotation (Line(points={{-60,106},{-60,100}}, color={0,127,255}));
  connect(inlPumChiWatPri.ports_b, pumChiWatPri.ports_a)
    annotation (Line(points={{-40,100},{-40,100}}, color={0,127,255}));
  connect(chi.bus, busPla) annotation (Line(
      points={{-80,110.2},{-80,140}},
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
  connect(TChiWatPriRet.port_b, inlChiWatChi.port_b)
    annotation (Line(points={{-10,-80},{-32,-80}}, color={0,127,255}));
  connect(loa.port_a, mChiWatPri_flow.port_b) annotation (Line(points={{88,-80},
          {100,-80},{100,100},{70,100}},color={0,127,255}));
  connect(booToRea.y,comSigLoa. u)
    annotation (Line(points={{240,68},{240,62}},     color={0,0,127}));
  connect(comSigLoa.y,loa. u)
    annotation (Line(points={{240,38},{240,-74},{90,-74}},  color={0,0,127}));
  connect(busChi.y1_actual,booToRea. u) annotation (Line(
      points={{200,140},{240,140},{240,92}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.chi,busChi)  annotation (Line(
      points={{-80,140},{200,140}},
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
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Components/Validation/ChillerGroupAirCooled.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the chiller group model
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.ChillerGroups.Compression\">
Buildings.Templates.Plants.Chillers.Components.ChillerGroups.Compression</a>
for air-cooled chillers.
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
end ChillerGroupAirCooled;
