within Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses;
block FMUZoneAdapter "Block that interacts with this EnergyPlus zone"
  extends Modelica.Blocks.Icons.Block;

  parameter String fmuName "Name of the FMU file that contains this zone";
  parameter String zoneName "Name of the thermal zone as specified in the EnergyPlus input";
  parameter Integer nFluPor "Number of fluid ports (Set to 2 for one inlet and one outlet)";

  final parameter Modelica.SIunits.Area AFlo(fixed=false) "Floor area";
  final parameter Modelica.SIunits.Volume V(fixed=false) "Zone volume";

  Modelica.Blocks.Interfaces.RealInput T(
    final unit="K",
    displayUnit="degC")
    "Zone air temperature" annotation (
      Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput X_w(final unit="kg/kg")
    "Zone air mass fraction in kg/kg total air" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent=
           {{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput m_flow[nFluPor](
     each final unit = "kg/s")
     "Mass flow rate" annotation (
      Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput TInlet[nFluPor](
    each final unit="K",
    each displayUnit="degC") "Air inlet temperatures"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput QGaiRad_flow(
    final unit="W")
    "Radiative heat gain" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput TRad(
    final unit="K",
    displayUnit="degC")
    "Radiative temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W")
    "Convective sensible heat to be added to zone air" annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={{
            100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput QLat_flow(final unit="W")
    "Latent heat to be added to zone air" annotation (Placement(transformation(
          extent={{100,-30},{120,-10}}), iconTransformation(extent={{100,-30},{120,
            -10}})));
  Modelica.Blocks.Interfaces.RealOutput QPeo_flow(
    final unit="W")
    "Total heat gain from people, to be used for optional computation of CO2 released"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Modelica.SIunits.Time tNext(start=t0-1, fixed=true) "Next sampling time";
  Modelica.SIunits.Time dtMax(start=600, fixed=true) "Hack to aovid too long time steps";
protected
  Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUZoneClass adapter=
      Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUZoneClass(
      fmuName=fmuName,
      zoneName=zoneName,
      nFluPor=nFluPor) "Class to communicate with EnergyPlus";
  parameter Modelica.SIunits.Time t0(fixed=false) "Simulation start time";
initial equation
  t0 = time;
  (AFlo, V) = Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.initialize(adapter);
equation
  when {initial(), time >= pre(tNext), time >= pre(dtMax)} then
    (TRad, QCon_flow, QLat_flow, QPeo_flow, tNext) =
      Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.exchange(
      adapter,
      T,
      X_w,
      m_flow,
      TInlet,
      QGaiRad_flow,
      time);
    dtMax = 100*QCon_flow/V/1006;
  end when;
  annotation (Icon(graphics={Bitmap(extent={{-90,-86},{84,88}}, fileName=
            "modelica://Buildings/Resources/Images/Fluid/FMI/FMI_icon.png")}),
      Documentation(info="<html>
<p>
Block that exchanges data between Modelica and EnergyPlus.
This block is calling the C functions to initialize EnergyPlus,
exchange data with EnergyPlus, and free the memory, through the destructor
of its class <code>adapter</code>, of EnergyPlus.
</p>
</html>", revisions="<html>
<ul>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FMUZoneAdapter;
