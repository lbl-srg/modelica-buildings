within Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces;
partial model PartialReturnSection
  extends Fluid.Interfaces.PartialOptionalFourPortInterface(
    redeclare final package Medium1=MediumConWat,
    redeclare final package Medium2=MediumChiWat,
    final haveMedium1=not isAirCoo,
    final haveMedium2=true);

  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (Dialog(enable=not isAirCoo));
  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component";

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.ReturnSection typ
    "Type of waterside economizer"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.Data
    dat(final typ=typ)
    "Return section data";

  outer parameter Integer nChi "Number of chillers";
  outer parameter Integer nCooTow "Number of cooling towers";

  outer parameter Boolean isAirCoo "Is chiller plant air cooled";

  final parameter Boolean is_none=
    dat.typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ReturnSection.NoEconomizer;

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon(
    final nChi=nChi, final nCooTow=nCooTow) if not is_none
    "Control bus" annotation (Placement(transformation(
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

end PartialReturnSection;
