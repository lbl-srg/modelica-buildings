within Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses;
block FMUZoneAdapter "Block that interacts with this EnergyPlus zone"
  extends Modelica.Blocks.Icons.Block;

  parameter String fmuName "Name of the FMU file that contains this zone";
  parameter String zoneName "Name of the thermal zone as specified in the EnergyPlus input";
  parameter Integer nFluPor(min=2) "Number of fluid ports (Set to 2 for one inlet and one outlet)";

  final parameter Modelica.SIunits.Area AFlo(fixed=false) "Floor area";
  final parameter Modelica.SIunits.Volume V(fixed=false) "Zone volume";

  Modelica.Blocks.Interfaces.RealInput T "Zone air temperature" annotation (
      Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput X_w
    "Zone air mass fraction in kg/kg total air" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent=
           {{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput m_flow[nFluPor] "Mass flow rate" annotation (
      Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput TInlet[nFluPor] "Air inlet temperatures"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput QGaiRad_flow
    "Radiative heat gain" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput TRad "Radiative temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput QGaiCon_flow
    "Convective sensible heat gain" annotation (Placement(transformation(extent=
           {{100,10},{120,30}}), iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput QGaiLat_flow "Latent heat gain" annotation (
      Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput QPeo_flow "Total heat gain from people"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Modelica.SIunits.Time tNext "Next sampling time";
protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";

  Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUZoneClass adapter=
      Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUZoneClass(
      fmuName=fmuName,
      zoneName=zoneName,
      nFluPor=nFluPor) "Class to communicate with EnergyPlus";
initial equation
  tNext = time;
  (AFlo, V) = Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.initialize(adapter);
equation
  when {initial(), tNext >= time} then
    (TRad, QGaiCon_flow, QGaiLat_flow, QPeo_flow, tNext) =
      Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.exchange(
      adapter,
      T,
      X_w,
      m_flow,
      TInlet,
      QGaiRad_flow,
      time);
  end when;
end FMUZoneAdapter;
