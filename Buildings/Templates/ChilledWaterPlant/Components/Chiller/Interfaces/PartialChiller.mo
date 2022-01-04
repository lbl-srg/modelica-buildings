within Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces;
partial model PartialChiller
  extends Buildings.Fluid.Interfaces.PartialOptionalFourPortInterface(
    redeclare replaceable package Medium1=Buildings.Media.Water,
    redeclare replaceable package Medium2=Buildings.Media.Water,
    final haveMedium1=true,
    final haveMedium2=not isAirCoo);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
     final computeFlowResistance1=true,
     final computeFlowResistance2=not isAirCoo);

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Chiller typ "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  // fixme: Figure out what this entails with existing chiller class
  parameter Boolean is_heaPreCon = false
    "= true if chiller is controlled with head pressure";
  parameter Boolean have_heaPreSig = false
    "= true if chiller has a head pressure signal"
    annotation(Dialog(enable=is_heaPreCon));

  parameter Boolean have_TCHWSup = true
    "= true if chiller chilled water supply temperature is measured"
    annotation (Dialog(enable=not is_heaPreCon or have_heaPreSig));
  parameter Boolean have_TCWRet = true
    "= true if chiller condenser water return temperature is measured"
    annotation (Dialog(enable=not is_heaPreCon or have_heaPreSig));

  parameter Boolean isAirCoo = false
    "= true, chillers in group are air cooled,
    = false, chillers in group are water cooled";
  replaceable parameter Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    per "Chiller performance data"
    annotation (Placement(transformation(extent={{-82,-90},{-62,-70}})));

  Buildings.Templates.Components.Interfaces.Bus
      busCon "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialChiller;
