within Buildings.Templates.ChilledWaterPlants.Components.EconomizerSection.Interfaces;
partial model PartialEconomizer "Partial waterside economizer model"
  extends Fluid.Interfaces.PartialOptionalFourPortInterface(
    redeclare final package Medium1=MediumConWat,
    redeclare final package Medium2=MediumChiWat,
    final m1_flow_nominal=dat.m1_flow_nominal,
    final m2_flow_nominal=dat.m2_flow_nominal,
    final haveMedium1=have_eco,
    final haveMedium2=true);

  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (Dialog(enable=have_eco));
  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component";

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Types.EconomizerFlowControl
    typ "Type of waterside economizer"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  outer parameter Integer nChi "Number of chillers";
  outer parameter Integer nCooTow "Number of cooling towers";

  final parameter Boolean have_eco=
    typ==Buildings.Templates.ChilledWaterPlants.Components.Types.EconomizerFlowControl.WatersideEconomizer;

  parameter Boolean have_valChiWatEcoByp=false
    "Set to true if CHW flowrate is controlled by a modulating bypass valve"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_eco));

  // Record

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Data.EconomizerSection
    dat(final typ=typ, final have_valChiWatEcoByp=have_valChiWatEcoByp)
    "Waterside economizer data";

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus(final nChi=nChi,
      final nCooTow=nCooTow) if have_eco "Control bus" annotation (Placement(
        transformation(
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
          fillPattern=FillPattern.Solid),
      Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end PartialEconomizer;
