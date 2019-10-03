within Buildings.Experimental.EnergyPlus;
model Building
  "Model that declares a building to which thermal zones belong to"
  extends Modelica.Blocks.Icons.Block;

  final constant String modelicaNameBuilding = getInstanceName()
    "Name of this instance"
    annotation(HideResult=true);

  parameter String idfName="" "Name of the IDF file";
  parameter String weaName="" "Name of the EnergyPlus weather file";

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));

  parameter Boolean usePrecompiledFMU = false
    "Set to true to use pre-compiled FMU with name specified by fmuName"
    annotation(Dialog(tab="Debug"));

  parameter String fmuName=""
    "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)"
    annotation(Dialog(tab="Debug", enable=usePrecompiledFMU));

  parameter Buildings.Experimental.EnergyPlus.Types.Verbosity verbosity=
    Buildings.Experimental.EnergyPlus.Types.Verbosity.Fatal
    "Verbosity of EnergyPlus output"
    annotation(Dialog(tab="Debug"));

annotation (
  defaultComponentName="building",
  defaultComponentPrefixes="inner",
  missingInnerMessage="
Your model is using an outer \"building\" component to declare building-level parameters, but
an inner \"building\" component is not defined.
Drag one instance of Buildings.Experimental.EnergyPlus.Building into your model,
above all declarations of Buildings.Experimental.EnergyPlus.ThermalZone,
to specify building-level parameters.",
  Icon(graphics={
          Bitmap(extent={{-44,-144},{94,-6}},
          fileName="modelica://Buildings/Resources/Images/Experimental/EnergyPlus/spawn_icon_darkbluetxmedres.png",
          visible=not usePrecompiledFMU),
      Rectangle(
        extent={{-64,54},{64,-48}},
        lineColor={150,150,150},
        fillPattern=FillPattern.Solid,
        fillColor={150,150,150}),
      Polygon(
        points={{0,96},{-78,54},{80,54},{0,96}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
        extent={{16,12},{44,40}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,12},{-14,40}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,-32},{-14,-4}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-32},{44,-4}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));

end Building;
