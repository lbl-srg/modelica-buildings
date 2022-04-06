within Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces;
partial model PartialChiller
  extends Buildings.Fluid.Interfaces.PartialOptionalFourPortInterface(
    redeclare replaceable package Medium1=Buildings.Media.Water,
    redeclare replaceable package Medium2=Buildings.Media.Water,
    final haveMedium1=true,
    final haveMedium2=not isAirCoo,
    final m1_flow_nominal=dat.m1_flow_nominal,
    final m2_flow_nominal=dat.m2_flow_nominal);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=true,
    final computeFlowResistance2=not isAirCoo,
    final dp1_nominal=dat.dp1_nominal,
    final dp2_nominal=dat.dp2_nominal);

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Chiller typ "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Compressor
    typCom = Buildings.Templates.ChilledWaterPlant.Components.Types.Compressor.ConstantSpeed
    "Type of compressor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean isAirCoo
    "= true, chillers in group are air cooled,
    = false, chillers in group are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.Data dat(
    final typ=typ,
    final isAirCoo=isAirCoo) "Chiller data";

  // fixme: Figure out what this entails with existing chiller class
  parameter Boolean is_heaPreCon = false
    "= true if chiller is controlled with head pressure";
  parameter Boolean have_heaPreSig = false
    "= true if chiller has a head pressure signal"
    annotation(Dialog(enable=is_heaPreCon));

  parameter Boolean have_TChiWatChiSup = true
    "= true if chiller chilled water supply temperature is measured"
    annotation (Dialog(enable=not is_heaPreCon or have_heaPreSig));
  parameter Boolean have_TConWatRet = true
    "= true if chiller condenser water return temperature is measured"
    annotation (Dialog(enable=not is_heaPreCon or have_heaPreSig));

  Buildings.Templates.Components.Interfaces.Bus bus "Control bus" annotation (
      Placement(transformation(
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
