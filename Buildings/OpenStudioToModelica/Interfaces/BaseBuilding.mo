within Buildings.OpenStudioToModelica.Interfaces;
partial model BaseBuilding "Building model that contains all the parameters and informations refefrenced by building models
  generated automatically using the OpenStudioToModelica ruby package"
  extends Buildings.BaseClasses.BaseIconBuilding;

  // FLUID AND AIR
  package MediumAir = Buildings.Media.Air "Medium air model";

  // WEATHER BUS
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"  annotation (Placement(
        transformation(extent={{-110,70},{-90,90}}),  iconTransformation(extent={{-116,64},
            {-90,90}})));

  // ROOM CONNECTORS
  RoomConnector_in rooms_conn[nRooms](each ports(redeclare package Medium =
          MediumAir)) "Room connectors for fluid and internal heat gains"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}}),
        iconTransformation(extent={{-120,-90},{-80,-50}})));

  // BASIC ORIENTATIONS
  parameter Modelica.SIunits.Angle S_ = Buildings.Types.Azimuth.S
    "Azimuth for south wall";
  parameter Modelica.SIunits.Angle E_ = Buildings.Types.Azimuth.E
    "Azimuth for east wall";
  parameter Modelica.SIunits.Angle W_ = Buildings.Types.Azimuth.W
    "Azimuth for west wall";
  parameter Modelica.SIunits.Angle N_ = Buildings.Types.Azimuth.N
    "Azimuth for north wall";
  parameter Modelica.SIunits.Angle F_ = Buildings.Types.Tilt.Floor
    "Tilt for floor";
  parameter Modelica.SIunits.Angle C_ = Buildings.Types.Tilt.Ceiling
    "Tilt for ceiling";
  parameter Modelica.SIunits.Angle Z_ = Buildings.Types.Tilt.Wall
    "Tilt for wall";

  // DEFAULT PARAMETERS AND SETTINGS
  parameter Integer nRooms(min=1) "Number of rooms";
  parameter Modelica.SIunits.Angle lon(displayUnit="deg") "Longitude";
  parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude";
  parameter Modelica.SIunits.Time timZon(displayUnit="h") "Time zone";
  parameter Buildings.HeatTransfer.Types.InteriorConvection intConMod=
    Buildings.HeatTransfer.Types.InteriorConvection.Fixed
    "Select mode for interior convection coefficient";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hInternalFixed = 3.0
    "Constant convection coefficient for room-facing surfaces of opaque constructions";
  parameter Buildings.HeatTransfer.Types.ExteriorConvection extConMod=
    Buildings.HeatTransfer.Types.ExteriorConvection.Fixed
    "Select mode for exterior convection coefficient";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hExternalFixed = 10.0
    "Constant convection coefficient for exterior facing surfaces of opaque constructions";
  parameter Modelica.Fluid.Types.Dynamics roomEnDyn = Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance for the rooms"   annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics roomMassDyn = roomEnDyn
    "Formulation of mass balance for the rooms"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.SIunits.Temperature T_ground = 283.15
    "Ground temperature.";
  parameter Integer nStaRef = 1
    "Number of state variables in a reference material of 0.2 m concrete";
  parameter Buildings.HeatTransfer.Data.Solids.Generic soil_material(x=2, k=1.3, c=800, d=1500, nSta = 1) annotation(Dialog(tab = "Materials", group="Soil"));
  parameter Real frame_fra = 0.1
    "Fraction of the windows surface occupied by the frame";
  parameter Modelica.SIunits.Emissivity abs_sol_iw = 0.84
    "Solar absorptivity of interior walls";
  parameter Modelica.SIunits.Emissivity abs_ir_iw = 0.84
    "Infrared absorptivity of interior walls";
  parameter Boolean linearizeRadiation = true
    "Flag that enables the linearized implementation of the radiation network in the room model.";
  Modelica.Blocks.Sources.Constant zeroPower(k = 0.0)
    "NUll power input connected to the rooms.";

  // INITIALIZATION
  parameter Modelica.SIunits.Temperature T_start = MediumAir.T_default
    "Start value of rooms temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.AbsolutePressure p_start = MediumAir.p_default
    "Start value of rooms pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.MassFraction X_start[MediumAir.nX] = MediumAir.X_default
    "Start value of mass fraction m_i/m_tot"
    annotation(Dialog(tab = "Initialization"));
  parameter Buildings.Media.Air.ExtraProperty C_start[MediumAir.nC](quantity = MediumAir.extraPropertiesNames) = fill(0, MediumAir.nC)
    "Start value of trace substance"
    annotation(Dialog(tab = "Initialization"));
  parameter Buildings.Media.Air.ExtraProperty C_nominal[MediumAir.nC](quantity = MediumAir.extraPropertiesNames) = fill(1e-2, MediumAir.nC)
    "Nominal value of trace substance (set to typical order of magnitude)"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.Temperature T_wall_start = 273.15 + 18
    "Initial temperature of the walls if not initialized in steady state mode."
    annotation(Dialog(tab = "Initialization"));
  parameter Boolean steadyStateInitialWalls = false
    "Flag tha indicates if the walls have to be initialized in steady state mode (dT/dt = 0 at t = 0)"
    annotation(Dialog(tab = "Initialization"));
  parameter Boolean homotopyInitialization = true
    "Flag tha indicates if using the homotopy operator at initialization"
    annotation(Dialog(tab = "Initialization"));

  // WEATHER AND BOUNDARY CONDITIONS
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi(T = T_ground)
    "Ground temperature";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end BaseBuilding;
